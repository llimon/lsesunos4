stagedir=/usr/local/stage-${app}-${release}
prefix=/usr/local/lse
osversion=`uname -sr | cut -d_ -f1 | tr ' ' '-' | tr 'A-Z' 'a-z'`
osname=`uname -s`
distdir=/home/luis/distfiles
builddir=/opt/build
srcfiles=/home/luis/source/srcfiles
distribution="lse"
