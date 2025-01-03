#!/bin/bash

MEMBER=$1
TEST_NAME=$2

# Execute a previously built test binary for this $MEMBER. while this would
# ordinarily compile a test binary as well, if rust/test.sh runs before
# this script does then the binaries will already exist. This is useful
# because this command merely executes those binaries, and nearly eliminates
# contention on the target directory and internal cargo locking.

# Additionally, this is using the runtime arg api to add a specific test name, if provided.
cargo test -p $MEMBER ${TEST_NAME:+$TEST_NAME}
