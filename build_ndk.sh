#!/bin/bash

check_error() {
  task="$1"
  echo -n "$task..."
  shift  
  out=`$* 2>&1`
  if [ $? -ne 0 ]; then
    echo -e "\n\tError during execution: $*"
    echo "$out"
    exit 1
  else
    echo -e "\r\033[K$task: OK"
  fi
}

check_error "Generating files" ./autogen.sh

arm=(arm arm arm -linux-androideabi -linux-androideabi)
aarch64=(aarch64 arm64 aarch64 -linux-android -linux-android)
mipsel=(mipsel mips mipsel -linux-android -linux-android)
mips64el=(mips64el mips64 mips64el -linux-android -linux-android)
x86=(x86 x86 i686 -linux-android)
x86_64=(x86_64 x86_64 x86_64 -linux-android)

for target in arm aarch64 mipsel mips64el x86 x86_64; do
    eval array=\( \${${target}[@]} \)

    SYSROOT=$1/platforms/android-21/arch-${array[1]}
    export CC="$1/toolchains/${array[0]}${array[4]}-4.9/prebuilt/darwin-x86_64/bin/${array[2]}${array[3]}-gcc --sysroot=$SYSROOT"
    export RANLIB="$1/toolchains/${array[0]}${array[4]}-4.9/prebuilt/darwin-x86_64/bin/${array[2]}${array[3]}-gcc-ranlib"
    export AR="$1/toolchains/${array[0]}${array[4]}-4.9/prebuilt/darwin-x86_64/bin/${array[2]}${array[3]}-gcc-ar"

    check_error "Configuring for ${array[0]}" ./configure --host=${array[2]}${array[3]}
    check_error "Building for ${array[0]}" make
done
