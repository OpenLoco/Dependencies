pushd vcpkg

REM Install libraries
.\vcpkg install sdl2:%TRIPLET% ^
	yaml-cpp:%TRIPLET%

REM Export libraries
.\vcpkg export sdl2:%TRIPLET% ^
	yaml-cpp:%TRIPLET% ^
	--zip --nuget

popd
