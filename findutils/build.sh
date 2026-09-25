#!/bin/sh

app=findutils
release=4.1

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    generic_build
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
