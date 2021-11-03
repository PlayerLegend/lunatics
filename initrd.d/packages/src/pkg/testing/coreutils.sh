#!/bin/busybox sh

# source: ftp://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz

export PKG_NAME='coreutils'
export PKG_VERSION='8.32'
export PKG_SOURCE='Qme3dgRgKYrt89rQKsJpzSQVzcPvyjsCvVjVYyqdwy3vK7/coreutils-8.32.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
