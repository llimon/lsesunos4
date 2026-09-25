#!/bin/sh
app=bash
release=2.05b

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    cd "${app}-${release}" || exit 1
    make clean
}

build() {
    generic_build
}

install() {
    clean_stage

    cd "${app}-${release}" || exit 1
    
    # Install into the temporary staging area using the locally built binary
    make prefix="${stagedir}${prefix}" install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
