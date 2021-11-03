#!/bin/busybox sh

# source: ftp://ftp.gnu.org/gnu/bison/bison-3.7.tar.xz

export PKG_NAME='bison'
export PKG_VERSION='3.7'
export PKG_SOURCE='QmXjGU6HWNLVkBP6PCHjHui295pv9iL4awozwUz2EYaZjB/bison-3.7.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
