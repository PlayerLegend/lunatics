#!/bin/sh

set -e

unset PKG_NAME
unset PKG_BUILD_SCRIPT

if test -z "$PKG_HOST_REPO"
then
    PKG_HOST_REPO=/pkg/hosted
fi

clean() {
    rm -f "$PKG_BUILD_SCRIPT"
}

fatal() {
    >&2 echo "$@"
    clean
    exit 1
}

is_script() {
    echo "$1" | grep -q '\.sh$'
}

run_tasks() {
    ( for task in $TASKS
      do
	  if ! "$task" "$@"
	  then
	      fatal "Failed to $(echo "$task" | tr _ ' ')"
	  fi
      done )
}

get_build_script() {
    PKG_BUILD_SCRIPT="$(mktemp)"
    pkg-script "$1" > "$PKG_BUILD_SCRIPT"
    . "$PKG_BUILD_SCRIPT"
}

remove_local_repo_package() {
    ipfs files rm -r "$PKG_HOST_REPO"/"$PKG_NAME" 2>/dev/null || true
}

add_local_repo_file() {
    ipfs files mkdir -p "$PKG_HOST_REPO"/"$PKG_NAME"/"$(dirname "$2")"
    ipfs files cp "$1" "$PKG_HOST_REPO"/"$PKG_NAME"/"$2"
}

import_repo_files() {
    if test -f "$1"
    then
	arg_hash="$(ipfs add -Q --pin=false "$1")"
	if is_script "$1"
	then
	    add_local_repo_file /ipfs/"$arg_hash" build.sh
	else
	    add_local_repo_file /ipfs/"$arg_hash" "$PKG_OUTFILE"
	    add_local_repo_file /ipfs/"$(ipfs add -Q --pin=false "$PKG_BUILD_SCRIPT")" build.sh
	    add_local_repo_file /ipfs/"$(echo "$PKG_SOURCE" | cut -d/ -f1)" src
	fi
    else
	repo="$(pkg-repos "$1" | head -1)"
	if test -z "$repo"
	then
	    fatal "Could not find $1 in any repos"
	fi
	
	ipfs files cp "$1" "$PKG_HOST_REPO"/"$PKG_NAME"
    fi
}

finish_message() {
    echo "Added $PKG_NAME to local repo at $PKG_HOST_REPO/$PKG_NAME"
}

install_package() {
    TASKS="get_build_script remove_local_repo_package import_repo_files clean finish_message" run_tasks "$1"
}

install_args() {
    for package in "$@"
    do
	install_package "$package"
    done
}

print_repo_digest() {
    echo "Digest of $PKG_HOST_REPO:"
    ipfs files stat --hash "$PKG_HOST_REPO"
}

TASKS="install_args print_repo_digest" run_tasks "$@"
