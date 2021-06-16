#!/bin/bash

# Echo commands as they're executed
set -x

# Exit when any of the commands below fails
set -e

# First, install a newer version of gcc
brew install gcc@8

# Get vcpkg and bootstrap it
git clone https://github.com/Microsoft/vcpkg
cd vcpkg
./bootstrap-vcpkg.sh

# Prepare for x86 target
cp ../x86-osx.cmake triplets/

# Install dependencies
./vcpkg install \
	benchark:x86-osx \
	gtest:x86-osx \
	libpng:x86-osx \
	sdl2:x86-osx \
	sdl2-mixer:x86-osx \
	yaml-cpp:x86-osx

# Zip the lot
zip -r ../macos.dependencies.zip .vcpkg-root installed/ scripts/
cd ..
