#!/usr/bin/env bash

set -e

IMAGE=image.img
SIZE=256M

rm -f $IMAGE

dd if=/dev/zero of=$IMAGE bs=1 count=0 seek=$SIZE

# 使用fdisk创建分区
{
  echo o  # 创建一个新的MBR分区表
  echo n  # 创建一个新的分区
  echo p  # 选择主分区
  echo 1  # 分区号
  echo    # 默认起始扇区
  echo +64M  # 分配 512MB 大小
  echo n  # 创建另一个新分区
  echo p  # 选择主分区
  echo 2  # 分区号
  echo    # 默认起始扇区
  echo    # 默认结束扇区（使用剩余空间）
  echo w  # 写入并退出
} | fdisk $IMAGE

UUID_EXT4="7cd65de3-e0be-41d9-b66d-96d749c02da7"

LOOP_DEV=$(sudo losetup -f -P --show $IMAGE)
PART1="${LOOP_DEV}p1"
sudo mkfs.vfat $PART1

PART2="${LOOP_DEV}p2"
sudo mkfs.ext4 -U $UUID_EXT4 $PART2

mkdir -p ./mnt/fat32 ./mnt/ext4
sudo mount /dev/loop0p1 ./mnt/fat32
sudo mount /dev/loop0p2 ./mnt/ext4

sudo cp uImage-tfcard mnt/fat32/
sudo cp uImage-wifi mnt/fat32/
sudo tar -C ./mnt/ext4 -xvf rootfs.tar
sudo cp -r modules ./mnt/ext4/lib/

sudo umount ./mnt/fat32 ./mnt/ext4

sudo losetup -d $LOOP_DEV

echo "Image file $IMAGE created with two partitions."
