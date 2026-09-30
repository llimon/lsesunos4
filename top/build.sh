#!/bin/sh

app=top
release=3.5.1

patches[0]=top-memory-corruption-fix.patch.gz

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
    make LIBS="-L$prefix/lib -llsecompat -lkvm" \
        CDEFS="-O2 -DMULTIPROCESSOR"
}

install() {
    PATH=/etc:/usr/etc:$PATH
    export PATH
    clean_stage
    cd ${builddir}/${app}-${release} || exit 1
    mkdir -p ${stagedir}${prefix}/bin ${stagedir}${prefix}/man
    make BINDIR="${stagedir}${prefix}/bin" MANDIR="${stagedir}${prefix}/man" install
    #generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
