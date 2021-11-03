#!/bin/busybox sh

list_repos() {
    grep -v -e '^#' -e '^$' /etc/pkg/repos | while read line
    do
	if  echo "$line" | grep -q '$/ipns/'
	then
	    ipfs resolve "$line"
	elif echo "$line" | grep -q '$/ipfs/'
	then
	    echo "$line"
	else
	    echo "/ipfs/$(ipfs files stat --hash "$line")"
	fi
    done
}

if ! test -z "$1"
then
    list_repos | while read repo
    do
	if ipfs ls "$repo"/"$1" >/dev/null 2>/dev/null
	then
	    echo "$repo"
	fi
    done
else
    list_repos
fi
