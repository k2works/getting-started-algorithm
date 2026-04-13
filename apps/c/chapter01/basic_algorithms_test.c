#include <stdio.h>
#include <string.h>
#include "../include/test_helper.h"
#include "basic_algorithms.h"

void test_max3(void) {
    ASSERT_EQ_INT(3, max3(1, 3, 2));
    ASSERT_EQ_INT(3, max3(3, 3, 3));
    ASSERT_EQ_INT(5, max3(5, 1, 3));
}

void test_med3(void) {
    ASSERT_EQ_INT(2, med3(1, 3, 2));
    ASSERT_EQ_INT(3, med3(3, 3, 3));
    ASSERT_EQ_INT(2, med3(1, 2, 3));
}

void test_judge_sign(void) {
    ASSERT_EQ_STR("positive", judge_sign(17));
    ASSERT_EQ_STR("negative", judge_sign(-5));
    ASSERT_EQ_STR("zero",     judge_sign(0));
}

void test_sum_1_to_n(void) {
    ASSERT_EQ_INT(15, sum_1_to_n(5));
    ASSERT_EQ_INT(1,  sum_1_to_n(1));
    ASSERT_EQ_INT(55, sum_1_to_n(10));
}

void test_alternative(void) {
    ASSERT_EQ_STR("+-+-+-+-+-+-", alternative(12));
    ASSERT_EQ_STR("+-+",         alternative(3));
}

void test_rectangle(void) {
    char buf[256];
    rectangle(32, buf, sizeof(buf));
    ASSERT_EQ_STR("1x32 2x16 4x8 ", buf);
}

void test_multiplication_table(void) {
    char buf[512];
    multiplication_table(buf, sizeof(buf));
    ASSERT_TRUE(strstr(buf, "  1  2  3") != NULL);
}

void test_triangle_lb(void) {
    char buf[64];
    triangle_lb(3, buf, sizeof(buf));
    ASSERT_EQ_STR("*\n**\n***\n", buf);
}

int main(void) {
    test_max3();
    test_med3();
    test_judge_sign();
    test_sum_1_to_n();
    test_alternative();
    test_rectangle();
    test_multiplication_table();
    test_triangle_lb();
    TEST_SUMMARY();
    return 0;
}
