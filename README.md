# Obelisk fibonacci benchmark suite


## Running
Assuming [Obelisk](https://github.com/obeli-sk/obelisk) and [just](https://github.com/casey/just) are installed.
Build the Rust components and launch Obelisk with the local deployment.
```sh
just build-rs
just serve-rs
```

Compute `fibo(10)` sequentially 100 times:
```sh
obelisk execution submit -f .../fibow.fiboa -- 10 100
```

Compute `fibo(10)` in parallel 200 times:
```sh
obelisk execution submit -f .../fibow.fiboa-concurrent -- 10 200
```

## Running with native JavaScript (no build step)
Launch Obelisk with native JS activity and workflow (no compilation required):
```sh
just serve-js-native
```
The `activity/js-native/fibo.js` and `workflow/js-native/` files are loaded directly by Obelisk's built-in JS runtime.

## Running with Kotlin (native WASIp2 activity)
The `fibo` activity is compiled natively from Kotlin to a WASIp2 component. Kotlin/Wasm
has no component-model toolchain yet: its `wasm-wasi` target still emits WASIp1 core
modules ([KT-64568](https://youtrack.jetbrains.com/issue/KT-64568)) and there is no WIT
binding generator ([KT-64569](https://youtrack.jetbrains.com/issue/KT-64569)). So
`activity/kt/build.sh` compiles the pure-numeric `fibo` export with `kotlinc-wasm` and
then componentizes it with `wasm-tools` plus the `wasi_snapshot_preview1` reactor
adapter. Because that route
cannot express the workflow's join-set resource imports, only the activity is Kotlin;
the `fibow` workflow is reused from the Rust build (Obelisk calls the activity by FFQN
regardless of its implementation language).
```sh
just build-rs   # provides the Rust workflow component
just build-kt   # builds activity/kt/dist/fiboa-kt.wasm
just serve-kt
```

## Building WASM Components from source
If [direnv](https://github.com/direnv/direnv) and [Nix](https://nixos.org/) are available:
```sh
cp .envrc-example .envrc
direnv allow
```
Otherwise install the following versions of dependencies used for development as described in [dev-deps.txt](./dev-deps.txt).

Build all components:
```sh
just build
```

Then run Obelisk with one of the provided TOML files. List all available targets:
```sh
just --list
just serve-???
```

### Note on `fiboa-rs-spawn` activity
This activity is configured as an exec activity that calls the native [`fibo`](bin/native/) binary.
Build the binary first and set `FIBO_EXE_PATH`:
```sh
just build-fibo-binary
export FIBO_EXE_PATH="$(pwd)/target/x86_64-unknown-linux-musl/release_bin/fibo"
```
