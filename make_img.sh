#!/usr/bin/env bash

set -e

IMAGE=image.img
SIZE=512M

rm -f $IMAGE

dd if=/dev/zero of=$IMAGE bs=1 count=0 seek=$SIZE

# 使用fdisk创建分区
{
  echo o  # 创建一个新的MBR分区表
  echo n  # 创建一个新的分区
  echo p  # 选择主分区
  echo 1  # 分区号
  echo    # 默认起始扇区
  echo +128M  # 分配 512MB 大小
  echo n  # 创建另一个新分区
  echo p  # 选择主分区
  echo 2  # 分区号
  echo    # 默认起始扇区
  echo    # 默认结束扇区（使用剩余空间）
  echo w  # 写入并退出
} | fdisk $IMAGE

LABEL_BOOT="BOOT"
LABEL_ROOT="ALPINE_ROOT"

LOOP_DEV=$(sudo losetup -f -P --show $IMAGE)
PART1="${LOOP_DEV}p1"
sudo mkfs.vfat -n $LABEL_BOOT $PART1

PART2="${LOOP_DEV}p2"
sudo mkfs.ext4 -L $LABEL_ROOT $PART2

tmpdir=$(mktemp -d) || exit 1;
trap "sudo umount $tmpdir/fat32 $tmpdir/ext4; sudo losetup -d $LOOP_DEV; sudo rm -rf $tmpdir" EXIT;

mkdir -p $tmpdir/fat32 $tmpdir/ext4
sudo mount ${LOOP_DEV}p1 $tmpdir/fat32
sudo mount ${LOOP_DEV}p2 $tmpdir/ext4

sudo tar -C $tmpdir/ext4 -xf rootfs.tar

for x in $tmpdir/ext4/boot/*; do
  if ! [ -L "$x" ]; then sudo mv $x $tmpdir/fat32/; fi
done

sudo rm -rf $tmpdir/ext4/boot/*

mv $IMAGE image-99pi.img

echo "Image file image-99pi.img created with two partitions."
