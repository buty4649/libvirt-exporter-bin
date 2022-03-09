#!/bin/bash

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: $(basename $0) <VERSION>"
  exit 1
fi

build() {
  local os_ver=$1

  pushd libvirt-exporter
  ./build-with ./build_containers/Dockerfile.ubuntu${os_ver}
  tar cvf - libvirt-exporter | gzip -9f - > ../libvirt-exporter-${VERSION}-${os_ver}.tar.gz
  popd
}

initialize() {
  if [ ! -d libvirt-exporter ]; then
    git clone https://github.com/AlexZzz/libvirt-exporter.git
  fi

  pushd libvirt-exporter
  git switch -c $VERSION
  popd
}

initialize
build 1604
build 1804
build 2004
