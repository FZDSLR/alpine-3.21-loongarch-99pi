set -e

cd /build

tar -cf src.tar uImage lib mkimage-la

if [ ! -f "/build/kernel.rsa" ]; then
{
  echo "/build/kernel.rsa"
  echo
} | abuild-keygen
fi

cp /build/kernel.rsa.pub /etc/apk/keys

mkdir -p /root/.abuild/ && touch /root/.abuild/abuild.conf && echo 'PACKAGER_PRIVKEY="/build/kernel.rsa"' >> /root/.abuild/abuild.conf

abuild -F checksum

abuild -F -r

rm src.tar

cp /root/packages/loongarch64/linux-99pi-*.apk /build/linux-99pi.apk
