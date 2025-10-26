# Build all components (Rust)
build: rust

# Build Rust components
rust:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)


serve:
	obelisk server run
