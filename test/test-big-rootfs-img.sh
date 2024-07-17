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

# make big file
fallocate -l 5G debian-bookworm-core-arm64/rootfs.img

# calc image size
IMG_SIZE=`du -s -B 1 debian-bookworm-core-arm64/rootfs.img | cut -f1`

# re-gen parameter.txt
./tools/generate-partmap-txt.sh ${IMG_SIZE} debian-bookworm-core-arm64

./mk-sd-image.sh debian-bookworm-core-arm64
sudo ./mk-emmc-image.sh debian-bookworm-core-arm64
