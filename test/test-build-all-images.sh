#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-6.1.y sd-fuse
cd sd-fuse

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/openmediavault-arm64-images.tgz
tar xzf openmediavault-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/debian-bookworm-core-arm64-images.tgz
tar xzf debian-bookworm-core-arm64-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/friendlywrt23-images.tgz
tar xzf friendlywrt23-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/friendlywrt23-docker-images.tgz
tar xzf friendlywrt23-docker-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/friendlywrt21-images.tgz
tar xzf friendlywrt21-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/friendlywrt21-docker-images.tgz
tar xzf friendlywrt21-docker-images.tgz

wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3566/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz

./mk-sd-image.sh friendlywrt23
./mk-emmc-image.sh friendlywrt23 autostart=yes

./mk-sd-image.sh friendlywrt23-docker
./mk-emmc-image.sh friendlywrt23-docker autostart=yes

./mk-sd-image.sh friendlywrt21
./mk-emmc-image.sh friendlywrt21 autostart=yes

./mk-sd-image.sh friendlywrt21-docker
./mk-emmc-image.sh friendlywrt21-docker autostart=yes

./mk-sd-image.sh openmediavault-arm64
./mk-emmc-image.sh openmediavault-arm64 autostart=yes

./mk-sd-image.sh debian-bookworm-core-arm64
./mk-emmc-image.sh debian-bookworm-core-arm64 autostart=yes

echo "done."
