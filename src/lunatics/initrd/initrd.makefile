init: src/lunatics/initrd/init.sh

UTILS_SH += init
INITRD_UTILS += init

INITRD_PACKAGES = initrd.d/packages/src/pkg/testing/busybox.sh initrd.d/packages/src/pkg/testing/glibc.sh initrd.d/packages/src/pkg/testing/make.sh initrd.d/packages/src/pkg/testing/go-ipfs-bin.sh initrd.d/packages/src/pkg/testing/xz.sh

initrd: boot/initramfs
INITRD_DEPENDS != find src/lunatics/initrd initrd.d -type f
boot/initramfs: utils $(INITRD_DEPENDS) $(INITRD_PACKAGES)
	INITRD_UTILS="$(INITRD_UTILS)" INITRD_PACKAGES="$(INITRD_PACKAGES)" /bin/busybox sh src/lunatics/initrd/gen-initrd.sh $@

install-boot: boot/initramfs boot/bzImage
	cp boot/initramfs $(DESTDIR)/
	cp boot/bzImage $(DESTDIR)/

.PHONY: initrd
