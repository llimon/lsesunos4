#!/bin/sh

app=apache
release=1.3.41
mod_ssl_release=2.8.31

. /home/luis/source/build.functions.sh

prep() {
    #generic_prep
    cd ${builddir} || exit 1
    gzip -d -c ${srcfiles}/${app}_${release}.tar.gz |tar -xvf -
    gzip -d -c ${srcfiles}/mod_ssl-${mod_ssl_release}-${release}.tar.gz |tar -xvf -
    
    

}

clean() {
    generic_clean
}

build() {
    
    # cd ${builddir}/mod_ssl-${mod_ssl_release}-${release} || exit 1
    # ./configure \
    #    --with-apache=../${app}_${release} \
    #    --with-ssl=${prefix} \
    #    --prefix=${prefix}/apache \
    #    --enable-module=rewrite \
    #    --enable-module=most \
    #    --enable-shared=max


    cd ${builddir}/${app}_${release} || exit 1
   # /usr/local/build/apache_1.3.41/src/include/hsregex.h
   make CC="gcc" \
     CFLAGS="-O2 -mcpu=v7 -DEAPI -I${builddir}/${app}_${release}/src/include -I${builddir}/${app}_${release}/src/lib/expat-lite -I${builddir}/${app}_${release}/src/lib/sdbm -I./src/include -I./src/os/unix -I${prefix}/include -include ${prefix}/include/lse/string_compat.h" \
     LDFLAGS="-L${prefix}/lib" \
     LIBS="-llsecompat" 
     
}

install() {
    clean_stage
    cd ${builddir}/${app}_${release} || exit 1
    make install prefix=${stagedir}${prefix}
    #generic_install
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
