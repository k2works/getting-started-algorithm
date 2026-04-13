# 第 6 章 ソートアルゴリズム

## はじめに

この章では 8 種類のソートアルゴリズムを F# で実装します。配列の in-place ソートには `mutable` 変数を使います。

## ソートとは

ソートとは、データの集合を特定の順序（昇順・降順など）に並べ替える操作です。ソートアルゴリズムの評価には以下の観点が重要です：

- **安定性（stability）**: 同じキーを持つ要素の相対的な順序がソート後も保たれるかどうか。安定なソートは、複数のキーで段階的にソートする場合に重要。
- **適応性（adaptivity）**: すでに部分的にソートされたデータに対して、効率が向上するかどうか。
- **in-place**: 追加のメモリ（配列のコピーなど）をほとんど使わずにソートできるかどうか。

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

## 2-1. シェーカーソート（双方向バブルソート）

バブルソートを改良し、左右交互に走査することで「亀」問題（小さい値が先頭に移動しにくい問題）を解消します。

```fsharp
/// シェーカーソート（双方向バブルソート）
let shakerSort (a: int[]) =
    let n = a.Length
    let mutable left = 0
    let mutable right = n - 1
    let mutable last = right
    while left < right do
        // 右方向のスキャン
        let mutable j = right
        while j > left do
            if a.[j-1] > a.[j] then
                let tmp = a.[j-1]; a.[j-1] <- a.[j]; a.[j] <- tmp
                last <- j
            j <- j - 1
        left <- last
        // 左方向のスキャン
        j <- left
        while j < right do
            if a.[j] > a.[j+1] then
                let tmp = a.[j]; a.[j] <- a.[j+1]; a.[j+1] <- tmp
                last <- j
            j <- j + 1
        right <- last
```

---

## 2-2. 二分挿入ソート

挿入ソートの挿入位置を二分探索で決定することで、比較回数を O(n log n) に削減します（移動回数は変わらないため、全体の計算量は O(n^2) のまま）。

```fsharp
/// 二分挿入ソート
let binaryInsertionSort (a: int[]) =
    let n = a.Length
    for i in 1..n-1 do
        let key = a.[i]
        let mutable lo = 0
        let mutable hi = i
        while lo < hi do
            let mid = (lo + hi) / 2
            if a.[mid] > key then hi <- mid
            else lo <- mid + 1
        for j in i-1 .. -1 .. lo do
            a.[j+1] <- a.[j]
        a.[lo] <- key
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

## 3-1. クイックソート（非再帰版）

スタックを使って再帰を除去したクイックソートです。再帰が深くなりすぎてスタックオーバーフローが発生するリスクを回避できます。

```fsharp
/// クイックソート（非再帰、スタック使用）
let quickSortNonRecursive (a: int[]) =
    if a.Length > 1 then
        let stack = System.Collections.Generic.Stack<int * int>()
        stack.Push(0, a.Length - 1)
        while stack.Count > 0 do
            let left, right = stack.Pop()
            let pivot = a.[(left + right) / 2]
            let mutable i = left
            let mutable j = right
            while i <= j do
                while a.[i] < pivot do i <- i + 1
                while a.[j] > pivot do j <- j - 1
                if i <= j then
                    let tmp = a.[i]; a.[i] <- a.[j]; a.[j] <- tmp
                    i <- i + 1; j <- j - 1
            if left < j then stack.Push(left, j)
            if i < right then stack.Push(i, right)
```

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

| アルゴリズム | 最良 | 平均 | 最悪 | 安定 | in-place | 備考 |
|-------------|------|------|------|------|----------|------|
| バブルソート | O(n) | O(n^2) | O(n^2) | Yes | Yes | 整列済み検出あり |
| シェーカーソート | O(n) | O(n^2) | O(n^2) | Yes | Yes | 双方向バブルソート |
| 選択ソート | O(n^2) | O(n^2) | O(n^2) | No | Yes | 交換回数が少ない |
| 挿入ソート | O(n) | O(n^2) | O(n^2) | Yes | Yes | 小規模データに有効 |
| 二分挿入ソート | O(n) | O(n^2) | O(n^2) | Yes | Yes | 比較回数を O(n log n) に削減 |
| シェルソート | O(n) | O(n^1.5) | O(n^2) | No | Yes | 挿入ソートの改良 |
| クイックソート | O(n log n) | O(n log n) | O(n^2) | No | Yes | 実用的に最速 |
| マージソート | O(n log n) | O(n log n) | O(n log n) | Yes | No | 追加メモリが必要 |
| ヒープソート | O(n log n) | O(n log n) | O(n log n) | No | Yes | 追加メモリ不要 |
| 度数ソート | O(n+k) | O(n+k) | O(n+k) | Yes | No | 値の範囲が限定的な場合に有効 |

## まとめ

この章では、10 種類のソートアルゴリズムを F# で実装しました：

1. **バブルソート** -- 隣接する要素を比較・交換する単純なアルゴリズム
2. **シェーカーソート** -- バブルソートの双方向改良版
3. **選択ソート** -- 未ソート部分から最小要素を選択するアルゴリズム
4. **挿入ソート** -- ソート済み部分に要素を挿入するアルゴリズム
5. **二分挿入ソート** -- 挿入位置を二分探索で決定する改良版
6. **シェルソート** -- 挿入ソートを改良したアルゴリズム
7. **クイックソート**（再帰版/非再帰版） -- 分割統治法に基づく高速なアルゴリズム
8. **マージソート** -- 分割統治法に基づく安定なアルゴリズム
9. **ヒープソート** -- ヒープデータ構造を利用するアルゴリズム
10. **度数ソート** -- 要素の値の範囲が限られている場合に効率的なアルゴリズム

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
