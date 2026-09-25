#!/bin/sh

app=vim
release=4.5

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
   generic_clean
}

build() {
    generic_build src
}

install() {
 generic_install src
}

pack() {
   generic_pack 
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
