#!/bin/busybox sh

set -e

unset tmp

result="$1"

clean() {
    rm -r "$tmp"
}

fatal() {
    >&2 echo "$@"
    clean
    exit 1
}

tmp="$(mktemp -d)"

extract_source() {
    ( cd "$tmp" && ipfs cat "$LINUX_HASH" | xz -d | tar xpvf - )
}

configure_source() {
    ( cd "$tmp"/*/ && make defconfig )
}

build_source() {
    ( cd "$tmp"/*/ && make -j`nproc` )
}

copy_result() {
    mkdir -p boot
    cp "$tmp"/*/arch/x86/boot/bzImage "$result"
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

run_tasks extract_source configure_source build_source copy_result clean
