#!/bin/bash

export ARCH=arm64

LC_ALL=C
BUILD_CROSS_COMPILE=$(pwd)/toolchain/google/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$(pwd)/toolchain/clang-12.0.7/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y WERROR=0"
OUT_DIR=$(pwd)/out

if [ "$1" == "clean" ]; then
    if [ -d "$OUT_DIR" ]; then
        make -C $(pwd) O=$OUT_DIR ARCH=arm64 clean
    fi
    echo "Cleaning is done."
else

if [ "$1" == "menuconfig" ]; then
    mkdir -p $OUT_DIR

    if [ ! -f "$OUT_DIR/.config" ]; then
        make -C $(pwd) O=$OUT_DIR $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE vendor/a52sxq_eur_open_defconfig
    fi

    make -C $(pwd) O=$OUT_DIR ARCH=arm64 menuconfig
    exit 0
fi

make -j64 -C $(pwd) O=$OUT_DIR $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/a52sxq_eur_open_defconfig 2>&1 | tee build.log
make -j64 -C $(pwd) O=$OUT_DIR $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y 2>&1 | tee build.log

cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
fi