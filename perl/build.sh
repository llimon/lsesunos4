#!/bin/sh

app=perl
release=5.6.2

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {

    cd "${app}-${release}" || exit 1
    #./Configure -de -Dcc=gcc -Dprefix=/usr/local -Dosname=sunos -Dosvers=4.1.4
    ./Configure -de \
       -Dprefix=/usr/local \
       -Dinstallprefix="${stagedir}${prefix}"
    make
}

install() {
   generic_install
#    cd "${app}-${release}" || exit 1
#    ./installperl -destdir="${stagedir}"
#    ./installman  \
#        --man1dir="${stagedir}${prefix}/man/man1" \
#        --man3dir="${stagedir}${prefix}/man/man3"

}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
