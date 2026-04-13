#include <string.h>
#include "../include/test_helper.h"
#include "tree.h"

/* ---- BST ---- */

void test_bst_insert_search(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    ASSERT_TRUE(bst_search(t, 5));
    ASSERT_TRUE(bst_search(t, 3));
    ASSERT_TRUE(bst_search(t, 7));
    ASSERT_FALSE(bst_search(t, 99));
    ASSERT_EQ_INT(3, bst_len(t));
    bst_free(t);
}

void test_bst_min_max(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    bst_insert(t, 1);
    bst_insert(t, 9);
    ASSERT_EQ_INT(1, bst_min(t));
    ASSERT_EQ_INT(9, bst_max(t));
    bst_free(t);
}

void test_bst_inorder(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    bst_insert(t, 1);
    bst_insert(t, 4);
    int buf[10];
    int n = bst_inorder(t, buf, 10);
    ASSERT_EQ_INT(5, n);
    ASSERT_EQ_INT(1, buf[0]);
    ASSERT_EQ_INT(3, buf[1]);
    ASSERT_EQ_INT(4, buf[2]);
    ASSERT_EQ_INT(5, buf[3]);
    ASSERT_EQ_INT(7, buf[4]);
    bst_free(t);
}

void test_bst_preorder(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    int buf[10];
    int n = bst_preorder(t, buf, 10);
    ASSERT_EQ_INT(3, n);
    ASSERT_EQ_INT(5, buf[0]);
    ASSERT_EQ_INT(3, buf[1]);
    ASSERT_EQ_INT(7, buf[2]);
    bst_free(t);
}

void test_bst_postorder(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    int buf[10];
    int n = bst_postorder(t, buf, 10);
    ASSERT_EQ_INT(3, n);
    ASSERT_EQ_INT(3, buf[0]);
    ASSERT_EQ_INT(7, buf[1]);
    ASSERT_EQ_INT(5, buf[2]);
    bst_free(t);
}

void test_bst_delete(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    bst_delete(t, 3);
    ASSERT_FALSE(bst_search(t, 3));
    ASSERT_EQ_INT(2, bst_len(t));
    bst_free(t);
}

/* ---- MinHeap ---- */

void test_min_heap_push_pop(void) {
    MinHeap *h = heap_new(10);
    heap_push(h, 5);
    heap_push(h, 3);
    heap_push(h, 7);
    heap_push(h, 1);
    ASSERT_EQ_INT(4, heap_len(h));
    ASSERT_EQ_INT(1, heap_pop(h));
    ASSERT_EQ_INT(3, heap_pop(h));
    ASSERT_EQ_INT(5, heap_pop(h));
    ASSERT_EQ_INT(7, heap_pop(h));
    heap_free(h);
}

void test_min_heap_peek(void) {
    MinHeap *h = heap_new(10);
    heap_push(h, 5);
    heap_push(h, 2);
    heap_push(h, 8);
    ASSERT_EQ_INT(2, heap_peek(h));
    ASSERT_EQ_INT(3, heap_len(h));
    heap_free(h);
}

int main(void) {
    test_bst_insert_search();
    test_bst_min_max();
    test_bst_inorder();
    test_bst_preorder();
    test_bst_postorder();
    test_bst_delete();
    test_min_heap_push_pop();
    test_min_heap_peek();
    TEST_SUMMARY();
    return 0;
}
