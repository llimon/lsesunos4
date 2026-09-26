#!/bin/sh

app=openssl
release=0.9.8zh

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    # Set GCC explicitly
    #export CFLAGS="$CFLAGS "
    #export LDFLAGS="-L${PREFIX}/lib -llsecompat"
    cd ${builddir}/${app}-${release} || exit 1
    ./Configure sunos-gcc \
       --prefix="${prefix}" \
       -Dssize_t=int
    make
}

install() {
    clean_stage

    echo "creating ${stagedir}${prefix}"
    mkdir -p "${stagedir}${prefix}"

    cd "${builddir}/${app}-${release}/${sub_dir}" || exit 1

    # OpenSSL 0.9.6 uses INSTALL_PREFIX as the staging directory (DESTDIR equivalent)
    # and INSTALLTOP for the prefix directory path.
    make install INSTALL_PREFIX="${stagedir}" INSTALLTOP="${prefix}" OPENSSLDIR="${prefix}/ssl"
}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
