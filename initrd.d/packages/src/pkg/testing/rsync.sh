#!/bin/busybox sh

# source: https://download.samba.org/pub/rsync/src/rsync-3.2.3.tar.gz

export PKG_NAME='rsync'
export PKG_VERSION='3.2.3'
export PKG_SOURCE='QmXcaMpahdCdvbwEnVujUM8uC8xUW7xZjx9bFSwSgDPa7X/rsync-3.2.3.tar.gz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
