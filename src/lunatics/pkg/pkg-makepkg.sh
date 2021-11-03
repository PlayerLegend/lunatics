#!/bin/busybox sh

installdir="$1"

set -e

unset list

clean() {
    rm "$list"
}

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

check_arg() {
    if test -z "$1"
    then
	fatal "usage: $0 [package root]"
    fi
}

check_environment_variables() {
    if test -z "$PKG_VERSION" || test -z "$PKG_NAME"
    then
	fatal "PKG_NAME and PKG_VERSION must be defined"
    fi
}

generate_package_file_list() {
    pkg_file_list="$(mktemp)"
    ( cd "$1" && find ) > "$pkg_file_list"
}

copy_info_files() {
    infodir="$1"/pkg/"$PKG_NAME"
    mkdir -p "$infodir"
    cp "$PKG_BUILD_SCRIPT" "$infodir"/build.sh
    cp "$pkg_file_list" "$infodir"/file-list
}

compress_package() {
    outfile="$PWD"/"$PKG_OUTFILE"

    set_tar_options() {
	unset tar_options
	
	case `echo "$PKG_OUTFILE" | rev | cut -d. -f1 | rev` in
	    bz2 )
		tar_options=jcvf
		;;
	    gz )
		tar_options=zcvf
		;;
	    xz )
		tar_options=Jcvf
		;;
	    * )
		fatal "Could not identify archive type"
		;;
	esac
    }

    set_tar_options
    
    if ! ( cd "$1" && tar $tar_options "$outfile" . )
    then
	rm "$outfile"
	exit 1
    fi
}

print_done_message() {
    echo "Created $PKG_NAME package at $outfile"
}

TASKS="check_arg check_environment_variables generate_package_file_list copy_info_files compress_package print_done_message" run_tasks "$@"
