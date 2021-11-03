#!/bin/sh

set -e

is_script() {
    test 'sh' = "$(echo "$1" | rev | cut -d. -f1 | rev)"
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
    if is_script "$1"
    then
	cat "$1"
    else
	cat "$1" | decompress "$1" | pkg-tar-getfile build.sh
    fi
else
    repo="$(pkg-repos "$1" | head -1)"
    if test -z "$repo"
    then
	exit 1
    else
	ipfs cat "$repo"/"$1"/build.sh
    fi
fi

