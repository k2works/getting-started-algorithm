#include <stdio.h>
#include "../include/test_helper.h"
#include "stack_queue.h"

void test_stack_basic(void) {
    Stack *s = stack_new(5);
    ASSERT_TRUE(stack_is_empty(s));
    ASSERT_FALSE(stack_is_full(s));
    ASSERT_EQ_INT(0, stack_push(s, 10));
    ASSERT_EQ_INT(0, stack_push(s, 20));
    ASSERT_EQ_INT(2, stack_size(s));
    int val;
    ASSERT_EQ_INT(0, stack_peek(s, &val));
    ASSERT_EQ_INT(20, val);
    ASSERT_EQ_INT(0, stack_pop(s, &val));
    ASSERT_EQ_INT(20, val);
    ASSERT_EQ_INT(1, stack_size(s));
    stack_free(s);
}

void test_stack_find_count_clear(void) {
    Stack *s = stack_new(5);
    stack_push(s, 1);
    stack_push(s, 2);
    stack_push(s, 1);
    ASSERT_EQ_INT(2, stack_find(s, 1));   /* top-most occurrence index */
    ASSERT_EQ_INT(2, stack_count(s, 1));
    stack_clear(s);
    ASSERT_TRUE(stack_is_empty(s));
    stack_free(s);
}

void test_queue_basic(void) {
    Queue *q = queue_new(5);
    ASSERT_TRUE(queue_is_empty(q));
    ASSERT_EQ_INT(0, queue_enqueue(q, 10));
    ASSERT_EQ_INT(0, queue_enqueue(q, 20));
    ASSERT_EQ_INT(2, queue_size(q));
    int val;
    ASSERT_EQ_INT(0, queue_peek(q, &val));
    ASSERT_EQ_INT(10, val);
    ASSERT_EQ_INT(0, queue_dequeue(q, &val));
    ASSERT_EQ_INT(10, val);
    ASSERT_EQ_INT(1, queue_size(q));
    queue_free(q);
}

void test_queue_find_count_clear(void) {
    Queue *q = queue_new(5);
    queue_enqueue(q, 1);
    queue_enqueue(q, 2);
    queue_enqueue(q, 1);
    ASSERT_EQ_INT(0, queue_find(q, 1)); /* front index */
    ASSERT_EQ_INT(2, queue_count(q, 1));
    queue_clear(q);
    ASSERT_TRUE(queue_is_empty(q));
    queue_free(q);
}

int main(void) {
    test_stack_basic();
    test_stack_find_count_clear();
    test_queue_basic();
    test_queue_find_count_clear();
    TEST_SUMMARY();
    return 0;
}
