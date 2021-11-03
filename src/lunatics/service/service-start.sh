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

service_start() {
    ( set -e
      name="$1"
      sv="$SERVICE_ROOT"/"$name"
      if ! test -e "$sv"/daemon.sh
      then
	  echo "No such service $name"
	  exit 1
      fi

      pidfile="/tmp/.service/pid/$name"

      if test -f "$pidfile"
      then
	  echo "Service $name is already running with pid file at $pidfile"
	  exit
      fi

      mkdir -p "$(dirname "$pidfile")"
      mkdir -p "$sv"/cwd
      cd "$sv"/cwd
      if nohup sh "$sv"/daemon.sh > "$sv"/stdout 2> "$sv"/stderr &
      then
	  echo "$!" > "$pidfile"
	  echo "started" > "$sv"/state
	  _unlock
      else
	  echo "Failed to start $service, error written to $sv/stdout"
	  exit 1
      fi
    )      
}

for name in "$@"
do
    _runlock service_start "$name"
done
