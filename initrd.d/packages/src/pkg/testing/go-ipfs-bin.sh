#!/bin/busybox sh

# source: https://github.com/ipfs/go-ipfs/releases/download/v0.8.0/go-ipfs_v0.8.0_linux-amd64.tar.gz

export PKG_NAME='go-ipfs'
export PKG_VERSION='0.8.0'
export PKG_SOURCE='QmPL4tjzUexdveEPBRm39cckZ2vNr4ekXGYRRatHHmCwP9/go-ipfs_v0.8.0_linux-amd64.tar.gz'

export PKG_INSTALL_DEPENDS='glibc'
export PKG_BUILD_DEPENDS=''

export PKG_OUTFILE='go-ipfs-0.8.0.tar.xz'

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    unset srcdir installdir
    
    clean() {
	rm -rf "$srcdir" "$installdir"
    }
    
    fatal() {
	>&2 echo "$@"
	clean
	exit 1
    }
    
    run_tasks() {
	( while read task
	  do
	      task_function="$(echo "$task" | tr ' ' _)"
	      if ! "$task_function" "$@"
	      then
		  fatal "Failed to $task"
	      fi
	  done )
    }

    extract_source() {
	srcdir="$(mktemp -d)"
	( cd "$srcdir" && pkg-source )
    }

    copy_ipfs() {
	installdir="$(mktemp -d)"
	mkdir -p "$installdir"/usr/bin
	cp "$srcdir"/go-ipfs/ipfs "$installdir"/usr/bin/
    }

    create_package() {
	pkg-makepkg "$installdir"
    }

    run_tasks <<EOF
extract source
copy ipfs
create package
clean
EOF
}
