#!/bin/sh

# test environment variables
: "${TRD_HOME:?environment variable not set or empty}"
: "${PETALINUX:?environment variable not set or empty}"

# set environment variables
export MAKEFLAGS='-j 20' \
OE_QMAKE_AR='aarch64-linux-gnu-ar' \
OE_QMAKE_CC='aarch64-linux-gnu-gcc  -Wl,--hash-style=gnu ' \
OE_QMAKE_CFLAGS=' -O2 -pipe -g -feliminate-unused-debug-types' \
OE_QMAKE_COMPILER='aarch64-linux-gnu-gcc  -Wl,--hash-style=gnu ' \
OE_QMAKE_CXX='aarch64-linux-gnu-g++  -Wl,--hash-style=gnu ' \
OE_QMAKE_CXXFLAGS=' -O2 -pipe -g -feliminate-unused-debug-types -fvisibility-inlines-hidden' \
OE_QMAKE_LDFLAGS='-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed' \
OE_QMAKE_LINK='aarch64-linux-gnu-g++  -Wl,--hash-style=gnu ' \
OE_QMAKE_STRIP='echo' \
SYSROOT=$SYSROOT \
PATH=$PETALINUX/components/yocto/source/aarch64/buildtools/sysroots/x86_64-petalinux-linux/usr/bin/qt5:$PATH \
QT_CONF_PATH=$TRD_HOME/qtVCU.conf

# test existence of SYSROOT directory
if [ ! -d "$SYSROOT" ]
then
  echo "SYSROOT directory $SYSROOT does not exist!"
fi

# generate Makefile
echo "To generate the Makefile, run the following command chosing the desired Qt project file:"
echo "qmake \$TRD_HOME/VCU.pro -r -spec linux-oe-g++"
