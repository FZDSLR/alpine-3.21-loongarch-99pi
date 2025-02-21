.PHONY: all clean

LINUX_SRC ?=

KERNEL_DIR := $(PWD)/kernel

all: image-99pi.img

kernel/linux-99pi.apk kernel/kernel.rsa.pub:
	$(MAKE) -C $(KERNEL_DIR)

rootfs.tar: kernel/linux-99pi.apk kernel/kernel.rsa.pub make_rootfs.sh alpine_init.sh
	@./make_rootfs.sh

image-99pi.img: rootfs.tar make_img.sh
	@./make_img.sh

clean:
	@rm -f ./image-99pi.img rootfs.tar
