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
    cd ${builddir}/${app}-${release} || echo 1
    make CC="gcc" CFLAGS="-O2 -include /usr/local/lse/include/lsecompat.h" \
	DEFS="-DCONFIGFILE="${prefix}/etc/prngd/prngd.conf" -DRANDSAVENAME=\"${prefix}/etc/prngd/prngd-seed\"" SYSLIBS="-L$prefix/lib -llsecompat" LDFLAGS="-llsecompat"
    
}

install() {
    clean_stage
    #( date; w; netstat -s; vmstat; ps -ax; iostat; last | who |ps -e ) |   dd of=/var/run/prngd-seed bs=1024 count=2 2>/dev/null
   mkdir -p ${stagedir}${prefix}/installers || exit 0
   mkdir -p ${stagedir}${prefix}/etc || exit 0
   mkdir -p ${stagedir}${prefix}/sbin || exit 0
   mkdir -p ${stagedir}${prefix}/share/man/man8 || exit 0
   
   cp ${builddir}/${app}-${release}/prngd ${stagedir}${prefix}/sbin/prngd
   cp start-prngd ${stagedir}${prefix}/sbin/start-prngd
   chmod 755 ${stagedir}${prefix}/sbin/start-prngd
   chmod 755 ${stagedir}${prefix}/sbin/prngd
  
   cp ${builddir}/${app}-${release}/prngd.man ${stagedir}${prefix}/share/man/man8/prngd.8

   cp ${builddir}/${app}-${release}/contrib/SunOS-4/prngd.conf.sunos4 ${stagedir}${prefix}/etc/prngd.conf
   cp install-prngd-service ${stagedir}${prefix}/installers/install-prngd-service
   chmod 755 ${stagedir}${prefix}/installers/install-prngd-service
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
