export LINUX_HASH ?= QmZzGjjukV6vkhoP5i1Zx1zGqdUR8v5Ru2riRJUsU1Ab9Z
LINUX_SCRIPT ?= initrd.d/packages/src/pkg/testing/linux-kernel.sh

linux-kernel:

linux: boot/bzImage
boot/bzImage:
	pkg-build --outdir external $(LINUX_SCRIPT)
	( . $(LINUX_SCRIPT) && tar xpvf external/$$PKG_OUTFILE )

.PHONY: linux
