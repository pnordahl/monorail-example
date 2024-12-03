#!/bin/bash

# Builds all module test binaries in this Go workspace using 
# go's internal incremental compilation. Object files previously 
# built with go/build.sh will be reused, and modules that haven't 
# changed will reuse the previously created test binary.

source monorail/vars.sh

OUT_DIR="bin"

echo "Building workspace test binaries"
mkdir -p $OUT_DIR
for mod in $(go work edit -json | jq -r '.Use[].DiskPath'); do
    go test -c -o "${OUT_DIR}/$(basename $mod).test" $mod
done
