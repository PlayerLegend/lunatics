#!/bin/sh

set -e

for package in "$@"
do
    if test -e "$package"
    then
	continue
    fi

    repo="$(pkg-repos "$package" | head -1)"
    if test -z "$repo"
    then
	echo "Could not find a repo containing $package"
	continue
    fi

    ipfs get "$repo"/"$package"
done
