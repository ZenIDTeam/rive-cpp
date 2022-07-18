#!/bin/sh
set -e

source ../../../dependencies/macosx/config_directories.sh

CONFIG=debug
GRAPHICS=gl
RENDERER=skia

for var in "$@"; do
    if [[ $var = "release" ]]; then
        CONFIG=release
    fi
    if [[ $var = "gl" ]]; then
        GRAPHICS=gl
    fi
    if [[ $var = "d3d" ]]; then
        GRAPHICS=d3d
    fi
    if [[ $var = "metal" ]]; then
        GRAPHICS=metal
    fi
    if [[ $var = "skia" ]]; then
        RENDERER=skia
    fi
done

if [[ ! -f "$DEPENDENCIES/bin/premake5" ]]; then
    pushd $DEPENDENCIES_SCRIPTS
    ./get_premake5.sh
    popd
fi

if [[ ! -d "$DEPENDENCIES/imgui" ]]; then
    pushd $DEPENDENCIES_SCRIPTS
    ./get_imgui.sh
    popd
fi

pushd ../../../build/macosx
./build_rive.sh $CONFIG
popd

if [ $RENDERER = "skia" ]; then
    pushd ../../../skia/renderer/build/macosx
    ./build_skia_renderer.sh text $@
    popd
fi

export PREMAKE=$DEPENDENCIES/bin/premake5
pushd ..

$PREMAKE --file=./premake5_viewer.lua gmake2 --graphics=$GRAPHICS --renderer=$RENDERER

for var in "$@"; do
    if [[ $var = "clean" ]]; then
        make clean
        make config=release clean
    fi
done

make config=$CONFIG -j$(($(sysctl -n hw.physicalcpu) + 1))

popd

for var in "$@"; do
    if [[ $var = "run" ]]; then
        bin/$CONFIG/$RENDERER/$GRAPHICS/rive_viewer
    fi
    if [[ $var = "lldb" ]]; then
        lldb bin/$CONFIG/$RENDERER/$GRAPHICS/rive_viewer
    fi
done