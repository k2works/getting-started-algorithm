#ifndef TEST_HELPER_H
#define TEST_HELPER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int test_pass_count = 0;
static int test_fail_count = 0;

#define ASSERT_EQ_INT(expected, actual) do { \
    if ((expected) == (actual)) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected %d, got %d\n", \
                __FILE__, __LINE__, (expected), (actual)); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_EQ_LONG(expected, actual) do { \
    if ((expected) == (actual)) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected %ld, got %ld\n", \
                __FILE__, __LINE__, (long)(expected), (long)(actual)); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_EQ_STR(expected, actual) do { \
    if (strcmp((expected), (actual)) == 0) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected \"%s\", got \"%s\"\n", \
                __FILE__, __LINE__, (expected), (actual)); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_TRUE(cond) do { \
    if (cond) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected true\n", __FILE__, __LINE__); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_FALSE(cond) do { \
    if (!(cond)) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected false\n", __FILE__, __LINE__); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_NULL(ptr) do { \
    if ((ptr) == NULL) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected NULL\n", __FILE__, __LINE__); \
        test_fail_count++; \
    } \
} while(0)

#define ASSERT_NOT_NULL(ptr) do { \
    if ((ptr) != NULL) { \
        test_pass_count++; \
    } else { \
        fprintf(stderr, "FAIL: %s:%d: expected non-NULL\n", __FILE__, __LINE__); \
        test_fail_count++; \
    } \
} while(0)

#define TEST_SUMMARY() do { \
    printf("%d tests run: %d passed, %d failed\n", \
           test_pass_count + test_fail_count, test_pass_count, test_fail_count); \
    if (test_fail_count > 0) { exit(1); } \
} while(0)

#endif /* TEST_HELPER_H */
