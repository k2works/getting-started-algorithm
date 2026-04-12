# 第 9 章 木構造

## はじめに

木構造は階層的なデータを表現するデータ構造です。C では再帰関数と動的メモリを使って実装します。この章では二分探索木と最小ヒープを実装します。

---

## 1. 二分探索木（BST: Binary Search Tree）

**性質**：
- 左部分木のすべてのキー < ルートのキー
- 右部分木のすべてのキー > ルートのキー
- 左右の部分木もまた二分探索木

```c
typedef struct _BSTNode {
    int key;
    struct _BSTNode *left;
    struct _BSTNode *right;
} BSTNode;

typedef struct {
    BSTNode *root;
    int no;
} BST;
```

### Red — 失敗するテストを書く

```c
void test_bst_insert_search(void) {
    BST *t = bst_new();
    bst_insert(t, 5);
    bst_insert(t, 3);
    bst_insert(t, 7);
    ASSERT_TRUE(bst_search(t, 5));
    ASSERT_FALSE(bst_search(t, 99));
    ASSERT_EQ_INT(3, bst_len(t));
    bst_free(t);
}
```

### Green — search / insert

```c
int bst_search(const BST *t, int key) {
    BSTNode *ptr = t->root;
    while (ptr != NULL) {
        if (key == ptr->key) return 1;
        ptr = (key < ptr->key) ? ptr->left : ptr->right;
    }
    return 0;
}

void bst_insert(BST *t, int key) {
    if (t->root == NULL) {
        t->root = malloc(sizeof(BSTNode));
        t->root->key = key;
        t->root->left = t->root->right = NULL;
        t->no++;
        return;
    }
    BSTNode *ptr = t->root;
    while (1) {
        if (key == ptr->key) return;  /* 重複は無視 */
        if (key < ptr->key) {
            if (ptr->left == NULL) {
                ptr->left = malloc(sizeof(BSTNode));
                ptr->left->key = key;
                ptr->left->left = ptr->left->right = NULL;
                t->no++;
                return;
            }
            ptr = ptr->left;
        } else {
            if (ptr->right == NULL) {
                ptr->right = malloc(sizeof(BSTNode));
                ptr->right->key = key;
                ptr->right->left = ptr->right->right = NULL;
                t->no++;
                return;
            }
            ptr = ptr->right;
        }
    }
}
```

### 走査（Traversal）

3 種類の深さ優先探索を実装します。

```c
static int _inorder(BSTNode *node, int *buf, int bufsz, int idx) {
    if (node == NULL || idx >= bufsz) return idx;
    idx = _inorder(node->left, buf, bufsz, idx);
    if (idx < bufsz) buf[idx++] = node->key;
    idx = _inorder(node->right, buf, bufsz, idx);
    return idx;
}
```

| 走査順序 | 順番 | 結果（例: 5,3,7,1,4）|
|---------|------|---------------------|
| 中順（inorder） | 左→根→右 | 1, 3, 4, 5, 7（昇順） |
| 前順（preorder） | 根→左→右 | 5, 3, 1, 4, 7 |
| 後順（postorder） | 左→右→根 | 1, 4, 3, 7, 5 |

### 削除（delete）

削除は 3 パターンに分岐します。

```c
void bst_delete(BST *t, int key) {
    /* ... 削除対象を探す ... */

    if (ptr->left == NULL && ptr->right == NULL) {
        /* 葉ノード: そのまま削除 */
        replacement = NULL;
    } else if (ptr->right == NULL) {
        /* 右子なし: 左子で置き換え */
        replacement = ptr->left;
    } else if (ptr->left == NULL) {
        /* 左子なし: 右子で置き換え */
        replacement = ptr->right;
    } else {
        /* 子が 2 つ: 右部分木の最小ノード（中順後継）で置き換え */
        BSTNode *succ_parent = ptr;
        BSTNode *succ = ptr->right;
        while (succ->left != NULL) { succ_parent = succ; succ = succ->left; }
        ptr->key = succ->key;
        /* 後継ノードを削除 */
        if (succ_parent == ptr) succ_parent->right = succ->right;
        else                     succ_parent->left  = succ->right;
        free(succ);
        return;
    }
    /* ... 置き換え処理 ... */
}
```

---

## 2. 最小ヒープ（MinHeap）

完全二分木を配列で表現します。親インデックス `i` に対して、左子は `2i+1`、右子は `2i+2` です。

```c
typedef struct {
    int *data;
    int size;
    int capacity;
} MinHeap;
```

**ヒープ条件**：すべてのノードで `親 ≤ 子`

### Red — 失敗するテストを書く

```c
void test_min_heap_push_pop(void) {
    MinHeap *h = heap_new(10);
    heap_push(h, 5);
    heap_push(h, 3);
    heap_push(h, 7);
    heap_push(h, 1);
    ASSERT_EQ_INT(1, heap_pop(h));
    ASSERT_EQ_INT(3, heap_pop(h));
    heap_free(h);
}
```

### Green — push（上方向に浮かせる）

```c
void heap_push(MinHeap *h, int val) {
    int i = h->size++;
    h->data[i] = val;
    while (i > 0) {
        int parent = (i - 1) / 2;
        if (h->data[parent] <= h->data[i]) break;
        int tmp = h->data[parent];
        h->data[parent] = h->data[i];
        h->data[i] = tmp;
        i = parent;
    }
}
```

### Green — pop（下方向に沈める）

```c
int heap_pop(MinHeap *h) {
    int top = h->data[0];
    h->data[0] = h->data[--h->size];
    int i = 0;
    while (1) {
        int left = 2*i+1, right = 2*i+2, smallest = i;
        if (left < h->size && h->data[left] < h->data[smallest]) smallest = left;
        if (right < h->size && h->data[right] < h->data[smallest]) smallest = right;
        if (smallest == i) break;
        int tmp = h->data[i];
        h->data[i] = h->data[smallest];
        h->data[smallest] = tmp;
        i = smallest;
    }
    return top;
}
```

---

## テスト実行結果

```bash
$ make test-chapter09/tree
=== Testing chapter09/tree ===
30 tests run: 30 passed, 0 failed
```

---

## 全章テスト

```bash
$ make test
=== Testing chapter01/basic_algorithms ===
17 tests run: 17 passed, 0 failed
=== Testing chapter02/arrays ===
13 tests run: 13 passed, 0 failed
=== Testing chapter03/search ===
22 tests run: 22 passed, 0 failed
=== Testing chapter04/stack_queue ===
25 tests run: 25 passed, 0 failed
=== Testing chapter05/recursion ===
14 tests run: 14 passed, 0 failed
=== Testing chapter06/sort ===
51 tests run: 51 passed, 0 failed
=== Testing chapter07/strings ===
11 tests run: 11 passed, 0 failed
=== Testing chapter08/linked_list ===
21 tests run: 21 passed, 0 failed
=== Testing chapter09/tree ===
30 tests run: 30 passed, 0 failed
All tests passed.
```

**合計 204 テスト全通過**

---

## まとめ

| データ構造 | 操作 | 計算量 | C の特徴 |
|-----------|------|--------|---------|
| BST 探索 | `bst_search` | O(h) | 非再帰ループ |
| BST 挿入 | `bst_insert` | O(h) | 非再帰ループ |
| BST 走査 | `bst_inorder` | O(n) | 再帰 + 出力バッファ |
| BST 削除 | `bst_delete` | O(h) | 3 パターン分岐 |
| MinHeap push | `heap_push` | O(log n) | 配列で完全二分木 |
| MinHeap pop | `heap_pop` | O(log n) | 最小子と交換 |

（h: 木の高さ、平均 O(log n)、最悪 O(n)）

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
