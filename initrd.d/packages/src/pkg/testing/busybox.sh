#!/bin/busybox sh

# source: https://busybox.net/downloads/busybox-1.33.1.tar.bz2

export PKG_NAME='busybox'
export PKG_VERSION='1.33.1'
export PKG_SOURCE='QmcWnjm2R83wUjgH97B9tLVcWigYiZK8AgQM762idEMsPn/busybox-1.33.1.tar.bz2'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='busybox-1.33.1.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    unset srcdir srcdir_tmp installdir
    
    clean() {
	rm -rf "$srcdir" "$srcdir_tmp" "$builddir" "$installdir"
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
	srcdir="$srcdir_tmp"/busybox-"$PKG_VERSION"/
    }

    configure_source() {
	make -C "$srcdir" defconfig
    }

    build_source() {
	make -C "$srcdir" $PKG_MAKEOPTS
    }
    
    install_build() {
	installdir="$(mktemp -d)"
	mkdir "$installdir"/bin
	cp "$srcdir"/busybox "$installdir"/bin/
	"$installdir"/bin/busybox --list | while read prog
	do
	    ln -s /bin/busybox "$installdir"/bin/"$prog"
	done
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

    run_tasks load_config extract_source configure_source build_source install_build create_package clean
}
