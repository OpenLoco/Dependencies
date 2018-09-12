pushd vcpkg

REM Install libraries
.\vcpkg install ^
    sdl2:%TRIPLET% ^
    sdl2-mixer:%TRIPLET% ^
    yaml-cpp:%TRIPLET%

REM Export libraries
.\vcpkg export ^
    sdl2:%TRIPLET% ^
    sdl2-mixer:%TRIPLET% ^
    yaml-cpp:%TRIPLET% ^
    --zip --nuget "--nuget-id=OpenLoco.Dependencies" "--nuget-version=%VERSION%"

popd
