/* 2. Map POSIX file sync flags to standard O_SYNC on SunOS 4 */

#ifndef FILE_COMPAT_H
#define FILE_COMPAT_H
#include <sys/types.h>
#include <unistd.h>

#  ifndef _SSIZE_T
#    define _SSIZE_T
     typedef int ssize_t;
#  endif

#  ifndef O_RSYNC
#    define O_RSYNC O_SYNC
#  endif
#  ifndef O_DSYNC
#    define O_DSYNC O_SYNC
#  endif


#ifdef __cplusplus
extern "C" {
#endif

/* Native system call prototype for SunOS 4 */
#if defined(sun) && !defined(SOLARIS2) && !defined(__solaris__)
int    ftruncate(int fd, off_t length);
#endif

#ifdef __cplusplus
}
#endif

#endif /* FILE_COMPAT_H */
