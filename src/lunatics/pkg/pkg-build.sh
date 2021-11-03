#!/bin/sh

unset PKG_BUILD_SCRIPT build_list

yes_deps=false
rebuild=false

fatal() {
    >&2 echo "$@"
    clean
    exit 1
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

get_script() {
    export PKG_BUILD_SCRIPT="$(mktemp)"
    pkg-script "$1" > "$PKG_BUILD_SCRIPT" && . "$PKG_BUILD_SCRIPT"
}

install_dependencies() {
    if ! test -z "$PKG_INSTALL_DEPENDS" || ! test -z "$PKG_BUILD_DEPENDS"
    then
	if $yes_deps
	then
	    pkg-install --yes $PKG_INSTALL_DEPENDS $PKG_BUILD_DEPENDS
	else
	    pkg-install $PKG_INSTALL_DEPENDS $PKG_BUILD_DEPENDS
	fi
    fi
}

build_package() {
    if $rebuild || ! test -f "$outdir"/"$PKG_OUTFILE"
    then
	mkdir -p "$outdir"
	( cd "$outdir" && build )
    fi
}

build_arg() {
    ( clean() {
	  rm "$PKG_BUILD_SCRIPT"
      }
      
      TASKS="get_script install_dependencies build_package clean" run_tasks "$1" )
}

set_vars() {
    outdir="$PWD"
    build_list="$(mktemp)"
}

read_args() {
    while ! test -z "$1"
    do
	case "$1" in
	    --yes )
		yes_deps=true
		;;

	    --rebuild )
		rebuild=true
		;;

	    --outdir )
		if test -z "$2"
		then
		    fatal "--outdir requires an argument"
		fi
		outdir="$2"
		shift
		;;
	    
	    * )
		echo "$1" >> "$build_list"
		;;
	esac

	shift
    done
}

build_packages() {
    for arg in `sort -u "$build_list"`
    do
	build_arg "$arg"
    done
}

clean() {
    rm "$build_list"
}

TASKS="set_vars read_args build_packages clean" run_tasks "$@"
