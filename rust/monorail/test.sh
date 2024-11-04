#!/bin/bash

# Build test binaries using cargo's incremental build cache. These binaries
# are then invoked in parallel for each target using the rust/member-test.sh script.
cargo test --no-run
