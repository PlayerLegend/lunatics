#!/bin/sh

unset PKG_INSTALL_DEPENDS
unset PKG_BUILD_DEPENDS

deps_file="$(mktemp)"
args_file="$(mktemp)"

is_script() {
    test 'sh' = "$(echo "$1" | rev | cut -d. -f1 | rev)"
}

direct_deps() {
    print_deps() {
	if $use_build_deps
	then
	    printf '%s\n' $PKG_BUILD_DEPENDS $PKG_INSTALL_DEPENDS
	else
	    printf '%s\n' $PKG_INSTALL_DEPENDS
	fi 
    }

    ( unset PKG_NAME
      unset PKG_BUILD_DEPENDS
      unset PKG_INSTALL_DEPENDS

      eval "$(pkg-script "$1")"

      print_deps )
}

filter_installed() {
    if $exclude_installed_deps
    then
	while read dep
	do
	    if ! test -d "$PKG_ROOT"/pkg/"$dep"
	    then
		echo "$dep"
	    fi
	done
    else
	cat
    fi
}

filter_repeats() {
    while read dep
    do
	if ! grep -qFx "$dep" "$deps_file"
	then
	    echo "$dep"
	fi
    done
}

add_deps() {
    direct_deps "$1" | grep -v '^$' | filter_repeats | filter_installed | tee -a "$deps_file" | while read dep
    do
	add_deps "$dep"
    done
}

exclude_installed_deps=false
use_build_deps=false

for arg in "$@"
do
    if test "$arg" = '--missing'
    then
	exclude_installed_deps=true
    elif test "$arg" = '--build'
    then
	use_build_deps=true
    else
	( unset PKG_NAME
	  
	  eval "$(pkg-script "$arg")"

	  echo "$PKG_NAME" >> "$args_file" )
    fi
    
    add_deps "$arg"
done

for file in "$deps_file" "$args_file"
do
    sed -i '/^$/d' "$file"
    sort -u -o "$file" "$file"
done

comm -23 "$deps_file" "$args_file"

rm "$deps_file" "$args_file"
