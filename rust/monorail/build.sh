#!/bin/bash

# Build crates using cargo's incremental build cache.

# Additionally, since we have declared a use on the "proto" target, it's safe
# to invoke `protoc` here and build protobufs for our C++ project. This is omitted
# for brevity.

cargo build
