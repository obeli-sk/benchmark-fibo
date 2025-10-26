# Build all components (Rust)
build: build-rs build-js

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

build-js:
	./scripts/build-components-js.sh

build-go:
	./scripts/build-components-go.sh

serve-rs:
	obelisk server run --config obelisk-rs.toml
serve-rs-oci:
	obelisk server run --config obelisk-rs-oci.toml

serve-js:
	obelisk server run --config obelisk-js.toml
serve-js-oci:
	obelisk server run --config obelisk-js-oci.toml

serve-go:
	obelisk server run --config obelisk-go.toml
serve-go-oci:
	obelisk server run --config obelisk-go-oci.toml
