#!/bin/sh
#gcc -x c -DSNPRINTF_LONGLONG_SUPPORT -DSOLARIS_COMPATIBLE -DSOLARIS_BUG_COMPATIBLE -D_TEST_SNPRINTF_COMPAT snprintf_compat.h -o snprintf_compat snprintf_compat.c
gcc -x c  -D_TEST_SNPRINTF_COMPAT snprintf_compat.h -o snprintf_compat snprintf_compat.c
