
cd /E/projects/mobileCore/trunk/androidCore/thirdparty/LuaJIT-2.0.2

NDK=/E/android/android-ndk-r9-windows-x86_64/android-ndk-r9

NDKABI=8

NDKVER=$NDK/toolchains/arm-linux-androideabi-4.8

NDKP=$NDKVER/prebuilt/windows-x86_64/bin/arm-linux-androideabi-

NDKF="--sysroot $NDK/platforms/android-$NDKABI/arch-arm -march=armv7-a"

$PATH=/e/MinGW/bin:$PATH

make HOST_CC="gcc -m32" CROSS=$NDKP TARGET_FLAGS="$NDKF" TARGET_SYS=LINUX