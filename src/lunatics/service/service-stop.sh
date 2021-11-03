#!/bin/busybox sh

set -e

# head

! test -z "$SERVICE_ROOT" || SERVICE_ROOT=/var/service

_runlock() {
    mkdir -p /tmp/.service
    ( flock -x 200
      _unlock() {
	  flock -u 200
      }
      "$@" ) 200>/tmp/.service/lockfile
}

export SERVICE_ROOT

mkdir -p "$SERVICE_ROOT"

# body

service_stop() {
    ( name="$1"
      sv="$SERVICE_ROOT"/"$name"
      if ! test -e "$sv"/daemon.sh
      then
	  echo "No such service $name"
	  exit 1
      fi

      pidfile="/tmp/.service/pid/$name"
      
      if ! test -f "$pidfile"
      then
	  echo "Service $name is not running"
	  exit 1
      fi

      pid="$(cat "$pidfile")"

      if kill "$pid"
      then
	  rm "$pidfile"
	  echo "Stopped $name"
      fi )
}

for name in "$@"
do
    _runlock service_stop "$name"
done
