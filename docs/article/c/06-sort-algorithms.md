# 第 6 章 ソートアルゴリズム

## はじめに

ソートは配列の要素を順序付けする基本的な操作です。この章では 8 種類のソートアルゴリズムを C で実装し、それぞれの特性を比較します。

---

## テストの共通パターン

```c
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
```

---

## 1. バブルソート

隣接する要素を比較・交換して整列します。

```c
void bubble_sort(int *a, int n) {
    for (int i = 0; i < n - 1; i++) {
        int swapped = 0;
        for (int j = n - 1; j > i; j--) {
            if (a[j - 1] > a[j]) { swap(&a[j-1], &a[j]); swapped = 1; }
        }
        if (!swapped) break;  /* 交換なし → 整列済み */
    }
}
```

`swapped` フラグで早期終了を実現します。

---

## 2. 選択ソート

各パスで最小値を探して先頭と交換します。

```c
void selection_sort(int *a, int n) {
    for (int i = 0; i < n - 1; i++) {
        int min = i;
        for (int j = i + 1; j < n; j++) if (a[j] < a[min]) min = j;
        if (min != i) swap(&a[i], &a[min]);
    }
}
```

---

## 3. 挿入ソート

未整列部分の先頭要素を整列済み部分の正しい位置に挿入します。

```c
void insertion_sort(int *a, int n) {
    for (int i = 1; i < n; i++) {
        int key = a[i], j = i - 1;
        while (j >= 0 && a[j] > key) { a[j+1] = a[j]; j--; }
        a[j+1] = key;
    }
}
```

データがほぼ整列済みの場合に効率的です。

---

## 4. シェルソート

挿入ソートの改良版。間隔（gap）を徐々に縮めながら整列します。

```c
void shell_sort(int *a, int n) {
    int h = 1;
    while (h < n / 9) h = h * 3 + 1;  /* Knuth 数列: 1, 4, 13, 40, ... */
    for (; h > 0; h /= 3) {
        for (int i = h; i < n; i++) {
            int key = a[i], j = i - h;
            while (j >= 0 && a[j] > key) { a[j+h] = a[j]; j -= h; }
            a[j+h] = key;
        }
    }
}
```

Knuth 数列（`h = 3h + 1`）は実用的な gap 選択として広く使われます。

---

## 5. クイックソート

ピボットで配列を分割して再帰的に整列します。

```c
void quick_sort(int *a, int left, int right) {
    if (left >= right) return;
    int pivot = a[(left + right) / 2];
    int i = left, j = right;
    while (i <= j) {
        while (a[i] < pivot) i++;
        while (a[j] > pivot) j--;
        if (i <= j) { swap(&a[i], &a[j]); i++; j--; }
    }
    quick_sort(a, left, j);
    quick_sort(a, i, right);
}
```

---

## 6. マージソート

配列を半分に分割し、整列済みの 2 つの部分をマージします。

```c
static void _merge(int *a, int left, int mid, int right) {
    int n1 = mid - left, n2 = right - mid;
    int *l = malloc((size_t)n1 * sizeof(int));
    int *r = malloc((size_t)n2 * sizeof(int));
    memcpy(l, a + left, (size_t)n1 * sizeof(int));
    memcpy(r, a + mid,  (size_t)n2 * sizeof(int));
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) a[k++] = (l[i] <= r[j]) ? l[i++] : r[j++];
    while (i < n1) a[k++] = l[i++];
    while (j < n2) a[k++] = r[j++];
    free(l); free(r);
}
```

---

## 7. ヒープソート

ヒープ構造を利用して整列します。

```c
static void _down_heap(int *a, int k, int n) {
    int tmp = a[k];
    while (2*k+1 < n) {
        int child = 2*k+1;
        if (child+1 < n && a[child+1] > a[child]) child++;
        if (tmp >= a[child]) break;
        a[k] = a[child]; k = child;
    }
    a[k] = tmp;
}

void heap_sort(int *a, int n) {
    for (int i = n/2 - 1; i >= 0; i--) _down_heap(a, i, n);
    for (int i = n - 1; i > 0; i--) { swap(&a[0], &a[i]); _down_heap(a, 0, i); }
}
```

---

## 8. 度数ソート（Counting Sort）

値の出現回数を数えて整列します。O(n+k)（k は値の範囲）の線形ソートです。

```c
void counting_sort(int *a, int n, int max_val) {
    int *cnt = calloc((size_t)max_val, sizeof(int));
    int *out = malloc((size_t)n * sizeof(int));
    for (int i = 0; i < n; i++) cnt[a[i]]++;
    for (int i = 1; i < max_val; i++) cnt[i] += cnt[i-1];
    for (int i = n - 1; i >= 0; i--) out[--cnt[a[i]]] = a[i];
    memcpy(a, out, (size_t)n * sizeof(int));
    free(cnt); free(out);
}
```

逆順に処理することで安定ソートを実現します。

---

## アルゴリズム比較

| アルゴリズム | 平均 | 最悪 | 安定 | 特徴 |
|------------|------|------|------|------|
| バブル | O(n²) | O(n²) | ✓ | 早期終了可 |
| 選択 | O(n²) | O(n²) | ✗ | 交換回数が少ない |
| 挿入 | O(n²) | O(n²) | ✓ | ほぼ整列済みに強い |
| シェル | O(n^1.5) | O(n²) | ✗ | 挿入の改良 |
| クイック | O(n log n) | O(n²) | ✗ | 実用的に最速 |
| マージ | O(n log n) | O(n log n) | ✓ | 安定・追加メモリ必要 |
| ヒープ | O(n log n) | O(n log n) | ✗ | 追加メモリ不要 |
| 度数 | O(n+k) | O(n+k) | ✓ | 値の範囲が限定的な場合 |

---

## テスト実行結果

```bash
$ make test-chapter06/sort
=== Testing chapter06/sort ===
51 tests run: 51 passed, 0 failed
```

---

## まとめ

C でのソート実装の特徴：

- 配列はポインタとして渡すため、in-place でソートできる
- `static void swap(int *a, int *b)` を内部ヘルパーとして定義する
- マージソートは一時バッファに `malloc` が必要（`memcpy` で効率的にコピー）
- 度数ソートは `calloc`（ゼロ初期化）で count 配列を確保する

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
