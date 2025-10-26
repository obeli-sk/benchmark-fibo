# Build all components (Rust)
build: build-rs build-js

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

build-js:
	./scripts/build-components-js.sh

serve-rs:
	obelisk server run --config obelisk-rs.toml

serve-js:
	obelisk server run --config obelisk-js.toml
