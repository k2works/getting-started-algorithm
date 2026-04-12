#include <string.h>
#include "../include/test_helper.h"
#include "linked_list.h"

/* ---- LinkedList (単方向) ---- */

void test_linked_list_add_first(void) {
    LinkedList *lst = ll_new();
    ll_add_first(lst, 10);
    ll_add_first(lst, 20);
    ASSERT_EQ_INT(2, ll_len(lst));
    ASSERT_EQ_INT(20, ll_get_head(lst));
    ll_free(lst);
}

void test_linked_list_add_last(void) {
    LinkedList *lst = ll_new();
    ll_add_last(lst, 10);
    ll_add_last(lst, 20);
    ASSERT_EQ_INT(2, ll_len(lst));
    ASSERT_EQ_INT(10, ll_get_head(lst));
    ll_free(lst);
}

void test_linked_list_remove_first(void) {
    LinkedList *lst = ll_new();
    ll_add_last(lst, 1);
    ll_add_last(lst, 2);
    ll_remove_first(lst);
    ASSERT_EQ_INT(1, ll_len(lst));
    ASSERT_EQ_INT(2, ll_get_head(lst));
    ll_free(lst);
}

void test_linked_list_remove_last(void) {
    LinkedList *lst = ll_new();
    ll_add_last(lst, 1);
    ll_add_last(lst, 2);
    ll_remove_last(lst);
    ASSERT_EQ_INT(1, ll_len(lst));
    ASSERT_EQ_INT(1, ll_get_head(lst));
    ll_free(lst);
}

void test_linked_list_search(void) {
    LinkedList *lst = ll_new();
    ll_add_last(lst, 1);
    ll_add_last(lst, 2);
    ll_add_last(lst, 3);
    ASSERT_TRUE(ll_search(lst, 2));
    ASSERT_FALSE(ll_search(lst, 99));
    ll_free(lst);
}

void test_linked_list_clear(void) {
    LinkedList *lst = ll_new();
    ll_add_last(lst, 1);
    ll_add_last(lst, 2);
    ll_clear(lst);
    ASSERT_EQ_INT(0, ll_len(lst));
    ll_free(lst);
}

/* ---- DoublyLinkedList (双方向) ---- */

void test_doubly_list_add_first(void) {
    DList *dl = dl_new();
    dl_add_first(dl, 10);
    dl_add_first(dl, 20);
    ASSERT_EQ_INT(2, dl_len(dl));
    dl_free(dl);
}

void test_doubly_list_add_last(void) {
    DList *dl = dl_new();
    dl_add_last(dl, 10);
    dl_add_last(dl, 20);
    ASSERT_EQ_INT(2, dl_len(dl));
    dl_free(dl);
}

void test_doubly_list_search(void) {
    DList *dl = dl_new();
    dl_add_last(dl, 1);
    dl_add_last(dl, 2);
    dl_add_last(dl, 3);
    ASSERT_TRUE(dl_search(dl, 2));
    ASSERT_FALSE(dl_search(dl, 99));
    dl_free(dl);
}

void test_doubly_list_clear(void) {
    DList *dl = dl_new();
    dl_add_last(dl, 1);
    dl_add_last(dl, 2);
    dl_clear(dl);
    ASSERT_EQ_INT(0, dl_len(dl));
    dl_free(dl);
}

/* ---- ArrayLinkedList (配列カーソル版) ---- */

void test_array_list_add_first(void) {
    AList *al = al_new(10);
    al_add_first(al, 10);
    al_add_first(al, 20);
    ASSERT_EQ_INT(2, al_len(al));
    al_free(al);
}

void test_array_list_add_last(void) {
    AList *al = al_new(10);
    al_add_last(al, 10);
    al_add_last(al, 20);
    ASSERT_EQ_INT(2, al_len(al));
    al_free(al);
}

void test_array_list_search(void) {
    AList *al = al_new(10);
    al_add_last(al, 1);
    al_add_last(al, 2);
    al_add_last(al, 3);
    ASSERT_TRUE(al_search(al, 2) >= 0);
    ASSERT_TRUE(al_search(al, 99) < 0);
    al_free(al);
}

void test_array_list_remove_first(void) {
    AList *al = al_new(10);
    al_add_last(al, 1);
    al_add_last(al, 2);
    al_remove_first(al);
    ASSERT_EQ_INT(1, al_len(al));
    al_free(al);
}

int main(void) {
    test_linked_list_add_first();
    test_linked_list_add_last();
    test_linked_list_remove_first();
    test_linked_list_remove_last();
    test_linked_list_search();
    test_linked_list_clear();
    test_doubly_list_add_first();
    test_doubly_list_add_last();
    test_doubly_list_search();
    test_doubly_list_clear();
    test_array_list_add_first();
    test_array_list_add_last();
    test_array_list_search();
    test_array_list_remove_first();
    TEST_SUMMARY();
    return 0;
}
