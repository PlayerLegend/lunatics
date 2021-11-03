#!/bin/sh

for file in /lib/libtinfow* /lib/libncursesw*
do
    ln -vs $file `echo $file | sed 's/w//g'`
done

for file in /lib/libtinfow* /lib/libncursesw*
do
    ln -vs `echo $file | sed 's/w//g'` `echo $file | sed 's/\.so/w\.so/g'`
done
