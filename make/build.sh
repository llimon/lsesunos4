#!/bin/sh

app=make
release=3.79.1

. /home/luis/source/build.functions.sh

prep() {
   generic_prep
}

clean() {
   generic_clean
}

build() {
    cd "${app}-${release}" || exit 1
    
    # 1. Configure to bake in the final paths and generate config.h
    ./configure --prefix="${prefix}"
    
    # 2. Bootstrap the compiler using the generated config
    sh build.sh
}

install() {
   generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
