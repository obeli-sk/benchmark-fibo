#!/usr/bin/env bash

set -exuo pipefail
cd "$(dirname "$0")/.."

generate() {
  local path="$1"
  local component_type="$2"

  if [ ! -d "$path" ]; then
    return 0
  fi

  echo "Updating $path"
  cd "$path/wit"
  obelisk generate wit-extensions "$component_type" . gen
}

generate "activity" "activity_wasm"
