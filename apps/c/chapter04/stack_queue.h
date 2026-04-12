#ifndef STACK_QUEUE_H
#define STACK_QUEUE_H

/* Fixed-size stack */
typedef struct {
    int *data;
    int  capacity;
    int  ptr;
} Stack;

Stack *stack_new(int capacity);
void   stack_free(Stack *s);
int    stack_is_empty(const Stack *s);
int    stack_is_full(const Stack *s);
int    stack_size(const Stack *s);
int    stack_push(Stack *s, int value);  /* 0=ok, -1=full */
int    stack_pop(Stack *s, int *value);  /* 0=ok, -1=empty */
int    stack_peek(const Stack *s, int *value);
int    stack_find(const Stack *s, int value);
int    stack_count(const Stack *s, int value);
void   stack_clear(Stack *s);

/* Fixed-size ring-buffer queue */
typedef struct {
    int *data;
    int  capacity;
    int  front;
    int  rear;
    int  num;
} Queue;

Queue *queue_new(int capacity);
void   queue_free(Queue *q);
int    queue_is_empty(const Queue *q);
int    queue_is_full(const Queue *q);
int    queue_size(const Queue *q);
int    queue_enqueue(Queue *q, int value); /* 0=ok, -1=full */
int    queue_dequeue(Queue *q, int *value);
int    queue_peek(const Queue *q, int *value);
int    queue_find(const Queue *q, int value);
int    queue_count(const Queue *q, int value);
void   queue_clear(Queue *q);

#endif /* STACK_QUEUE_H */
