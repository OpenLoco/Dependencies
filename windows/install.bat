REM Install upstream vcpkg
git clone -q https://github.com/Microsoft/vcpkg.git
robocopy /v /fp triplets vcpkg/triplets/
pushd vcpkg
call .\bootstrap-vcpkg.bat
git pull

REM Uninstall out of date packages so they are updated
.\vcpkg remove --outdated --recurse

REM Reduce dependencies for SDL2-mixer
git apply %~dp0\..\sdl2_patches.patch

popd
