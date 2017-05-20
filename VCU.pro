QT += qml quick widgets core gui
QT += charts

CONFIG += c++11
CONFIG += qwt
SOURCES += \
    src/main.cpp \
    src/CPUStat.cpp \
    src/maincontroller.cpp \
    src/dirop.cpp

HEADERS += \
    include/CPUStat.h \
    include/maincontroller.h \
    include/dirop.h

RESOURCES += qml.qrc

QML_IMPORT_PATH =

QML_DESIGNER_IMPORT_PATH =

DEFINES += QT_DEPRECATED_WARNINGS

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    VCU.pro.user \
    VCU_TRD.pro.user

MOC_DIR = moc

OBJECTS_DIR = obj

mkdirs.commands = $(MKDIR) $$MOC_DIR $$OBJECTS_DIR

QMAKE_EXTRA_TARGETS += mkdirs

INCLUDEPATH += \
        include \
        ../vcu_gst_lib/include \
	../perfmon_lib/include \
        ${SYSROOT}/usr/include/gstreamer-1.0 \
        ${SYSROOT}/usr/include/gstreamer-1.0/gst \
        ${SYSROOT}/usr/include/glib-2.0 \
        ${SYSROOT}/usr/include/glib-2.0/gio \
        ${SYSROOT}/usr/include/glib-2.0/glib \
        ${SYSROOT}/usr/include/glib-2.0/gobject \
        ${SYSROOT}/usr/lib/glib-2.0/include \
        ${SYSROOT}/usr/lib/gstreamer-1.0/include \
        ${SYSROOT}/usr/lib/gstreamer-1.0/include/gst \
        =/usr/include


QMAKE_LIBDIR_FLAGS += \
        -L../vcu_gst_lib/Release \
        -L../vcu_gst_lib/Debug \
	-L../perfmon_lib/Release \
	-L../perfmon_lib/Debug \
        -L=/usr/lib \
        -L=/${SYSROOT}/usr/lib \
        -L=/${SYSROOT}/usr/lib/gstreamer-1.0

LIBS += \
        -lQt5PrintSupport \
        -lQt5OpenGL \
        -lQt5Svg \
        -lperfmon \
	-lvcu_gst_lib \
        -lgstreamer-1.0 \
	-lgthread-2.0 \
        -lgobject-2.0 \
        -lglib-2.0

CONFIG += "release"

QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_CFLAGS_RELEASE -= -O2
QMAKE_CFLAGS_RELEASE += -O3 --sysroot=${SYSROOT}
QMAKE_CXXFLAGS_RELEASE += -O3 --sysroot=${SYSROOT}
QMAKE_LFLAGS_RELEASE += --sysroot=${SYSROOT}
QMAKE_LFLAGS_RELEASE += -Wl,-rpath-link=${SYSROOT}/lib,-rpath-link=${SYSROOT}/usr/lib

