#!/bin/bash

MEMBER=$1

# Execute a previously built test binary for this $MEMBER. while this would
# ordinarily compile a test binary as well, if rust/test.sh runs before
# this script does then the binaries will already exist. This is useful
# because this command merely executes those binaries, and nearly eliminates
# contention on the target directory and internal cargo locking.

cargo test -p $MEMBER