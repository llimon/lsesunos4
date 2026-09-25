# Legasy SPARC Extensions for SunOS 4

LSE Is a group of cohesive Open Source and GNU software for SunOS 4.1.X / Solaris 1.1.x

## Installation
Pour the tar files in */usr/local*, They were compiled with prefix /usr/local/lse. 
It is possible to move them to /opt or /usr. Just update your PATH and LD_LIBRARY_PATH. 

GCC in any location other than /usr/local/lse needs additional export variables to locate it's files.

All binaries were compiled In a 40Mhz SPARCstation 10 using the LSE build system.

```bash
# Add the GCC internal include path to the front
GCC_INTERNAL_INC=/usr/local/build/lib/gcc-lib/sparc-sun-sunos4.1.3_U1/2.8.1/include

CPLUS_INCLUDE_PATH=${GCC_INTERNAL_INC}:/usr/local/build/include/g++:/usr/local/build/sparc-sun-sunos4.1.3_U1/include:/usr/local/build/include
export CPLUS_INCLUDE_PATH

C_INCLUDE_PATH=${GCC_INTERNAL_INC}:/usr/local/build/sparc-sun-sunos4.1.3_U1/include:/usr/local/build/include
export C_INCLUDE_PATH
```

## Core Toolchain & Compatibility

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **liblsecompat** | `1.0.0` | `liblsecompat.a`, `sunos_compat.h` | **Completed.** POSIX/ANSI shim layer (`strsep`, `strtoul`, `ssize_t`, `TMP_MAX`, `errno`). |
| **GCC** | `2.95.3` | `/usr/local/lse/bin/gcc` | **Completed.** Primary C/C++ compiler. |
| **GCC** | `2.8.1` | `/usr/local/lse/bin/gcc` | **Completed.** Legacy C compiler stage. |
| **GNU Make** | `3.79.1` | `/usr/local/lse/bin/make` | **Completed.** Primary build automation engine. |
| **GNU Bison** | `1.29` | `/usr/local/lse/bin/bison` | **Completed.** LALR(1) parser generator. |
| **flex** | `2.5.4a` | `/usr/local/lse/bin/flex` | **Completed.** Lexical analyzer generator (pairs with Bison). |

---

## System Shells, Admin & Security

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **GNU Bash** | `2.05b` | `/usr/local/lse/bin/bash` | **Completed.** Primary POSIX/interactive shell. |
| **Sudo** | `1.6.3p7` | `/usr/local/lse/bin/sudo` | **Completed.** Configured with `--sysconfdir=/usr/local/lse/etc`. |
| **OpenSSL** | `0.9.6m` | `libcrypto.a`, `libssl.a` | **Target.** Cryptographic library (`sunos-gcc` target). |
| **OpenSSH** | `3.8.1p1` | `ssh`, `sshd`, `ssh-keygen` | **Target.** Secure shell client/server with BSD PTY support. |
| **top** | `3.5.1` | `/usr/local/lse/bin/top` | **Target.** Process monitor via `libkvm` (`chmod 2755`, `root:kmem`). |
| **logrotate** | `3.3` | `/usr/local/lse/sbin/logrotate` | **Target.** Log rotation tool (requires `libpopt`). |

---

## Scripting Languages & Runtimes

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **Perl** | `5.6.2` | `/usr/local/lse/bin/perl` | **Completed.** Full Perl 5 interpreter with standard modules. |
| **Python** | `1.5.2` | `/usr/local/lse/bin/python1.5` | **Target (Preferred).** Pre-POSIX Python engine. |
| **Python** | `2.0.1` | `/usr/local/lse/bin/python2.0` | **Target (Alternative).** Early 2.x option. |

---

## File Managers, Editors & Utilities

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **Midnight Commander** | `4.1.40` | `/usr/local/lse/bin/mc` | **Completed.** Built with S-Lang/curses and `liblsecompat`. |
| **Vim** | `6.4` | `/usr/local/lse/bin/vim` | **Completed.** Terminal text editor. |
| **GNU Screen** | `3.9.4` | `/usr/local/lse/bin/screen` | **Completed.** Terminal multiplexer. |
| **ncurses / S-Lang** | `5.2` / `1.4.x` | `libncurses.a`, `libslang.a` | **Completed.** Terminal handling libraries. |
| **less** | `381` | `/usr/local/lse/bin/less` | **Target.** Enhanced file pager replacing SunOS `more`. |

---

## Core Utilities, Archiving & Text Processing

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **GNU Tar** | `1.13` | `/usr/local/lse/bin/tar` | **Completed.** Archive manager. |
| **gzip** | `1.2.4a` | `/usr/local/lse/bin/gzip` | **Completed.** Compression utility. |
| **GNU Patch** | `2.5` | `/usr/local/lse/bin/patch` | **Completed.** Source code patching tool. |
| **GNU sh-utils** | `2.0` | `echo`, `env`, `uname`, `who` | **Completed.** Core shell utilities. |
| **GNU findutils** | `4.1` | `find`, `xargs` | **Completed.** Directory searching utilities. |
| **GNU sed** | `3.02` | `/usr/local/lse/bin/sed` | **Target.** Stream editor with larger buffer limits than native `sed`. |
| **GNU gawk** | `3.0.6` | `/usr/local/lse/bin/gawk` | **Target.** POSIX `awk` replacing original SunOS `oawk`. |
| **GNU sed** | `---` | `/usr/local/lse/bin/sed` | **TODO. |
| **GNU diffutils** | `2.7` | `diff`, `cmp`, `sdiff` | **Target.** Context/unified diff generation tool. |
| **bzip2** | `1.0.2` | `/usr/local/lse/bin/bzip2` | **Target.** `.bz2` archive decompression support. |
| **popt** | `1.7` | `libpopt.a` | **Target.** Command-line option parsing library (for `logrotate`). |

---

## Network Tools & File Transfer

| Package | Version | Binary / Library Output | Status / Role |
| :--- | :--- | :--- | :--- |
| **zlib** | `1.1.4` | `libz.a` | **Target.** Compression library for OpenSSH/Wget. |
| **Wget** | `1.8.2` | `/usr/local/lse/bin/wget` | **Target.** HTTP/FTP retriever for pulling distfiles. |
| **rsync** | `2.5.5` | `/usr/local/lse/bin/rsync` | **Target.** Remote file synchronization over SSH. |
| **Minicom** | `1.83.1` | `/usr/local/lse/bin/minicom` | **Target.** Serial communications program (`/var/spool/locks`). |
