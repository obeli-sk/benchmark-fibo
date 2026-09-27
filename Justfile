# Build all components
build: build-js-componentize build-rs build-fibo-binary

# Native JavaScript components need no build step
build-js:

# Build JavaScript components with componentize-js
build-js-componentize:
	(cd activity/js-componentize && npm install && npm run build)
	(cd workflow/js-componentize && npm install && npm run build)

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

build-rs-spawn: build-rs build-fibo-binary

build-fibo-binary:
	cargo build -p fibo --profile=release_bin --target x86_64-unknown-linux-musl

# Start server with native JavaScript components (no build step needed)
serve-js *params:
	obelisk server run --server-config server.toml --app-config app.toml --deployment deployment-js.toml  {{params}}
# Start server with componentize-js components built locally
serve-js-componentize *params:
	obelisk server run --server-config server.toml --app-config app.toml --deployment deployment-js-componentize.toml  {{params}}

# Start server with Rust components built locally
serve-rs:
	obelisk server run --server-config server.toml --app-config app.toml --deployment deployment-rs.toml

# Start server with Rust components (spawning native process) built locally
serve-rs-spawn:
	obelisk server run --server-config server-spawn.toml --app-config app-spawn.toml --deployment deployment-rs-spawn.toml
