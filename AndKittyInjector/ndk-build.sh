#!/bin/bash

# Path to NDK (需提前设置NDK_HOME环境变量)
NDK="$NDK_HOME"

# 工具路径
CMAKE="$ANDROID_HOME/cmake/3.22.1/cmake"
MAKE="$ANDROID_HOME/ndk/25.2.9519653/make"
BUILD_PATH="cmake_build"

# 目标ABI
ABIs="arm64-v8a"

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
done
