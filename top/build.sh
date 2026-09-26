#!/bin/sh

app=top
release=3.5.1

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    #generic_build
    cd "${builddir}/${app}-${release}" || exit 1
    ./Configure sunos4
    make LIBS="-L$prefix/lib -llsecompat -lkvm"
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
