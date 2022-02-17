$ErrorActionPreference='Stop'

pushd vcpkg

$packages=@(
    "benchmark";
    "breakpad";
    "gtest";
    "libpng";
    "sdl2";
    "sdl2-mixer";
    "yaml-cpp";
    "openal-soft";
)

# Install libraries
.\vcpkg install $packages

# Export libraries
.\vcpkg export $packages `
    --zip --nuget --nuget-id=OpenLoco.Dependencies --nuget-version=$env:VERSION

popd
