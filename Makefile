.DEFAULT_GOAL:=help

TARGET := target/wasm32-wasi/release/worker.wasm

build: ## Build the WASI worker module
	cargo build --target wasm32-wasi --release

run-cf: build ## Run the WASI worker module with CloudFlare Wrangler
	npx wrangler@wasm dev ${TARGET}

run-wt: build ## Run the WASI worker module with Wasmtime
	wasmtime run ${TARGET}

publish-cf: build ## Publish the WASI worker module to CloudFlare
	npx wrangler@wasm publish --name wasi-worker --compatibility-date 2023-04-11 ${TARGET}

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

