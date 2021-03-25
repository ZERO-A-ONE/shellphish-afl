#!/bin/bash -e
  
# taken from the QIRA project

sudo apt install debootstrap debian-archive-keyring -y


DEBOOTSTRAP_DIR=/usr/share/debootstrap
UBUNTU_KEYRING=/usr/share/keyrings/ubuntu-archive-keyring.gpg
DEBIAN_KEYRING=/usr/share/keyrings/debian-archive-keyring.gpg

release_num=$(lsb_release -r --short)
code_name=$(lsb_release -c --short)
hw_arch=$(uname -m)

if [ ! -d "$DEBOOTSTRAP_DIR" ] || [ ! -f "$DEBIAN_KEYRING" ]; then
  echo "this script requires debootstrap and debian-archive-keyring to be installed"
  exit 1
fi

# this is ubuntu specific i think
fetcharch() {
  ARCH="$1"
  DISTRO="$2"
  SUITE="$3"
	
  echo "$ARCH"
  echo "$DISTRO"
  echo "$SUITE"

  exec 4>&1
  SHA_SIZE=256
  DEBOOTSTRAP_CHECKSUM_FIELD="SHA$SHA_SIZE"
  TARGET="$ARCH"
  TARGET="$(echo "`pwd`/$TARGET")"
  HOST_ARCH=`/usr/bin/dpkg --print-architecture`
  HOST_OS=linux
  USE_COMPONENTS=main
  RESOLVE_DEPS=true
  export DEBOOTSTRAP_CHECKSUM_FIELD

  mkdir -p "$TARGET" "$TARGET/debootstrap"

  . $DEBOOTSTRAP_DIR/functions
  . $DEBOOTSTRAP_DIR/scripts/$SUITE

  if [ $DISTRO == "ubuntu" ]; then
    KEYRING=$UBUNTU_KEYRING
    MIRRORS="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"
    if [ $ARCH == "i386" ];then
        MIRRORS="http://cn.archive.ubuntu.com/ubuntu/"
    fi
    echo "$DEF_MIRROR"
  elif [ $DISTRO == "debian" ]; then
    KEYRING=$DEBIAN_KEYRING
    MIRRORS="http://ftp.cn.debian.org/debian"
  else
    echo "need a distro"
    exit 1
  fi

  download_indices
  work_out_debs

  all_debs=$(resolve_deps $LIBS)
  echo "$all_debs"
  download $all_debs

  choose_extractor
  extract $all_debs
}

mkdir -p bin/fuzzer-libs
cd bin/fuzzer-libs

LIBS="libc-bin libstdc++6"
fetcharch armhf ubuntu $code_name
#fetcharch armel debian strech
fetcharch powerpc ubuntu $code_name
fetcharch arm64 ubuntu $code_name
fetcharch i386 ubuntu $code_name
#fetcharch mips debian stretch
#fetcharch mipsel debian stretch


echo "armhf arm64 i386 all done"
# mini debootstrap 
