VM_RAM ?= 5G
VM_ROOTSIZE ?= 4.5G
LUNATICS_VM_DISK ?= /home/lunatics.img
LUNATICS_VM_DISK_UUID != blkid -s UUID -o value $(LUNATICS_VM_DISK)

#QEMU_KERNEL_PARAMETERS = disk=caa5ce24-4234-4e8e-a632-ae9aefc9f92d/disk disk=afda243c-7900-48a7-8272-7470a06c1e23/tmp IPFS_PATH=/disk/ipfs rootsize=$(VM_ROOTSIZE) add_repo=QmSEHg8MYvPjVJRwrnVGEgrHLmoNz5PeNGJkscvzzPun4P add_repo=QmSGaTP4eatTf9QZYuhZ66bxaCjkrWMBouirLDP9t4tAgq pkg-install=$(PKGINSTALL) pkg-build=$(PKGBUILD)

QEMU_KERNEL_PARAMETERS = mount_disk=$(LUNATICS_VM_DISK_UUID)/disk IPFS_PATH=/disk/ipfs install_packages=$(INSTALL_PACKAGES)

VM_CORES ?= `nproc`
#QEMU ?= qemu-system-x86_64
QEMU ?= kvm


#		-net nic -net tap,ifname=tap0,script=no,downscript=no \

QEMU_COMMAND = 	$(QEMU) --enable-kvm -cpu host -m $(VM_RAM) -smp $(VM_CORES) \
		-drive file=$(LUNATICS_VM_DISK),format=raw \
		-net nic -net tap,ifname=tap0,script=no,downscript=no \
		-kernel boot/bzImage -initrd boot/initramfs \
		-append 'console=ttyS0 $(QEMU_KERNEL_PARAMETERS)'

qemu-gui: initrd linux
	$(QEMU_COMMAND)

qemu-cli: initrd linux
	$(QEMU_COMMAND) --nographic
#	su -c "$(QEMU_COMMAND) --nographic"

qemu-term: initrd linux
	xterm -hold -e $(QEMU_COMMAND) --nographic

qemu-init-bridge:
	echo 1 > /proc/sys/net/ipv4/ip_forward
	brctl addbr br0
	brctl addif br0 enp24s0
	ip link set dev br0 up
	ip link set dev enp24s0 up
	dhclient -v br0

qemu-init-tap:
	modprobe tun
	/usr/sbin/openvpn --mktun --dev tap0 --user legend
	brctl addif br0 tap0
	ip link set dev tap0 up

.PHONY: qemu-gui qemu-cli qemu-term
