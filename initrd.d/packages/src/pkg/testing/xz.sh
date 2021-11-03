#!/bin/busybox sh

# source: https://tukaani.org/xz/xz-5.2.5.tar.xz

export PKG_NAME='xz'
export PKG_VERSION='5.2.5'
export PKG_SOURCE='QmewZJVttkFgFutiBrMMmdqX1SvuunJT3ftQ5A2NiP9nDt/xz-5.2.5.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
