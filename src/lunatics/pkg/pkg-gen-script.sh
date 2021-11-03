#!/bin/busybox sh

set -e

unset srcdir

PKG_SOURCE_URL="$1"

clean() {
    rm -r "$srcdir"
}

fatal() {
    >&2 echo "$@"
    clean
    exit 1
}

get_source() {
    srcdir="$(mktemp -d)"
    ( cd "$srcdir" && wget "$PKG_SOURCE_URL" )
}

set_url_vars() {
    ! test -z "$PKG_NAME" || PKG_NAME="$(echo "$PKG_SOURCE_URL" | rev | cut -d/ -f1 | rev | cut -d. -f1 | rev | cut -d- -f2- | rev | grep -Eo '[A-Z,a-z]+' | tr '\n' - | sed 's/-$/\n/g')"
    ! test -z "$PKG_VERSION" || PKG_VERSION="$(basename "$PKG_SOURCE_URL" | rev | cut -d. -f2- | rev | grep -Eo '[0-9]+' | tr '\n' . | sed 's/\.$/\n/g')"

    save_name="$PKG_NAME"
    save_version="$PKG_VERSION"
}

source_build_script() {
    PKG_BUILD_SCRIPT="$(realpath "$PKG_NAME".sh)"
    
    if test -f "$PKG_BUILD_SCRIPT"
    then
	echo "Updating existing script: $PKG_BUILD_SCRIPT"
	. "$PKG_BUILD_SCRIPT"
    fi

    PKG_NAME="$save_name"
    PKG_VERSION="$save_version"
}

digest_source() {
    source_hash="$(ipfs add -Qr "$srcdir")"
    if test -z "$source_hash"
    then
	fatal "Failed to hash source dir"
    else
	PKG_SOURCE="$source_hash"/"$(ls "$srcdir")"
    fi
}

write_script() {
    cat <<EOF > "$PKG_BUILD_SCRIPT"
#!/bin/busybox sh

# source: $PKG_SOURCE_URL

export PKG_NAME='$PKG_NAME'
export PKG_VERSION='$PKG_VERSION'
export PKG_SOURCE='$PKG_SOURCE'

export PKG_INSTALL_DEPENDS='$PKG_INSTALL_DEPENDS'
export PKG_BUILD_DEPENDS='$PKG_BUILD_DEPENDS'

export PKG_OUTFILE="\$PKG_NAME-\$PKG_VERSION.\$(uname -m).tar.xz"

export CFLAGS='-Os'
export CXXFLAGS='-Os'

build() {
    pkg-build-autotools
}
EOF
    chmod +x "$PKG_BUILD_SCRIPT"
}

run_tasks() {
    for task in "$@"
    do
	if ! "$task"
	then
	    fatal "Failed to `echo "$task" | tr _ ' '`"
	fi
    done
}

print_done_text()
{
    echo "Wrote $PKG_BUILD_SCRIPT"
}

run_tasks get_source set_url_vars source_build_script digest_source write_script clean print_done_text
