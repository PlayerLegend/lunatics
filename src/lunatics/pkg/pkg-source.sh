#!/bin/sh

decompress() {
    case `echo "$1" | rev | cut -d. -f1 | rev` in
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
	    fatal "Could not identify archive type for $1"
	    ;;
    esac
}

if ! test -z "$1"
then
    eval "$(pkg-script "$1")"
fi

if test -z "$PKG_SOURCE"
then
    exit 1
fi

ipfs cat "$PKG_SOURCE" | decompress "$PKG_SOURCE" | tar xpf -
