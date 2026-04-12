# 第 8 章 リスト

## はじめに

連結リストはポインタでノードをつなぐデータ構造です。配列と異なり挿入・削除が O(1) ですが、ランダムアクセスは O(n) です。C では 3 種類の実装を学びます。

---

## 1. 単方向連結リスト（LinkedList）

各ノードが次のノードへのポインタを持ちます。

```c
typedef struct _LLNode {
    int data;
    struct _LLNode *next;
} LLNode;

typedef struct {
    LLNode *head;
    int no;
} LinkedList;
```

### Red — 失敗するテストを書く

```c
void test_linked_list_add_first(void) {
    LinkedList *lst = ll_new();
    ll_add_first(lst, 10);
    ll_add_first(lst, 20);
    ASSERT_EQ_INT(2, ll_len(lst));
    ASSERT_EQ_INT(20, ll_get_head(lst));  /* 先頭に追加 */
    ll_free(lst);
}
```

### Green — add_first / add_last

```c
void ll_add_first(LinkedList *lst, int data) {
    LLNode *node = malloc(sizeof(LLNode));
    node->data = data;
    node->next = lst->head;
    lst->head = node;
    lst->no++;
}

void ll_add_last(LinkedList *lst, int data) {
    LLNode *node = malloc(sizeof(LLNode));
    node->data = data;
    node->next = NULL;
    if (lst->head == NULL) {
        lst->head = node;
    } else {
        LLNode *ptr = lst->head;
        while (ptr->next != NULL) ptr = ptr->next;
        ptr->next = node;
    }
    lst->no++;
}
```

### remove_first / remove_last

```c
void ll_remove_first(LinkedList *lst) {
    if (lst->head == NULL) return;
    LLNode *old = lst->head;
    lst->head = old->next;
    free(old);
    lst->no--;
}

void ll_remove_last(LinkedList *lst) {
    if (lst->head == NULL) return;
    if (lst->head->next == NULL) {
        free(lst->head);
        lst->head = NULL;
    } else {
        LLNode *ptr = lst->head;
        while (ptr->next != NULL && ptr->next->next != NULL)
            ptr = ptr->next;
        free(ptr->next);
        ptr->next = NULL;
    }
    lst->no--;
}
```

---

## 2. 双方向連結リスト（DoublyLinkedList）— 番兵ノード使用

番兵（ダミー）ノードを使うことで、先頭・末尾の特別処理を不要にします。

```c
typedef struct _DLNode {
    int data;
    struct _DLNode *prev;
    struct _DLNode *next;
} DLNode;

typedef struct {
    DLNode *head;  /* 番兵ノード: head->next が実際の先頭、head->prev が末尾 */
    int no;
} DList;
```

### 番兵ノードの構造

```
         ┌──────────────────────────────┐
         ↓                              │
[番兵] ⇔ [ノード1] ⇔ [ノード2] ⇔ [ノード3]
  ↑                                    │
  └────────────────────────────────────┘
```

### Green — add_first / add_last

```c
void dl_add_first(DList *dl, int data) {
    DLNode *node = malloc(sizeof(DLNode));
    node->data = data;
    node->prev = dl->head;
    node->next = dl->head->next;
    dl->head->next->prev = node;
    dl->head->next = node;
    dl->no++;
}

void dl_add_last(DList *dl, int data) {
    DLNode *node = malloc(sizeof(DLNode));
    node->data = data;
    node->next = dl->head;
    node->prev = dl->head->prev;
    dl->head->prev->next = node;
    dl->head->prev = node;
    dl->no++;
}
```

番兵ノードを使うメリット：`head == NULL` チェックが不要になり、コードがシンプルになります。

---

## 3. 配列カーソル版リスト（ArrayLinkedList）

ポインタの代わりに配列インデックスを使います。

```c
typedef struct {
    int data;
    int next;   /* 次ノードのインデックス（AL_NULL = なし）*/
    int dnext;  /* 削除リスト用（フリーリスト） */
} ANode;

typedef struct {
    int head;
    int deleted;  /* フリーリストの先頭 */
    int max;      /* 使用済み最大インデックス */
    int capacity;
    ANode *n;
    int no;
} AList;
```

### フリーリスト（削除済みスロットの再利用）

```c
static int al_get_insert_index(AList *al) {
    if (al->deleted == AL_NULL) {
        if (al->max + 1 < al->capacity) return ++al->max;
        return AL_NULL;  /* 満杯 */
    } else {
        int rec = al->deleted;
        al->deleted = al->n[rec].dnext;  /* フリーリストを進める */
        return rec;
    }
}
```

削除されたスロットを `dnext` でつないでフリーリストを管理します。次に挿入するとき、フリーリストから再利用します。

### Python との対応

| Python | C |
|--------|---|
| `None` | `NULL` / `AL_NULL`（= -1） |
| `_Node.next` | `LLNode *next`（ポインタ） |
| 配列インデックス | `ANode.next`（int） |
| GC による自動解放 | `free(node)` による手動解放 |

---

## テスト実行結果

```bash
$ make test-chapter08/linked_list
=== Testing chapter08/linked_list ===
21 tests run: 21 passed, 0 failed
```

---

## まとめ

| 実装 | 挿入/削除 | 探索 | 特徴 |
|------|----------|------|------|
| 単方向リスト | O(1)先頭、O(n)末尾 | O(n) | シンプル |
| 双方向リスト | O(1) | O(n) | 番兵で境界処理不要 |
| 配列カーソル版 | O(1)先頭 | O(n) | キャッシュ効率が高い |

C でのメモリ管理のポイント：

- `malloc` で確保したノードは必ず `free` で解放する
- `ll_free`, `dl_free` などデストラクタ関数を用意する
- 番兵ノードはリスト解放時も `free` する

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
