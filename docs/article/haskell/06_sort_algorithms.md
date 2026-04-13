# 第 6 章 ソートアルゴリズム（Haskell 版）

## はじめに

前章では再帰アルゴリズムを学びました。この章では、データを特定の順序に並べ替える「ソートアルゴリズム」を TDD で実装します。

Haskell のソート実装には Python 版と大きく異なる点があります：

- **純粋関数** — 入力リストを変更せず、新しいリストを返す（in-place ではない）
- **パターンマッチング** — 基底ケースと再帰ケースを自然に表現
- **高階関数** — `filter`、`foldr`、`partition` などを活用
- **`Data.Array`** — インデックスベースのアルゴリズムには不変配列を使う

### 目次

1. [ソートとは（Haskell における考え方）](#ソートとは-haskell-における考え方)
2. [バブルソート](#1-バブルソート)
3. [選択ソート](#2-選択ソート)
4. [挿入ソート](#3-挿入ソート)
5. [シェルソート](#4-シェルソート)
6. [クイックソート](#5-クイックソート)
7. [マージソート](#6-マージソート)
8. [ヒープソート](#7-ヒープソート)
9. [度数ソート](#8-度数ソート)
10. [Python 版との比較](#python-版との比較)
11. [ソートアルゴリズムの比較表](#ソートアルゴリズムの比較表)

---

## ソートとは（Haskell における考え方）

ソートとは、データを特定の順序（通常は昇順または降順）に並べ替える操作です。

**Python 版との大きな違い**：Python 版では `list` を in-place で変更する（`def bubble_sort(a: list) -> None`）のが一般的ですが、Haskell では**新しいリストを返す純粋関数**として実装します。

```haskell
-- Haskell のソート関数シグネチャ
bubbleSort   :: Ord a => [a] -> [a]  -- 入力リストを変更せず、ソート済みリストを返す
quickSort    :: Ord a => [a] -> [a]
mergeSort    :: Ord a => [a] -> [a]
```

`Ord a =>` は**型クラス制約**であり、「比較可能な任意の型 `a` に対して使える」ことを表します。Int、Double、String など全ての `Ord` インスタンスに対して動作します。

---

## 1. バブルソート

隣接する要素を比較・交換し、最大値を末尾へ「浮き上がらせる」アルゴリズムです。

### Red — 失敗するテストを書く

```haskell
-- test/SortAlgorithmsSpec.hs
module SortAlgorithmsSpec (spec) where

import Test.Hspec
import SortAlgorithms

spec :: Spec
spec = do
  describe "SortAlgorithms" $ do
    let unsorted = [5, 3, 8, 1, 9, 2, 7, 4, 6] :: [Int]
    let sorted   = [1, 2, 3, 4, 5, 6, 7, 8, 9] :: [Int]

    describe "bubbleSort" $ do
      it "バブルソートでソートする" $ do
        bubbleSort unsorted `shouldBe` sorted
        bubbleSort ([] :: [Int]) `shouldBe` []
        bubbleSort [1] `shouldBe` [1]
```

### Green — テストを通す実装

```haskell
-- src/SortAlgorithms.hs
-- | バブルソート（純粋関数版）
bubbleSort :: Ord a => [a] -> [a]
bubbleSort [] = []
bubbleSort xs = iterate bubble xs !! (length xs - 1)
  where
    bubble []       = []
    bubble [y]      = [y]
    bubble (y:z:ys)
      | y > z     = z : bubble (y:ys)  -- 交換
      | otherwise = y : bubble (z:ys)  -- そのまま
```

### 実装の解説

`iterate bubble xs` は `[xs, bubble xs, bubble (bubble xs), ...]` という無限リストを生成します。`!! (length xs - 1)` で n-1 回のパスを適用した結果を取り出しています。

```
xs = [3, 1, 2]

1回目の bubble:
  bubble [3,1,2]
  → 3 > 1 なので交換: 1 : bubble [3,2]
  → 3 > 2 なので交換: 2 : bubble [3] = [2, 3]
  結果: [1, 2, 3]   ← すでにソート済み

iterate bubble [3,1,2] = [[3,1,2], [1,2,3], [1,2,3], ...]
!! 2 (length 3 - 1) = [1,2,3]
```

**計算量**: O(n²)（常に n-1 回のパスを実行）

### Python 版との比較

| 観点 | Python 版 | Haskell 版 |
|------|-----------|------------|
| 戻り値 | `None`（in-place） | ソート済みリスト |
| 最適化 | 交換なしで早期終了 | 常に n-1 回パス |
| メモリ | O(1) 追加メモリ | O(n) 新リスト |

---

## 2. 選択ソート

未整列部分の最小値を探し、先頭と交換するアルゴリズムです。

### Red — 失敗するテストを書く

```haskell
describe "selectionSort" $ do
  it "選択ソートでソートする" $ do
    selectionSort unsorted `shouldBe` sorted
```

### Green — テストを通す実装

```haskell
-- | 選択ソート（純粋関数版）
selectionSort :: Ord a => [a] -> [a]
selectionSort [] = []
selectionSort xs =
  let m    = minimum xs        -- 最小値を探す
      rest = deleteFirst m xs  -- 最小値を除いたリスト
  in m : selectionSort rest    -- 先頭に配置して再帰

  where
    deleteFirst _ []     = []
    deleteFirst v (y:ys)
      | v == y    = ys           -- 最初に見つかった要素を削除
      | otherwise = y : deleteFirst v ys
```

### 実装の解説

```
selectionSort [3, 1, 2]

1回目: minimum = 1, rest = [3, 2]
  → 1 : selectionSort [3, 2]
    2回目: minimum = 2, rest = [3]
      → 2 : selectionSort [3]
        3回目: minimum = 3, rest = []
          → 3 : selectionSort []
            = 3 : [] = [3]
          = [2, 3]
        = [1, 2, 3]
```

**計算量**: O(n²)（常に比較回数は n*(n-1)/2）

### Python 版との比較

Python 版では配列のインデックス操作でスワップを行いますが、Haskell 版では `minimum` と `deleteFirst` を使ってより宣言的に実装しています。

---

## 3. 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入するアルゴリズムです。

### Red — 失敗するテストを書く

```haskell
describe "insertionSort" $ do
  it "挿入ソートでソートする" $ do
    insertionSort unsorted `shouldBe` sorted
```

### Green — テストを通す実装

```haskell
-- | 挿入ソート（foldr を使ったエレガントな実装）
insertionSort :: Ord a => [a] -> [a]
insertionSort = foldr insert' []
  where
    insert' x []     = [x]       -- リストが空なら x だけのリスト
    insert' x (y:ys)
      | x <= y    = x : y : ys  -- x が y 以下なら x を先に挿入
      | otherwise = y : insert' x ys  -- y を先に置いて残りに x を挿入
```

### `foldr` を使った実装の解説

`foldr insert' [] xs` は右畳み込みで、各要素をソート済みリストに挿入します：

```
insertionSort [3, 1, 2]
= foldr insert' [] [3, 1, 2]
= insert' 3 (insert' 1 (insert' 2 []))
= insert' 3 (insert' 1 [2])
= insert' 3 [1, 2]
= [1, 2, 3]
```

`foldr` を使うことで、明示的な再帰を隠蔽しつつ簡潔に実装できます。

**計算量**: 最悪 O(n²)、最良 O(n)

---

## 4. シェルソート

挿入ソートの改良版。間隔（gap）を縮小しながら複数回の挿入ソートを行います。

### Red — 失敗するテストを書く

```haskell
describe "shellSort" $ do
  it "シェルソートでソートする" $ do
    shellSort unsorted `shouldBe` sorted
```

### Green — テストを通す実装

```haskell
-- | シェルソート（配列ベースで正確に実装）
shellSort :: Ord a => [a] -> [a]
shellSort [] = []
shellSort xs = elems $ foldl passGap arr gaps
  where
    n    = length xs
    arr  = listArray (0, n - 1) xs       -- IArray に変換
    gaps = takeWhile (> 0) $ iterate (`div` 2) (n `div` 2)  -- n/2, n/4, ...

    passGap a h = foldl (insertAt h) a [h .. n - 1]

    insertAt h a i =
      let val = a ! i
          go j acc
            | j >= h && acc ! (j - h) > val =
                go (j - h) (acc // [(j, acc ! (j - h))])
            | otherwise = acc // [(j, val)]
      in go i a
```

### `Data.Array` の活用

シェルソートはインデックスアクセスが必要なため、Haskell の不変配列（`Data.Array`）を使います：

```haskell
import Data.Array (listArray, (!), (//), elems)

-- リストを配列に変換
arr = listArray (0, n - 1) xs  -- インデックス 0〜n-1 の配列

-- 要素へのアクセス（O(1)）
arr ! i  -- i 番目の要素

-- 配列の更新（新しい配列を作成）
arr // [(i, val)]  -- i 番目を val に変更した新しい配列

-- 配列をリストに変換
elems arr  -- 全要素のリスト
```

**重要**: `Data.Array` は**不変配列（immutable array）**です。`//` は更新された新しい配列を返します。

### gaps 数列の生成

```haskell
gaps = takeWhile (> 0) $ iterate (`div` 2) (n `div` 2)
-- n=8: [4, 2, 1]
-- n=9: [4, 2, 1]
-- n=16: [8, 4, 2, 1]
```

`iterate f x` は `[x, f x, f (f x), ...]` という無限リストを生成し、`takeWhile (> 0)` で正の値だけを取り出します。

**計算量**: O(n^(3/2)) ～ O(n log² n)（gap 数列に依存）

---

## 5. クイックソート

ピボットを基準に配列を 2 分割し、再帰的にソートします。Haskell において最も「らしい」実装が可能なアルゴリズムです。

### Red — 失敗するテストを書く

```haskell
describe "quickSort" $ do
  it "クイックソートでソートする" $ do
    quickSort unsorted `shouldBe` sorted
    quickSort ([] :: [Int]) `shouldBe` []
```

### Green — テストを通す実装

```haskell
-- | クイックソート（最も Haskell らしい実装）
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  let (smaller, larger) = partition (<= x) xs
  in quickSort smaller ++ [x] ++ quickSort larger
```

### Haskell クイックソートの美しさ

これはおそらく Haskell の最も有名なコード例の一つです：

```haskell
quickSort [] = []
quickSort (x:xs) =
  let (smaller, larger) = partition (<= x) xs
  in quickSort smaller ++ [x] ++ quickSort larger
```

- `(x:xs)` — パターンマッチングでピボット `x` と残り `xs` に分解
- `partition (<= x) xs` — `xs` を「x 以下」と「x より大きい」に分割
- `++` — リスト連結で結果を合成

この 4 行がクイックソートの本質を完全に表現しています。

### `partition` 関数の活用

```haskell
-- Data.List の partition
partition :: (a -> Bool) -> [a] -> ([a], [a])

-- 使用例
partition (<= 5) [3, 7, 1, 9, 2, 8]
-- => ([3, 1, 2], [7, 9, 8])
```

Python 版では左右カーソルを使った複雑な in-place 分割が必要でしたが、Haskell では `partition` で一行で実現できます。

### アルゴリズムの展開

```
quickSort [3, 1, 2]

ピボット = 3, 残り = [1, 2]
partition (<= 3) [1, 2] = ([1, 2], [])

quickSort [1, 2] ++ [3] ++ quickSort []

  ピボット = 1, 残り = [2]
  partition (<= 1) [2] = ([], [2])
  quickSort [] ++ [1] ++ quickSort [2]
  = [] ++ [1] ++ [2] = [1, 2]

= [1, 2] ++ [3] ++ [] = [1, 2, 3]
```

**計算量**: 平均 O(n log n)、最悪 O(n²)

### 実用的な改善

この実装はピボット選択が常に先頭要素なので、ソート済み入力で最悪ケースになります。実用的には中央値を使うなどの工夫が必要です：

```haskell
-- メジアン・オブ・スリーによるピボット選択
quickSortImproved :: Ord a => [a] -> [a]
quickSortImproved [] = []
quickSortImproved [x] = [x]
quickSortImproved xs =
  let pivot = median3 (head xs) (xs !! (length xs `div` 2)) (last xs)
      (smaller, rest) = partition (< pivot) xs
      (equal, larger) = partition (== pivot) rest
  in quickSortImproved smaller ++ equal ++ quickSortImproved larger
  where
    median3 a b c
      | (a <= b && b <= c) || (c <= b && b <= a) = b
      | (b <= a && a <= c) || (c <= a && a <= b) = a
      | otherwise = c
```

---

## 6. マージソート

配列を半分に分割し、再帰的にソートして結合します。

### Red — 失敗するテストを書く

```haskell
describe "mergeSort" $ do
  it "マージソートでソートする" $ do
    mergeSort unsorted `shouldBe` sorted
    mergeSort ([] :: [Int]) `shouldBe` []
```

### Green — テストを通す実装

```haskell
-- | マージソート（分割統治）
mergeSort :: Ord a => [a] -> [a]
mergeSort []  = []
mergeSort [x] = [x]
mergeSort xs  =
  let (l, r) = splitAt (length xs `div` 2) xs
  in merge (mergeSort l) (mergeSort r)
  where
    merge [] ys         = ys
    merge xs []         = xs
    merge (a:as) (b:bs)
      | a <= b    = a : merge as (b:bs)
      | otherwise = b : merge (a:as) bs
```

### 実装の解説

```
mergeSort [5, 3, 8, 1]

分割: [5, 3] と [8, 1]

mergeSort [5, 3]:
  分割: [5] と [3]
  mergeSort [5] = [5]
  mergeSort [3] = [3]
  merge [5] [3] = [3, 5]

mergeSort [8, 1]:
  分割: [8] と [1]
  mergeSort [8] = [8]
  mergeSort [1] = [1]
  merge [8] [1] = [1, 8]

merge [3, 5] [1, 8]:
  1 < 3: 1 : merge [3,5] [8]
  3 < 8: 3 : merge [5] [8]
  5 < 8: 5 : merge [] [8]
  = 5 : [8] = [5, 8]
  = 3 : [5, 8] = [3, 5, 8]
  = [1, 3, 5, 8]
```

`merge` 関数はパターンマッチングで 3 つのケースを処理します：

| パターン | 動作 |
|---------|------|
| `merge [] ys` | 左が空 → 右をそのまま返す |
| `merge xs []` | 右が空 → 左をそのまま返す |
| `merge (a:as) (b:bs)` | 先頭を比較して小さい方を選択 |

**計算量**: 常に O(n log n)

---

## 7. ヒープソート

ヒープデータ構造を利用したソートアルゴリズムです。

### Red — 失敗するテストを書く

```haskell
describe "heapSort" $ do
  it "ヒープソートでソートする" $ do
    heapSort unsorted `shouldBe` sorted
```

### Green — テストを通す実装

```haskell
-- | ヒープソート（配列ベース）
heapSort :: Ord a => [a] -> [a]
heapSort [] = []
heapSort xs = elems $ extractAll (buildMaxHeap arr) n
  where
    n   = length xs
    arr = listArray (0, n - 1) xs

    -- 配列の i, j を入れ替えた新しい配列を返す
    swap i j a = a // [(i, a ! j), (j, a ! i)]

    -- i を根とするサブツリーをヒープ化（downHeap）
    heapify a i sz =
      let l = 2 * i + 1               -- 左の子のインデックス
          r = 2 * i + 2               -- 右の子のインデックス
          cands   = filter (< sz) [l, r]
          largest = foldl (\m j -> if a ! j > a ! m then j else m) i cands
      in if largest /= i
         then heapify (swap i largest a) largest sz
         else a

    -- 配列全体を最大ヒープに変換
    buildMaxHeap a =
      foldl (\acc i -> heapify acc i n) a [n `div` 2 - 1, n `div` 2 - 2 .. 0]

    -- ヒープから要素を順に取り出す
    extractAll a 0  = a
    extractAll a sz =
      let a' = swap 0 (sz - 1) a      -- 根と末尾を交換
      in extractAll (heapify a' 0 (sz - 1)) (sz - 1)
```

### ヒープの概念

最大ヒープ（Max-Heap）は以下の性質を持つ完全二分木です：

```
     9
    / \
   7   8
  / \ / \
 5  6 3  4
```

- 親ノードは子ノード以上の値を持つ
- 配列でインデックス i の左の子は `2*i+1`、右の子は `2*i+2`

ヒープソートの手順：

1. **buildMaxHeap** — 配列を最大ヒープに変換（O(n)）
2. **extractAll** — 根（最大値）を末尾と交換 → heapify → 繰り返す（O(n log n)）

### `swap` と `//` の動作

```haskell
-- a の i 番目と j 番目を交換した新しい配列を返す
swap i j a = a // [(i, a ! j), (j, a ! i)]

-- 例:
let arr = listArray (0,4) [3,1,4,1,5]
swap 0 4 arr
-- => array (0,4) [(0,5),(1,1),(2,4),(3,1),(4,3)]
```

**注意**: Haskell の `Data.Array` は不変なので、`//` は新しい配列を生成します。これは Python の in-place 操作とは異なりますが、参照透明性を保つ Haskell の設計思想に従っています。

**計算量**: 常に O(n log n)

---

## 8. 度数ソート

度数ソート（カウンティングソート）は、要素の値の範囲が限られている場合に効率的なソートアルゴリズムです。

### Red — 失敗するテストを書く

```haskell
describe "countingSort" $ do
  it "度数ソートでソートする" $ do
    countingSort 10 [5, 3, 8, 1, 9, 2, 7, 4, 6] `shouldBe` sorted
    countingSort 5 [4, 2, 3, 1, 0] `shouldBe` [0, 1, 2, 3, 4]
```

### Green — テストを通す実装

```haskell
-- | 度数ソート（0 以上 k 未満の整数のみ）
countingSort :: Int -> [Int] -> [Int]
countingSort k xs =
  let count = map (\i -> length (filter (== i) xs)) [0..k-1]
  in concatMap (\(i, c) -> replicate c i) (zip [0..] count)
```

### 実装の解説

```haskell
countingSort 5 [3, 1, 2, 1, 3]

-- 各値の出現回数をカウント
count = map (\i -> length (filter (== i) [3,1,2,1,3])) [0..4]
      = [0, 2, 1, 2, 0]
--       ^  ^  ^  ^  ^
--       0  1  2  3  4 のそれぞれの出現回数

-- zip [0..] count = [(0,0), (1,2), (2,1), (3,2), (4,0)]

-- concatMap: 各 (値, 回数) について replicate 回数 値 を生成
-- replicate 0 0 = []
-- replicate 2 1 = [1, 1]
-- replicate 1 2 = [2]
-- replicate 2 3 = [3, 3]
-- replicate 0 4 = []

-- 結果: [1, 1, 2, 3, 3]
```

### 高階関数の活用

この実装は Haskell の高階関数を最大限に活用しています：

| 関数 | 役割 |
|------|------|
| `map` | 各値の出現回数を計算 |
| `filter` | 特定の値のみを抽出 |
| `length` | リストの長さ（= 出現回数）を取得 |
| `zip` | インデックスと出現回数をペアにする |
| `concatMap` | ペアから展開されたリストを結合 |
| `replicate` | 同じ値を指定回数繰り返す |

**計算量**: O(n * k)（n は要素数、k は値の範囲）
※ Python 版の O(n + k) より非効率ですが、実装がより関数的です。

### より効率的な実装

効率が重要な場合は `Data.Map` を使います：

```haskell
import qualified Data.Map.Strict as Map

countingSortEfficient :: (Ord a) => [a] -> [a]
countingSortEfficient xs =
  let freq = Map.fromListWith (+) [(x, 1) | x <- xs]
  in concatMap (\(v, c) -> replicate c v) (Map.toAscList freq)
```

---

## Python 版との比較

### 根本的な設計の違い

| 観点 | Python 版 | Haskell 版 |
|------|-----------|------------|
| 操作スタイル | In-place（配列を直接変更） | Pure（新しいリストを返す） |
| 戻り値 | `None`（多くの場合） | ソート済みリスト |
| 状態管理 | ローカル変数、インデックス | 再帰、パターンマッチング |
| エラー処理 | 例外 | 型システム（`Maybe` など） |
| メモリ | O(1) 追加（多くの場合） | O(n) 追加（新リスト生成） |
| 型制約 | なし（Duck Typing） | `Ord a =>` 型クラス制約 |

### クイックソートの比較（最も際立つ違い）

**Python 版（in-place）**:
```python
def quick_sort(a: list, left: int = 0, right: int | None = None) -> None:
    if right is None:
        right = len(a) - 1
    if left >= right:
        return
    pivot = a[(left + right) // 2]
    i, j = left, right
    while i <= j:
        while a[i] < pivot:
            i += 1
        while a[j] > pivot:
            j -= 1
        if i <= j:
            a[i], a[j] = a[j], a[i]
            i += 1
            j -= 1
    quick_sort(a, left, j)
    quick_sort(a, i, right)
```

**Haskell 版（純粋関数）**:
```haskell
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  let (smaller, larger) = partition (<= x) xs
  in quickSort smaller ++ [x] ++ quickSort larger
```

行数が 18 行 vs 4 行と大きく異なります。Haskell 版は数学的なクイックソートの定義に忠実です。

### マージソートの比較

**Python 版**:
```python
def merge_sort(a: list) -> list:
    if len(a) <= 1:
        return a[:]
    mid = len(a) // 2
    left = merge_sort(a[:mid])
    right = merge_sort(a[mid:])
    return _merge(left, right)

def _merge(left: list, right: list) -> list:
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

**Haskell 版**:
```haskell
mergeSort :: Ord a => [a] -> [a]
mergeSort []  = []
mergeSort [x] = [x]
mergeSort xs  =
  let (l, r) = splitAt (length xs `div` 2) xs
  in merge (mergeSort l) (mergeSort r)
  where
    merge [] ys         = ys
    merge xs []         = xs
    merge (a:as) (b:bs)
      | a <= b    = a : merge as (b:bs)
      | otherwise = b : merge (a:as) bs
```

Haskell の `merge` は `while` ループを使わず、パターンマッチングと再帰で記述しています。

### ヒープソートの比較

**Python 版（配列を直接変更）**:
```python
def heap_sort(a: list) -> None:
    def down_heap(a: list, left: int, right: int) -> None:
        temp = a[left]
        parent = left
        while parent < (right + 1) // 2:
            cl = parent * 2 + 1
            cr = cl + 1
            child = cr if cr <= right and a[cr] > a[cl] else cl
            if temp >= a[child]:
                break
            a[parent] = a[child]
            parent = child
        a[parent] = temp

    n = len(a)
    for i in range((n - 1) // 2, -1, -1):
        down_heap(a, i, n - 1)
    for i in range(n - 1, 0, -1):
        a[0], a[i] = a[i], a[0]
        down_heap(a, 0, i - 1)
```

**Haskell 版（Data.Array を使った不変配列）**:
```haskell
heapSort :: Ord a => [a] -> [a]
heapSort [] = []
heapSort xs = elems $ extractAll (buildMaxHeap arr) n
  where
    -- （実装は前述のとおり）
```

Python 版は配列を直接変更（in-place）し、Haskell 版は毎回新しい配列を生成します。これはメモリ効率では劣りますが、参照透明性を保ちます。

---

## テスト実行結果

```bash
$ cd apps/haskell && cabal test

SortAlgorithms
  bubbleSort
    バブルソートでソートする           OK
  selectionSort
    選択ソートでソートする             OK
  insertionSort
    挿入ソートでソートする             OK
  shellSort
    シェルソートでソートする           OK
  quickSort
    クイックソートでソートする         OK
  mergeSort
    マージソートでソートする           OK
  heapSort
    ヒープソートでソートする           OK
  countingSort
    度数ソートでソートする             OK

Finished in 0.0045 seconds
8 examples, 0 failures
```

---

## ソートアルゴリズムの比較表

| アルゴリズム | 最良 | 平均 | 最悪 | 安定 | Haskell での特徴 |
|------------|------|------|------|------|----------------|
| バブルソート | O(n²) | O(n²) | O(n²) | ✓ | `iterate` で n-1 パス |
| 選択ソート | O(n²) | O(n²) | O(n²) | ✓ | `minimum` + 再帰 |
| 挿入ソート | O(n) | O(n²) | O(n²) | ✓ | `foldr insert'` |
| シェルソート | O(n) | O(n^1.5) | O(n²) | ✗ | `Data.Array` + `foldl` |
| クイックソート | O(n log n) | O(n log n) | O(n²) | ✗ | `partition` で超簡潔 |
| マージソート | O(n log n) | O(n log n) | O(n log n) | ✓ | パターンマッチング |
| ヒープソート | O(n log n) | O(n log n) | O(n log n) | ✗ | `Data.Array` で実装 |
| 度数ソート | O(n*k) | O(n*k) | O(n*k) | ✓ | `map`/`concatMap` で宣言的 |

### Python 版との安定性比較

| アルゴリズム | Python 版安定性 | Haskell 版安定性 | 備考 |
|------------|----------------|-----------------|------|
| バブルソート | ✓ | ✓ | 等値要素は交換しない |
| 選択ソート | ✗ | ✓ | Haskell 版は最初に見つかった最小値のみ削除 |
| 挿入ソート | ✓ | ✓ | `<=` で等値要素の相対順序を保持 |
| クイックソート | ✗ | ✗ | ピボットに依存 |
| マージソート | ✓ | ✓ | `a <= b` で等値時は左を優先 |

---

## まとめ

この章では、Haskell における 8 種類のソートアルゴリズムを学びました：

1. **バブルソート** — `iterate` を使って n-1 回のパスを適用。純粋関数として実装。

2. **選択ソート** — `minimum` と `deleteFirst` を使った宣言的な実装。再帰で元のリストを縮小。

3. **挿入ソート** — `foldr insert'` というワンライナーに近い実装。`foldr` の威力を実感できる。

4. **シェルソート** — `Data.Array` の不変配列を活用。`//` で更新した新しい配列を生成する Haskell のスタイル。

5. **クイックソート** — 最も Haskell らしい実装。`partition` を使った 4 行の実装がアルゴリズムの本質を表現。

6. **マージソート** — `splitAt` と再帰的 `merge` によるシンプルな分割統治。パターンマッチングで 3 つのケースを明示。

7. **ヒープソート** — 配列ベースの実装を Haskell の不変配列で再現。`buildMaxHeap` と `extractAll` の分離で可読性を向上。

8. **度数ソート** — `map`、`filter`、`concatMap`、`replicate` を組み合わせた関数的な実装。

Python 版と比べると、Haskell 版は：
- コードが短く（特にクイックソート）
- 型安全性が高い（`Ord a =>` 型クラス制約）
- 参照透明性を保つ（in-place 変更なし）
- 副作用が明示される（IO 不要）

次の章では、文字列処理アルゴリズムについて学んでいきましょう。

## 参考文献

- 『プログラミング Haskell（第 2 版）』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- 『テスト駆動開発』 — Kent Beck
