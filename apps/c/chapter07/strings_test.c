#include <string.h>
#include "../include/test_helper.h"
#include "strings.h"

void test_bf_match(void) {
    ASSERT_EQ_INT(12, bf_match("ABCXDEZCABACABAB", "ABAB"));
    ASSERT_EQ_INT(-1, bf_match("ABCXDEZCABACABAB", "XYZ"));
}

void test_kmp_match(void) {
    ASSERT_EQ_INT(12, kmp_match("ABCXDEZCABACABAB", "ABAB"));
    ASSERT_EQ_INT(-1, kmp_match("ABCXDEZCABACABAB", "XYZ"));
}

void test_bm_match(void) {
    ASSERT_EQ_INT(12, bm_match("ABCXDEZCABACABAB", "ABAB"));
    ASSERT_EQ_INT(-1, bm_match("ABCXDEZCABACABAB", "XYZ"));
}

void test_count_chars(void) {
    CharCount cc[26];
    int n = count_chars("hello", cc, 26);
    /* find 'l' */
    int found = 0;
    for (int i = 0; i < n; i++) {
        if (cc[i].c == 'l') { ASSERT_EQ_INT(2, cc[i].count); found = 1; }
    }
    ASSERT_TRUE(found);
}

void test_reverse_string(void) {
    char buf[16];
    reverse_string("hello", buf, sizeof(buf));
    ASSERT_EQ_STR("olleh", buf);
}

void test_is_palindrome(void) {
    ASSERT_TRUE(is_palindrome("racecar"));
    ASSERT_FALSE(is_palindrome("hello"));
}

int main(void) {
    test_bf_match();
    test_kmp_match();
    test_bm_match();
    test_count_chars();
    test_reverse_string();
    test_is_palindrome();
    TEST_SUMMARY();
    return 0;
}
