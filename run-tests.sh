#!/bin/sh

for program in "$@"
do
    echo "Testing $program ..."

    fail() {
	echo "$@"
	echo "stdout written to $program.stdout"
	echo "stderr written to $program.stderr"
	exit 1
    }

    if ! "$program" > "$program".stdout 2> "$program".stderr
    then
	fail "Failed to run $program"
    fi

    find src -name "$(basename "$program")".stdout | if read file && ! cmp "$program".stdout "$file"
    then
	fail "Program stdout differs from what is expected in $file"
    fi

    find src -name "$(basename "$program")".stderr | if read file && ! cmp "$program".stderr "$file"
    then
	fail "Program stderr differs from what is expected in $file"
    fi
done
