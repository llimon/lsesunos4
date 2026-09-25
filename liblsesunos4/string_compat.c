/* BEGIN IMPL */
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>

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
/* END IMPL */
