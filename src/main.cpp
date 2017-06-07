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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QMainWindow>
#include <QQmlContext>
#include <QtWidgets/QApplication>
#include "dirop.h"
#include <maincontroller.h>

void signalhandler(int sig){
    QCoreApplication::exit(sig);
}

int main(int argc, char *argv[])
{
    char const *sources[] = {"File", "HDMI", "Test Pattern"};
    char const *controls[] = {"AVC Low", "AVC Medium", "AVC High", "HEVC Low", "HEVC Medium", "HEVC High", "Custom", "None"};
    QApplication qapp(argc, argv);
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQmlApplicationEngine engine;

    signal(SIGINT, signalhandler);

    engine.rootContext()->setContextProperty("resoluteFrac",1);
    engine.rootContext()->setContextProperty("imageResolution",2160);
    engine.rootContext()->setContextProperty("imageResolutionHeight", 1920);
    engine.rootContext()->setContextProperty("imageResolutionWidth", 1080);

    QVariantList sourceList;
    QVariantMap map;
    for(unsigned int i = 0; i < (sizeof(sources)/sizeof(sources[0])); i++){
        map.insert("shortName", sources[i]);
        sourceList.append(map);
    }
    QVariantList controlList;
    QVariantMap mapCtrl;
    for(unsigned int i = 0; i < (sizeof(controls)/sizeof(controls[0])); i++){
        mapCtrl.insert("shortName", controls[i]);
        controlList.append(mapCtrl);
    }

    engine.rootContext()->setContextProperty("videoSourcesCount",4);
    engine.rootContext()->setContextProperty("videoSourceList",QVariant::fromValue(sourceList));
    engine.rootContext()->setContextProperty("controlList",QVariant::fromValue(controlList));

    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));


    QQmlContext *ctx = engine.rootContext();
    maincontroller mc;
    mc.inits();
    mc.rootUIObj(engine.rootObjects().first());
    ctx->setContextProperty("controller", &mc);

    QObject :: connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()) );
    QObject :: connect( qApp, SIGNAL(aboutToQuit()),&mc,SLOT(closeall()));

    DirOp currDir;
    currDir.currentDir.setPath(ROOT_FILE_PATH);
    ctx->setContextProperty("dirOPS", &currDir);
#if 1 // Testing dirop

    //    currDir.listDirectory();
    //    currDir.changeFolder(QString("bin"));
    //    currDir.listDirectory();
    //    currDir.initGStreamer();
#endif
    return qapp.exec();
}
