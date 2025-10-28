# Build all components
build: build-go build-js build-py build-rs

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

# Start server with Go components built locally
serve-go:
	obelisk server run --config obelisk-go.toml
# Start server with Go components downloaded from OCI registry
serve-go-oci:
	obelisk server run --config obelisk-go-oci.toml

# Start server with JavaScript components built locally
serve-js:
	obelisk server run --config obelisk-js.toml
# Start server with JavaScript components downloaded from OCI registry
serve-js-oci:
	obelisk server run --config obelisk-js-oci.toml

# Start server with Python components build locally
serve-py:
	obelisk server run --config obelisk-py.toml
# Start server with Python components downloaded from OCI registry
serve-py-oci:
	obelisk server run --config obelisk-py-oci.toml

# Start server with Rust components built locally
serve-rs:
	obelisk server run --config obelisk-rs.toml
# Start server with Rust components downloaded from OCI registry
serve-rs-oci:
	obelisk server run --config obelisk-rs-oci.toml

# Start server with Rust components built locally
serve-rs-spawn:
	obelisk server run --config obelisk-rs-spawn.toml
