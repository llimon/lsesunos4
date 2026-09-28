#!/bin/sh

app=Python
release=2.3.7

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    export LDFLAGS="-L/usr/local/lse/lib -llsecompat"
    export CPPFLAGS="-include $prefix/include/lse/lsecompat.h"
    #export LDFLAGS="-L/usr/local/lse/lib"
    cd ${builddir}/${app}-${release} || exit 1
    #gsed -i |Sun/4*||g configure
    ./configure

    #make CPPFLAGS="-O2"
    #make CPPFLAGS="-O2 "
    make 
}

install() {
    clean_stage
    generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
