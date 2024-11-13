#!/bin/bash

# Builds all modules in this Go workspace using go's internal incremental
# compilation. Only modules that Go detects as changed will be affected.
# For our purposes, these module object files and binaries can
# be reused in later scripts by `go test` and `go run`, respectively.

# Additionally, since we have declared a use on the "proto" target, it's safe
# to invoke `protoc` here and build protobufs for our Go modules to use.  
# This is omitted for brevity.

OUT_DIR="../bin/"

echo "Building workspace modules"
for mod in $(go work edit -json | jq -r '.Use[].DiskPath'); do
    go build -C $mod -o "$OUT_DIR" ./...
done
