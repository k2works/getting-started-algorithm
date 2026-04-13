# 第 3 章 探索アルゴリズム

## はじめに

この章では、線形探索、二分探索、ハッシュ法という 3 種類の探索アルゴリズムを C で実装します。C ではポインタと動的メモリ（`malloc/free`）を使ったデータ構造が登場します。

---

## 1. 線形探索

配列を先頭から順に調べます。

### Red — 失敗するテストを書く

```c
void test_ssearch(void) {
    int a[] = {1, 3, 5, 7, 9};
    ASSERT_EQ_INT(2,  ssearch_while(a, 5, 5));  /* index=2 */
    ASSERT_EQ_INT(-1, ssearch_while(a, 5, 4));  /* 未発見 */
    ASSERT_EQ_INT(2,  ssearch_sentinel(a, 5, 5));
}
```

### Green — while 版

```c
int ssearch_while(const int *a, int n, int key) {
    int i = 0;
    while (i < n) {
        if (a[i] == key) return i;
        i++;
    }
    return -1;
}
```

### Green — 番兵版

```c
int ssearch_sentinel(const int *a, int n, int key) {
    int *tmp = (int *)malloc((size_t)(n + 1) * sizeof(int));
    memcpy(tmp, a, (size_t)n * sizeof(int));
    tmp[n] = key;  /* 番兵 */
    int i = 0;
    while (tmp[i] != key) i++;
    free(tmp);
    return (i < n) ? i : -1;
}
```

番兵（sentinel）を配列末尾に置くことで、ループ内の `i < n` という条件チェックを省略できます。毎回の条件チェックが減るため、大きな配列では高速化が期待できます。

---

## 2. 二分探索

ソート済み配列を対象に、中央値との比較で探索範囲を半分ずつ絞り込みます。

### Red — 失敗するテストを書く

```c
void test_bsearch_int(void) {
    int a[] = {1, 3, 5, 7, 9, 11};
    ASSERT_EQ_INT(2,  bsearch_int(a, 6, 5));
    ASSERT_EQ_INT(-1, bsearch_int(a, 6, 4));
}
```

### Green — テストを通す実装

```c
int bsearch_int(const int *a, int n, int key) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (a[mid] == key) return mid;
        else if (a[mid] < key) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}
```

`mid = lo + (hi - lo) / 2` は `(lo + hi) / 2` の整数オーバーフローを防ぐ書き方です。

| アルゴリズム | 計算量 | 前提条件 |
|------------|--------|---------|
| 線形探索 | O(n) | なし |
| 二分探索 | O(log n) | ソート済み |

---

## 3. ハッシュ法

ハッシュ関数でキーをインデックスに変換し、O(1) に近い探索を実現します。

### チェイン法（チェイニング）

衝突をリスト（連鎖）で解決します。

```c
typedef struct _BucketNode {
    int key;
    struct _BucketNode *next;
} BucketNode;

typedef struct {
    int capacity;
    BucketNode **table;  /* ポインタの配列 */
} ChainedHash;
```

### Red — 失敗するテストを書く

```c
void test_chained_hash(void) {
    ChainedHash *h = chained_hash_new(13);
    ASSERT_EQ_INT(0, chained_hash_add(h, 1));
    ASSERT_EQ_INT(0, chained_hash_add(h, 14)); /* 1 % 13 == 14 % 13 → 衝突 */
    ASSERT_TRUE(chained_hash_search(h, 1));
    ASSERT_TRUE(chained_hash_search(h, 14));
    ASSERT_FALSE(chained_hash_search(h, 99));
    chained_hash_free(h);
}
```

### Green — add / search

```c
int chained_hash_add(ChainedHash *h, int key) {
    int idx = ((key % h->capacity) + h->capacity) % h->capacity;
    BucketNode *ptr = h->table[idx];
    while (ptr) {
        if (ptr->key == key) return 1;  /* 重複 */
        ptr = ptr->next;
    }
    BucketNode *node = malloc(sizeof(BucketNode));
    node->key = key;
    node->next = h->table[idx];
    h->table[idx] = node;
    return 0;
}

int chained_hash_search(const ChainedHash *h, int key) {
    int idx = ((key % h->capacity) + h->capacity) % h->capacity;
    for (BucketNode *p = h->table[idx]; p; p = p->next)
        if (p->key == key) return 1;
    return 0;
}
```

### オープンアドレス法

衝突時に次の空きスロットへ線形探索（再ハッシュ）します。

```c
typedef enum { EMPTY, OCCUPIED, DELETED } BucketStatus;

typedef struct {
    int capacity;
    int *keys;
    BucketStatus *status;
} OpenHash;
```

```c
int open_hash_add(OpenHash *h, int key) {
    int hash = ((key % h->capacity) + h->capacity) % h->capacity;
    for (int i = 0; i < h->capacity; i++) {
        int idx = (hash + i) % h->capacity;
        if (h->status[idx] == EMPTY || h->status[idx] == DELETED) {
            h->keys[idx] = key;
            h->status[idx] = OCCUPIED;
            return 0;
        }
        if (h->status[idx] == OCCUPIED && h->keys[idx] == key) return 1;
    }
    return -1;  /* 満杯 */
}
```

| 手法 | 衝突解決 | メモリ | キャッシュ効率 |
|------|---------|--------|-------------|
| チェイン法 | 連結リスト | 動的 | 低 |
| オープンアドレス法 | 線形探索 | 固定 | 高 |

---

## テスト実行結果

```bash
$ make test-chapter03/search
=== Testing chapter03/search ===
22 tests run: 22 passed, 0 failed
```

---

## まとめ

C でのハッシュ実装のポイント：

- `malloc/free` で動的メモリを管理する
- `calloc` で初期化済みメモリを確保する（`calloc(n, sizeof(T))` = `malloc(n*sizeof(T))` + ゼロ初期化）
- 負のキーへのモジュロ演算は `((key % cap) + cap) % cap` で正の余りを保証する

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
