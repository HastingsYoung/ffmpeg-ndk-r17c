#!/bin/bash  
set -x
NDK=/home/ubuntu/android-ndk-r17c
SYSROOT=$NDK/platforms/android-23/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

function build_one
{
./configure \
--prefix=$PREFIX \
--enable-shared \
--disable-static \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-symver \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--target-os=linux \
--arch=armeabi-v7a \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-I$NDK/sysroot/usr/include/arm-linux-androideabi -Os -fpic $ADDI_CFLAGS -isysroot $NDK/sysroot" \
--extra-ldflags="$ADDI_LDFLAGS" \
$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}
CPU=armeabi-v7a
PREFIX=$(pwd)/android/$CPU
ADDI_CFLAGS="-marm"
build_one

