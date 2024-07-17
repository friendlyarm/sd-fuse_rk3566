#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
UBOOT_REPO=https://github.com/friendlyarm/uboot-rockchip
UBOOT_BRANCH=nanopi5-v2017.09

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse
cd sd-fuse
if [ -f ../../debian-bookworm-core-arm64-images.tgz ]; then
	tar xvzf ../../debian-bookworm-core-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/debian-bookworm-core-arm64-images.tgz
    tar xvzf debian-bookworm-core-arm64-images.tgz
fi

git clone ${UBOOT_REPO} --depth 1 -b ${UBOOT_BRANCH} uboot-rk3566
[ -d rkbin ] || git clone https://github.com/friendlyarm/rkbin --depth 1 -b nanopi5
UBOOT_SRC=$PWD/uboot-rk3566 ./build-uboot.sh debian-bookworm-core-arm64
sudo ./mk-sd-image.sh debian-bookworm-core-arm64
