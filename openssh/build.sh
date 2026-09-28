#!/bin/sh

app=openssh
release=5.4p1

. /home/luis/source/build.functions.sh

prep() {
    generic_prep
}

clean() {
    generic_clean
}

build() {
    # Set GCC explicitly
    export CC="gcc"
    export LDFLAGS="-L${prefix}/lib"
    export CPPFLAGS="-I${prefix}/include -D_POSIX_VDISABLE=0 -DMAXHOSTNAMELEN=64 -DRTLD_NOW=0x00002 -Usignal"
    cd ${builddir}/${app}-${release} || exit 1
        #--with-ssl-dir=/path/to/openssl-0.9.8zh \
     ./configure \
        --prefix=${prefix} \
        --with-egd-pool=/dev/egd-pool \
        --disable-strip
    make
}

install() {
   # Ensure we are running as root (UID 0)
   if [ "$(id -u)" -ne 0 ]; then
       echo "Error: This script must be run as root." >&2
       exit 1
   fi
   
   # Set up privilege separation user/group if missing
   if ! grep -q "^sshd:" /etc/group; then
       echo "Creating 'sshd' group..."
       echo "sshd:*:50:" >> /etc/group
   fi
   
   if ! grep -q "^sshd:" /etc/passwd; then
       echo "Creating 'sshd' user..."
       echo "sshd:*:50:50:Privilege Separation:/var/empty:/bin/false" >> /etc/passwd
   fi
   
   # Ensure chroot directory exists with correct permissions
   if [ ! -d /var/empty ]; then
       mkdir -p /var/empty
   fi
   chown root:sys /var/empty
   chmod 755 /var/empty 
    generic_install
}

pack() {
   mkdir -p ${stagedir}${prefix}/installers || exit 0
   cp install-ssh-service ${stagedir}${prefix}/installers/install-ssh-service
   # remove install keys for packaging. 
   rm -f ${stagedir}${prefix}/etc/ssh*host*key*
   generic_pack
}

# Route to a function (quoted to protect empty arguments)
param_router "$1"
