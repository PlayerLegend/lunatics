#!/bin/sh

if ! test -z "$IPFS_PATH" && ! test -d "$IPFS_PATH"/
then
    mkdir -p "$IPFS_PATH"
    #ipfs init
fi

export IPFS_PATH

ipfs daemon --init
