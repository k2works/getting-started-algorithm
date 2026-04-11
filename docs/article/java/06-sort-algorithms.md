# 第 6 章 ソートアルゴリズム

## はじめに

この章では 8 種類のソートアルゴリズムを TDD で実装します。

---

## ソートアルゴリズム一覧

| アルゴリズム | 計算量（平均） | 計算量（最悪） | 安定 | in-place |
|-------------|---------------|---------------|------|----------|
| バブルソート | $O(n^2)$ | $O(n^2)$ | Yes | Yes |
| 選択ソート | $O(n^2)$ | $O(n^2)$ | No | Yes |
| 挿入ソート | $O(n^2)$ | $O(n^2)$ | Yes | Yes |
| シェルソート | $O(n^{3/2})$ | $O(n^{3/2})$ | No | Yes |
| クイックソート | $O(n \log n)$ | $O(n^2)$ | No | Yes |
| マージソート | $O(n \log n)$ | $O(n \log n)$ | Yes | No |
| ヒープソート | $O(n \log n)$ | $O(n \log n)$ | No | Yes |
| 度数ソート | $O(n + k)$ | $O(n + k)$ | Yes | No |

---

## 実装例: バブルソート

```java
public static void bubbleSort(int[] a) {
    int n = a.length;
    for (int i = 0; i < n - 1; i++) {
        boolean swapped = false;
        for (int j = n - 1; j > i; j--) {
            if (a[j - 1] > a[j]) {
                int tmp = a[j - 1]; a[j - 1] = a[j]; a[j] = tmp;
                swapped = true;
            }
        }
        if (!swapped) break;
    }
}
```

---

## 実装例: クイックソート

```java
public static void quickSort(int[] a, int left, int right) {
    if (left >= right) return;
    int pivot = a[(left + right) / 2];
    int i = left, j = right;
    while (i <= j) {
        while (a[i] < pivot) i++;
        while (a[j] > pivot) j--;
        if (i <= j) {
            int tmp = a[i]; a[i] = a[j]; a[j] = tmp;
            i++; j--;
        }
    }
    quickSort(a, left, j);
    quickSort(a, i, right);
}
```

---

## テスト実行結果

```
SortTest > BubbleSortTest > 基本() PASSED
SortTest > SelectionSortTest > 基本() PASSED
SortTest > InsertionSortTest > 基本() PASSED
SortTest > ShellSortTest > 基本() PASSED
SortTest > QuickSortTest > 基本() PASSED
SortTest > MergeSortTest > 基本() PASSED
SortTest > HeapSortTest > 基本() PASSED
SortTest > CountingSortTest > 基本() PASSED
```
