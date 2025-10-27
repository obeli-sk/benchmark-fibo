#!/usr/bin/env bash
set -exuo pipefail
cd "$(dirname "$0")"

componentize-py --wit-path wit --world root componentize --stub-wasi app -o dist/fibow-py.wasm
