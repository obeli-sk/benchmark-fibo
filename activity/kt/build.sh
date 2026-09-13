#!/usr/bin/env bash
set -exuo pipefail
cd "$(dirname "$0")"

# Kotlin/Wasm has no WASIp2/component toolchain yet (WASI 0.2 target KT-64568, WIT
# bindings / component model KT-64569), so we compile the
# pure-numeric `fibo` export to a wasm-wasi (WASIp1) core module with kotlinc-wasm,
# then componentize it to WASIp2 with wasm-tools + the wasi_snapshot_preview1
# reactor adapter. The wasi stdlib klib is not bundled with the kotlin compiler and
# the adapter ships with wasmtime releases, so both are fetched and cached in libs/.
set +e +o pipefail # kotlinc-wasm keeps writing after grep/head close the pipe
KOTLIN_VERSION="${KOTLIN_VERSION:-$(kotlinc-wasm -version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)}"
set -e -o pipefail
WASMTIME_VERSION="${WASMTIME_VERSION:-48.0.2}"

mkdir -p libs build dist
stdlib="libs/kotlin-stdlib-wasm-wasi-$KOTLIN_VERSION.klib"
if [ ! -f "$stdlib" ]; then
  curl -sSfL "https://repo1.maven.org/maven2/org/jetbrains/kotlin/kotlin-stdlib-wasm-wasi/$KOTLIN_VERSION/kotlin-stdlib-wasm-wasi-$KOTLIN_VERSION.klib" -o "$stdlib"
fi
adapter="libs/wasi_snapshot_preview1.reactor-$WASMTIME_VERSION.wasm"
if [ ! -f "$adapter" ]; then
  curl -sSfL "https://github.com/bytecodealliance/wasmtime/releases/download/v$WASMTIME_VERSION/wasi_snapshot_preview1.reactor.wasm" -o "$adapter"
fi

# Stage 1: Kotlin sources -> klib.
kotlinc-wasm -Xwasm-target=wasm-wasi -Xwasm-use-new-exception-proposal \
  -libraries "$stdlib" \
  -Xir-produce-klib-file -ir-output-dir build -ir-output-name fiboa-kt \
  fibo.kt
# Stage 2: klib -> wasm-wasi core module.
kotlinc-wasm -Xwasm-target=wasm-wasi -Xwasm-use-new-exception-proposal \
  -libraries "$stdlib" \
  -Xir-produce-js -Xinclude=build/fiboa-kt.klib \
  -ir-output-dir build -ir-output-name fiboa-kt
# Componentize: embed the WIT world, then lift WASIp1 imports to WASIp2.
wasm-tools component embed wit/ build/fiboa-kt.wasm --world root -o build/embedded.wasm
wasm-tools component new build/embedded.wasm --adapt wasi_snapshot_preview1="$adapter" -o dist/fiboa-kt.wasm
wasm-tools validate dist/fiboa-kt.wasm
