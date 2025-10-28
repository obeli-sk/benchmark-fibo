#!/usr/bin/env bash

# Pushes all WASM components to the Docker Hub and updates obelisk-oci.toml

set -exuo pipefail
cd "$(dirname "$0")/.."

TAG="$1"
PREFIX="docker.io/getobelisk/benchmark_fibo_"

push_component() {
    RELATIVE_PATH="$1"
    COMPONENT_NAME="$2"

    OCI_LOCATION="${PREFIX}${COMPONENT_NAME}:${TAG}"
    echo "Pushing ${RELATIVE_PATH} to ${OCI_LOCATION}..." >&2
    obelisk client component push "$RELATIVE_PATH" "$OCI_LOCATION"
}

update_toml() {
    TOML_FILE="$1"
    COMPONENT_NAME="$2"
    NEW_LOCATION="$3"

    # Replace the old location with the new OCI location
    sed -i -E "/name = \"${COMPONENT_NAME}\"/{n;s|location\.oci = \".*\"|location.oci = \"${NEW_LOCATION}\"|}" "$TOML_FILE"
}

push_and_update() {
    RELATIVE_PATH="$1"
    COMPONENT_NAME="$2"
    shift 2
    TOML_FILES=("$@")

    OCI_LOCATION=$(push_component "$RELATIVE_PATH" "$COMPONENT_NAME")

    for TOML_FILE in "${TOML_FILES[@]}"; do
        update_toml "$TOML_FILE" "$COMPONENT_NAME" "$OCI_LOCATION"
    done
}

just build

push_and_update "activity/go/dist/fiboa-go.wasm" fiboa_go obelisk-go-oci.toml
push_and_update "workflow/go/dist/fibow-go.wasm" fibow_go obelisk-go-oci.toml

push_and_update "activity/js/dist/fiboa-js.wasm" fiboa_js obelisk-js-oci.toml
push_and_update "workflow/js/dist/fibow-js.wasm" fibow_js obelisk-js-oci.toml

push_and_update "target/wasm32-wasip2/release_activity/fiboa_rs.wasm" fiboa_rs obelisk-rs-oci.toml
# fibow_rs is shared between two configs
push_and_update "target/wasm32-unknown-unknown/release_workflow/fibow_rs.wasm" fibow_rs obelisk-rs-oci.toml obelisk-rs-spawn-oci.toml

push_and_update "target/wasm32-wasip2/release_activity/fiboa_rs_spawn.wasm" fiboa_rs_spawn obelisk-rs-spawn-oci.toml

push_and_update "activity/py/dist/fiboa-py.wasm" fiboa_py obelisk-py-oci.toml
push_and_update "workflow/py/dist/fibow-py.wasm" fibow_py obelisk-py-oci.toml

echo "All components pushed and TOML file updated successfully."
