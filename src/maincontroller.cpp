/******************************************************************************
 * (c) Copyright 2012-2016 Xilinx, Inc. All rights reserved.
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

void maincontroller :: inits(){
    cpuStat1 = new CPUStat("cpu0");
    cpuStat2 = new CPUStat("cpu1");
    cpuStat3 = new CPUStat("cpu2");
    cpuStat4 = new CPUStat("cpu3");

    inputParam.height = SCREEN_HEIGHT;
    inputParam.width = SCREEN_WIDTH;

    perfmon_init_all(PERF_SAMPLE_INTERVAL_COUNTER);
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
    perfmon_deinit_all(PERF_SAMPLE_INTERVAL_COUNTER);
}

void maincontroller :: updatecpu( QAbstractSeries *cpu1, QAbstractSeries *cpu2, QAbstractSeries *cpu3, QAbstractSeries *cpu4) {

    double data[NCpuData];
    cpuStat1->statistic(data[Cpu1]);
    cpuStat2->statistic(data[Cpu2]);
    cpuStat3->statistic(data[Cpu3]);
    cpuStat4->statistic(data[Cpu4]);

    QString cpus1s;
    cpus1s.sprintf("%.2f%%",data[Cpu1]);
    QString cpus2s;
    cpus2s.sprintf("%.2f%%",data[Cpu2]);
    QString cpus3s;
    cpus3s.sprintf("%.2f%%",data[Cpu3]);
    QString cpus4s;
    cpus4s.sprintf("%.2f%%",data[Cpu4]);

    QString cpu1s;
    cpu1s.sprintf("CPU 1 (%.0f)",data[Cpu1]);
    QString cpu2s;
    cpu2s.sprintf("CPU 2 (%.0f)",data[Cpu2]);
    QString cpu3s;
    cpu3s.sprintf("CPU 3 (%.0f)",data[Cpu3]);
    QString cpu4s;
    cpu4s.sprintf("CPU 4 (%.0f)",data[Cpu4]);

    QXYSeries *cpu1Series = static_cast<QXYSeries *>(cpu1);
    QXYSeries *cpu2Series = static_cast<QXYSeries *>(cpu2);
    QXYSeries *cpu3Series = static_cast<QXYSeries *>(cpu3);
    QXYSeries *cpu4Series = static_cast<QXYSeries *>(cpu4);

    cpu1Series->setName(cpu1s);
    cpu2Series->setName(cpu2s);
    cpu3Series->setName(cpu3s);
    cpu4Series->setName(cpu4s);

    if(cpu1List.length()>60){
        cpu1List.removeFirst();
        cpu2List.removeFirst();
        cpu3List.removeFirst();
        cpu4List.removeFirst();
    }

    cpu1List.append(data[Cpu1]);
    cpu2List.append(data[Cpu2]);
    cpu3List.append(data[Cpu3]);
    cpu4List.append(data[Cpu4]);

    QVector<QPointF> cpu1points;
    QVector<QPointF> cpu2points;
    QVector<QPointF> cpu3points;
    QVector<QPointF> cpu4points;

    for(int p = 0; p < cpu1List.length(); p++){
        cpu1points.append(QPointF(p,cpu1List.at(p)));
        cpu2points.append(QPointF(p,cpu2List.at(p)));
        cpu3points.append(QPointF(p,cpu3List.at(p)));
        cpu4points.append(QPointF(p,cpu4List.at(p)));
    }
    cpu1Series->replace(cpu1points);
    cpu2Series->replace(cpu2points);
    cpu3Series->replace(cpu3points);
    cpu4Series->replace(cpu4points);
}

void maincontroller :: updateThroughput(QAbstractSeries *videoSrcAS, QAbstractSeries *acceleratorAS){
    double data[NMemData];
    QXYSeries *videoSrcSeries = static_cast<QXYSeries *>(videoSrcAS);
    QXYSeries *acceleratorSeries = static_cast<QXYSeries *>(acceleratorAS);

    data[videoSrc] = (float)((perfmon_get_countervalue(PS_DDRAPM_SLOT_4, 8, PERF_SAMPLE_INTERVAL_COUNTER) + perfmon_get_countervalue(PS_DDRAPM_SLOT_4, 9, PERF_SAMPLE_INTERVAL_COUNTER))* 8 / 1000000000.0);
    data[filter] = (float)((perfmon_get_countervalue(PS_DDRAPM_SLOT_5, 0, PERF_SAMPLE_INTERVAL_COUNTER) + perfmon_get_countervalue(PS_DDRAPM_SLOT_5, 1, PERF_SAMPLE_INTERVAL_COUNTER))* 8 / 1000000000.0);

    perfmon_reset_countervalue(PS_DDRAPM_SLOT_4, PERF_SAMPLE_INTERVAL_COUNTER);
    perfmon_reset_countervalue(PS_DDRAPM_SLOT_5, PERF_SAMPLE_INTERVAL_COUNTER);

    if(videoSrcList.length() > 60){
        videoSrcList.removeFirst();
        filterList.removeFirst();
    }
    videoSrcList.append(data[videoSrc]);
    filterList.append(data[filter]);

    QString str1;
    str1.sprintf("Encoder Bandwidth Utilization (%2.0f Gbps)", data[videoSrc]);
    QString str2;
    str2.sprintf("Decoder Bandwidth Utilization (%2.0f Gbps)", data[filter]);

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

void maincontroller :: updateEncParam(int bitRate, int bFrameCount, QString encName, int gopLength){
    encoderParam.bitrate = bitRate;
    encoderParam.b_frame = bFrameCount;
    encoderParam.enc_name = g_strdup(encName.toLatin1().data());
    encoderParam.GoP_len = gopLength;
}

void maincontroller :: updateInputParam(QString format, int num_src, bool raw, QString src, int device_type, QString uri){
    inputParam.format = g_strdup(format.toLatin1().data());
    inputParam.num_src = num_src;
    inputParam.raw = raw;
    inputParam.src = g_strdup(src.toLatin1().data());
    inputParam.device_type = device_type;
    inputParam.uri = g_strdup(uri.toLatin1().data());
}

void maincontroller :: start_pipeline(){
    int err = vgst_config_options(&encoderParam, &inputParam);
    if(errorPopup(err)){
        return;
    }
    err = vgst_start_pipeline();
    if(errorPopup(err)){
        return;
    }
}

void maincontroller :: stop_pipeline(){
    int err = vgst_stop_pipeline();
    if(errorPopup(err)){
        return;
    }
}
