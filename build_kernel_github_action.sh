#!/bin/bash

echo "### Setting up PATH..."
export PATH=~/toolchains/clang/bin/:$PATH
export CC=clang
CLANG=~/toolchains/clang/bin
GCC32=~/toolchains/arm-linux-androideabi-4.9/bin
GCC64=~/toolchains/aarch64-linux-android-4.9/bin
PATH=$CLANG:$GCC64:$GCC32:$PATH
export PATH
export ARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-
chmod +x dtc/dtc
export DTC_EXT=dtc/dtc
echo "### Setting up ARCH..."
export ARCH=arm64
export SUBARCH=arm64

if [ ! -d "out" ]; then
	mkdir out
fi

echo "### Making kernel config..."
make ARCH=arm64 O=out CC="ccache clang" sdm845-perf_defconfig
# make ARCH=arm64 O=out CC=clang oldconfig

echo "### Making kernel...(This may take long time)"
make ARCH=arm64 O=out CC=clang -j$(nproc --all) 2>&1 | tee kernel_build_log.txt


if [ -f out/arch/arm64/boot/Image.gz-dtb ]; then
	echo "### Finished kernel building!"
	echo "### Exiting script..."
	exit 0
else
	echo " "
	echo "### Kernel building failed!"
        echo "### Exiting script..."
	exit 0
fi
