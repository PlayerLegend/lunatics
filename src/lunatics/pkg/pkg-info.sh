#!/bin/busybox sh

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

lookup_info() {
    pkg-repos | ( while read repo
		  do
		      if ipfs cat "$repo"/"$arg"/build.sh 2>/dev/null
		      then
			  >&2 echo "$repo"/"$arg"
			  exit
		      fi
		  done

		  exit 1 )
}

arg="$1"

PKG_BUILD_SCRIPT="$(mktemp)"
PKG_REPO=''
PKG_OUTFILE_HASH=''

clean() {
    rm "$PKG_BUILD_SCRIPT"
}

fatal() {
    >&2 echo "$@"
    clean
    exit 1
}

if test -f "$arg"
then
    if ! cat "$arg" | decompress "$arg" | pkg-tar-getfile build.sh > "$PKG_BUILD_SCRIPT"
    then
	fatal "Could not find a build.sh in $arg"
    fi

    PKG_OUTFILE_HASH="/ipfs/$(ipfs add -Q --pin=false "$1")"
    
    if test "$PKG_OUTFILE_HASH" = '/ipfs/'
    then
	fatal "Could not add $arg to ipfs"
    fi
else
    PKG_REPO="$(pkg-repos "$arg" | head -1)"
    if test -z "$PKG_REPO"
    then
	fatal "Could not find $arg in any repos"
    fi

    if ! ipfs cat "$PKG_REPO"/"$arg"/build.sh > "$PKG_BUILD_SCRIPT"
    then
	fatal "Could not find a build.sh in repo $PKG_REPO/$arg"
    fi

    . "$PKG_BUILD_SCRIPT"

    PKG_OUTFILE_HASH="$(ipfs resolve "$PKG_REPO"/"$arg"/"$PKG_OUTFILE")"

    if test -z "$PKG_OUTFILE_HASH"
    then
	fatal "Could not find a hash for $PKG_REPO/$PKG_OUTFILE"
    fi
fi

echo "PKG_REPO='$PKG_REPO'"
echo "PKG_OUTFILE_HASH='$PKG_OUTFILE_HASH'"
echo "PKG_BUILD_SCRIPT='$PKG_BUILD_SCRIPT'"
echo
cat "$PKG_BUILD_SCRIPT"

