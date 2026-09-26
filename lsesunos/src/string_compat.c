/* BEGIN IMPL */
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>
#include <locale.h>

#if defined(__GNUC__)
#  if defined(__ELF__) || defined(__solaris__) || defined(SOLARIS2)
     /* ELF systems: Use pragma weak */
#    pragma weak memmove
#    pragma weak strerror
#    pragma weak difftime
#    pragma weak atexit
#    pragma weak strsep
#    pragma weak strtoul
#    pragma weak setlocale
#  elif defined(__aout__) || defined(sun) || defined(__sunos__)
     /* SunOS 4 / a.out systems: Standard declarations without weak attributes */
     void          *memmove(void *dest, const void *src, size_t n);
     char          *strerror(int errnum);
     double         difftime(time_t time1, time_t time0);
     int            atexit(void (*func)(void));
     char          *strsep(char **stringp, const char *delim);
     unsigned long  strtoul(const char *nptr, char **endptr, int base);
     char          *setlocale(int category, const char *locale);
#  else
     /* Fallback for other GCC platforms supporting weak attributes */
     void          *memmove(void *dest, const void *src, size_t n)     __attribute__((weak));
     char          *strerror(int errnum)                              __attribute__((weak));
     double         difftime(time_t time1, time_t time0)              __attribute__((weak));
     int            atexit(void (*func)(void))                         __attribute__((weak));
     char          *strsep(char **stringp, const char *delim)         __attribute__((weak));
     unsigned long  strtoul(const char *nptr, char **endptr, int base) __attribute__((weak));
     char          *setlocale(int category, const char *locale)        __attribute__((weak));
#  endif
#endif

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


char *strsep(char **stringp, const char *delim)
{
    char *begin, *end;

    begin = *stringp;
    if (begin == NULL)
        return NULL;

    /* Find the end of the token */
    end = begin + strcspn(begin, delim);

    if (*end) {
        *end = '\0';
        *stringp = end + 1;
    } else {
        *stringp = NULL;
    }

    return begin;
}

unsigned long strtoul(const char *nptr, char **endptr, int base)
{
    const char *s = nptr;
    unsigned long acc = 0;
    int c;
    unsigned long cutoff;
    int neg = 0, any = 0, cutlim;

    /* Skip white space */
    do {
        c = *s++;
    } while (isspace((unsigned char)c));

    if (c == '-') {
        neg = 1;
        c = *s++;
    } else if (c == '+') {
        c = *s++;
    }

    if ((base == 0 || base == 16) && c == '0' && (*s == 'x' || *s == 'X')) {
        c = s[1];
        s += 2;
        base = 16;
    }
    if (base == 0)
        base = (c == '0') ? 8 : 10;

    cutoff = ULONG_MAX / (unsigned long)base;
    cutlim = (int)(ULONG_MAX % (unsigned long)base);

    for (;; c = *s++) {
        if (isdigit((unsigned char)c))
            c -= '0';
        else if (isalpha((unsigned char)c))
            c -= isupper((unsigned char)c) ? 'A' - 10 : 'a' - 10;
        else
            break;

        if (c >= base)
            break;

        if (any < 0 || acc > cutoff || (acc == cutoff && c > cutlim)) {
            any = -1;
        } else {
            any = 1;
            acc *= (unsigned long)base;
            acc += (unsigned long)c;
        }
    }

    if (any < 0) {
        acc = ULONG_MAX;
    } else if (neg) {
        acc = -acc;
    }

    if (endptr != NULL)
        *endptr = (char *)(any ? s - 1 : nptr);

    return acc;
}

/* setlocale dummy shim for SunOS 4 */

char *setlocale(int category, const char *locale) {
    /* SunOS 4 only supports the default C / POSIX locale */
    if (locale == NULL || locale[0] == '\0' || strcmp(locale, "C") == 0 || strcmp(locale, "POSIX") == 0) {
        return "C";
    }
    return NULL; /* Unsupported locale request */
}
/* END IMPL */
