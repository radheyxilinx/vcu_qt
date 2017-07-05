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
 * This file defines GUI helper functions.
 */

#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QQuickItem>
#include <pthread.h>
#include "CPUStat.h"
#include <QtCharts/QAbstractSeries>
#include <QtCharts/QXYSeries>
#include "vgst_lib.h"
#include "perfapm.h"

QT_CHARTS_USE_NAMESPACE

#define SCREEN_HEIGHT 2160;
#define SCREEN_WIDTH 3840;
#define ROOT_FILE_PATH "/media/card"
#define BYTE_TO_GBIT (8 / 1000000000.0)

class maincontroller : public QObject
{
    Q_OBJECT
    enum CpuData{
        Cpu,
        NCpuData
    };
    CPUStat *cpuStat;

    QVector<qreal> cpuList;

    enum MemData{
        videoSrc,
        filter,
        NMemData
    };
    QVector<qreal> videoSrcList;
    QVector<qreal> filterList;

    QObject * rootobject;

    vgst_enc_params encoderParam;
    vgst_input_params inputParam;

public:
    void rootUIObj(QObject * item);

public slots:
    void inits();
    void closeall();
    bool errorPopup(int);
    void updatecpu(QAbstractSeries *cpu);
    void updateThroughput(QAbstractSeries *videoSrc, QAbstractSeries *accelerator);
    void updateEncParam(int, int, QString, int);
    void updateInputParam(QString, int, bool, QString, int, QString);
    void start_pipeline();
    void stop_pipeline();
    void updateFPS();
    void pollError();
};

#endif // MAINCONTROLLER_H
