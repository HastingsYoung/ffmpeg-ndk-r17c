#!/bin/bash  
set -x
NDK=/home/ubuntu/android-ndk-r17c
SYSROOT=$NDK/platforms/android-23/arch-arm64/
TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

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
--cc=$TOOLCHAIN/bin/aarch64-linux-android-gcc-4.9 \
--cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
--target-os=linux \
--arch=arm64 \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-I$NDK/sysroot/usr/include/aarch64-linux-android -Os -fpic $ADDI_CFLAGS -isysroot $NDK/sysroot" \
--extra-ldflags="$ADDI_LDFLAGS" \
$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}
CPU=armv8-a
PREFIX=$(pwd)/android/$CPU
ADDI_CFLAGS="-marm"
build_one

