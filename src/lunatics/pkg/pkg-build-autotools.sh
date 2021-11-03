#!/bin/busybox sh

set -e

unset srcdir srcdir_tmp builddir installdir

! test -z "$PKG_SEPARATE_BUILD_DIR" || PKG_SEPARATE_BUILD_DIR=true
! test -z "$PKG_1UP_SOURCE_DIR" || PKG_1UP_SOURCE_DIR=true
! test -z "$PKG_SHOULD_AUTOGEN" || PKG_SHOULD_AUTOGEN=false
! test -z "$PKG_CONFIGURE_FILENAME" || PKG_CONFIGURE_FILENAME=configure

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
    
    if $PKG_1UP_SOURCE_DIR
    then
	srcdir="$srcdir_tmp"/"$(ls "$srcdir_tmp")"
    else
	srcdir="$srcdir_tmp"
    fi
}

autogen_build() {
    if $PKG_SHOULD_AUTOGEN
    then
	( cd "$srcdir" && sh autogen.sh )
    fi
}

configure_build() {
    if $PKG_SEPARATE_BUILD_DIR
    then
	builddir="$(mktemp -d)"
    else
	builddir="$srcdir"
    fi

    ( cd "$builddir" && "$srcdir"/"$PKG_CONFIGURE_FILENAME" --prefix=/usr $PKG_CONFIGURE_OPTIONS )
}

compile_build() {
    make -C "$builddir" $PKG_MAKEOPTS
}

install_build() {
    installdir="$(mktemp -d)"
    export DESTDIR="$installdir"
    make -C "$builddir" DESTDIR="$DESTDIR" install
}

create_package() {
    pkg-makepkg "$installdir"
}

finish_message() {
    echo "Built $PKG_NAME: $PKG_OUTFILE"
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

run_tasks <<EOF
load config
extract source
autogen build
configure build
compile build
install build
create package
clean
EOF

