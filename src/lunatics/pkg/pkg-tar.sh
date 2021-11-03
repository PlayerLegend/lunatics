#!/bin/sh

fatal() {
    >&2 echo "$@"
    exit 1
}

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

if test -f "$1"
then
    cat "$1" | decompress "$1"
else
    repo="$(pkg-repos "$1" | head -1)"
    if test -z "$repo"
    then
	exit 1
    fi
    eval "$(ipfs cat "$repo"/"$1"/build.sh)"
    if test -z "$PKG_OUTFILE"
    then
	exit 1
    fi
    ipfs cat "$repo"/"$1"/"$PKG_OUTFILE" | decompress "$PKG_OUTFILE"
fi
