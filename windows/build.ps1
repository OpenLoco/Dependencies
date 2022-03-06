$ErrorActionPreference='Stop'

pushd vcpkg

$packages=@(
    "benchmark";
    "breakpad";
    "gtest";
    "libpng";
    "openal-soft";
    "sdl2";
    "yaml-cpp";
)

# Install libraries
.\vcpkg install $packages

# Export libraries
.\vcpkg export $packages `
    --zip --nuget --nuget-id=OpenLoco.Dependencies --nuget-version=$env:VERSION

popd
