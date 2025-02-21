#!/usr/bin/env bash

if [ -f "/proc/sys/fs/binfmt_misc/qemu-loongarch64" ]; then
    echo "binfmt for qemu-loongarch64 is enabled.";
else
    echo "binfmt for qemu-loongarch64 is not enabled.";
    sudo podman run --rm --privileged loongcr.lcpu.dev/multiarch/archlinux --reset -p yes;
fi;

container_name=$(podman create --platform linux/loong64 ghcr.io/fzdslr/alpine:3.21 sh -c "echo $(base64 -w 0 ./alpine_init.sh)| base64 -d | sh")
trap "podman rm $container_name" EXIT;

podman cp kernel/linux-99pi.apk $container_name:/root/
podman cp kernel/kernel.rsa.pub $container_name:/etc/apk/keys/
podman start -a $container_name
podman export $container_name > rootfs.tar
