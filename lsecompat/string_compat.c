/* BEGIN IMPL */
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>
#include <locale.h>
#include <stdio.h>
#include <errno.h>

#if defined(__GNUC__)
#  if defined(__ELF__) || defined(__solaris__) || defined(SOLARIS2)
     /* ELF systems: Use pragma weak */
#    pragma weak memmove
#    pragma weak atexit
#    pragma weak strsep
#    pragma weak strtoul
#    pragma weak strtol
#    pragma weak setlocale
#  elif defined(__aout__) || defined(sun) || defined(__sunos__)
     /* SunOS 4 / a.out systems: Standard declarations without weak attributes */
     void          *memmove(void *dest, const void *src, size_t n);
     int            atexit(void (*func)(void));
     char          *strsep(char **stringp, const char *delim);
     long          strtol(const char *nptr, char **endptr, int base);
     unsigned long  strtoul(const char *nptr, char **endptr, int base);
     char          *setlocale(int category, const char *locale);
#  else
     /* Fallback for other GCC platforms supporting weak attributes */
     void          *memmove(void *dest, const void *src, size_t n)     __attribute__((weak));
     int            atexit(void (*func)(void))                         __attribute__((weak));
     char          *strsep(char **stringp, const char *delim)         __attribute__((weak));
     long           strtol(const char *nptr, char **endptr, int base) __attribute__((weak));
     unsigned long  strtoul(const char *nptr, char **endptr, int base) __attribute__((weak));
     char          *setlocale(int category, const char *locale)        __attribute__((weak));
#  endif
#endif

/* SunOS 4 libc global error string definitions */
extern int sys_nerr;
extern char *sys_errlist[];
extern void *memmove(void *dest, const void *src, size_t n);

void *memmove(void *dest, const void *src, size_t n) {
    if (dest != src && n > 0) {
        bcopy(src, dest, n);
    }
    return dest;
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

long strtol(const char *nptr, char **endptr, int base)
{
    const char *s = nptr;
    long acc = 0;
    int neg = 0;
    int digit = -1;
    int c;
    const char *start_digits;

    while (isspace((unsigned char)*s))
        s++;

    if (*s == '-') {
        neg = 1;
        s++;
    } else if (*s == '+') {
        s++;
    }

    if ((base == 0 || base == 16) && *s == '0' && (s[1] == 'x' || s[1] == 'X')) {
        s += 2;
        base = 16;
    } else if (base == 0) {
        base = (*s == '0') ? 8 : 10;
    }

    start_digits = s;
    while (*s != '\0') {
        c = (unsigned char)*s;
        digit = -1;

        if (isdigit(c)) {
            digit = c - '0';
        } else if (isalpha(c)) {
            digit = tolower(c) - 'a' + 10;
        } else {
            break;
        }

        if (digit >= base)
            break;

        acc = acc * base + digit;
        s++;
    }

    if (neg)
        acc = -acc;

    if (endptr != NULL)
        *endptr = (char *)(s == start_digits ? nptr : s);

    return acc;
}


unsigned long strtoul(const char *nptr, char **endptr, int base)
{
    return (unsigned long)strtol(nptr, endptr, base);
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
