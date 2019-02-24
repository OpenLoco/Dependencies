#!/bin/bash

# First, bootstrap vcpkg
git clone https://github.com/Microsoft/vcpkg
cd vcpkg
./bootstrap-vcpkg.sh

# Now, let's get our patches in
git apply ../../sdl2_patches.patch
cp ../x86-osx.cmake triplets/

# Install dependencies
./vcpkg install sdl2:x86-osx \
	sdl2-mixer:x86-osx \
	yaml-cpp:x86-osx

# Zip the lot
zip -r ../macos.dependencies.zip .vcpkg-root installed/ scripts/
cd ..
