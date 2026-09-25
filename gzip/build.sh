#!/bin/sh

app=gzip
release=1.2.4a

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
   generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
