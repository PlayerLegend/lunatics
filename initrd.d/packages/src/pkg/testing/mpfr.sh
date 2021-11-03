#!/bin/busybox sh

# source: https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.xz

export PKG_NAME='mpfr'
export PKG_VERSION='4.1.0'
export PKG_SOURCE='Qmcsw9bKqEQPyb3XM8TGx8Cijrvug6yfzA4T3M8ruuD85U/mpfr-4.1.0.tar.xz'

export PKG_INSTALL_DEPENDS='glibc'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='mpfr.4.1.0.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
