#!/bin/bash

# A naive build script. In practice, you'd want to separate building
# object files, building the main binary, and building the test binary
# into separate commands; e.g. "build-objects", "build-bins", "build-test-bins".

# Additionally, since we have declared a use on the "proto" target, it's safe
# to invoke `protoc` here and build protobufs for our C++ project.
# This is omitted for brevity.

set -e

SRC_DIR="src"
OBJ_DIR="../build"
BIN_DIR="../bin"
SRC_FILES="$SRC_DIR/hello.cpp $SRC_DIR/main.cpp $SRC_DIR/test_hello.cpp"
OBJ_FILES="$OBJ_DIR/hello.o $OBJ_DIR/main.o"
BINARY="$BIN_DIR/hello"
TEST_BINARY="$BIN_DIR/hello_test"

mkdir -p $BIN_DIR $OBJ_DIR

echo "Compiling source files..."
for src in $SRC_FILES; do
    base_name=$(basename "$src" .cpp)
    g++ -c $src -o "$OBJ_DIR/$base_name.o"
done

echo "Creating main binary..."
g++ -o $BINARY $OBJ_FILES -L$OBJ_DIR

echo "Creating test binary..."
g++ -o $TEST_BINARY "$OBJ_DIR/test_hello.o" "$OBJ_DIR/hello.o"

echo "Done"