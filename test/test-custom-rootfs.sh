#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse
cd sd-fuse
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/debian-bookworm-core-arm64-images.tgz
tar xzf debian-bookworm-core-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/rootfs/rootfs-debian-bookworm-core-arm64.tgz

sudo tar xzfp rootfs-debian-bookworm-core-arm64.tgz --numeric-owner --same-owner
sudo ./build-rootfs-img.sh debian-bookworm-core-arm64/rootfs debian-bookworm-core-arm64

./mk-sd-image.sh debian-bookworm-core-arm64
./mk-emmc-image.sh debian-bookworm-core-arm64
