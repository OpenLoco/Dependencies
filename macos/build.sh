#!/bin/bash

# Echo commands as they're executed, exit when any of the commands below fails
set -ex

# First, install a newer version of gcc
brew install gcc@8

# Get vcpkg and bootstrap it
git clone -q https://github.com/Microsoft/vcpkg
pushd vcpkg
./bootstrap-vcpkg.sh

# Prepare for x86 target
VCPKG_DEFAULT_TRIPLET=x86-osx
cp ../macos/${VCPKG_DEFAULT_TRIPLET}.cmake triplets/

# Install dependencies
./vcpkg install \
	benchmark \
	gtest \
	libpng \
	sdl2 \
	sdl2-mixer \
	yaml-cpp

# Zip the lot
zip -r ../macos.dependencies.zip .vcpkg-root installed/ scripts/

popd
