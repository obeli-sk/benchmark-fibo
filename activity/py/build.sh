#!/usr/bin/env bash
set -exuo pipefail
cd "$(dirname "$0")"

componentize-py --wit-path wit --world root componentize app -o dist/fiboa-py.wasm
