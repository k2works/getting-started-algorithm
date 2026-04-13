#include <stdio.h>
#include <string.h>
#include "../include/test_helper.h"
#include "arrays.h"

void test_max_of(void) {
    int a[] = {172, 153, 192, 140, 165};
    ASSERT_EQ_INT(192, max_of(a, 5));
}

void test_reverse_array(void) {
    int a[] = {2, 5, 1, 3, 9, 6, 7};
    reverse_array(a, 7);
    int expected[] = {7, 6, 9, 3, 1, 5, 2};
    for (int i = 0; i < 7; i++) {
        ASSERT_EQ_INT(expected[i], a[i]);
    }
}

void test_card_conv(void) {
    char buf[64];
    card_conv(29, 2, buf, sizeof(buf));
    ASSERT_EQ_STR("11101", buf);
    card_conv(255, 16, buf, sizeof(buf));
    ASSERT_EQ_STR("FF", buf);
}

void test_prime1(void) {
    ASSERT_EQ_INT(78022, prime1(1000));
}

void test_prime2(void) {
    ASSERT_EQ_INT(14622, prime2(1000));
}

void test_prime3(void) {
    ASSERT_EQ_INT(3774, prime3(1000));
}

int main(void) {
    test_max_of();
    test_reverse_array();
    test_card_conv();
    test_prime1();
    test_prime2();
    test_prime3();
    TEST_SUMMARY();
    return 0;
}
