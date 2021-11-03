#!/bin/busybox sh

# source: https://ftp.gnu.org/gnu/gcc/gcc-9.3.0/gcc-9.3.0.tar.xz

export PKG_NAME='gcc'
export PKG_VERSION='9.3.0'
export PKG_SOURCE='QmP6yTTKvuFE1CiTBn3AatzSqs8sC5bV3JRAAB9T2pBSLS/gcc-9.3.0.tar.xz'

export PKG_INSTALL_DEPENDS='binutils isl gmp mpc mpfr linux-headers'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
