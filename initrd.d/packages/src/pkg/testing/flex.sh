#!/bin/busybox sh

# source: https://github.com/westes/flex/releases/download/v2.6.3/flex-2.6.3.tar.gz

export PKG_NAME='flex'
export PKG_VERSION='2.6.3'
export PKG_SOURCE='Qmdy6Po7e16aEtdPaZwcSncx6wVaZLjNfWube2VfjaavZv/flex-2.6.3.tar.gz'

export PKG_INSTALL_DEPENDS='m4'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='flex.2.6.3.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
