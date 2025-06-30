@ECHO OFF

:: Path to ndk
SET "NDK=%NDK_HOME%"


:: Path to cmake
SET "CMAKE=cmake"

:: Path to cmake
SET "MAKE=make"

SET BUILD_PATH=cmake_build

:: Targets
SET "ABIs=arm64-v8a"

for %%x in (%ABIs%) do (
    ECHO ==========================
    ECHO = Building %%x
    ECHO ==========================

    CMAKE -S. -B%BUILD_PATH%/%%x -G "Unix Makefiles" ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=TRUE ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%NDK%/build/cmake/android.toolchain.cmake ^
    -DCMAKE_C_COMPILER=%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\clang.exe ^
    -DCMAKE_CXX_COMPILER=%NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64\bin\clang++.exe ^
    -DANDROID_NDK=%NDK% ^
    -DANDROID_ABI=%%x ^
    -DANDROID_NATIVE_API_LEVEL=21

    MAKE -C%BUILD_PATH%/%%x -j16
    tar -czvf %BUILD_PATH%/AndKittyInjector-%%x.gz %BUILD_PATH%/%%x/AndKittyInjector
)

D:\apktool\cache\venv\Lib\site-packages\adbutils\binaries\adb.exe push D:\AndKittyInjector\AndKittyInjector\cmake_build\arm64-v8a\AndKittyInjector /data/local/tmp
D:\apktool\cache\venv\Lib\site-packages\adbutils\binaries\adb.exe shell chmod +x /data/local/tmp/AndKittyInjector
PAUSE