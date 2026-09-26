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
    #generic_install
    ( date; w; netstat -s; vmstat; ps -ax; iostat; last | who |ps -e ) |   dd of=/var/run/prngd-seed bs=1024 count=2 2>/dev/null
    #cp /opt/build/prngd-0.9.29/contrib/SunOS-4/prngd.conf.sunos4 /usr/local/lse/etc/prngd.conf
    #sudo /opt/build/prngd-0.9.29/prngd -f -d -c /usr/local/lse/etc/prngd.conf --seedfile /var/run/prngd-seed /dev/egd-pool
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
