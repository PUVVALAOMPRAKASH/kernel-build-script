#!/bin/bash

# Simple Kernel Build Script - OmKernel

cd RyZeN || exit

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_HOST="OmKernel-Build"
export KBUILD_BUILD_USER="omrak325"

TC_DIR="/home/omrak325/KernelBuild"
MPATH="$TC_DIR/CLANG-13/bin/:$PATH"

DATE=$(TZ=Asia/Kolkata date +"%Y%m%d")
BUILD_START=$(date +"%s")

# Clean previous builds
rm -f out/arch/arm64/boot/Image.gz-dtb

# Set defconfig
make O=out vendor/I2019-perf_defconfig

# Compile the kernel
PATH="$MPATH" make -j$(nproc) O=out \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    LD=ld.lld \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    CC=clang \
    AR=llvm-ar \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    2>&1 | tee error.log

# Copy output to AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb ../Anykernel/

cd ../Anykernel || exit

# Zip the kernel
if [ -f "Image.gz-dtb" ]; then
    ZIP_NAME="OmKernel-I2019-$DATE.zip"
    zip -r9 "$ZIP_NAME" * -x .git README.md *placeholder

    # Go back and sign the zip
    cd ..
    java -jar zipsigner-3.0.jar "Anykernel/$ZIP_NAME" "OmKernel-I2019-$DATE-signed.zip"

    # Cleanup
    rm "Anykernel/$ZIP_NAME"
    rm "Anykernel/Image.gz-dtb"

    BUILD_END=$(date +"%s")
    DIFF=$(($BUILD_END - $BUILD_START))
    echo "Build completed successfully in $(($DIFF / 60)) min $(($DIFF % 60)) sec."
    echo "Signed output: OmKernel-I2019-$DATE-signed.zip"
else
    echo "Build failed — Image.gz-dtb not found."
    exit 1
fi
