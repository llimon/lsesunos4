#!/bin/sh

app=prngd
release=0.9.29

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    cd ${app}-${release} || echo 1
    make CC="gcc" CFLAGS="-O2 -include /usr/local/lse/include/lse/sunos_compat.h"
	DEFS="-DCONFIGFILE="${prefix}/etc/prngd/prngd.conf" -DRANDSAVENAME=\"${prefix}/etc/prngd/prngd-seed\"" SYSLIBS="-L$prefix/lib"
    
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
