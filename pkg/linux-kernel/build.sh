#!/bin/busybox sh

# source: https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.12.tar.xz

export PKG_NAME='linux-kernel'
export PKG_VERSION='5.12.12'
export PKG_SOURCE='QmPkgpjfjKYqAPKZ5CX3Lt3xRxnUhqQB7X5LCMB3fBFip5/linux-5.12.12.tar.xz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS='rsync'

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    unset srcdir srcdir_tmp installdir
    
    clean() {
	rm -rf "$srcdir" "$srcdir_tmp" "$installdir"
    }

    fatal() {
	>&2 echo "$@"
	clean
	exit 1
    }
    
    load_config() {
	if test -f $HOME/.pkg.sh
	then
	    . $HOME/.pkg.sh
	fi
    }

    extract_source() {
	srcdir_tmp="$(mktemp -d)"
	( cd "$srcdir_tmp" && pkg-source )
	srcdir="$srcdir_tmp"/linux-"$PKG_VERSION"/
    }

    configure_source() {
	make -C "$srcdir" defconfig
    }

    compile_source() {
	make -C "$srcdir" $PKG_MAKEOPTS
    }

    install_build() {
	installdir="$(mktemp -d)"
	mkdir "$installdir"/boot
	cp "$srcdir"/arch/x86/boot/bzImage "$installdir"/boot/
    }
    
    create_package() {
	pkg-makepkg "$installdir"
    }
    
    run_tasks() {
	for task in "$@"
	do
	    if ! "$task"
	    then
		fatal "Failed to `echo "$task" | tr _ ' '`"
	    fi
	done
    }

    run_tasks load_config extract_source configure_source compile_source install_build create_package clean
}
