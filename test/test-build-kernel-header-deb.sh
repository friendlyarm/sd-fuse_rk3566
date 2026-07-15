#!/bin/bash
set -eu

if [ -f "$(dirname "$(readlink -f "$0")")/../.use-local-r2" ]; then
    CDN_URL=http://cdn.local/friendlyelec-cdn/os-images/rk3566/images
else
    CDN_URL=https://downloads.friendlyelec.com/os-images/rk3566/images
fi
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
if [ -f ../../debian-trixie-core-arm64-images.tgz ]; then
	tar xvzf ../../debian-trixie-core-arm64-images.tgz
else
	wget ${CDN_URL}/debian-trixie-core-arm64-images.tgz
    tar xvzf debian-trixie-core-arm64-images.tgz
fi

if [ -f ../../kernel-rk3566.tgz ]; then
	tar xvzf ../../kernel-rk3566.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3566
fi

MK_HEADERS_DEB=1 BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3566 ./build-kernel.sh debian-trixie-core-arm64
