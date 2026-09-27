# Build all components
build: build-js build-rs build-fibo-binary

# Build JavaScript components (componentize-js)
build-js:
	(cd activity/js && npm install && npm run build)
	(cd workflow/js && npm install && npm run build)

build-js-native:

# Build Rust components
build-rs:
	(cd activity/rs && cargo build --profile release_activity)
	(cd workflow/rs && cargo build --profile release_workflow)

build-rs-spawn: build-rs build-fibo-binary

build-fibo-binary:
	cargo build -p fibo --profile=release_bin --target x86_64-unknown-linux-musl

# Start server with JavaScript components built locally
serve-js  *params:
	obelisk server run --server-config server.toml --app-config app.toml --deployment obelisk-js.toml  {{params}}
# Start server with native JavaScript components (no build step needed)
serve-js-native *params:
	obelisk server run --server-config server.toml --app-config app.toml --deployment obelisk-js-native.toml  {{params}}

# Start server with Rust components built locally
serve-rs:
	obelisk server run --server-config server.toml --app-config app.toml --deployment obelisk-rs.toml

# Start server with Rust components (spawning native process) built locally
serve-rs-spawn:
	obelisk server run --server-config server-spawn.toml --app-config app-spawn.toml --deployment obelisk-rs-spawn.toml
