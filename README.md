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

## Running with JavaScript (no build step)
Launch Obelisk with native JS activity and workflow (no compilation required):
```sh
just serve-js
```
The `activity/js/fibo.js` and `workflow/js/` files are loaded directly by Obelisk's built-in JS runtime.

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

Then run Obelisk with one of the provided `deployment-*.toml` files and its app policy. List all available targets:
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
The `rs-spawn` deployment uses `app-spawn.toml` and `server-spawn.toml` to approve native execution.
