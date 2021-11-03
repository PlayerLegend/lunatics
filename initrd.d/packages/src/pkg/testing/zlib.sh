#!/bin/busybox sh

# source: https://zlib.net/zlib-1.2.11.tar.xz

export PKG_NAME='zlib'
export PKG_VERSION='1.2.11'
export PKG_SOURCE='QmP5EzeFGM77YEo7ssEdUgyDxwXZAk2VwUa3CV9xBABVET/zlib-1.2.11.tar.xz'

export PKG_INSTALL_DEPENDS='glibc'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='zlib.1.2.11.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
