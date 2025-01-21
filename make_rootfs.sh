#!/usr/bin/env bash

sudo podman run --rm --privileged loongcr.lcpu.dev/multiarch/archlinux --reset -p yes
podman run --platform linux/loong64 --name "la99pi-alpine-rootfs" ghcr.io/fzdslr/alpine:3.21 sh -c "echo $(base64 -w 0 ./alpine_init.sh)| base64 -d | sh"
podman export la99pi-alpine-rootfs > rootfs.tar
podman rm la99pi-alpine-rootfs

