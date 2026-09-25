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
#    generic_build
    #liblsesunoscompat.a
    export LDFLAGS="-L/usr/local/lse/lib -llsesunoscompat"
    cd ${app}-${release} || exit 1
    ./configure

    make CPPFLAGS="-O2 -include /usr/local/lse/include/lse/sunos_compat.h"
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
