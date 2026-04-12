#include <string.h>
#include "../include/test_helper.h"
#include "sort.h"

static void assert_sorted(int *a, int n) {
    for (int i = 0; i < n - 1; i++)
        ASSERT_TRUE(a[i] <= a[i + 1]);
}

void test_bubble_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    bubble_sort(a, 7);
    assert_sorted(a, 7);
    ASSERT_EQ_INT(1, a[0]);
}

void test_selection_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    selection_sort(a, 7);
    assert_sorted(a, 7);
}

void test_insertion_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    insertion_sort(a, 7);
    assert_sorted(a, 7);
}

void test_shell_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    shell_sort(a, 7);
    assert_sorted(a, 7);
}

void test_quick_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    quick_sort(a, 0, 6);
    assert_sorted(a, 7);
}

void test_merge_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    merge_sort(a, 7);
    assert_sorted(a, 7);
}

void test_heap_sort(void) {
    int a[] = {6, 4, 3, 7, 1, 9, 8};
    heap_sort(a, 7);
    assert_sorted(a, 7);
}

void test_counting_sort(void) {
    int a[] = {3, 1, 4, 1, 5, 9, 2, 6};
    counting_sort(a, 8, 10);
    assert_sorted(a, 8);
    ASSERT_EQ_INT(1, a[0]);
}

int main(void) {
    test_bubble_sort();
    test_selection_sort();
    test_insertion_sort();
    test_shell_sort();
    test_quick_sort();
    test_merge_sort();
    test_heap_sort();
    test_counting_sort();
    TEST_SUMMARY();
    return 0;
}
