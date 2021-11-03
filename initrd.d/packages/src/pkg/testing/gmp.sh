#!/bin/busybox sh

# source: ftp://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz

export PKG_NAME='gmp'
export PKG_VERSION='6.2.1'
export PKG_SOURCE='QmVC81Wmbw4b4HVqtSkzQmMiSvEhsaLeGU32cDJPzgyKRR/gmp-6.2.1.tar.xz'

export PKG_INSTALL_DEPENDS='glibc'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='gmp.6.2.1.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
