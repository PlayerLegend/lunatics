#!/bin/busybox sh

# source: ftp://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz

export PKG_NAME='m4'
export PKG_VERSION='1.4.19'
export PKG_SOURCE='Qmbo2EKqRXe2qZr4LNgxfzUGcsy2EbokYJ4Y2VdRFNeHfH/m4-1.4.19.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
