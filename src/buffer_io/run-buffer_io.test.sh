#!/bin/sh

set -e

input="$(mktemp)"
output="$(mktemp)"

clean() {
    rm "$input" "$output"
}

dd if=/dev/urandom of="$input" bs=1M count=1 2>/dev/null
cat "$input" | test/buffer_io > "$output"

if cmp "$input" "$output"
then
    echo "Passed buffer_io"
    clean
else
    echo "buffer_io failed to reproduce its input"
    clean
fi
