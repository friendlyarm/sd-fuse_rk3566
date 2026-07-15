#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3566/images
    ROOTFS_URL=http://cdn.local/friendlyelec-cdn/rootfs/rk3566
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3566/images
    ROOTFS_URL=https://downloads.friendlyelec.com/rootfs/rk3566
fi
# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse
cd sd-fuse
wget ${CDN_URL}/debian-trixie-core-arm64-images.tgz
tar xzf debian-trixie-core-arm64-images.tgz
wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget ${ROOTFS_URL}/rootfs-debian-trixie-core-arm64.tgz
wget ${ROOTFS_URL}/rootfs-debian-trixie-core-arm64.tgz.sha256
sha256sum -c rootfs-debian-trixie-core-arm64.tgz.sha256

sudo tar xzfp rootfs-debian-trixie-core-arm64.tgz --numeric-owner --same-owner
sudo ./build-rootfs-img.sh debian-trixie-core-arm64/rootfs debian-trixie-core-arm64

./mk-sd-image.sh debian-trixie-core-arm64
./mk-emmc-image.sh debian-trixie-core-arm64
