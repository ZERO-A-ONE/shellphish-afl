#!/bin/sh
sudo apt update && sudo apt upgrade -y
sudo apt-get install libtool-bin bison python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential -y
sudo apt-get install build-essential gcc-multilib debootstrap debian-archive-keyring -y
sudo apt-get install pkg-config libglib2.0-dev libmount-dev python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential autoconf automake libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev unzip cmake yasm libx264-dev libmp3lame-dev libopus-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev -y
sudo apt-get build-dep qemu -y
sudo apt-get install re2c
git clone git://github.com/ninja-build/ninja.git && cd ninja
./configure.py --bootstrap
sudo cp ninja /usr/bin/
ninja --version
sudo apt install glances
