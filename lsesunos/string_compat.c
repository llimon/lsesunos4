/* memmove shim for SunOS 4 */
#include <string.h>

void *memmove(void *dest, const void *src, size_t n) {
    bcopy(src, dest, n);
    return dest;
}

/* strerror shim for SunOS 4 */
extern char *sys_errlist[];
extern int sys_nerr;

char *strerror(int errnum) {
    if (errnum >= 0 && errnum < sys_nerr)
        return sys_errlist[errnum];
    return "Unknown error";
}

/* difftime shim for SunOS 4 */
#include <time.h>

double difftime(time_t time1, time_t time0) {
    return (double)(time1 - time0);
}

/* atexit shim for SunOS 4 */
#include <sys/types.h>

int atexit(void (*func)(void)) {
    return on_exit((void (*)())func, NULL);
}
