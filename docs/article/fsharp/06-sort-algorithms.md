# 第 6 章 ソートアルゴリズム

## はじめに

この章では 8 種類のソートアルゴリズムを F# で実装します。配列の in-place ソートには `mutable` 変数を使います。

---

## 1. バブルソート

隣接要素を比較して交換し、最大値を末尾へ「浮かび上がらせる」アルゴリズムです。

```fsharp
/// バブルソート（スワップがなければ早期終了）
let bubbleSort (a: int[]) =
    let n = a.Length
    let mutable i = 0
    while i < n - 1 do
        let mutable swapped = false
        let mutable j = n - 1
        while j > i do
            if a.[j-1] > a.[j] then
                let tmp = a.[j-1]
                a.[j-1] <- a.[j]
                a.[j] <- tmp
                swapped <- true
            j <- j - 1
        if not swapped then i <- n  // 早期終了
        else i <- i + 1
```

---

## 2. 選択ソート・挿入ソート

```fsharp
/// 選択ソート（最小値を選んで先頭と交換）
let selectionSort (a: int[]) =
    let n = a.Length
    for i in 0..n-2 do
        let mutable minIdx = i
        for j in i+1..n-1 do
            if a.[j] < a.[minIdx] then minIdx <- j
        if minIdx <> i then
            let tmp = a.[i]
            a.[i] <- a.[minIdx]
            a.[minIdx] <- tmp

/// 挿入ソート（整列済み部分に適切な位置を挿入）
let insertionSort (a: int[]) =
    let n = a.Length
    for i in 1..n-1 do
        let key = a.[i]
        let mutable j = i - 1
        while j >= 0 && a.[j] > key do
            a.[j+1] <- a.[j]
            j <- j - 1
        a.[j+1] <- key
```

---

## 3. クイックソート（再帰版）

```fsharp
/// クイックソート（再帰）
let quickSort (a: int[]) =
    let rec sort left right =
        if left < right then
            let pivot = a.[(left + right) / 2]
            let mutable i = left
            let mutable j = right
            while i <= j do
                while a.[i] < pivot do i <- i + 1
                while a.[j] > pivot do j <- j - 1
                if i <= j then
                    let tmp = a.[i]
                    a.[i] <- a.[j]
                    a.[j] <- tmp
                    i <- i + 1
                    j <- j - 1
            sort left j
            sort i right
    if a.Length > 1 then sort 0 (a.Length - 1)
```

`let rec sort` は局所再帰関数です。

---

## 4. マージソート

```fsharp
/// ソート済み配列のマージ
let mergeSortedArrays (a: int[]) (b: int[]) =
    // ... 2 つのソート済み配列をマージして返す

/// マージソート（再帰）
let rec mergeSort (a: int[]) =
    if a.Length <= 1 then Array.copy a
    else
        let mid = a.Length / 2
        let left = mergeSort a.[..mid-1]
        let right = mergeSort a.[mid..]
        mergeSortedArrays left right
```

`a.[..mid-1]` と `a.[mid..]` は F# のスライス構文です。

---

## 5. ヒープソート・度数ソート

```fsharp
/// ヒープソート（最大ヒープを利用）
let heapSort (a: int[]) = ...

/// 度数ソート（カウンティングソート）
let countingSort (a: int[]) = ...
```

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 52、スキップ: 0、合計: 52
```

## ソートアルゴリズムの比較

| アルゴリズム | 平均 | 最悪 | 安定性 |
|-------------|------|------|--------|
| バブルソート | O(n²) | O(n²) | 安定 |
| 選択ソート | O(n²) | O(n²) | 不安定 |
| 挿入ソート | O(n²) | O(n²) | 安定 |
| シェルソート | O(n^1.5) | O(n²) | 不安定 |
| クイックソート | O(n log n) | O(n²) | 不安定 |
| マージソート | O(n log n) | O(n log n) | 安定 |
| ヒープソート | O(n log n) | O(n log n) | 不安定 |
| 度数ソート | O(n+k) | O(n+k) | 安定 |
