#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QMainWindow>
#include <QQmlContext>
#include <maincontroller.h>
#include <QtWidgets/QApplication>
#include "dirop.h"

int main(int argc, char *argv[])
{
    char *sources[] = {"File", "HDMI", "Test Pattern"};
    char *controls[] = {"HEVC Low", "HEVC Medium", "HEVC High", "AVC Low", "AVC Medium", "AVC High"};
    QApplication qapp(argc, argv);
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQmlApplicationEngine engine;

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
    ctx->setContextProperty("controller", &mc);


    QObject *item = engine.rootObjects().first();
    DirOp currDir;
    currDir.currentDir.setPath("/");
    ctx->setContextProperty("dirOPS", &currDir);
#if 1 // Testing dirop

    //    currDir.listDirectory();
    //    currDir.changeFolder(QString("bin"));
    //    currDir.listDirectory();
    //    currDir.initGStreamer();
#endif
    return qapp.exec();
}
