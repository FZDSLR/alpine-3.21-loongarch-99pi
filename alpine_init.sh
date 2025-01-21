sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories

apk add openrc vim openssh alpine-conf fastfetch util-linux e2fsprogs-extra cloud-utils-growpart wpa_supplicant wireless-regdb

rc-update add devfs boot
rc-update add procfs boot
rc-update add sysfs boot
rc-update add networking default
rc-update add sshd default

echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

echo "Asia/Shanghai" > /etc/timezone
echo 'LA99Pi-Alpine' > /etc/hostname
echo 'nameserver 114.114.114.114' > /etc/resolv.conf

echo "ttyS0::respawn:/sbin/agetty --autologin root -L 115200 ttyS0 vt100" >> /etc/inittab

cat > /etc/network/interfaces << EOF
auto eth0
iface eth0 inet dhcp
EOF

echo root:root | chpasswd
