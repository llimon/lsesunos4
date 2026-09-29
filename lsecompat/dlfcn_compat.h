#ifndef DLFCN_COMPAT_H
#define DLFCN_COMPAT_H

#include <sys/types.h>

#ifndef COMPAT_DLFCN_COMPAT_H
#define COMPAT_DLFCN_COMPAT_H

/* Force inclusion of system dlfcn.h first to pull in Dl_info and prototypes */

/* Supply missing POSIX flags for Solaris 2.5.1 and SunOS 4 */
#ifndef RTLD_LAZY
# define RTLD_LAZY   0x00001
#endif
#ifndef RTLD_NOW
# define RTLD_NOW    0x00002
#endif
#ifndef RTLD_GLOBAL
# define RTLD_GLOBAL 0x00100
#endif
#ifndef RTLD_LOCAL
# define RTLD_LOCAL  0x00000
#endif
#ifndef RTLD_LOCAL
#  define RTLD_LOCAL 0x00000
#endif

#endif /* COMPAT_DLFCN_COMPAT_H */

#endif /* DLFCN_COMPAT_H */
