app=gcc
release=2.8.1
stagedir=/usr/local/stage
prefix=/usr/local
osversion=`uname -r | cut -d_ -f1 | tr ' ' '-' | tr 'A-Z' 'a-z'`
osname=`uname -s`
distdir=/home/luis/distfiles

. /home/luis/source/build.functions.sh
prep() {
	gzip -d -c libstdc++-2.8.1.tar.gz | tar -xvf -
	gzip -d -c  gcc-2.8.1.tar.gz |tar -xvf -
	mv gcc-2.8.1 libstdc++-2.8.1/gcc
}

clean() {
	cd libstdc++-${release}/${app} &&
	make clean
}

build() {
	## Compile the software as normal
	cd "libstdc++-${release}/${app}"
	
	./configure --prefix=${prefix}
	
	make bootstrap
}

install() {
	clean_stage
	# Install into the temporary staging area
	#make prefix=${stagedir}/${prefix} install
}

pack() {
    mkdir -p "${distdir}"
    echo "cd ${stagedir}/${prefix}"
    ls -al "${stagedir}/${prefix}"
   (cd "${stagedir}/${prefix}" && echo "running tar" && tar -cvf "${distdir}/${app}-${release}-${osversion}.tar" ./*)
    pwd
    ls -al "${distdir}/${app}-${release}-${osversion}.tar"
}

# Route to a function
param_router $1

