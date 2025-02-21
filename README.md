在龙芯久久派上启动 Alpine 3.21 / Launching Alpine 3.21 on Loongarch 99 pi

![fastfetch](./pic/1.jpg)

## 如何构建？ / How to build?

确保 Podman 可用 / Make sure Podman is available

```bash
make LINUX_SRC=/your/linx/kernel/src
```

## 如何烧录？ / How to burn?

Linux 下： / Under Linux:

```bash
dd if=./image-99pi.img of=/dev/${Your_USB_Disk} bs=4M
```

Windows 下，使用 rufus 等软件进行烧录。/ For Windows, use software like rufus to burn.

## 如何引导？ / How to boot?

请确保久久派的 Uboot 可用。 / Ensure that Uboot is available for 99 Pi。

在 Uboot 命令行下： / At the Uboot command line:

```
fatload usb 0:1 0x9000000003000000 boot.scr;
source 0x9000000003000000;
```

## 启动系统后的注意事项 / Tips after booting the system

### 如何扩展根分区？ / How to extend the root partition?

进入 Alpine 后，执行： / After entering Alpine, run:

```bash
growpart /dev/sda 2
resize2fs /dev/sda2
```
