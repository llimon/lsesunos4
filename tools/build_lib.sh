#!/bin/sh
# build_lib.sh - Unified builder for liblsecompat and liblsenet
# Usage: ./build_lib.sh -build-lsecompat  OR  ./build_lib.sh -build-lsenet

# Enforce mandatory first parameter check
if [ "$1" != "-build-lsecompat" ] && [ "$1" != "-build-lsenet" ]; then
    echo "Error: Missing or invalid target parameter."
    echo "Usage: $0 <-build-lsecompat | -build-lsenet>"
    exit 1
fi

TARGET="$1"
CC="gcc -I/usr/local/lse/include"
OS_TYPE=`uname -s`
CFLAGS="-O2 -mcpu=v7 -I."
LDFLAGS="-lgcc_s"

# Configure explicit source arrays and library names based on target
if [ "$TARGET" = "-build-lsecompat" ]; then
    LIB_BASE="liblsecompat"
    SRC_FILES="strtoimax_compat.c ftello_compat.c snprintf_compat.c getprogname_compat.c usleep_compat.c utimes_compat.c math_compat.c string_compat.c"
    EXTRA_LIBS=""
else
    LIB_BASE="liblsenet"
    SRC_FILES="dns_rfc2553_compat.c socket_compat.c"
    # Network compatibility requires socket and nsl libraries on Solaris/SunOS
    EXTRA_LIBS="-lsocket -lnsl"
fi

echo "=== Building Target: $LIB_BASE (Platform:$OS_TYPE) ==="

if [ "$OS_TYPE" = "SunOS" ]; then
    RELEASE=`uname -r | cut -d. -f1`

    if [ "$RELEASE" -eq 4 ]; then
        echo "Building Static Archive for SunOS 4.x (a.out)..."
        LIB_A="${LIB_BASE}.a"

        for src in $SRC_FILES; do
            [ -f "$src" ] || { echo "Error: Missing source file $src"; exit 1; }
            obj=`basename "$src" .c`.o
            echo "Compiling $src ->$obj"
            $CC $CFLAGS -c "$src" -o "$obj" || exit 1
        done

        echo "=== Creating $LIB_A ==="
        rm -f "$LIB_A"
        #ar rcs "$LIB_A" *.o
        ar cr "$LIB_A" *.o

        echo "Indexing $LIB_BASE with ranlib..."
        ranlib "$LIB_A"

        echo "Successfully generated static archive $LIB_A"
        exit 0
    fi
fi

exit
# Solaris 2.x / SVR4 Build Path (Builds both .a and .so)
echo "Building Static and Shared Libraries for Solaris 2.x (ELF)..."
CFLAGS="$CFLAGS -fPIC -fno-exceptions -fno-unwind-tables"
LIB_A="${LIB_BASE}.a"
LIB_SO="${LIB_BASE}.so"

# Make sure we don't have objects from a previous run
rm -f *.o

for src in $SRC_FILES; do
    [ -f "$src" ] || { echo "Error: Missing source file $src"; exit 1; }
    obj=`basename "$src" .c`.o
    echo "Compiling $src ->$obj"
    $CC $CFLAGS -c "$src" -o "$obj" || exit 1
done

echo ""
echo "=== Packaging $LIB_BASE and$LIB_SO ==="
ar rcs "$LIB_A" *.o

# Shared library link step (injects -lsocket -lnsl only for liblsenet)
$CC -shared -static-libgcc  -Wl,-z,text -o "$LIB_SO" *.o $EXTRA_LIBS || exit 1

#echo "Successfully built both $LIB_A and $LIB_SO for$LIB_BASE"
echo "Successfully built both $LIB_A and $LIB_SO for$LIB_BASE"
