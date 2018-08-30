set packages=vcpkg\installed\%TRIPLET%
set outarchive=openloco-libs-v%version%-%TRIPLET%

pushd %packages%

REM create zip
7z a -tzip -mx9 -mtc=off "%outarchive%.zip" "*"

popd
