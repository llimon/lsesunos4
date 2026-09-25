#!/bin/sh

app=sudo 
release=1.6.3

patches[0]=sudo-1.6.3p7.patch.gz

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    cd ${app}-${release} || exit 1
    ./configure \
       --prefix=${prefix} \
       --sysconfdir=/usr/local/lse/etc \
       --with-sudoers-file=/usr/local/lse/etc/sudoers \
       --with-ignore-dot 
    make
}

install() {
    clean_stage
    generic_install
    mkdir -p ${stagedir}${prefix}/etc
    #cp sample.sudoers ${stagedir}${prefix}/etc/sudoers || exit 1
    sh ./install-sh -c -o 0 -g 0 -m 0440 sample.sudoers ${stagedir}${prefix}/etc/sudoers
}

pack() {
   # overide version, to account for patch level
   release=1.6.3p7
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
