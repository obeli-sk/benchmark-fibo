#!/usr/bin/env bash

# Pushes all WASM components to the Docker Hub and updates obelisk-oci.toml

set -exuo pipefail
cd "$(dirname "$0")/.."

TAG="$1"
PREFIX="oci://docker.io/getobelisk/benchmark_fibo_"

push_component() {
    local LOCAL_DEPLOYMENT_TOML="$1"
    local COMPONENT_NAME="$2"

    OCI_LOCATION="${PREFIX}${COMPONENT_NAME}:${TAG}"
    obelisk component push --deployment "$LOCAL_DEPLOYMENT_TOML" "$COMPONENT_NAME" "$OCI_LOCATION"
}

push_and_update() {
    local LOCAL_DEPLOYMENT_TOML="$1"
    local COMPONENT_NAME="$2"
    shift 2
    DST_TOML_FILES=("$@")

    OCI_LOCATION=$(push_component "$LOCAL_DEPLOYMENT_TOML" "$COMPONENT_NAME")

    for DST_TOML_FILE in "${DST_TOML_FILES[@]}"; do
        obelisk component add --deployment "$DST_TOML_FILE" "$OCI_LOCATION" "$COMPONENT_NAME"
    done
}

just build

push_and_update obelisk-go.toml fiboa_go obelisk-go-oci.toml
push_and_update obelisk-go.toml fibow_go obelisk-go-oci.toml

push_and_update obelisk-js.toml fiboa_js obelisk-js-oci.toml
push_and_update obelisk-js.toml fibow_js obelisk-js-oci.toml

push_and_update obelisk-js-native.toml fiboa_js_native obelisk-js-native-oci.toml
push_and_update obelisk-js-native.toml fibow_js_native obelisk-js-native-oci.toml
push_and_update obelisk-js-native.toml fibow_concurrent_js_native obelisk-js-native-oci.toml

push_and_update obelisk-rs.toml fiboa_rs obelisk-rs-oci.toml
# fibow_rs is shared between two configs
push_and_update obelisk-rs.toml fibow_rs obelisk-rs-oci.toml obelisk-rs-spawn-oci.toml

push_and_update obelisk-rs-spawn.toml fiboa_rs_spawn obelisk-rs-spawn-oci.toml

push_and_update obelisk-py.toml fiboa_py obelisk-py-oci.toml
push_and_update obelisk-py.toml fibow_py obelisk-py-oci.toml

echo "All components pushed and TOML file updated successfully."
