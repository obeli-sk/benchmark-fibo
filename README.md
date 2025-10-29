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
In order to run this [activity](bin/native/), the `fibo` binary must be first built and `FIBO_EXE_PATH` must be set:
```sh
just build-fibo-binary
export FIBO_EXE_PATH="$(pwd)/target/x86_64-unknown-linux-musl/release_bin/fibo"
```


## Running on Amazon Linux
```sh
sudo dnf update -y
sudo dnf install -y docker git
sudo systemctl start docker
sudo usermod -aG docker $USER

git clone https://github.com/obeli-sk/benchmark-fibo.git
cd benchmark-fibo

# If testing the `fiboa-rs-spawn` activity, the `fibo` native binary must be built.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo build -p fibo --profile=release_bin --target x86_64-unknown-linux-musl
export FIBO_DIR=/home/ec2-user/benchmark-fibo/target/x86_64-unknown-linux-musl/release_bin
export FIBO_EXE_PATH=$FIBO_DIR/fibo # only needed if running Obelisk directly without Docker

# Run Obelisk server
docker run --net=host --rm -it \
  -u $(id -u):$(id -g) \
  -v $(pwd):/config \
  -e 'OBELISK__WASM__CACHE_DIRECTORY=/cache/obelisk/wasm' \
  -v ~/.cache/obelisk/wasm:/cache/obelisk/wasm \
  -v $FIBO_DIR:/fibodir \
  -e 'FIBO_EXE_PATH=/fibodir/fibo' \
  getobelisk/obelisk \
  server run -c /config/obelisk-rs-oci.toml

# From within the container (docker exec..) run fibo(10) with a single iteration
obelisk client execution submit -f .../fibow.fiboa -- 10 1
```
