# Obelisk fibonacci benchmark suite

## Running
Assuming [Obelisk](https://github.com/obeli-sk/obelisk) and [just](https://github.com/casey/just) are installed.
Launch Obelisk with Rust components downloaded from an OCI registry.
```sh
just serve-rs-oci
```

Compute `fibo(10)` sequentially 100 times:
```sh
obelisk client execution submit -f .../fibow.fiboa -- 10 100
```

Compute `fibo(10)` in parallel 200 times:
```sh
obelisk client execution submit -f .../fibow.fiboa-concurrent -- 10 200
```

Compute `fibo(33)` in parallel 10 times:
```sh
obelisk client execution submit -f .../fibow.fiboa-concurrent -- 33 10
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

Then run Obelisk with one of the provided TOML files. List all available just targets:
```sh
just --list
```
