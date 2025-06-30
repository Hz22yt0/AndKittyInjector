#!/bin/bash

# Path to NDK (需提前设置NDK_HOME环境变量)
NDK_HOME="/usr/local/lib/android/sdk/ndk/28.1.13356709"
NDK="$NDK_HOME"

# 工具路径
CMAKE="/usr/local/lib/android/sdk/cmake/3.31.5/bin/cmake"
MAKE="$NDK_HOME/prebuilt/linux-x86_64/bin/make"
BUILD_PATH="cmake_build"

# 目标ABI
ABIs="arm64-v8a armeabi-v7a x86 x86_64"

for abi in $ABIs; do
    echo "=========================="
    echo "= Building $abi"
    echo "=========================="

    $CMAKE -S. -B$BUILD_PATH/$abi -G "Unix Makefiles" \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_C_COMPILER=$NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/clang \
    -DCMAKE_CXX_COMPILER=$NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++ \
    -DANDROID_NDK=$NDK \
    -DANDROID_ABI=$abi \
    -DANDROID_NATIVE_API_LEVEL=21

    $MAKE -C$BUILD_PATH/$abi -j16
    cp $BUILD_PATH/$abi/AndKittyInjector $BUILD_PATH/AndKittyInjector-$abi
    tar -czvf $BUILD_PATH/AndKittyInjector-$abi.gz $BUILD_PATH/$abi/AndKittyInjector
done
