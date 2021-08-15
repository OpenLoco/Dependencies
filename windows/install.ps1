$ErrorActionPreference='Stop'

# Install upstream vcpkg
git clone -q https://github.com/Microsoft/vcpkg.git
pushd vcpkg
.\bootstrap-vcpkg.bat
git pull

# Uninstall out of date packages so they are updated
.\vcpkg remove --outdated --recurse

popd
