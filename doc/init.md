# init script

  Found in src/lunatics/initrd/init.sh, this is the script that goes from kernel startup to login terminal. Along the line, it will run the makefile init system, which is configurable.

# makefile init

  Found in initrd.d/init/etc/init/, this is where you should configure startup scripts.
  Scripts can be placed in this directory