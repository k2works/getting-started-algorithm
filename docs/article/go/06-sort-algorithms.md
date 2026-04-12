# 第 6 章 ソートアルゴリズム

## はじめに

ソートアルゴリズムは、データを特定の順序に並べ替えるアルゴリズムです。

---

## 1. バブルソート（O(n²)）

```go
func BubbleSort(a []int) {
    n := len(a)
    for i := 0; i < n-1; i++ {
        swapped := false
        for j := n - 1; j > i; j-- {
            if a[j-1] > a[j] {
                a[j-1], a[j] = a[j], a[j-1]
                swapped = true
            }
        }
        if !swapped {
            break
        }
    }
}
```

---

## 2. 選択ソート（O(n²)）

```go
func SelectionSort(a []int) {
    n := len(a)
    for i := 0; i < n-1; i++ {
        minIdx := i
        for j := i + 1; j < n; j++ {
            if a[j] < a[minIdx] {
                minIdx = j
            }
        }
        if minIdx != i {
            a[i], a[minIdx] = a[minIdx], a[i]
        }
    }
}
```

---

## 3. 挿入ソート（O(n²)）

```go
func InsertionSort(a []int) {
    n := len(a)
    for i := 1; i < n; i++ {
        key := a[i]
        j := i - 1
        for j >= 0 && a[j] > key {
            a[j+1] = a[j]
            j--
        }
        a[j+1] = key
    }
}
```

---

## 4. クイックソート（O(n log n) 平均）

```go
func QuickSort(a []int, left, right int) {
    if left >= right {
        return
    }
    pivot := a[(left+right)/2]
    i, j := left, right
    for i <= j {
        for a[i] < pivot { i++ }
        for a[j] > pivot { j-- }
        if i <= j {
            a[i], a[j] = a[j], a[i]
            i++
            j--
        }
    }
    QuickSort(a, left, j)
    QuickSort(a, i, right)
}
```

---

## 5. マージソート（O(n log n)）

```go
func MergeSort(a []int, left, right int) {
    if left >= right {
        return
    }
    mid := (left + right) / 2
    MergeSort(a, left, mid)
    MergeSort(a, mid+1, right)
    merge(a, left, mid, right)
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| in-place ソート | `a[i], a[j] = a[j], a[i]` | `a[i], a[j] = a[j], a[i]` |
| フラグ変数 | `swapped = False` | `swapped := false` |
| 標準ソート | `a.sort()` | `sort.Ints(a)` |
