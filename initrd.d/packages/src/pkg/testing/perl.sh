#!/bin/busybox sh

# source: https://www.cpan.org/src/5.0/perl-5.34.0.tar.gz

export PKG_NAME='perl'
export PKG_VERSION='5.34.0'
export PKG_SOURCE='QmZ7c35nM5BhPFU7xa8E9dn2eEcvQSsvojAZZUCHtEnzA5/perl-5.34.0.tar.gz'

export PKG_INSTALL_DEPENDS=''
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE="$PKG_NAME-$PKG_VERSION.$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

export PKG_CONFIGURE_FILENAME='Configure'
export PKG_CONFIGURE_OPTIONS='-d'

build() {
    set -e

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

    decompress() {
	case `echo "$PKG_SOURCE" | rev | cut -d. -f1 | rev` in
	    bz2 )
		bzip2 -d
		;;
	    gz )
		gzip -d
		;;
	    xz )
		xz -d
		;;
	    * )
		fatal "Could not identify archive type"
		;;
	esac
    }

    extract_source() {
	srcdir="$(mktemp -d)"
	ipfs cat "$PKG_SOURCE" | decompress | ( cd "$srcdir" && tar -xpf- )

	if $PKG_1UP_SOURCE_DIR
	then
	    srcdir_tmp="$srcdir"
	    srcdir="$srcdir_tmp"/"$(ls "$srcdir_tmp")"
	fi
    }

    configure_build() {
	( cd "$srcdir" && sh "$srcdir"/"$PKG_CONFIGURE_FILENAME" -des -Dcc=gcc -Dprefix=/usr -d )
    }

    compile_build() {
	make -C "$srcdir" $PKG_MAKEOPTS
    }

    install_build() {
	installdir="$(mktemp -d)"
	export DESTDIR="$installdir"
	make -C "$srcdir" DESTDIR="$DESTDIR" install
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

    create_package() {
	pkg-makepkg "$installdir"
    }

    run_tasks load_config extract_source configure_build compile_build install_build create_package clean

    echo "Done"
}
