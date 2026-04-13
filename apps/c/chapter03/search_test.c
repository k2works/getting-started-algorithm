#include <stdio.h>
#include "../include/test_helper.h"
#include "search.h"

void test_ssearch_while(void) {
    int a[] = {6, 4, 3, 2, 1, 2, 8};
    ASSERT_EQ_INT(3, ssearch_while(a, 7, 2));
    ASSERT_EQ_INT(-1, ssearch_while(a, 7, 9));
}

void test_ssearch_for(void) {
    int a[] = {6, 4, 3, 2, 1, 2, 8};
    ASSERT_EQ_INT(3, ssearch_for(a, 7, 2));
    ASSERT_EQ_INT(-1, ssearch_for(a, 7, 9));
}

void test_ssearch_sentinel(void) {
    int a[] = {6, 4, 3, 2, 1, 2, 8};
    ASSERT_EQ_INT(3, ssearch_sentinel(a, 7, 2));
    ASSERT_EQ_INT(-1, ssearch_sentinel(a, 7, 9));
}

void test_bsearch_int(void) {
    int a[] = {1, 2, 3, 5, 7, 8, 9};
    ASSERT_EQ_INT(3, bsearch_int(a, 7, 5));
    ASSERT_EQ_INT(-1, bsearch_int(a, 7, 4));
}

void test_chained_hash(void) {
    ChainedHash *h = chained_hash_new(13);
    ASSERT_TRUE(chained_hash_add(h, 1, 100));
    ASSERT_TRUE(chained_hash_add(h, 14, 200)); /* same bucket as 1 */
    ASSERT_EQ_INT(100, chained_hash_search(h, 1));
    ASSERT_EQ_INT(200, chained_hash_search(h, 14));
    ASSERT_EQ_INT(-1,  chained_hash_search(h, 99));
    ASSERT_TRUE(chained_hash_remove(h, 1));
    ASSERT_EQ_INT(-1,  chained_hash_search(h, 1));
    chained_hash_free(h);
}

void test_open_hash(void) {
    OpenHash *h = open_hash_new(13);
    ASSERT_TRUE(open_hash_add(h, 1, 100));
    ASSERT_TRUE(open_hash_add(h, 14, 200));
    ASSERT_EQ_INT(100, open_hash_search(h, 1));
    ASSERT_EQ_INT(200, open_hash_search(h, 14));
    ASSERT_EQ_INT(-1,  open_hash_search(h, 99));
    ASSERT_TRUE(open_hash_remove(h, 1));
    ASSERT_EQ_INT(-1,  open_hash_search(h, 1));
    open_hash_free(h);
}

int main(void) {
    test_ssearch_while();
    test_ssearch_for();
    test_ssearch_sentinel();
    test_bsearch_int();
    test_chained_hash();
    test_open_hash();
    TEST_SUMMARY();
    return 0;
}
