# 第 3 章 探索アルゴリズム（Haskell 版）

## はじめに

前章では配列（リスト）とデータ構造について学びました。この章では、データの中から特定の値を見つけ出す「探索アルゴリズム」について学んでいきます。

Haskell で探索アルゴリズムを実装することで、以下の概念を深く理解できます：

- **パターンマッチング** による分岐（`linearSearch`）
- **再帰** による探索範囲の絞り込み（`binarySearch`）
- **`Data.Set`** による O(1) 平均の探索（`hashSearch`）

主に以下の 3 つの方法を TDD で実装します：

1. 線形探索（Linear Search）
2. 二分探索（Binary Search）
3. ハッシュ探索（Hash Search）

---

## 準備

```bash
# Nix 環境に入る
nix develop .#haskell

# プロジェクトディレクトリへ移動
cd apps/haskell

# テスト実行
cabal test --test-show-details=always
```

### インポートの設定

探索アルゴリズムのモジュールでは `Data.Set` を使います：

```haskell
-- src/SearchAlgorithms.hs
module SearchAlgorithms (linearSearch, binarySearch, hashSearch) where
import qualified Data.Set as Set
```

`qualified` インポートにより、`Set.member`, `Set.fromList` などの形で明示的に使います。

---

## 探索アルゴリズムとは

探索アルゴリズムとは、データの集合から特定の条件を満たす要素を見つけ出すための手順です。

探索アルゴリズムの性能は、主に以下の要素によって評価されます：

- **時間効率（計算量）**：探索にかかる時間（O(1), O(log n), O(n) など）
- **空間効率**：使用するメモリ量
- **前提条件**：データが整列されている必要があるかなど
- **型の制約**：Haskell では型クラスで明示的に表現される

Haskell では、探索の結果を `Maybe Int`（見つかった場合は `Just インデックス`、見つからない場合は `Nothing`）または `Bool` で表現します。これは Python の `-1` 返却よりも型安全です。

---

## 1. 線形探索（linearSearch）

配列の先頭から順に各要素を調べ、目的のキーと一致する要素を探します。

### TDD サイクル — Red

```haskell
-- test/SearchAlgorithmsSpec.hs
module SearchAlgorithmsSpec (spec) where

import Test.Hspec
import SearchAlgorithms

spec :: Spec
spec = do
  describe "SearchAlgorithms" $ do
    let xs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    describe "linearSearch" $ do
      it "線形探索で要素のインデックスを返す" $ do
        linearSearch xs 3  `shouldBe` Just 2
        linearSearch xs 10 `shouldBe` Just 9
        linearSearch xs 11 `shouldBe` Nothing
        linearSearch ([] :: [Int]) 1 `shouldBe` Nothing
```

### TDD サイクル — Green

```haskell
-- src/SearchAlgorithms.hs
module SearchAlgorithms (linearSearch, binarySearch, hashSearch) where
import qualified Data.Set as Set

linearSearch :: Eq a => [a] -> a -> Maybe Int
linearSearch xs target = go xs 0
  where
    go [] _ = Nothing
    go (y:ys) i
      | y == target = Just i
      | otherwise   = go ys (i + 1)
```

実装のポイント：

- `Eq a =>` 型クラス制約：等値比較が可能な型
- `go` は内部補助関数（`where` 節で定義）
- パターンマッチング：`[]` と `(y:ys)` の 2 ケース
- ガード節：`y == target` と `otherwise`
- 再帰：見つからなければ `go ys (i + 1)` で次の要素へ

### TDD サイクル — Refactor

標準ライブラリの `findIndex` を使ったよりシンプルな実装：

```haskell
import Data.List (findIndex)

linearSearch' :: Eq a => [a] -> a -> Maybe Int
linearSearch' xs target = findIndex (== target) xs
```

さらにポイントフリースタイルで：

```haskell
linearSearch'' :: Eq a => [a] -> a -> Maybe Int
linearSearch'' xs = findIndex . (==) `flip` xs
-- または
linearSearch''' :: Eq a => [a] -> a -> Maybe Int
linearSearch''' = flip $ findIndex . (==)
```

### アルゴリズムの考え方

```
linearSearch [1,2,3,4,5] 3

go [1,2,3,4,5] 0
  1 /= 3 → go [2,3,4,5] 1
  2 /= 3 → go [3,4,5] 2
  3 == 3 → Just 2  ← 発見！

linearSearch [1,2,3] 99
go [1,2,3] 0
  1 /= 99 → go [2,3] 1
  2 /= 99 → go [3] 2
  3 /= 99 → go [] 3
  []      → Nothing  ← 見つからなかった
```

計算量の分析：

| ケース | 計算量 | 説明 |
|--------|--------|------|
| 最良 | O(1) | 先頭要素がターゲット |
| 最悪 | O(n) | 末尾またはなし |
| 平均 | O(n/2) = O(n) | ランダムな位置 |

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 見つからない場合 | `-1` を返す | `Nothing` を返す |
| 型安全性 | 実行時判定 | 型システムで強制 |
| 実装スタイル | `while` ループ | 再帰 + パターンマッチ |
| 型制約 | 暗黙的（`==` が使えれば）| `Eq a` で明示的 |

```python
# Python 版（while ループ）
def ssearch_while(a: Sequence, key: Any) -> int:
    i = 0
    while True:
        if i == len(a):
            return -1
        if a[i] == key:
            return i
        i += 1
```

```haskell
-- Haskell 版（再帰 + パターンマッチ）
linearSearch :: Eq a => [a] -> a -> Maybe Int
linearSearch xs target = go xs 0
  where
    go [] _ = Nothing
    go (y:ys) i
      | y == target = Just i
      | otherwise   = go ys (i + 1)
```

---

## 2. 二分探索（binarySearch）

**前提**：リストが整列（ソート）されていること。

中央の要素とキーを比較し、探索範囲を半分に絞り込むことを繰り返します。

### TDD サイクル — Red

```haskell
    describe "binarySearch" $ do
      it "二分探索でソート済みリストの要素インデックスを返す" $ do
        binarySearch xs 3  `shouldBe` Just 2
        binarySearch xs 10 `shouldBe` Just 9
        binarySearch xs 1  `shouldBe` Just 0
        binarySearch xs 11 `shouldBe` Nothing
        binarySearch ([] :: [Int]) 1 `shouldBe` Nothing
```

### TDD サイクル — Green

```haskell
binarySearch :: Ord a => [a] -> a -> Maybe Int
binarySearch [] _ = Nothing
binarySearch xs target = go 0 (length xs - 1)
  where
    go lo hi
      | lo > hi = Nothing
      | xs !! mid == target = Just mid
      | xs !! mid < target  = go (mid + 1) hi
      | otherwise             = go lo (mid - 1)
      where mid = (lo + hi) `div` 2
```

実装のポイント：

- `Ord a =>` 型クラス制約：大小比較が可能な型
- `!!` 演算子：インデックスアクセス（O(n)）
- `go lo hi` で探索範囲を追跡する補助関数
- ガード節で 3 ケースを処理：見つかった、右半分を探索、左半分を探索
- `where mid = (lo + hi) \`div\` 2` で中央インデックスを計算

### TDD サイクル — Refactor

Haskell のリストは O(n) のインデックスアクセスのため、効率的な二分探索には `Data.Vector` や `Data.Array` が適切です。

```haskell
import qualified Data.Vector as V

-- Vector を使った効率的な二分探索（O(log n)）
binarySearchV :: Ord a => V.Vector a -> a -> Maybe Int
binarySearchV xs target = go 0 (V.length xs - 1)
  where
    go lo hi
      | lo > hi = Nothing
      | xs V.! mid == target = Just mid
      | xs V.! mid < target  = go (mid + 1) hi
      | otherwise             = go lo (mid - 1)
      where mid = (lo + hi) `div` 2
```

`V.!` はベクターの O(1) インデックスアクセスです。

### アルゴリズムの考え方

```
binarySearch [1,2,3,4,5,6,7,8,9,10] 3

go 0 9
  mid = (0+9) `div` 2 = 4
  xs !! 4 = 5 > 3 → go 0 3

go 0 3
  mid = (0+3) `div` 2 = 1
  xs !! 1 = 2 < 3 → go 2 3

go 2 3
  mid = (2+3) `div` 2 = 2
  xs !! 2 = 3 == 3 → Just 2  ← 発見！
```

探索範囲の絞り込み：

```
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 0  1  2  3  4  5  6  7  8   9   ← インデックス

ステップ1: lo=0, hi=9, mid=4, xs[4]=5
  5 > 3 なので左半分を探索 → lo=0, hi=3

ステップ2: lo=0, hi=3, mid=1, xs[1]=2
  2 < 3 なので右半分を探索 → lo=2, hi=3

ステップ3: lo=2, hi=3, mid=2, xs[2]=3
  3 == 3 → Just 2
```

計算量の分析：

| ケース | 計算量 | 説明 |
|--------|--------|------|
| 最良 | O(1) | 最初の中央要素がターゲット |
| 最悪 | O(log n) | 見つからないか最後に発見 |
| 平均 | O(log n) | |

**線形探索と二分探索の性能比較**：

| 要素数 | 線形探索（最悪） | 二分探索（最悪） |
|--------|--------------|--------------|
| 100 | 100 回 | 7 回 |
| 1,000 | 1,000 回 | 10 回 |
| 1,000,000 | 1,000,000 回 | 20 回 |
| 10 億 | 10 億 回 | 30 回 |

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 実装スタイル | `while` ループ | 再帰 + ガード節 |
| インデックスアクセス | O(1)（動的配列）| O(n)（連結リスト）|
| 前提条件 | 整列済み | 整列済み |
| 型制約 | 暗黙的 | `Ord a` で明示的 |
| 空リスト処理 | 実行時エラー可能 | パターンマッチで安全処理 |

```python
# Python 版（while ループ）
def bseach(a: Sequence, key: Any) -> int:
    pl = 0
    pr = len(a) - 1

    while True:
        pc = (pl + pr) // 2
        if a[pc] == key:
            return pc
        elif a[pc] < key:
            pl = pc + 1
        else:
            pr = pc - 1
        if pl > pr:
            break
    return -1
```

```haskell
-- Haskell 版（再帰）
binarySearch :: Ord a => [a] -> a -> Maybe Int
binarySearch [] _ = Nothing
binarySearch xs target = go 0 (length xs - 1)
  where
    go lo hi
      | lo > hi = Nothing
      | xs !! mid == target = Just mid
      | xs !! mid < target  = go (mid + 1) hi
      | otherwise             = go lo (mid - 1)
      where mid = (lo + hi) `div` 2
```

---

## 3. ハッシュ探索（hashSearch）

`Data.Set` を使ってハッシュ探索を実装します。

### TDD サイクル — Red

```haskell
    describe "hashSearch" $ do
      it "ハッシュ探索で要素の存在を確認する" $ do
        hashSearch xs 3  `shouldBe` True
        hashSearch xs 11 `shouldBe` False
        hashSearch ([] :: [Int]) 1 `shouldBe` False
```

### TDD サイクル — Green

```haskell
hashSearch :: Ord a => [a] -> a -> Bool
hashSearch xs target = Set.member target (Set.fromList xs)
```

非常に簡潔な実装です。`Data.Set` の内部は平衡二分木（AVL 木）です。

実装のポイント：

- `Set.fromList xs` — リストから集合を作成（O(n log n)）
- `Set.member target` — 集合内の要素を検索（O(log n)）
- `Ord a =>` — `Set` は要素の順序比較を必要とする

### TDD サイクル — Refactor

頻繁に同じリストを検索する場合、事前に `Set` を作成しておくと効率的です：

```haskell
-- 事前に Set を構築してから複数回検索する場合
makeSearchable :: Ord a => [a] -> Set.Set a
makeSearchable = Set.fromList

searchInSet :: Ord a => Set.Set a -> a -> Bool
searchInSet = flip Set.member

-- 使用例
let mySet = makeSearchable [1..1000000]
searchInSet mySet 42    -- True（O(log n)）
searchInSet mySet 99999 -- True（O(log n)）
```

`HashMap` を使ったより高速な実装（平均 O(1)）：

```haskell
import qualified Data.Set as Set
import qualified Data.HashMap.Strict as HashMap

-- HashMap を使った O(1) 平均の探索
hashSearchFast :: (Ord a, Hashable a) => [a] -> a -> Bool
hashSearchFast xs target =
  let hashSet = HashMap.fromList [(x, ()) | x <- xs]
  in HashMap.member target hashSet
```

### アルゴリズムの考え方

`Data.Set` の内部構造（平衡二分木）：

```
Set.fromList [5, 3, 7, 1, 4, 6, 8]

内部ツリー:
         5
        / \
       3   7
      / \ / \
     1  4 6  8

Set.member 4: 5→左→3→右→4 (3回比較)
Set.member 9: 5→右→7→右→8→なし (3回比較)
```

`Data.Set` vs Python の `set`：

| 項目 | Python `set` | Haskell `Data.Set` |
|------|-------------|-------------------|
| 内部構造 | ハッシュテーブル | 平衡二分木 |
| `member` 計算量 | O(1) 平均 | O(log n) |
| メモリ効率 | ハッシュテーブル | ツリー |
| 要素の順序 | 順序なし | 整列済み |
| 型制約 | `__hash__` が必要 | `Ord` が必要 |

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| データ構造 | `set`（ハッシュテーブル）| `Data.Set`（平衡二分木）|
| 計算量 | O(1) 平均 | O(log n) |
| 型制約 | ハッシュ可能 | `Ord` |
| 返り値 | `bool` | `Bool` |

```python
# Python 版
def hash_search(xs: list, target) -> bool:
    return target in set(xs)
```

```haskell
-- Haskell 版
hashSearch :: Ord a => [a] -> a -> Bool
hashSearch xs target = Set.member target (Set.fromList xs)
```

---

## 4. 完全なテストスイートと実装

### テストファイル（全体）

```haskell
-- test/SearchAlgorithmsSpec.hs
module SearchAlgorithmsSpec (spec) where

import Test.Hspec
import SearchAlgorithms

spec :: Spec
spec = do
  describe "SearchAlgorithms" $ do
    let xs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    describe "linearSearch" $ do
      it "線形探索で要素のインデックスを返す" $ do
        linearSearch xs 3  `shouldBe` Just 2
        linearSearch xs 10 `shouldBe` Just 9
        linearSearch xs 11 `shouldBe` Nothing
        linearSearch ([] :: [Int]) 1 `shouldBe` Nothing

      it "先頭要素を見つける" $ do
        linearSearch xs 1 `shouldBe` Just 0

      it "同じ値が複数ある場合は最初のインデックスを返す" $ do
        linearSearch [1,2,2,3] 2 `shouldBe` Just 1

      it "文字列リストでも動作する" $ do
        linearSearch ["apple", "banana", "cherry"] "banana"
          `shouldBe` Just 1

    describe "binarySearch" $ do
      it "二分探索でソート済みリストの要素インデックスを返す" $ do
        binarySearch xs 3  `shouldBe` Just 2
        binarySearch xs 10 `shouldBe` Just 9
        binarySearch xs 1  `shouldBe` Just 0
        binarySearch xs 11 `shouldBe` Nothing
        binarySearch ([] :: [Int]) 1 `shouldBe` Nothing

      it "中央の要素を見つける" $ do
        binarySearch xs 5 `shouldBe` Just 4

      it "単一要素のリスト" $ do
        binarySearch [42] 42 `shouldBe` Just 0
        binarySearch [42] 0  `shouldBe` Nothing

    describe "hashSearch" $ do
      it "ハッシュ探索で要素の存在を確認する" $ do
        hashSearch xs 3  `shouldBe` True
        hashSearch xs 11 `shouldBe` False
        hashSearch ([] :: [Int]) 1 `shouldBe` False

      it "文字でも動作する" $ do
        hashSearch ['a'..'z'] 'm' `shouldBe` True
        hashSearch ['a'..'z'] '1' `shouldBe` False
```

### 実装ファイル（全体）

```haskell
-- src/SearchAlgorithms.hs
module SearchAlgorithms (linearSearch, binarySearch, hashSearch) where
import qualified Data.Set as Set

-- | リストを線形探索し、ターゲットが最初に見つかったインデックスを返す
-- 見つからない場合は Nothing を返す
--
-- >>> linearSearch [1,2,3,4,5] 3
-- Just 2
-- >>> linearSearch [1,2,3] 99
-- Nothing
linearSearch :: Eq a => [a] -> a -> Maybe Int
linearSearch xs target = go xs 0
  where
    go [] _ = Nothing
    go (y:ys) i
      | y == target = Just i
      | otherwise   = go ys (i + 1)

-- | ソート済みリストを二分探索し、ターゲットのインデックスを返す
-- 見つからない場合は Nothing を返す
-- 前提: リストがソート済みであること
--
-- >>> binarySearch [1,2,3,4,5] 3
-- Just 2
-- >>> binarySearch [1,2,3,4,5] 6
-- Nothing
binarySearch :: Ord a => [a] -> a -> Maybe Int
binarySearch [] _ = Nothing
binarySearch xs target = go 0 (length xs - 1)
  where
    go lo hi
      | lo > hi = Nothing
      | xs !! mid == target = Just mid
      | xs !! mid < target  = go (mid + 1) hi
      | otherwise             = go lo (mid - 1)
      where mid = (lo + hi) `div` 2

-- | リスト内にターゲットが存在するかを Data.Set を使って確認する
--
-- >>> hashSearch [1,2,3,4,5] 3
-- True
-- >>> hashSearch [1,2,3,4,5] 99
-- False
hashSearch :: Ord a => [a] -> a -> Bool
hashSearch xs target = Set.member target (Set.fromList xs)
```

---

## 5. Maybe 型と探索結果の処理

Haskell の `Maybe` 型は、探索の成功・失敗を型システムで表現します。

### Maybe 型の操作

```haskell
-- パターンマッチングで処理
handleResult :: Maybe Int -> String
handleResult Nothing  = "見つかりませんでした"
handleResult (Just i) = "インデックス " ++ show i ++ " で見つかりました"

-- case 式で処理
printResult :: Maybe Int -> IO ()
printResult result = case result of
  Nothing  -> putStrLn "見つかりませんでした"
  Just idx -> putStrLn $ "インデックス: " ++ show idx

-- maybe 関数で処理
-- maybe デフォルト値 変換関数 maybeValue
indexOrDefault :: Maybe Int -> Int
indexOrDefault = maybe (-1) id  -- Nothing → -1, Just n → n

-- fmap で Maybe の中の値を変換
doubleIndex :: Maybe Int -> Maybe Int
doubleIndex = fmap (*2)
-- doubleIndex (Just 3) = Just 6
-- doubleIndex Nothing  = Nothing
```

### Maybe のモナドとしての利用

複数の探索を連鎖させる場合、`>>=`（バインド演算子）を使います：

```haskell
-- 2段階の探索
searchTwoLevel :: [[Int]] -> Int -> Int -> Maybe Int
searchTwoLevel matrix row target = do
  rowList <- if row < length matrix
             then Just (matrix !! row)
             else Nothing
  linearSearch rowList target

-- 使用例
let matrix = [[1,2,3], [4,5,6], [7,8,9]]
searchTwoLevel matrix 1 5  -- Just 1（2行目の5はインデックス1）
searchTwoLevel matrix 5 1  -- Nothing（行が存在しない）
```

---

## 6. Data.Set の詳細

`Data.Set` モジュールはソートされた集合を提供します。

### 基本操作

```haskell
import qualified Data.Set as Set

-- 集合の作成
s1 :: Set.Set Int
s1 = Set.fromList [3, 1, 4, 1, 5, 9, 2, 6]
-- fromList [1,2,3,4,5,6,9]（重複が除去され、ソートされる）

-- 要素の追加
s2 :: Set.Set Int
s2 = Set.insert 7 s1
-- fromList [1,2,3,4,5,6,7,9]

-- 要素の削除
s3 :: Set.Set Int
s3 = Set.delete 3 s1
-- fromList [1,2,4,5,6,9]

-- 集合の演算
s4 :: Set.Set Int
s4 = Set.fromList [1, 2, 3]
s5 :: Set.Set Int
s5 = Set.fromList [2, 3, 4]

Set.union s4 s5        -- fromList [1,2,3,4]
Set.intersection s4 s5 -- fromList [2,3]
Set.difference s4 s5   -- fromList [1]

-- サイズ
Set.size s1  -- 7

-- 最小値・最大値
Set.findMin s1  -- 1
Set.findMax s1  -- 9
```

### Set を使ったより高度な探索

```haskell
-- 範囲内の要素が存在するか確認
anyInRange :: Ord a => [a] -> a -> a -> Bool
anyInRange xs lo hi =
  let s = Set.fromList xs
      subSet = Set.filter (\x -> x >= lo && x <= hi) s
  in not (Set.null subSet)

-- 使用例
anyInRange [1..10] 3 7   -- True
anyInRange [1..10] 15 20 -- False
```

---

## 7. 探索アルゴリズムの比較

### 計算量の比較

| アルゴリズム | 前提条件 | 事前準備 | 探索 | 空間 | 備考 |
|-------------|---------|---------|------|------|------|
| 線形探索 | なし | O(1) | O(n) | O(1) | 最もシンプル |
| 二分探索 | 整列済み | O(1)* | O(log n) | O(1) | *整列コストは別途 |
| ハッシュ探索（Set） | なし | O(n log n) | O(log n) | O(n) | `Data.Set` |
| ハッシュ探索（HashMap） | なし | O(n) | O(1) 平均 | O(n) | `Data.HashMap` |

### 使い分けの指針

| 状況 | 推奨アルゴリズム | 理由 |
|------|----------------|------|
| データが少量（< 100）| 線形探索 | シンプルで十分 |
| データが整列済み | 二分探索 | O(log n) で高速 |
| 同じリストを何度も探索 | `Data.Set` または `Data.HashMap` | 前処理コストを償却 |
| データが未整列・大量 | `Data.Set` で変換 | 前処理後に O(log n) |

### Python 版との総合比較

| 観点 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 見つからない場合 | `-1` 返却 | `Nothing`（型安全）|
| 型制約 | 暗黙的 | `Eq a`, `Ord a` で明示 |
| ハッシュ実装 | `set`（O(1) 平均）| `Data.Set`（O(log n)）|
| 番兵法 | サポート | 標準では不使用 |
| チェイン法 | `ChainedHash` クラス | `Data.HashMap` で代替 |
| リストへの依存 | `Sequence` 型 | Haskell リスト |

---

## 8. 高度な探索：標準ライブラリの活用

Haskell の標準ライブラリには豊富な探索関連関数があります。

### Data.List の探索関数

```haskell
import Data.List (find, findIndex, findIndices, elemIndex, elemIndices)

-- find: 条件を満たす最初の要素
find even [1,3,4,6,7]       -- Just 4
find (> 10) [1,3,4,6,7]     -- Nothing

-- findIndex: 条件を満たす最初のインデックス
findIndex even [1,3,4,6,7]  -- Just 2
findIndex (> 10) [1,2,3]    -- Nothing

-- findIndices: 条件を満たすすべてのインデックス
findIndices even [1,2,3,4,5,6]  -- [1,3,5]

-- elemIndex: 特定要素の最初のインデックス
elemIndex 3 [1,2,3,4,3]  -- Just 2

-- elemIndices: 特定要素のすべてのインデックス
elemIndices 3 [1,2,3,4,3]  -- [2,4]

-- elem: 要素が存在するか
elem 3 [1,2,3,4,5]   -- True
notElem 3 [1,2,3,4,5] -- False
```

### 使用例

```haskell
-- 探索アルゴリズムの標準ライブラリ版
linearSearchStd :: Eq a => [a] -> a -> Maybe Int
linearSearchStd xs target = elemIndex target xs

-- 上記の実装と等価
linearSearch xs target == linearSearchStd xs target  -- True
```

---

## 9. 探索の実用的なパターン

### 複数条件での探索

```haskell
-- 複数の条件を組み合わせた探索
data Person = Person { name :: String, age :: Int } deriving (Show)

people :: [Person]
people = [ Person "Alice" 30
         , Person "Bob" 25
         , Person "Charlie" 35
         ]

-- 名前で検索
findByName :: String -> [Person] -> Maybe Person
findByName n = find (\p -> name p == n)

-- 年齢範囲で検索
findByAgeRange :: Int -> Int -> [Person] -> [Person]
findByAgeRange lo hi = filter (\p -> age p >= lo && age p <= hi)

-- 使用例
findByName "Bob" people           -- Just (Person {name = "Bob", age = 25})
findByAgeRange 28 36 people       -- [Alice, Charlie]
```

### 木構造での二分探索

```haskell
data BST a = Empty | Node (BST a) a (BST a)

insertBST :: Ord a => a -> BST a -> BST a
insertBST x Empty = Node Empty x Empty
insertBST x (Node l v r)
  | x < v    = Node (insertBST x l) v r
  | x > v    = Node l v (insertBST x r)
  | otherwise = Node l v r  -- 重複は無視

searchBST :: Ord a => a -> BST a -> Bool
searchBST _ Empty = False
searchBST x (Node l v r)
  | x == v   = True
  | x < v    = searchBST x l
  | otherwise = searchBST x r

-- 使用例
let bst = foldr insertBST Empty [5, 3, 7, 1, 4, 6, 8]
searchBST 4 bst  -- True
searchBST 9 bst  -- False
```

---

## テスト実行結果

```bash
$ cabal test --test-show-details=always

Running 1 test suites...
Test suite haskell-algorithm-test: RUNNING...

SearchAlgorithms
  linearSearch
    線形探索で要素のインデックスを返す
      ✓ passed (0.00s)
    先頭要素を見つける
      ✓ passed (0.00s)
    同じ値が複数ある場合は最初のインデックスを返す
      ✓ passed (0.00s)
    文字列リストでも動作する
      ✓ passed (0.00s)
  binarySearch
    二分探索でソート済みリストの要素インデックスを返す
      ✓ passed (0.00s)
    中央の要素を見つける
      ✓ passed (0.00s)
    単一要素のリスト
      ✓ passed (0.00s)
  hashSearch
    ハッシュ探索で要素の存在を確認する
      ✓ passed (0.00s)
    文字でも動作する
      ✓ passed (0.00s)

Finished in 0.0089 seconds
9 examples, 0 failures

Test suite haskell-algorithm-test: PASS
Test suite logged to:
  dist-newstyle/build/.../test/haskell-algorithm-test.log
1 of 1 test suites (1 of 1 test cases) passed.
```

---

## まとめ

この章では、3 つの探索アルゴリズムを Haskell の TDD で実装しました：

| アルゴリズム | 関数 | Haskell の特徴 |
|-------------|------|--------------|
| 線形探索 | `linearSearch` | パターンマッチ、再帰、`Maybe` 型 |
| 二分探索 | `binarySearch` | ガード節、再帰、`Ord` 制約 |
| ハッシュ探索 | `hashSearch` | `Data.Set`、`Ord` 制約 |

### 計算量まとめ

| アルゴリズム | 事前条件 | 計算量 | 適用場面 |
|-------------|---------|--------|---------|
| 線形探索 | なし | O(n) | 小規模・未整列データ |
| 二分探索 | 整列済み | O(log n) | 大規模・整列済みデータ |
| ハッシュ探索（Set）| なし | O(log n) | 繰り返し探索 |

### Python 版と Haskell 版の主な違い

1. **返り値の型** — Python は `-1`（特殊値）、Haskell は `Maybe Int`（型安全）
2. **実装スタイル** — Python はループ、Haskell は再帰 + パターンマッチ
3. **型制約** — Haskell は `Eq`, `Ord` を型シグネチャで明示
4. **ハッシュデータ構造** — Python は O(1) の `set`、Haskell は O(log n) の `Data.Set`
5. **エラーハンドリング** — Python は例外または特殊値、Haskell は `Maybe` モナド

Haskell のアプローチは型システムとパターンマッチングにより、多くのエラーをコンパイル時に検出できます。特に `Maybe` 型による失敗の明示は、探索の結果を安全に扱うための重要なパターンです。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
- 『プログラミング Haskell』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- [Data.Set ドキュメント](https://hackage.haskell.org/package/containers/docs/Data-Set.html)
- [Data.List ドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html)
- [HSpec ドキュメント](https://hspec.github.io/)
