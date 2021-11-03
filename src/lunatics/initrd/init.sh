#!/bin/busybox sh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

initial_startup() {
    mount_kernel_filesystems() {
	( while read mount_line
	  do
	      do_mount() {
		  mkdir -p "$2"
		  mount "$@"
	      }
	      
	      do_mount $mount_line
	  done ) <<EOF
devtmpfs /dev     -t devtmpfs
devpts   /dev/pts -t devpts
proc     /proc    -t proc
sysfs    /sys     -t sysfs
tmpfs    /run     -t tmpfs
EOF
    }

    detect_devices() {
	mdev -s
    }

    clear_output() {
	echo 0 > /proc/sys/kernel/printk
	clear
    }

    mount_kernel_filesystems
    detect_devices
    clear_output
}

conditional_switch_root() {
    should_switch_root() {
	cat /proc/mounts | grep ^rootfs | cut -d' ' -f2 | grep -qFx /
    }

    if should_switch_root
    then
	newroot=/newroot

	mkdir -p /newroot
	mount tmpfs /newroot -t tmpfs
	
	ls / | grep -v -e newroot -e dev -e proc -e sys -e run | while read target
	do
	    cp -r /"$target" /newroot/
	done

	exec switch_root /newroot /init
	echo "Failed to switch root, dropping to a debug shell"
	exec sh
    fi
}

create_directories() {
    ( while read dir
      do
	  mkdir -p "$dir"
      done ) <<EOF
/bin
/tmp
/etc
/home
/mnt
/root
EOF
}

run_make_init() {
    echo Running makefile init

    touch /etc/init/Makefile
    make -j -C /etc/init

    echo Finished running makefile init
}

start_login_terminals() {

    export ENV=/etc/profile
    
    if ! test -f /etc/hostname
    then
	hostname lunatics
    fi

    exec getty 115200 $(cttyhack)
    #exec getty 115200 /dev/tty0 /dev/tty1 /dev/tty2 /dev/tty3 /dev/tty4 /dev/tty5
    echo failed to getty
    exec sh
}

initial_startup
conditional_switch_root
create_directories
run_make_init
start_login_terminals
