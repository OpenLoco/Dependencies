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
cp ../x86-osx.cmake triplets/

# Install dependencies
./vcpkg install \
	benchmark:x86-osx \
	gtest:x86-osx \
	libpng:x86-osx \
	openal-soft:x86-osx \
	sdl2:x86-osx \
	yaml-cpp:x86-osx

# Zip the lot
zip -r ../macos.dependencies.zip .vcpkg-root installed/ scripts/

popd
