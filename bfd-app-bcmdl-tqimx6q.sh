#!/bin/bash

CUR_DIR=`pwd`
export LIBUSB_PATH=${CUR_DIR}/src/usbdev/libusb-1.0.9
export LIBUSB_COMPACT_PATH=${CUR_DIR}/src/usbdev/libusb-compat-0.1.3
cd ${CUR_DIR}/src/usbdev
tar -jxvf libusb-1.0.9.tar.bz2
tar -jxvf libusb-compat-0.1.3.tar.bz2
mkdir ${TARGETDIR}
cd ${LIBUSB_PATH}
./configure --host=arm-linux  --prefix=`pwd`/install
make
make install
cd ${LIBUSB_COMPACT_PATH}
./configure --host=arm-linux  --prefix=`pwd`/install PKG_CONFIG_PATH=${LIBUSB_PATH}/install/lib/pkgconfig
make
make install
cd ${CUR_DIR}
make -C src/usbdev/usbdl CC=${CC} STRIP=${STRIP} $1
rm -rf ${LIBUSB_PATH}
rm -rf ${LIBUSB_COMPACT_PATH}
if [ "${TARGETARCH}" == mips ] ; then
	cp -v src/usbdev/usbdl/mips/bcmdl ${TARGETDIR}
	cp -v src/usbdev/usbdl/mips/bcmdl ${TARGETDIR}/bcmdl-${TARGETMACH}
else
	cp -v src/usbdev/usbdl/bcmdl ${TARGETDIR}
	cp -v src/usbdev/usbdl/bcmdl ${TARGETDIR}/bcmdl-${TARGETMACH}
fi
