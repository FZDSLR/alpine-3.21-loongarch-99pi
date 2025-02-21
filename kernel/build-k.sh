#!/usr/bin/env bash

cd /build

# make ARCH=loongarch CROSS_COMPILE=loongarch64-linux-gnu- CC=loongarch64-linux-gnu-gcc-13 ls2k0300_99_pai_tfcard_defconfig

make ARCH=loongarch CROSS_COMPILE=loongarch64-linux-gnu- CC=loongarch64-linux-gnu-gcc-13 uImage -j $(($(nproc) - 1))

make ARCH=loongarch CROSS_COMPILE=loongarch64-linux-gnu- CC=loongarch64-linux-gnu-gcc-13 modules_install -j12 INSTALL_MOD_PATH="/install"  -j $(($(nproc) - 1))

tar -cf /install/lib.tar -C /install lib

cp /build/arch/loongarch/boot/uImage /install/uImage
