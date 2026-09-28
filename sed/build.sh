#!/bin/sh

app=sed
release=4.2

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    export CPPFLAGS="-DEILSEQ=ENOEXEC -I${prefix}/include"
    generic_build
}

install() {
    clean_stage
    # Pre-create the entire prefix tree inside stage
    mkdir -p ${stagedir}${prefix}/bin
    mkdir -p ${stagedir}${prefix}/lib
    mkdir -p ${stagedir}${prefix}/include
    mkdir -p ${stagedir}${prefix}/share/locale
    # Fix relative mkinstalldirs path inside intl directory if needed
    if [ -f mkinstalldirs ] && [ ! -f intl/mkinstalldirs ]; then
        cp mkinstalldirs intl/
    fi
    generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
