# 第 4 章 スタックとキュー

## はじめに

スタックとキューは LIFO・FIFO というアクセスパターンを持つ基本的なデータ構造です。C では構造体とポインタを使って実装します。

---

## 1. スタック（Stack）

LIFO（Last In First Out）: 最後に積んだものを最初に取り出す。

```
push(1) → [1]
push(2) → [1, 2]
push(3) → [1, 2, 3]
pop()   → 3, スタック = [1, 2]
```

### 構造体定義

```c
typedef struct {
    int  *data;
    int   ptr;      /* スタックポインタ（次に push する位置） */
    int   capacity;
} Stack;
```

### Red — 失敗するテストを書く

```c
void test_stack_push_pop(void) {
    Stack *s = stack_new(10);
    ASSERT_EQ_INT(0, stack_push(s, 1));
    ASSERT_EQ_INT(0, stack_push(s, 2));
    ASSERT_EQ_INT(2, stack_pop(s));
    ASSERT_EQ_INT(1, stack_pop(s));
    stack_free(s);
}
```

### Green — push / pop

```c
Stack *stack_new(int capacity) {
    Stack *s = malloc(sizeof(Stack));
    s->data = malloc((size_t)capacity * sizeof(int));
    s->ptr = 0;
    s->capacity = capacity;
    return s;
}

int stack_push(Stack *s, int val) {
    if (s->ptr >= s->capacity) return -1;  /* オーバーフロー */
    s->data[s->ptr++] = val;
    return 0;
}

int stack_pop(Stack *s) {
    if (s->ptr <= 0) return INT_MIN;  /* アンダーフロー */
    return s->data[--s->ptr];
}
```

### peek / find / count / clear

```c
int stack_peek(const Stack *s) { return s->data[s->ptr - 1]; }

int stack_find(const Stack *s, int val) {
    for (int i = s->ptr - 1; i >= 0; i--)
        if (s->data[i] == val) return i;
    return -1;
}

int  stack_count(const Stack *s) { return s->ptr; }
void stack_clear(Stack *s)       { s->ptr = 0; }
```

---

## 2. キュー（Queue）— リングバッファ

FIFO（First In First Out）: 最初に入れたものを最初に取り出す。リングバッファを使うことで `enqueue/dequeue` ともに O(1) を達成します。

```
head → | 1 | 2 | 3 |   | ← tail
       [0] [1] [2] [3]
```

### 構造体定義

```c
typedef struct {
    int *data;
    int  head;      /* 先頭インデックス */
    int  tail;      /* 末尾インデックス（次に enqueue する位置） */
    int  size;      /* 現在の要素数 */
    int  capacity;
} Queue;
```

### Red — 失敗するテストを書く

```c
void test_queue_enqueue_dequeue(void) {
    Queue *q = queue_new(10);
    queue_enqueue(q, 1);
    queue_enqueue(q, 2);
    queue_enqueue(q, 3);
    ASSERT_EQ_INT(1, queue_dequeue(q));
    ASSERT_EQ_INT(2, queue_dequeue(q));
    queue_free(q);
}
```

### Green — enqueue / dequeue

```c
int queue_enqueue(Queue *q, int val) {
    if (q->size >= q->capacity) return -1;
    q->data[q->tail] = val;
    q->tail = (q->tail + 1) % q->capacity;
    q->size++;
    return 0;
}

int queue_dequeue(Queue *q) {
    if (q->size <= 0) return INT_MIN;
    int val = q->data[q->head];
    q->head = (q->head + 1) % q->capacity;
    q->size--;
    return val;
}
```

リングバッファのポイント：`(index + 1) % capacity` で末尾が先頭に折り返します。

---

## テスト実行結果

```bash
$ make test-chapter04/stack_queue
=== Testing chapter04/stack_queue ===
25 tests run: 25 passed, 0 failed
```

---

## まとめ

| データ構造 | アクセス | 実装方針 |
|-----------|---------|---------|
| Stack | LIFO | 配列 + `ptr` |
| Queue | FIFO | リングバッファ（`head/tail/size`） |

C での実装のポイント：

- `malloc` でヒープメモリを確保し、`free` で解放する
- リングバッファは `% capacity` でインデックスを折り返す
- オーバーフロー・アンダーフローは戻り値（`-1` / `INT_MIN`）で通知する

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
