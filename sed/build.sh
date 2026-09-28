#!/bin/sh

app=sed
release=3.02

patches[0]=sed-inplace-edit.patch.gz

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    #export CPPFLAGS="-DEILSEQ=ENOEXEC -Dmemmove(d,s,n)=bcopy((s),(d),(n)) -I${prefix}/include"
    export CPPFLAGS="-DEILSEQ=ENOEXEC -include ${prefix}/include/lse/string_compat.h -I${prefix}/include"
    export LIBS="-llsecompat"
    #generic_build
    cd ${builddir}/${app}-${release} || exit 1
    ./configure --prefix=${prefix} \
            --disable-nls \
            --disable-i18n \
            --disable-mbcs
    make HELP2MAN=true
}

install() {
    clean_stage
    # Pre-create the entire prefix tree inside stage
    #mkdir -p ${stagedir}${prefix}/bin
    #mkdir -p ${stagedir}${prefix}/lib
    #mkdir -p ${stagedir}${prefix}/include
    #mkdir -p ${stagedir}${prefix}/share/locale
    # Fix relative mkinstalldirs path inside intl directory if needed
    #if [ -f mkinstalldirs ] && [ ! -f intl/mkinstalldirs ]; then
    #    cp mkinstalldirs intl/
    #fi
    #generic_install
    cd ${builddir}/${app}-${release} || exit 1
    make HELP2MAN=true install prefix="${stagedir}${prefix}"

}

pack() {
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
