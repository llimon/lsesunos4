#!/bin/sh
# Shell script to build liblsecompat for SunOS 4.1.x

set -e

# Setup paths and compiler flags
PREFIX="/usr/local/lse"
INC_DIR="${PREFIX}/include/lse"
LIB_DIR="${PREFIX}/lib"

CC="gcc"
CFLAGS="-O2 -I."
AR="ar"
RANLIB="ranlib"

echo "=== 1. Compiling lsecompat_string.c ==="
$CC $CFLAGS -c string_compat.c -o string_compat.o

echo "=== 2. Building and running unit tests ==="
$CC $CFLAGS test_lsecompat.c string_compat.o -o test_lsecompat
./test_lsecompat

echo "=== 3. Creating liblsecompat.a ==="
$AR cr liblsesunoscompat.a string_compat.o
$RANLIB liblsesunoscompat.a

echo "=== 4. Staging headers and library ==="
mkdir -p "${INC_DIR}" "${LIB_DIR}"
cp lsesunos.h "${INC_DIR}/"
cp liblsesunoscompat.a "${LIB_DIR}/"

echo "=== Build Complete ==="
echo "Library installed at: ${LIB_DIR}/liblsesunoscompat.a"
echo "Header installed at:  ${INC_DIR}/liblsesunos.h"
