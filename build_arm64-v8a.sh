#!/bin/bash  
set -x
NDK=/home/ubuntu/android-ndk-r17c
BUILD_PLATFORM=linux-x86_64
ARCH=arm64
ANDROID_ARCH_ABI=aarch64
ANDROID_VERSION=23
BUILD_DIR=$(pwd)/build_dir/${ANDROID_ARCH_ABI}
CFLAGS="-march=armv8-a"
CPU=armv8-a
PREFIX=$(pwd)/android/${CPU}/${ANDROID_ARCH_ABI}
SYSROOT=$NDK/platforms/android-${ANDROID_VERSION}/arch-${ARCH}
TOOLCHAIN=$NDK/toolchains/${ANDROID_ARCH_ABI}-linux-android-4.9/prebuilt/${BUILD_PLATFORM}
CROSS_PREFIX=${TOOLCHAIN}/bin/aarch64-linux-android-

echo "pwd==$(pwd)"
echo "ARCH==${ARCH}"
echo "PREFIX==${PREFIX}"
echo "SYSROOT=${SYSROOT}"
echo "CFLAGS=${CFLAGS}"
echo "TOOLCHAIN==${TOOLCHAIN}"
echo "CROSS_PREFIX=${CROSS_PREFIX}"

mkdir -p ${BUILD_DIR}

function build_one
{
echo "-------- Build Started -------"
./configure \
--prefix=${PREFIX} \
--target-os=linux \
--arch=${ARCH} \
--sysroot=${SYSROOT} \
--enable-cross-compile \
--cross-prefix=${CROSS_PREFIX} \
--extra-cflags="$CFLAGS -Os -fpic -DANDROID -I$NDK/sysroot/usr/include/$ANDROID_ARCH_ABI-linux-android -isysroot $NDK/sysroot" \
--extra-ldflags="-L${SYSROOT}/usr/lib" \
--enable-shared \
--enable-asm \
--disable-static \
--disable-doc \
--enable-protocol='file,pipe' \
--enable-demuxer='aac,avi,dnxhd,flac,flv,gif,h261,h263,h264,image2,matroska,webm,mov,mp3,mp4,mpeg,ogg,srt,wav,webvtt,gif,image2,image2pipe,mjpeg' \
--enable-muxer='3gp,dnxhd,flac,flv,gif,image2,matroska,webm,mov,mp3,mp4,mpeg,ogg,opus,srt,wav,webvtt,ipod,gif,image2,image2pipe,mjpeg' \
--enable-encoder='aac,dnxhd,flac,flv,gif,libmp3lame,libopus,libshine,libvorbis,mpeg4,png,mjpeg,gif,srt,subrip,webvtt' \
--enable-decoder='aac,aac_at,aac_fixed,aac_latm,dnxhd,flac,flv,h261,h263,h263i,h263p,h264,vp8,vp9,libopus,libvorbis,mp3,mpeg4,wavpack,png,mjpeg,gif,pcm_s16le,pcm_s16be,rawvideo,srt,webvtt' \
--enable-gpl \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-symver \
--disable-avdevice \
--enable-small
echo "-------- Build Ended -------"
make clean
make
make install
}
build_one