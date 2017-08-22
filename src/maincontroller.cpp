/******************************************************************************
 * (c) Copyright 2017 Xilinx, Inc. All rights reserved.
 *
 * This file contains confidential and proprietary information of Xilinx, Inc.
 * and is protected under U.S. and international copyright and other
 * intellectual property laws.
 *
 * DISCLAIMER
 * This disclaimer is not a license and does not grant any rights to the
 * materials distributed herewith. Except as otherwise provided in a valid
 * license issued to you by Xilinx, and to the maximum extent permitted by
 * applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
 * FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
 * IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
 * and (2) Xilinx shall not be liable (whether in contract or tort, including
 * negligence, or under any other theory of liability) for any loss or damage
 * of any kind or nature related to, arising under or in connection with these
 * materials, including for any direct, or any indirect, special, incidental,
 * or consequential loss or damage (including loss of data, profits, goodwill,
 * or any type of loss or damage suffered as a result of any action brought by
 * a third party) even if such damage or loss was reasonably foreseeable or
 * Xilinx had been advised of the possibility of the same.
 *
 * CRITICAL APPLICATIONS
 * Xilinx products are not designed or intended to be fail-safe, or for use in
 * any application requiring fail-safe performance, such as life-support or
 * safety devices or systems, Class III medical devices, nuclear facilities,
 * applications related to the deployment of airbags, or any other applications
 * that could lead to death, personal injury, or severe property or
 * environmental damage (individually and collectively, "Critical
 * Applications"). Customer assumes the sole risk and liability of any use of
 * Xilinx products in Critical Applications, subject only to applicable laws
 * and regulations governing limitations on product liability.
 *
 * THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
 * AT ALL TIMES.
 *******************************************************************************/

/*
 * This file implements GUI helper functions.
 */

#include "maincontroller.h"
#include <unistd.h>
#include <gst/gst.h>
#include "perfapm.h"
#include <QHostAddress>
#include <QNetworkInterface>
#include <QNetworkAddressEntry>

void maincontroller :: inits(){
    vgst_init();
    memset(&inputParam, 0, sizeof(inputParam));
    memset(&encoderParam, 0, sizeof(encoderParam));
    memset(&outputParam, 0, sizeof(outputParam));
    cpuStat = new CPUStat("cpu");

    inputParam.height = SCREEN_HEIGHT;
    inputParam.width = SCREEN_WIDTH;

    perf_monitor_init();
}
void maincontroller :: rootUIObj(QObject * item){
    rootobject = item;
}
bool maincontroller:: errorPopup(int errorno){
    if(errorno == VGST_SUCCESS){
        return false;
    }
    QVariant errorName = QString("Error");
    rootobject->setProperty("errorNameText",QVariant(errorName));

    QVariant errorMsg = QString::fromUtf8(vgst_error_to_string((VGST_ERROR_LOG)errorno));
    rootobject->setProperty("errorMessageText",QVariant(errorMsg));
    return true;
}

void maincontroller::closeall() {
    perf_monitor_deinit();
}

void maincontroller :: updatecpu( QAbstractSeries *cpu) {

    double data[NCpuData];

    cpuStat->statistic(data[Cpu]);

    QString cpus;
    cpus.sprintf("CPU Utilization (%.2f%%)",data[Cpu]);

    QXYSeries *cpuSeries = static_cast<QXYSeries *>(cpu);

    cpuSeries->setName(cpus);

    if(cpuList.length()>60){
        cpuList.removeFirst();
    }

    cpuList.append(data[Cpu]);

    QVector<QPointF> cpupoints;


    for(int p = 0; p < cpuList.length(); p++){
        cpupoints.append(QPointF(p,cpuList.at(p)));
    }
    cpuSeries->replace(cpupoints);
}

void maincontroller :: updateThroughput(QAbstractSeries *videoSrcAS, QAbstractSeries *acceleratorAS){
    double data[NMemData];
    QXYSeries *videoSrcSeries = static_cast<QXYSeries *>(videoSrcAS);
    QXYSeries *acceleratorSeries = static_cast<QXYSeries *>(acceleratorAS);

    data[videoSrc] = (float)((perf_monitor_get_rd_wr_cnt(E_APM0) + perf_monitor_get_rd_wr_cnt(E_APM1))* BYTE_TO_GBIT);
    data[filter] = (float)((perf_monitor_get_rd_wr_cnt(E_APM2) + perf_monitor_get_rd_wr_cnt(E_APM3))* BYTE_TO_GBIT);

    if(videoSrcList.length() > 60){
        videoSrcList.removeFirst();
        filterList.removeFirst();
    }
    videoSrcList.append(data[videoSrc]);
    filterList.append(data[filter]);

    QString str1;
    str1.sprintf("Encoder Memory Bandwidth (%2.2f Gbps)", data[videoSrc]);
    QString str2;
    str2.sprintf("Decoder Memory Bandwidth (%2.2f Gbps)", data[filter]);

    videoSrcSeries->setName(str1);
    acceleratorSeries->setName(str2);

    QVector < QPointF > videoSrcpoints;
    QVector < QPointF > accelpoints;

    for(int p = 0; p < videoSrcList.length(); p++){
        videoSrcpoints.append(QPointF(p, videoSrcList.at(p)));
        accelpoints.append(QPointF(p, filterList.at(p)));
    }
    videoSrcSeries->replace(videoSrcpoints);
    acceleratorSeries->replace(accelpoints);
}

void maincontroller :: updateEncParam(int bitRate, int bFrameCount, QString encName, int gopLength, int profile, int qpMode, int rateControlmode, bool l2Cache, int slice){
   encoderParam.bitrate = bitRate;
    encoderParam.b_frame = bFrameCount;
    encoderParam.enc_name = g_strdup(encName.toLatin1().data());
    encoderParam.GoP_len = gopLength;
    encoderParam.profile = profile;
    encoderParam.qp_mode = qpMode;
    encoderParam.rc_mode = rateControlmode;
    encoderParam.enable_l2Cache = l2Cache;
    encoderParam.slice = slice;
}

void maincontroller :: updateInputParam(QString format, int num_src, bool raw, QString src, int device_type, QString uri){
    inputParam.format = g_strdup(format.toLatin1().data());
    inputParam.num_src = num_src;
    inputParam.raw = raw;
    inputParam.src = g_strdup(src.toLatin1().data());
    inputParam.device_type = device_type;
    inputParam.uri = g_strdup(uri.toLatin1().data());
}

void maincontroller :: updateOutputParam(QString fileOut, QString hostIp, int duration, int sinkType, int port){
    outputParam.file_out = g_strdup(fileOut.toLatin1().data());
    outputParam.host_ip = g_strdup(hostIp.toLatin1().data());
    outputParam.duration = duration;
    outputParam.sink_type = sinkType;
    outputParam.port_num = port;
}

void maincontroller :: start_pipeline(){
    int err = vgst_config_options(&encoderParam, &inputParam, &outputParam);
    if(errorPopup(err)){
        rootobject->setProperty("play", false);
        return;
    }
    err = vgst_start_pipeline();
    if(errorPopup(err)){
        rootobject->setProperty("play", false);
        return;
    }else{
        rootobject->setProperty("play", true);
    }
}

void maincontroller :: stop_pipeline(){
    int err = vgst_stop_pipeline();
    if(errorPopup(err)){
        rootobject->setProperty("play", true);
        return;
    }else{
        rootobject->setProperty("play", false);
    }
}

void maincontroller :: updateFPS(){
    rootobject->setProperty("fpsValue", vgst_calc_fps());
}

void maincontroller :: pollError(){
    int err = vgst_poll_event(VGST_EVENT_ERR);
    if(errorPopup(err)){
        rootobject->setProperty("errorFound", true);
        return;
    }
}

void maincontroller :: getLocalIpAddress(){
    QList<QNetworkInterface> interface = QNetworkInterface::allInterfaces();
    for (int i = 0; i <interface.size(); i++){
        QNetworkInterface item = interface.at(i);
        QList<QNetworkAddressEntry> entryList = item.addressEntries();
        if(entryList.size() && (item.name().toStdString() == "eth0")){
            if((entryList.at(0).ip().toString().length() >= 7) && (entryList.at(0).ip().toString().length() <= 15))
            rootobject->setProperty("ipAddress", entryList.at(0).ip().toString());
        }
    }
}

void maincontroller :: freeMemory(){
    free(inputParam.format);
    inputParam.format = NULL;
    free(inputParam.src);
    inputParam.src = NULL;
    free(inputParam.uri);
    inputParam.uri = NULL;
    free(encoderParam.enc_name);
    encoderParam.enc_name = NULL;
    free(outputParam.file_out);
    outputParam.file_out = NULL;
    free(outputParam.host_ip);
    outputParam.host_ip = NULL;
}

void maincontroller :: uninitAll(){
    vgst_uninit();
}
