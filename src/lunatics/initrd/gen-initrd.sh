#!/bin/busybox sh

set -e

outfile="$1"
mkdir -p "$(dirname "$outfile")"
mkdir -p external
unset initrd_root
initrd_root="$(mktemp -d)"

clean() {
    rm -rf "$initrd_root"
}

fatal() {
    >&2 echo "$@"
    clean
    exit 1
}

copy_initrd_options() {
    for dir in initrd.d/*
    do
	cp -vr "$dir"/* "$initrd_root"/
    done
}

create_root_directories() {
    for dir in dev sys proc bin sbin etc
    do
	mkdir -p "$initrd_root"/"$dir"
    done
}

install_base_packages() {
    echo pkg-install --root "$initrd_root" --cache external --yes "$INITRD_PACKAGES"
    pkg-install --root "$initrd_root" --cache external --yes $INITRD_PACKAGES
}

copy_initrd_utilities() {
    for prog in $INITRD_UTILS
    do
	mkdir -p "$initrd_root"/"$(dirname "$prog")"
	cp "$prog" "$initrd_root"/"$(dirname "$prog")"/
    done
}

generate_initrd_image() {
    ( cd "$initrd_root" && find | cpio -H newc -o ) > "$outfile"
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

run_tasks copy_initrd_options create_root_directories install_base_packages copy_initrd_utilities generate_initrd_image clean
