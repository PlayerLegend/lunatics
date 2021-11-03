#!/bin/busybox sh

# source: https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.xz

export PKG_NAME='binutils'
export PKG_VERSION='2.36'
export PKG_SOURCE='QmYitrqso8fhf8nzrz3UPnEhCzJUt4agVrJRYMupKtPyfn/binutils-2.36.tar.xz'

export PKG_INSTALL_DEPENDS='glibc flex'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='binutils-2.36.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
