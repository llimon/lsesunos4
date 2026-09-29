#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <limits.h>

/* Forward declarations for standalone testing */
char *strsep(char **stringp, const char *delim);
unsigned long strtoul(const char *nptr, char **endptr, int base);

static void test_strsep(void)
{
    char buf[64];
    char *token;
    char *running;

    printf("Testing strsep()... ");

    /* Test 1: Basic colon-delimited parsing */
    strcpy(buf, "usr:local:bin");
    running = buf;

    token = strsep(&running, ":");
    assert(token != NULL && strcmp(token, "usr") == 0);

    token = strsep(&running, ":");
    assert(token != NULL && strcmp(token, "local") == 0);

    token = strsep(&running, ":");
    assert(token != NULL && strcmp(token, "bin") == 0);

    token = strsep(&running, ":");
    assert(token == NULL && running == NULL);

    /* Test 2: Consecutive delimiters (empty token) */
    strcpy(buf, "a::b");
    running = buf;

    token = strsep(&running, ":");
    assert(strcmp(token, "a") == 0);

    token = strsep(&running, ":");
    assert(strcmp(token, "") == 0);

    token = strsep(&running, ":");
    assert(strcmp(token, "b") == 0);

    printf("PASSED\n");
}

static void test_strtoul(void)
{
    char *endp;
    unsigned long val;

    printf("Testing strtoul()... ");

    /* Test 1: Base 10 conversion */
    val = strtoul("123456", &endp, 10);
    assert(val == 123456UL && *endp == '\0');

    /* Test 2: Base 16 auto-detection with 0x prefix */
    val = strtoul("0xDEADBEEF", &endp, 0);
    assert(val == 0xDEADBEEFUL && *endp == '\0');

    /* Test 3: Base 8 conversion with leading zeroes */
    val = strtoul("0755", &endp, 0);
    assert(val == 0755UL && *endp == '\0');

    /* Test 4: Trailing non-digit stopping behavior */
    val = strtoul("4294967295abc", &endp, 10);
    assert(val == ULONG_MAX && strcmp(endp, "abc") == 0);

    printf("PASSED\n");
}

int main(void)
{
    printf("=== Running liblsecompat String Unit Tests ===\n");
    test_strsep();
    test_strtoul();
    printf("All tests passed successfully!\n");
    return 0;
}
/*
How to Compile and Verify
Bash
gcc -O2 -std=gnu89 -c lsecompat_string.c -o lsecompat_string.o
gcc -O2 -std=gnu89 test_lsecompat.c lsecompat_string.o -o test_lsecompat
./test_lsecompat
Once verified, add lsecompat_string.o to liblsecompat.a, pass -llsecompat to your Midnight Commander link step, and mc will finish building!
*/
