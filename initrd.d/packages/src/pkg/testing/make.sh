#!/bin/busybox sh

# source: https://ftp.gnu.org/gnu/make/make-4.3.tar.gz

export PKG_NAME='make'
export PKG_VERSION='4.3'
export PKG_SOURCE='QmWuRQqXVkkWGrmxidiJHyrHAAGRa4iaPNdowezonjWc7j/make-4.3.tar.gz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='make-4.3.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
