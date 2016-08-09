#!/bin/bash

./autogen.sh

./configure --prefix=/usr/local/mingw/x86_64-w64-mingw32 --host=x86_64-w64-mingw32 PKG_CONFIG_LIBDIR=/usr/local/mingw/x86_64-w64-mingw32/lib/pkgconfig
make

./configure --prefix=/usr/local/mingw/i686-w64-mingw32 --host=i686-w64-mingw32 PKG_CONFIG_LIBDIR=/usr/local/mingw/i686-w64-mingw32/lib/pkgconfig
make
