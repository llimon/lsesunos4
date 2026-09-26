
app=libstdc++
release=2.8.1
stagedir=/usr/local/stage
prefix=/usr/local
osver_t="`uname -s`-`uname -r`"
osver="`echo $osver |awk -F_ '{print $1}'`"
distdir=/home/luis/distfiles

# clean stage
#rm -r -f /usr/local/stage/*

# Create your temporary directory (if you haven't already)
mkdir -p ${stagedir}/usr/local/bin
mkdir -p ${stagedir}/usr/local/sbin
mkdir -p ${stagedir}/usr/local/info
mkdir -p ${stagedir}/usr/local/lib
mkdir -p ${stagedir}/usr/local/man

#gzip -d -c libstdc++-2.8.1.tar.gz | tar -xvf -
#gzip -d -c  gcc-2.8.1.tar.gz |tar -xvf -
#mv gcc-2.8.1 libstdc++-2.8.1/gcc
#
## Compile the software as normal
#cd "libstdc++-${release}"
#
#./configure --prefix=${prefix}
#
#make 
#
# Install into the temporary staging area
#make prefix=${stagedir}/${prefix} install
#
mkdir -p ${distdir}
echo cd ${stagedir}/${prefix}
ls -al ${stagedir}/${prefix}
(cd ${stagedir}/${prefix}  && echo "running tar" && tar -cvf "${distdir}/${app}-${release}-${osver}.tar" ./*)
pwd
ls -al ${distdir}/${app}-${release}-${osver}.tar


