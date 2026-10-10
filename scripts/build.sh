#!/usr/bin/env bash

set -euo pipefail


ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIRETORY="${ROOT}/project"

rm -rf "$PROJECT_DIRETORY/addons/example/bin" # rm built addon bin files 
rm -rf "$PROJECT_DIRETORY/.godot/" # rm godot cache 

BUILD_PROFILE_FILE="${ROOT}/build_profile.json"
if [ ! -e "$BUILD_PROFILE_FILE" ]; then
    scons compiledb=yes compile_commands.json
fi

# scons -c # clean out c++ build files 

scons # build