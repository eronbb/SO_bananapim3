#!/bin/bash
# Gera a imagem do Banana Pi M3. Rode num PC Linux x86_64 (Ubuntu 22.04/24.04) com ~30GB livres.
set -e
cd "$(dirname "$0")"
[ -d armbian-build ] || git clone --depth=1 https://github.com/armbian/build armbian-build
rm -rf armbian-build/userpatches && cp -r userpatches armbian-build/userpatches
cd armbian-build
./compile.sh build \
  BOARD=bananapim3 BRANCH=current RELEASE=noble \
  BUILD_MINIMAL=yes BUILD_DESKTOP=no KERNEL_CONFIGURE=no \
  COMPRESS_OUTPUTIMAGE=sha,xz
echo "Imagem em: armbian-build/output/images/"
