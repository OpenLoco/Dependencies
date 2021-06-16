pushd vcpkg

REM Install libraries
.\vcpkg install ^
    benchmark:%TRIPLET% ^
    breakpad:%TRIPLET% ^
    gtest:%TRIPLET% ^
    libpng:%TRIPLET% ^
    sdl2:%TRIPLET% ^
    sdl2-mixer:%TRIPLET% ^
    yaml-cpp:%TRIPLET%

REM Export libraries
.\vcpkg export ^
    benchmark:%TRIPLET% ^
    breakpad:%TRIPLET% ^
    gtest:%TRIPLET% ^
    libpng:%TRIPLET% ^
    sdl2:%TRIPLET% ^
    sdl2-mixer:%TRIPLET% ^
    yaml-cpp:%TRIPLET% ^
    --zip --nuget "--nuget-id=OpenLoco.Dependencies" "--nuget-version=%VERSION%"

popd
