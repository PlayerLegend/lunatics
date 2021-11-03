#!/bin/sh

set -e

unset tmp install_list

pkg_dir="$PKG_ROOT"/pkg
install_list="$(mktemp)"

fatal() {
    >&2 echo "$@"
    clean
    rm "$install_list"
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

is_script() {
    echo "$1" | grep -q '\.sh$'
}

get_build_script() {
    tmp="$(mktemp -d)"
    
    if $from_source || is_script "$1"
    then
	pkg-script "$1" > "$tmp"/build.sh
    fi
}

build_package() {
    if test -f "$tmp"/build.sh
    then
	if ! test -z "$cache_dir"
	then
	    outdir="$cache_dir"
	else
	    outdir="$tmp"
	fi

	pkg-build "$tmp"/build.sh --outdir "$outdir"
	. "$tmp"/build.sh

	TASKS="install_package_files host_package clean" run_tasks "$outdir"/"$PKG_OUTFILE"
	exit
    fi
}

install_package_files() {
    echo "installing files for $1"
    pkg-tar "$1" | pkg-tar-install
}

host_package() {
    PKG_HOST_REPO=/pkg/installed pkg-host "$1"
}

install_package()
{
    unset tmp
    clean() {
	rm -rf "$tmp"
    }
    echo "Installing $1"
    TASKS="get_build_script build_package install_package_files host_package clean" run_tasks "$1"
}

ask() {
    echo -n "Install $1? [Y(es)/a(ll)/n(o)/N(o all)] "

    while true
    do
	if ! read answer
	then
	    return 1
	fi

	if test -z "$answer"
	then
	    return
	fi

	if test "$answer" = Y || test "$answer" = y
	then
	    return
	fi

	if test "$answer" = N
	then
	    no_all=true
	    return 1
	fi
	
	if test "$answer" = n
	then
	    return 1
	fi

	if test "$answer" = A || test "$answer" = a
	then
	    yes_all=true
	    return
	fi

	echo -n "Invalid answer $answer, please enter y or n> "
    done

    return 1
}

help() {
    cat <<EOF
$0 - Install packages from files or repositories

usage: $0 [flags] [packages]

Flags are:
      --yes               Yes to all "should install?" prompts
      --no-deps           Do not install any dependencies for the given packages
      --reinstall         Install or reinstall the given packages
      --reinstall-deps    Install or reinstall the given packages and their dependencies
      --source        	  Build the packages from source
      --help        	  Show this help text

Packages may be local archives created with pkg-makepkg, build scripts, or package names found within the repositories listed in /etc/pkg/repos.
The order of flag and package arguments does not matter.
EOF
}

set_defaults() {
    yes_all=false
    no_all=false
    no_deps=false
    from_source=false
    reinstall_packages=false
    reinstall_dependencies=false
}

read_args() {
    if test -z "$1"
    then
	help
	clean
	exit
    fi

    install_list="$(mktemp)"

    while ! test -z "$1"
    do
	case "$1" in
	    --yes )
		yes_all=true
		;;

	    --no-deps )
		no_deps=true
		;;

	    --reinstall )
		reinstall_packages=true
		;;

	    --reinstall-deps )
		reinstall_packages=true
		reinstall_dependencies=true
		;;

	    --source )
		from_source=true
		;;

	    --cache )
		if test -z "$2"
		then
		    fatal "--cache requires an argument"
		fi
		
		cache_dir="$2"
		shift
		;;

	    --root )
		if test -z "$2"
		then
		    fatal "--root requires an argument"
		fi
		
		export PKG_ROOT="$2"
		shift
		;;

	    --help )
		help
		exit
		;;
	    
	    * )
		if test -d "$pkg_dir"/"$1" && ! $reinstall_packages
		then
		    echo "$1 is already installed"
		else
		    echo "$1" >> "$install_list"
		fi
		;;
	esac
	shift
    done
}

add_dependencies() {
    if $no_deps
    then
	return
    fi

    if $reinstall_dependencies
    then
	pkg-depends `sort -u "$install_list"` >> "$install_list"
    else
	pkg-depends --missing `sort -u "$install_list"` >> "$install_list"
    fi
}

print_dependency_list() {
    echo "Packages to install:"
    echo
    sort -u "$install_list" | sed 's/^/    /'
}

install_list() {
    for package in `sort -u $install_list`
    do
	echo
	if ! $yes_all && ! ask "$package"
	then
	    if $no_all
	    then
		break
	    fi
	    
	    continue
	fi

	install_package "$package"
    done
}

clean() {
    rm "$install_list"
}

TASKS="set_defaults read_args add_dependencies print_dependency_list install_list clean" run_tasks "$@"
