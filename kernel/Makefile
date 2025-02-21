LINUX_SRC ?=

.PHONY: all clean

all: linux-99pi.apk

.kernel-image:
	@if ! podman image exists la-k-builder; then \
		echo "The image la-k-builder does not exist, starting to build..."; \
		podman build -t la-k-builder ./loongarch64-kernel-builder; \
		touch .kernel-image; \
	else \
		echo "The image la-k-builder already exists, skip the build step."; \
	fi

uImage lib.tar: .kernel-image build-k.sh
	@if [ -z "$(LINUX_SRC)" ]; then \
		echo "Error: The directory of the kernel source code is not provided."; \
		exit 1; \
	fi
	@if [ ! -d "$(LINUX_SRC)" ]; then \
		echo "The provided path is not a directory."; \
		exit 1; \
	fi
	@tmpdir=$$(mktemp -d) || exit 1; \
	trap 'rm -rf "$$tmpdir"' EXIT; \
	podman run --rm \
		-v "$(LINUX_SRC):/build" \
		-v "$$tmpdir:/install" \
		localhost/la-k-builder \
		/bin/bash -c "echo $(shell base64 -w 0 ./build-k.sh) | base64 -d | bash"; \
	cp "$$tmpdir/uImage" "$$tmpdir/lib.tar" ./

.apk-image:
	@if [ -f "/proc/sys/fs/binfmt_misc/qemu-loongarch64" ]; then \
		echo "binfmt for qemu-loongarch64 is enabled."; \
	else \
		echo "binfmt for qemu-loongarch64 is not enabled."; \
		sudo podman run --rm --privileged loongcr.lcpu.dev/multiarch/archlinux --reset -p yes; \
	fi; \
	if ! podman image exists la-apk-builder; then \
		echo "The image la-apk-builder does not exist, starting to build..."; \
		podman build --platform linux/loong64 -t la-apk-builder ./loongarch64-kernel-apk-builder; \
		touch .apk-image; \
	else \
		echo "The image la-apk-builder already exists, skip the build step."; \
	fi

linux-99pi.apk kernel.rsa kernel.rsa.pub: uImage lib.tar APKBUILD linux-99pi.post-install alpine-pkg.sh .apk-image
	@tmpdir=$$(mktemp -d) || exit 1; \
	trap 'rm -rf "$$tmpdir"' EXIT; \
	cp ./uImage ./mkimage-la  ./APKBUILD ./linux-99pi.post-install "$$tmpdir"; \
	tar -xf lib.tar -C "$$tmpdir"; \
	if [ -f "./kernel.rsa" ] && [ -f "./kernel.rsa.pub" ]; then \
		cp ./kernel.rsa "$$tmpdir"; \
		cp ./kernel.rsa.pub "$$tmpdir"; \
	fi; \
	if [ -f "/proc/sys/fs/binfmt_misc/qemu-loongarch64" ]; then \
		echo "binfmt for qemu-loongarch64 is enabled."; \
	else \
		echo "binfmt for qemu-loongarch64 is not enabled."; \
		sudo podman run --rm --privileged loongcr.lcpu.dev/multiarch/archlinux --reset -p yes; \
	fi; \
	podman run --rm --platform linux/loong64 -it -v "$$tmpdir:/build" localhost/la-apk-builder \
		sh -c "echo $(shell base64 -w 0 ./alpine-pkg.sh) | base64 -d | sh"; \
	cp "$$tmpdir/linux-99pi.apk" ./ ; \
	if [ ! -f "./kernel.rsa" ] && [ ! -f "./kernel.rsa.pub" ]; then \
		cp "$$tmpdir/kernel.rsa" ./; \
		cp "$$tmpdir/kernel.rsa.pub" ./; \
	else \
		touch ./kernel.rsa ./kernel.rsa.pub ; \
	fi

clean:
	rm -f uImage lib.tar linux-99pi.apk
