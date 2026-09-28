#!/bin/sh

app=lsof
release=4.50

. /home/luis/source/build.functions.sh

prep() {
#    generic_prep
   mkdir -p ${builddir} || exit 1
   cd ${builddir} || exit 1
   tar -zxvf ${srcfiles}/${app}_${release}_W.tar.gz || exit 1
   cd ${app}_${release}
   tar -xvf ${app}_${release}.tar

}

clean() {
    generic_clean
}

build() {
    cd ${builddir}/${app}_${release} || exit 1
    ./Configure -n sunos
    make
    
     
}

install() {
    clean_stage
    cd ${builddir}/${app}_${release} || exit 1
    mkdir -p ${stagedir}${prefix}/bin
    mkdir -p ${stagedir}${prefix}/share/man/man8
    cp lsof ${stagedir}${prefix}/bin
    
    chmod 2755 ${stagedir}${prefix}/bin/lsof
    cp lsof.8 ${stagedir}${prefix}/share/man/man8
    chmod 444 ${stagedir}${prefix}/share/man/man8/lsof.8
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
