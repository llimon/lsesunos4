#!/bin/sh
#
# install-apache-service.sh - Install/uninstall Apache 1.3.41 startup block in /etc/rc.local
# System: SunOS 4.1.3 / 4.1.4 (SPARC)
#

RC_LOCAL="/etc/rc.local"
HTTPD_BIN="/usr/local/lse/apache/bin/httpd"
APACHECTL="/usr/local/lse/apache/bin/apachectl start  -f /usr/local/lse/apache/conf/httpd.conf"
START_TAG="# BEGIN APACHE HTTPD STARTUP"
END_TAG="# END APACHE HTTPD STARTUP"

usage() {
    echo "Usage: $0 [install|uninstall]"
    exit 1
}

if [ `id -u` -ne 0 ]; then
    echo "Error: Must be run as root."
    exit 1
fi

if [ ! -f "${RC_LOCAL}" ]; then
    echo "Error: ${RC_LOCAL} not found."
    exit 1
fi

do_install() {
    # Check if already installed
    if grep -q "${START_TAG}" "${RC_LOCAL}"; then
        echo "Apache startup block is already present in ${RC_LOCAL}."
        exit 0
    fi

    # Verify binaries exist
    if [ ! -x "${APACHECTL}" ] && [ ! -x "${HTTPD_BIN}" ]; then
        echo "Warning: ${APACHECTL} or${HTTPD_BIN} not found or not executable."
        echo "Installing startup block anyway..."
    fi

    echo "Backing up ${RC_LOCAL} to${RC_LOCAL}.bak..."
    cp -p "${RC_LOCAL}" "${RC_LOCAL}.bak"

    echo "Appending Apache startup block to ${RC_LOCAL}..."
    cat >> "${RC_LOCAL}" << EOF

${START_TAG}
if [ -f ${APACHECTL} ]; then
    echo -n ' apache'
    ${APACHECTL} start >/dev/null 2>&1
elif [ -f ${HTTPD_BIN} ]; then
    echo -n ' httpd'
    ${HTTPD_BIN} -k start >/dev/null 2>&1
fi
${END_TAG}
EOF

    echo "Done. Apache will now start automatically at boot."
}

do_uninstall() {
    if ! grep -q "${START_TAG}" "${RC_LOCAL}"; then
        echo "No Apache startup block found in ${RC_LOCAL}."
        exit 0
    fi

    echo "Backing up ${RC_LOCAL} to${RC_LOCAL}.bak..."
    cp -p "${RC_LOCAL}" "${RC_LOCAL}.bak"

    echo "Removing Apache startup block from ${RC_LOCAL}..."
    sed "/${START_TAG}/,/${END_TAG}/d" "${RC_LOCAL}.bak" > "${RC_LOCAL}"
    echo "Done. Removed Apache from ${RC_LOCAL}."
}

case "$1" in
    install|"")
        do_install
        ;;
    uninstall)
        do_uninstall
        ;;
    *)
        usage
        ;;
esac
