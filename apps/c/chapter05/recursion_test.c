#include <stdio.h>
#include "../include/test_helper.h"
#include "recursion.h"

void test_factorial(void) {
    ASSERT_EQ_INT(120, factorial(5));
    ASSERT_EQ_INT(1,   factorial(0));
}

void test_gcd(void) {
    ASSERT_EQ_INT(2, gcd(22, 8));
    ASSERT_EQ_INT(6, gcd(18, 24));
}

void test_recursive_sum(void) {
    ASSERT_EQ_INT(15, recursive_sum(5));
    ASSERT_EQ_INT(0,  recursive_sum(0));
}

void test_hanoi(void) {
    HanoiMove moves[10];
    int n = hanoi(1, 'A', 'C', 'B', moves);
    ASSERT_EQ_INT(1, n);
    ASSERT_EQ_INT('A', moves[0].from);
    ASSERT_EQ_INT('C', moves[0].to);

    n = hanoi(3, 'A', 'C', 'B', moves);
    ASSERT_EQ_INT(7, n);
}

void test_maze_solve(void) {
    int maze[3][3] = {{1,1,1},{1,0,1},{1,1,1}};
    ASSERT_TRUE(maze_solve((int *)maze, 3, 3, 1, 1, 1, 1));
}

void test_eight_queen(void) {
    int result_count = eight_queen();
    ASSERT_EQ_INT(8*8*8*8*8*8*8*8, result_count); /* 8^8 = 16777216 */
}

void test_eight_queen2(void) {
    int result_count = eight_queen2();
    ASSERT_EQ_INT(40320, result_count); /* 8! = 40320 */
}

void test_eight_queen3(void) {
    int result_count = eight_queen3();
    ASSERT_EQ_INT(92, result_count);
}

int main(void) {
    test_factorial();
    test_gcd();
    test_recursive_sum();
    test_hanoi();
    test_maze_solve();
    test_eight_queen();
    test_eight_queen2();
    test_eight_queen3();
    TEST_SUMMARY();
    return 0;
}
