#!/bin/busybox sh

# source: http://isl.gforge.inria.fr/isl-0.19.tar.xz

export PKG_NAME='isl'
export PKG_VERSION='0.19'
export PKG_SOURCE='QmTrTeCgnN3daojbAzzyfHyakjZoEkeGzBvFTA5xzwRBo7/isl-0.19.tar.xz'

export PKG_INSTALL_DEPENDS='glibc'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='isl.0.19.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
