# 第 6 章 ソートアルゴリズム

## はじめに

この章では 8 種類のソートアルゴリズムを Scala で実装します。in-place ソートは `Array[Int]` を更新し、非 in-place ソートは新しい配列を返します。

## ソートとは

ソートとは、データを一定の順序（昇順・降順）に並べ替える操作です。

| アルゴリズム | 平均計算量 | 最悪計算量 | 安定 | in-place |
|-------------|-----------|-----------|------|----------|
| バブルソート | O(n²) | O(n²) | ✓ | ✓ |
| 選択ソート | O(n²) | O(n²) | ✗ | ✓ |
| 挿入ソート | O(n²) | O(n²) | ✓ | ✓ |
| シェルソート | O(n log n) | O(n²) | ✗ | ✓ |
| クイックソート | O(n log n) | O(n²) | ✗ | ✓ |
| マージソート | O(n log n) | O(n log n) | ✓ | ✗ |
| ヒープソート | O(n log n) | O(n log n) | ✗ | ✓ |
| 度数ソート | O(n+k) | O(n+k) | ✓ | ✗ |

---

## 1. バブルソート

```scala
def bubbleSort(a: Array[Int]): Unit =
  val n = a.length
  var i = 0
  while i < n - 1 do
    var swapped = false
    var j = n - 1
    while j > i do
      if a(j - 1) > a(j) then
        val tmp = a(j - 1); a(j - 1) = a(j); a(j) = tmp
        swapped = true
      j -= 1
    if !swapped then i = n  // 早期終了
    i += 1
```

---

## 2. クイックソート

```scala
def quickSort(a: Array[Int], left: Int, right: Int): Unit =
  if left < right then
    val pivot = a((left + right) / 2)
    var i = left; var j = right
    while i <= j do
      while a(i) < pivot do i += 1
      while a(j) > pivot do j -= 1
      if i <= j then
        val tmp = a(i); a(i) = a(j); a(j) = tmp
        i += 1; j -= 1
    quickSort(a, left, j)
    quickSort(a, i, right)
```

---

## 3. マージソート

```scala
def mergeSort(a: Array[Int]): Array[Int] =
  if a.length <= 1 then a.clone()
  else
    val mid   = a.length / 2
    val left  = mergeSort(a.slice(0, mid))
    val right = mergeSort(a.slice(mid, a.length))
    merge(left, right)
```

---

## テスト実行結果

```
Tests: succeeded 11, failed 0
```

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
