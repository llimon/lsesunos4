#!/bin/sh

app=lsecompat
release=1.0

. /home/luis/source/build.functions.sh

prep() {
    echo "no-op"
}

clean() {
    rm *.o *.a *.so
}

build() {
    make 
}

install() {
    clean_stage
    make install prefix=${stagedir}/${prefix}
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
