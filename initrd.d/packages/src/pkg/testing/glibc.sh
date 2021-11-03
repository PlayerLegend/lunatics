#!/bin/busybox sh

# source: ftp://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.xz

export PKG_NAME='glibc'
export PKG_VERSION='2.28'
export PKG_SOURCE='QmSY6yfdf8LBYpVUEmmiLP3WgYnX9r4u5basxUREq2PGae/glibc-2.28.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
