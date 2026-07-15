#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3566/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3566/images
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-6.1.y sd-fuse
cd sd-fuse

wget ${CDN_URL}/openmediavault-arm64-images.tgz
tar xzf openmediavault-arm64-images.tgz

wget ${CDN_URL}/debian-trixie-core-arm64-images.tgz
tar xzf debian-trixie-core-arm64-images.tgz

wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

./mk-sd-image.sh openmediavault-arm64
./mk-emmc-image.sh openmediavault-arm64 autostart=yes

./mk-sd-image.sh debian-trixie-core-arm64
./mk-emmc-image.sh debian-trixie-core-arm64 autostart=yes

wget ${CDN_URL}/friendlywrt25-images.tgz
tar xzf friendlywrt25-images.tgz

wget ${CDN_URL}/friendlywrt25-docker-images.tgz
tar xzf friendlywrt25-docker-images.tgz

./mk-sd-image.sh friendlywrt25
./mk-emmc-image.sh friendlywrt25 autostart=yes

./mk-sd-image.sh friendlywrt25-docker
./mk-emmc-image.sh friendlywrt25-docker autostart=yes

echo "done."
