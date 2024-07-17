#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi6-v6.1.y

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

if [ -f ../../kernel-rk3566.tgz ]; then
	tar xvzf ../../kernel-rk3566.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3566
fi

MK_HEADERS_DEB=1 BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3566 ./build-kernel.sh debian-bookworm-core-arm64
