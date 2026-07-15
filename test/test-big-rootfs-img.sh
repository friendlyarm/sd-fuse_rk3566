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
git clone ../../.git sd-fuse
cd sd-fuse
wget ${CDN_URL}/debian-trixie-core-arm64-images.tgz
tar xzf debian-trixie-core-arm64-images.tgz

wget ${CDN_URL}/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

# make big file
fallocate -l 5G debian-trixie-core-arm64/rootfs.img

# calc image size
IMG_SIZE=`du -s -B 1 debian-trixie-core-arm64/rootfs.img | cut -f1`

# re-gen parameter.txt
./tools/generate-partmap-txt.sh ${IMG_SIZE} debian-trixie-core-arm64

./mk-sd-image.sh debian-trixie-core-arm64
sudo ./mk-emmc-image.sh debian-trixie-core-arm64
