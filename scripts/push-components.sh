#!/usr/bin/env bash

# Pushes all WASM components to the Docker Hub and updates obelisk-oci.toml

set -exuo pipefail
cd "$(dirname "$0")/.."

TAG="$1"
PREFIX="docker.io/getobelisk/benchmark_fibo_"

push() {
    RELATIVE_PATH="$1"
    TOML_FILE="$2"
    COMPONENT_NAME="$3"

    OCI_LOCATION="${PREFIX}${COMPONENT_NAME}:${TAG}"
    echo "Pushing ${RELATIVE_PATH} to ${OCI_LOCATION}..."
    OUTPUT=$(obelisk client component push "$RELATIVE_PATH" "$OCI_LOCATION")

    # Replace the old location with the actual OCI location
    sed -i -E "/name = \"${COMPONENT_NAME}\"/{n;s|location\.oci = \".*\"|location.oci = \"${OUTPUT}\"|}" "$TOML_FILE"
}

just build

push "activity/go/dist/fiboa-go.wasm" obelisk-go-oci.toml fiboa_go
push "workflow/go/dist/fibow-go.wasm" obelisk-go-oci.toml fibow_go

push "activity/js/dist/fiboa-js.wasm" obelisk-js-oci.toml fiboa_js
push "workflow/js/dist/fibow-js.wasm" obelisk-js-oci.toml fibow_js

push "target/wasm32-wasip2/release_activity/fiboa_rs.wasm" obelisk-rs-oci.toml fiboa_rs
push "target/wasm32-unknown-unknown/release_workflow/fibow_rs.wasm" obelisk-rs-oci.toml fibow_rs

push "activity/py/dist/fiboa-py.wasm" obelisk-py-oci.toml fiboa_py
push "workflow/py/dist/fibow-py.wasm" obelisk-py-oci.toml fibow_py

echo "All components pushed and TOML file updated successfully."
