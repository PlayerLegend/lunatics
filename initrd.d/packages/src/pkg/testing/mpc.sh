#!/bin/busybox sh

# source: https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz

export PKG_NAME='mpc'
export PKG_VERSION='1.1.0'
export PKG_SOURCE='QmW5V66UTMoMQfFsRqchHpH7UHw3WBeuMwU2vtEJQ8ufo2/mpc-1.1.0.tar.gz'

export PKG_INSTALL_DEPENDS='mpfr'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='mpc.1.1.0.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
