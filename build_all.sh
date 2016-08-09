#!/bin/bash

set -e

./build_darwin.sh

./build_windows.sh

if [ "1" == "$NATJ_ENABLE_NDK_BUILD" ]; then
	./build_ndk.sh $NDK_PATH
fi
