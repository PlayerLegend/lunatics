#!/bin/busybox sh

# source: https://www.openssl.org/source/old/1.1.1/openssl-1.1.1j.tar.gz

export PKG_NAME='openssl'
export PKG_VERSION='1.1.1j'
export PKG_SOURCE='QmSKF2wveQtgG3fHZoxwtSFSPGbXQeQ4ymQUqfnxmKMTV3/openssl-1.1.1j.tar.gz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS='perl coreutils'

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

export PKG_CONFIGURE_FILENAME=Configure

build() {
    pkg-build-autotools
}
