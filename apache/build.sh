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
    
    cd ${builddir}/mod_ssl-${mod_ssl_release}-${release} || exit 1
    ./configure \
       --with-apache=../${app}_${release} \
       --with-ssl=${prefix} \
       --prefix=${prefix}/apache \
       --sysconfdir=${prefix}/apache/conf \
       --datadir=${prefix}/apache/htdocs \
       --localstatedir=${prefix}/apache/logs \
       --sbindir=${prefix}/apache/bin \
       --enable-module=rewrite \
       --enable-module=ssl \
       --disable-shared=ssl \
       --enable-module=most \
       --disable-shared=max


    ## NOTE mod_ssl needs -fpic library
    ##      should be done during gcc preparation of tar file.
    #cd /usr/local/build/lib/gcc-lib/sparc-sun-sunos4.1.3_U1/2.8.1/
    #cp libgcc.a libgcc.a.static
    #cp ucpic/libgcc.a libgcc.a


    cd ${builddir}/${app}_${release} || exit 1
   # /usr/local/build/apache_1.3.41/src/include/hsregex.h
   make -j3 CC="gcc" \
     OPTIM="-O2 -fpic" \
     CFLAGS="-O2 -fpic -mcpu=v7 -DEAPI -I${builddir}/${app}_${release}/src/include -I${builddir}/${app}_${release}/src/lib/expat-lite -I${builddir}/${app}_${release}/src/lib/sdbm -I./src/include -I./src/os/unix -I${prefix}/include -include ${prefix}/include/lse/string_compat.h" \
     LDFLAGS="-fpic -L${prefix}/lib" \
     LIBS="${builddir}/${app}_${release}/src/ap/libap.a -llsecompat -lm" \
     EXTRA_LDFLAGS="-L${prefix}/lib /opt/build/apache_1.3.41/src/ap/libap.a -llsecompat -lm"
     
}

install() {
    clean_stage
    cd ${builddir}/${app}_${release} || exit 1
    make install root=${stagedir}${prefix}
}

pack() {
    mkdir -p ${stagedir}${prefix}/installers
    mkdir -p ${stagedir}${prefix}/tools
    cp install-apache-service.sh ${stagedir}${prefix}/installers/
    cp make-self-signed-cert.sh ${stagedir}${prefix}/tools/
    chmod 755  ${stagedir}${prefix}/installers/install-apache-service.sh
    chmod 755  ${stagedir}${prefix}/tools/make-self-signed-cert.sh
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
