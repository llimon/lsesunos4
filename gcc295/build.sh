#!/bin/sh


app=gcc
release=2.95.3

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {

    cd "${builddir}/${app}-${release}" || exit 1
    ./configure \
        --prefix=/usr/local/gcc-2.95 \
        --enable-languages=c,c++,f77,objc

     #make bootstrap

     #make \
     #   CFLAGS="-O2 -mv7" \
     #   BOOT_CFLAGS="-O2 -mcpu=v7 -fPIC" \
     #   CFLAGS_FOR_TARGET="-O2 -mv7 -fPIC" \
     #   MULTILIB_EXTRA_OPTS="-mv7" \
     #   bootstrap

     make bootstrap \
       CFLAGS="-O2 " \
       BOOT_CFLAGS="-O2 -fPIC" \
       LIBGCC2_CFLAGS="-O2 -fPIC" \
       CFLAGS_FOR_TARGET="-O2 -fPIC" \
       MULTILIB_EXTRA_OPTS="-fPIC"
       
}

install() {
   generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
