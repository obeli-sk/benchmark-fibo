# Build all components
build: build-go build-js build-py build-rs build-fibo-binary

# Build Go components
build-go:
	(cd activity/go && ./build.sh)
	(cd workflow/go && ./build.sh)

# Build JavaScript components
build-js:
	(cd activity/js && npm install && npm run build)
	(cd workflow/js && npm install && npm run build)

# Build Python components
build-py:
	(cd activity/py && ./build.sh)
	(cd workflow/py && ./build.sh)

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd activity/rs-spawn && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

build-fibo-binary:
	cargo build -p fibo --profile=release_bin --target x86_64-unknown-linux-musl

# Start server with Go components built locally
serve-go:
	obelisk server run --server-config server.toml --deployment obelisk-go.toml
# Start server with Go components downloaded from OCI registry
serve-go-oci:
	obelisk server run --server-config server.toml --deployment obelisk-go-oci.toml

# Start server with JavaScript components built locally
serve-js  *params:
	obelisk server run --server-config server.toml --deployment obelisk-js.toml  {{params}}
# Start server with JavaScript components downloaded from OCI registry
serve-js-oci:
	obelisk server run --server-config server.toml --deployment obelisk-js-oci.toml

# Start server with native JavaScript components (no build step needed)
serve-js-native *params:
	obelisk server run --server-config server.toml --deployment obelisk-js-native.toml  {{params}}

# Start server with Python components build locally
serve-py:
	obelisk server run --server-config server.toml --deployment obelisk-py.toml
# Start server with Python components downloaded from OCI registry
serve-py-oci:
	obelisk server run --server-config server.toml --deployment obelisk-py-oci.toml

# Start server with Rust components built locally
serve-rs:
	obelisk server run --server-config server.toml --deployment obelisk-rs.toml
# Start server with Rust components downloaded from OCI registry
serve-rs-oci:
	obelisk server run --server-config server.toml --deployment obelisk-rs-oci.toml

# Start server with Rust components (spawning native process) built locally
serve-rs-spawn:
	obelisk server run --server-config server-spawn.toml --deployment obelisk-rs-spawn.toml
# Start server with Rust components (spawning native process) downloaded from OCI registry
serve-rs-spawn-oci:
	obelisk server run --server-config server-spawn.toml --deployment obelisk-rs-spawn-oci.toml
