#include <stdlib.h>
#include "stack_queue.h"

/* ---- Stack ---- */

Stack *stack_new(int capacity) {
    Stack *s = (Stack *)malloc(sizeof(Stack));
    s->data = (int *)malloc((size_t)capacity * sizeof(int));
    s->capacity = capacity;
    s->ptr = 0;
    return s;
}

void stack_free(Stack *s) { free(s->data); free(s); }
int  stack_is_empty(const Stack *s) { return s->ptr <= 0; }
int  stack_is_full(const Stack *s)  { return s->ptr >= s->capacity; }
int  stack_size(const Stack *s)     { return s->ptr; }

int stack_push(Stack *s, int value) {
    if (stack_is_full(s)) return -1;
    s->data[s->ptr++] = value;
    return 0;
}

int stack_pop(Stack *s, int *value) {
    if (stack_is_empty(s)) return -1;
    *value = s->data[--s->ptr];
    return 0;
}

int stack_peek(const Stack *s, int *value) {
    if (stack_is_empty(s)) return -1;
    *value = s->data[s->ptr - 1];
    return 0;
}

int stack_find(const Stack *s, int value) {
    for (int i = s->ptr - 1; i >= 0; i--) {
        if (s->data[i] == value) return i;
    }
    return -1;
}

int stack_count(const Stack *s, int value) {
    int c = 0;
    for (int i = 0; i < s->ptr; i++) {
        if (s->data[i] == value) c++;
    }
    return c;
}

void stack_clear(Stack *s) { s->ptr = 0; }

/* ---- Queue ---- */

Queue *queue_new(int capacity) {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->data = (int *)malloc((size_t)capacity * sizeof(int));
    q->capacity = capacity;
    q->front = q->rear = q->num = 0;
    return q;
}

void queue_free(Queue *q) { free(q->data); free(q); }
int  queue_is_empty(const Queue *q) { return q->num <= 0; }
int  queue_is_full(const Queue *q)  { return q->num >= q->capacity; }
int  queue_size(const Queue *q)     { return q->num; }

int queue_enqueue(Queue *q, int value) {
    if (queue_is_full(q)) return -1;
    q->data[q->rear] = value;
    q->rear = (q->rear + 1) % q->capacity;
    q->num++;
    return 0;
}

int queue_dequeue(Queue *q, int *value) {
    if (queue_is_empty(q)) return -1;
    *value = q->data[q->front];
    q->front = (q->front + 1) % q->capacity;
    q->num--;
    return 0;
}

int queue_peek(const Queue *q, int *value) {
    if (queue_is_empty(q)) return -1;
    *value = q->data[q->front];
    return 0;
}

int queue_find(const Queue *q, int value) {
    for (int i = 0; i < q->num; i++) {
        if (q->data[(q->front + i) % q->capacity] == value) return i;
    }
    return -1;
}

int queue_count(const Queue *q, int value) {
    int c = 0;
    for (int i = 0; i < q->num; i++) {
        if (q->data[(q->front + i) % q->capacity] == value) c++;
    }
    return c;
}

void queue_clear(Queue *q) { q->front = q->rear = q->num = 0; }
