# Build all components
build: build-rs build-js

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

# Build JavaScript components
build-js:
	./scripts/build-components-js.sh

# Build Go components
build-go:
	./scripts/build-components-go.sh

# Start server with Rust components built locally
serve-rs:
	obelisk server run --config obelisk-rs.toml
# Start server with Rust components downloaded from OCI registry
serve-rs-oci:
	obelisk server run --config obelisk-rs-oci.toml

# Start server with JavaScript components built locally
serve-js:
	obelisk server run --config obelisk-js.toml
# Start server with JavaScript components downloaded from OCI registry
serve-js-oci:
	obelisk server run --config obelisk-js-oci.toml

# Start server with Go components built locally
serve-go:
	obelisk server run --config obelisk-go.toml
# Start server with Go components downloaded from OCI registry
serve-go-oci:
	obelisk server run --config obelisk-go-oci.toml
