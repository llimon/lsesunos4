#ifndef _STRING_COMPAT_H
#define _STRING_COMPAT_H

#include <stddef.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

void          *memmove(void *dest, const void *src, size_t n);
char          *strerror(int errnum);
double         difftime(time_t time1, time_t time0);
int            atexit(void (*func)(void));
char          *strsep(char **stringp, const char *delim);
unsigned long  strtoul(const char *nptr, char **endptr, int base);
char          *setlocale(int category, const char *locale);

#ifdef __cplusplus
}
#endif

#endif /* _STRING_COMPAT_H */
