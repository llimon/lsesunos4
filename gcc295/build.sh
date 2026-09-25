#!/bin/sh

. /home/luis/source/build.functions.sh

app=gcc
release=2.95.3

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {

    cd "${app}-${release}" || exit 1
    ./configure \
        --prefix=/usr/local/gcc-2.95 \
        --enable-languages=c,c++,f77,objc

     #make bootstrap

     make \
        CFLAGS="-O2 -mcpu=v7" \
        BOOT_CFLAGS="-O2 -mcpu=v7" \
        CFLAGS_FOR_TARGET="-O2 -mcpu=v7" \
        MULTILIB_EXTRA_OPTS="-mcpu=v7" \
        bootstrap
}

install() {
   generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
