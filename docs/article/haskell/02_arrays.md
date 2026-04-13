# 第 2 章 配列（Haskell 版）

## はじめに

前章では基本的なアルゴリズムについて学びました。この章では、プログラミングにおいて非常に重要なデータ構造である「配列」について学んでいきます。Haskell では配列に相当するデータ構造として「リスト」が中心的な役割を果たします。

Haskell のリストは単方向連結リストとして実装されており、Python のリストとは内部構造が異なります。しかし、豊富な組み込み関数とリスト内包表記により、配列操作を非常に簡潔かつ宣言的に記述できます。

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

---

## 1. データ構造と Haskell のリスト

### データ構造とは

データ構造とは、データ単位とデータ自身との間の物理的または論理的な関係を表したものです。適切なデータ構造を選ぶことで、効率的なアルゴリズムを実装することができます。

### Haskell のリスト

Haskell のリストは**均一な型**の要素を持つ単方向連結リストです。Python のリストとは異なり、異なる型の要素を混在させることはできません。

```haskell
-- 整数のリスト
xs :: [Int]
xs = [1, 2, 3, 4, 5]

-- 文字列のリスト
names :: [String]
names = ["Alice", "Bob", "Charlie"]

-- 空リスト
empty :: [Int]
empty = []

-- リストの構築（コンス演算子 :）
oneToFive :: [Int]
oneToFive = 1 : 2 : 3 : 4 : 5 : []  -- [1, 2, 3, 4, 5] と同じ
```

### Haskell のリストと Python のリストの違い

| 項目 | Python リスト | Haskell リスト |
|------|-------------|--------------|
| 型 | 異なる型を混在可能 | 均一な型のみ |
| 内部構造 | 動的配列（ArrayList） | 単方向連結リスト |
| ランダムアクセス | O(1) | O(n) |
| 先頭への追加 | O(n) | O(1)（cons 演算子） |
| 変更可能性 | ミュータブル | イミュータブル |
| 無限リスト | 不可 | 可能（遅延評価）|

### リストの基本操作

```haskell
-- head: 先頭要素
head [1,2,3]  -- 1

-- tail: 先頭以外
tail [1,2,3]  -- [2,3]

-- last: 末尾要素
last [1,2,3]  -- 3

-- init: 末尾以外
init [1,2,3]  -- [1,2]

-- length: リストの長さ
length [1,2,3]  -- 3

-- null: 空リストかどうか
null []   -- True
null [1]  -- False

-- !! : インデックスアクセス（0始まり）
[1,2,3] !! 0  -- 1
[1,2,3] !! 2  -- 3

-- take: 前 n 個を取り出す
take 3 [1,2,3,4,5]  -- [1,2,3]

-- drop: 前 n 個を除く
drop 3 [1,2,3,4,5]  -- [4,5]

-- 連結
[1,2,3] ++ [4,5,6]  -- [1,2,3,4,5,6]
```

### 無限リスト

Haskell の遅延評価により、無限リストを扱えます。

```haskell
-- 無限の自然数リスト
naturals :: [Int]
naturals = [1..]

-- 無限の偶数リスト
evens :: [Int]
evens = [2,4..]

-- 無限リストの最初の 10 要素だけ使う
take 10 naturals  -- [1,2,3,4,5,6,7,8,9,10]
take 5 evens      -- [2,4,6,8,10]
```

### リストの走査

```haskell
-- map: 各要素に関数を適用
map (*2) [1,2,3]  -- [2,4,6]

-- filter: 条件を満たす要素を抽出
filter even [1,2,3,4,5]  -- [2,4]

-- foldl: 左から畳み込み
foldl (+) 0 [1,2,3,4,5]  -- 15（合計）

-- foldr: 右から畳み込み
foldr (:) [] [1,2,3]  -- [1,2,3]

-- zipWith: 2つのリストの要素を結合
zipWith (+) [1,2,3] [4,5,6]  -- [5,7,9]
```

---

## 2. リスト内包表記

Haskell の最も特徴的な機能の 1 つがリスト内包表記です。数学の集合記法に似た構文でリストを生成します。

```haskell
-- 基本形: [式 | 変数 <- リスト]
squares :: [Int]
squares = [x^2 | x <- [1..10]]
-- [1,4,9,16,25,36,49,64,81,100]

-- 条件付き（ガード）
evenSquares :: [Int]
evenSquares = [x^2 | x <- [1..10], even x]
-- [4,16,36,64,100]

-- 複数の生成元
pairs :: [(Int, Int)]
pairs = [(x, y) | x <- [1..3], y <- [1..3], x /= y]
-- [(1,2),(1,3),(2,1),(2,3),(3,1),(3,2)]
```

Python のリスト内包表記との比較：

```python
# Python 版
squares = [x**2 for x in range(1, 11)]
even_squares = [x**2 for x in range(1, 11) if x % 2 == 0]
pairs = [(x, y) for x in range(1, 4) for y in range(1, 4) if x != y]
```

```haskell
-- Haskell 版
squares = [x^2 | x <- [1..10]]
evenSquares = [x^2 | x <- [1..10], even x]
pairs = [(x, y) | x <- [1..3], y <- [1..3], x /= y]
```

---

## 3. リストの最大値（maxOfList）

### TDD サイクル — Red

```haskell
-- test/ArraysSpec.hs
module ArraysSpec (spec) where

import Test.Hspec
import Arrays

spec :: Spec
spec = do
  describe "Arrays" $ do
    describe "maxOfList" $ do
      it "リストの最大値を返す" $ do
        maxOfList [3, 2, 1, 4, 0] `shouldBe` Just 4
        maxOfList [1]             `shouldBe` Just 1
        maxOfList ([] :: [Int])   `shouldBe` Nothing
```

### TDD サイクル — Green

Haskell では空リストの扱いを `Maybe` 型で安全に表現します。Python のように例外を投げるのではなく、型システムで「失敗の可能性」を表現します。

```haskell
-- src/Arrays.hs
module Arrays (maxOfList, cardinalNumber, primeNumbers) where

maxOfList :: Ord a => [a] -> Maybe a
maxOfList [] = Nothing
maxOfList (x:xs) = Just $ foldl max x xs
```

- `Nothing` — 空リストの場合、最大値は存在しない
- `Just $ foldl max x xs` — 先頭要素 `x` を初期値として残りの要素 `xs` を畳み込む

### TDD サイクル — Refactor

Haskell 標準ライブラリには `maximum` 関数がありますが、空リストで例外が発生します。安全なバージョンを `Maybe` で実装します。

```haskell
-- 標準ライブラリの maximum（空リストで例外）
-- maximum [1,2,3]  -- 3
-- maximum []       -- 例外: Prelude.maximum: empty list

-- 安全な実装
maxOfList :: Ord a => [a] -> Maybe a
maxOfList [] = Nothing
maxOfList xs = Just (maximum xs)

-- または foldl1 を使った実装
maxOfList' :: Ord a => [a] -> Maybe a
maxOfList' [] = Nothing
maxOfList' (x:xs) = Just $ foldl1 max (x:xs)
```

### アルゴリズムの考え方

```
maxOfList []     = Nothing  -- 空リストは Nothing
maxOfList (x:xs) = Just (先頭要素xを初期値として残りxsをmax で畳み込む)
```

**Maybe 型の利点**：呼び出し側でパターンマッチを強制し、空リストの処理を忘れることができません。

```haskell
-- Maybe 型の利用例
case maxOfList [3, 1, 4, 1, 5] of
  Nothing  -> putStrLn "リストが空です"
  Just val -> putStrLn $ "最大値: " ++ show val
-- 出力: 最大値: 5
```

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 空リストの処理 | 例外が発生（IndexError）| `Nothing` を返す |
| 型 | `Any`（最大値そのもの） | `Maybe a`（失敗を型で表現）|
| 安全性 | 実行時に判明 | コンパイル時に強制 |
| 実装 | `for` ループで更新 | `foldl` による畳み込み |

```python
# Python 版
def max_of(a: Sequence) -> Any:
    maximum = a[0]  # 空リストで IndexError
    for i in range(1, len(a)):
        if a[i] > maximum:
            maximum = a[i]
    return maximum
```

```haskell
-- Haskell 版
maxOfList :: Ord a => [a] -> Maybe a
maxOfList [] = Nothing
maxOfList (x:xs) = Just $ foldl max x xs
```

---

## 4. 頻度数計算（cardinalNumber）

要素の出現頻度を計算します。

### TDD サイクル — Red

```haskell
    describe "cardinalNumber" $ do
      it "要素の頻度を数える" $ do
        cardinalNumber 10 [1, 3, 2, 3, 1, 5] `shouldBe` [0, 2, 1, 2, 0, 1, 0, 0, 0, 0]
        cardinalNumber 5 []                    `shouldBe` [0, 0, 0, 0, 0]
```

### TDD サイクル — Green

```haskell
cardinalNumber :: Int -> [Int] -> [Int]
cardinalNumber n xs = map (\i -> length (filter (== i) xs)) [0..n-1]
```

この実装では：
- `[0..n-1]` — 0 から n-1 までのインデックスを生成
- `filter (== i) xs` — リスト `xs` から `i` と等しい要素を抽出
- `length (...)` — 抽出した要素の個数を数える
- `map (...)` — 全インデックスに対して適用

### TDD サイクル — Refactor

`Data.Map` を使ってより効率的な実装も可能です：

```haskell
import qualified Data.Map.Strict as Map

cardinalNumber' :: Int -> [Int] -> [Int]
cardinalNumber' n xs =
  let freq = foldl (\m x -> Map.insertWith (+) x 1 m) Map.empty xs
  in map (\i -> Map.findWithDefault 0 i freq) [0..n-1]
```

O(n²) から O(n log n) へ改善されます（n はリストの長さ）。

### アルゴリズムの考え方

```
cardinalNumber 5 [1, 3, 2, 3, 1]
  = map (\i -> length (filter (== i) [1,3,2,3,1])) [0..4]
  = [length (filter (==0) ...), length (filter (==1) ...), ...]
  = [0, 2, 1, 2, 0]
       ^  ^  ^  ^  ^
       0  1  2  3  4 の出現頻度
```

リスト内包表記を使った等価な実装：

```haskell
cardinalNumber'' :: Int -> [Int] -> [Int]
cardinalNumber'' n xs = [length [x | x <- xs, x == i] | i <- [0..n-1]]
```

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| アプローチ | カウンター配列を更新 | リスト内包表記 + `length` |
| スタイル | 命令型 | 宣言型 |
| 可読性 | ループが必要 | 数学的な記法 |

```python
# Python 版（collections.Counter を使う方法）
from collections import Counter
def cardinal_number(n: int, xs: list) -> list:
    counter = Counter(xs)
    return [counter.get(i, 0) for i in range(n)]
```

```haskell
-- Haskell 版
cardinalNumber :: Int -> [Int] -> [Int]
cardinalNumber n xs = map (\i -> length (filter (== i) xs)) [0..n-1]
```

---

## 5. 素数の列挙（primeNumbers）— エラトステネスの篩

素数を列挙するエラトステネスの篩をリスト内包表記で実装します。

### TDD サイクル — Red

```haskell
    describe "primeNumbers" $ do
      it "n以下の素数リストを返す" $ do
        primeNumbers 20 `shouldBe` [2, 3, 5, 7, 11, 13, 17, 19]
        primeNumbers 10 `shouldBe` [2, 3, 5, 7]
        primeNumbers 2  `shouldBe` [2]
        primeNumbers 1  `shouldBe` []
```

### TDD サイクル — Green

```haskell
primeNumbers :: Int -> [Int]
primeNumbers n = sieve [2..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

このエレガントな実装では：
- `sieve []` — 空リストなら空リストを返す
- `sieve (p:xs)` — 先頭の素数 `p` と、`xs` から `p` の倍数を除いたリストを再帰的に篩にかける
- `[x | x <- xs, x `mod` p /= 0]` — `p` の倍数でない要素のみを残す

### TDD サイクル — Refactor

より効率的な実装：

```haskell
-- 奇数のみを対象にした実装
primeNumbers' :: Int -> [Int]
primeNumbers' n
  | n < 2    = []
  | n == 2   = [2]
  | otherwise = 2 : sieve [3,5..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

### アルゴリズムの考え方

エラトステネスの篩の動作：

```
primeNumbers 20

sieve [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
  p = 2
  2 : sieve [3, 5, 7, 9, 11, 13, 15, 17, 19]   ← 2の倍数を除く

sieve [3, 5, 7, 9, 11, 13, 15, 17, 19]
  p = 3
  3 : sieve [5, 7, 11, 13, 17, 19]             ← 3の倍数を除く

sieve [5, 7, 11, 13, 17, 19]
  p = 5
  5 : sieve [7, 11, 13, 17, 19]                ← 5の倍数を除く
...
結果: [2, 3, 5, 7, 11, 13, 17, 19]
```

再帰の可視化：

```
sieve [2..20]
  = 2 : sieve [3,5,7,9,11,13,15,17,19]
  = 2 : 3 : sieve [5,7,11,13,17,19]
  = 2 : 3 : 5 : sieve [7,11,13,17,19]
  = 2 : 3 : 5 : 7 : sieve [11,13,17,19]
  = 2 : 3 : 5 : 7 : 11 : sieve [13,17,19]
  = 2 : 3 : 5 : 7 : 11 : 13 : sieve [17,19]
  = 2 : 3 : 5 : 7 : 11 : 13 : 17 : sieve [19]
  = 2 : 3 : 5 : 7 : 11 : 13 : 17 : 19 : sieve []
  = 2 : 3 : 5 : 7 : 11 : 13 : 17 : 19 : []
  = [2, 3, 5, 7, 11, 13, 17, 19]
```

### 無限リストによる全素数の生成

Haskell の遅延評価を活用すると、全素数の無限リストを定義できます：

```haskell
-- 全素数の無限リスト
primes :: [Int]
primes = sieve [2..]
  where
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

-- 使用例
take 10 primes  -- [2,3,5,7,11,13,17,19,23,29]

-- 100番目の素数
primes !! 99    -- 541
```

これは Python では実現できない Haskell 固有の機能です。

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 実装スタイル | 配列とループ | 再帰 + リスト内包表記 |
| 無限リスト | 不可 | 可能（遅延評価）|
| 簡潔さ | 比較的冗長 | 非常に簡潔（5 行）|
| 可読性 | アルゴリズムが明示的 | 数学的定義に近い |
| 効率 | 手動最適化が必要 | 基本実装 |

```python
# Python 版（エラトステネスの篩）
def sieve_of_eratosthenes(n: int) -> list:
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    for i in range(2, int(n**0.5) + 1):
        if is_prime[i]:
            for j in range(i*i, n + 1, i):
                is_prime[j] = False
    return [i for i in range(2, n + 1) if is_prime[i]]
```

```haskell
-- Haskell 版（エラトステネスの篩）
primeNumbers :: Int -> [Int]
primeNumbers n = sieve [2..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

---

## 6. 完全なテストスイートと実装

### テストファイル（全体）

```haskell
-- test/ArraysSpec.hs
module ArraysSpec (spec) where

import Test.Hspec
import Arrays

spec :: Spec
spec = do
  describe "Arrays" $ do
    describe "maxOfList" $ do
      it "リストの最大値を返す" $ do
        maxOfList [3, 2, 1, 4, 0] `shouldBe` Just (4 :: Int)
        maxOfList [1]             `shouldBe` Just (1 :: Int)
        maxOfList ([] :: [Int])   `shouldBe` Nothing

      it "降順リストの最大値" $ do
        maxOfList [5, 4, 3, 2, 1] `shouldBe` Just (5 :: Int)

      it "同じ値のリスト" $ do
        maxOfList [3, 3, 3] `shouldBe` Just (3 :: Int)

      it "文字のリストでも動作する" $ do
        maxOfList ['a', 'z', 'm'] `shouldBe` Just 'z'

    describe "cardinalNumber" $ do
      it "要素の頻度を数える" $ do
        cardinalNumber 10 [1, 3, 2, 3, 1, 5]
          `shouldBe` [0, 2, 1, 2, 0, 1, 0, 0, 0, 0]

      it "空リストの頻度はすべて0" $ do
        cardinalNumber 5 [] `shouldBe` [0, 0, 0, 0, 0]

      it "単一要素のリスト" $ do
        cardinalNumber 3 [1] `shouldBe` [0, 1, 0]

    describe "primeNumbers" $ do
      it "n以下の素数リストを返す" $ do
        primeNumbers 20 `shouldBe` [2, 3, 5, 7, 11, 13, 17, 19]
        primeNumbers 10 `shouldBe` [2, 3, 5, 7]
        primeNumbers 2  `shouldBe` [2]
        primeNumbers 1  `shouldBe` []

      it "30 以下の素数" $ do
        primeNumbers 30 `shouldBe` [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
```

### 実装ファイル（全体）

```haskell
-- src/Arrays.hs
module Arrays (maxOfList, cardinalNumber, primeNumbers) where

-- | リストの最大値を Maybe 型で返す
-- 空リストの場合は Nothing を返す
--
-- >>> maxOfList [3, 2, 1, 4, 0]
-- Just 4
-- >>> maxOfList []
-- Nothing
maxOfList :: Ord a => [a] -> Maybe a
maxOfList [] = Nothing
maxOfList (x:xs) = Just $ foldl max x xs

-- | n 以下のインデックス（0 から n-1）について
-- リスト xs 内の各値の出現頻度を計算する
--
-- >>> cardinalNumber 5 [1, 3, 2, 3, 1]
-- [0,2,1,2,0]
cardinalNumber :: Int -> [Int] -> [Int]
cardinalNumber n xs = map (\i -> length (filter (== i) xs)) [0..n-1]

-- | n 以下の素数リストをエラトステネスの篩で生成する
--
-- >>> primeNumbers 10
-- [2,3,5,7]
primeNumbers :: Int -> [Int]
primeNumbers n = sieve [2..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

---

## 7. 高階関数とリスト操作

Haskell のリスト操作の核心は高階関数にあります。

### map — 各要素への関数適用

```haskell
-- 各要素を 2 倍する
map (*2) [1,2,3,4,5]
-- [2,4,6,8,10]

-- 各要素の長さを求める
map length ["hello", "world", "!"]
-- [5,5,1]

-- 独自関数の適用
map (\x -> x^2 + 1) [1..5]
-- [2,5,10,17,26]
```

### filter — 条件による絞り込み

```haskell
-- 偶数のみ
filter even [1..10]
-- [2,4,6,8,10]

-- 10 以上
filter (>= 10) [5,8,10,12,15]
-- [10,12,15]

-- 自分自身が含まれる文字列
filter (\s -> 'a' `elem` s) ["banana", "apple", "cherry"]
-- ["banana","apple"]
```

### foldl / foldr — 畳み込み

```haskell
-- 合計（foldl）
foldl (+) 0 [1..5]  -- 15

-- 積（foldl）
foldl (*) 1 [1..5]  -- 120

-- リストの反転（foldr）
foldr (:) [] [1,2,3]  -- [1,2,3]
foldl (flip (:)) [] [1,2,3]  -- [3,2,1]（反転）

-- 文字列の連結
foldl (++) "" ["Hello", " ", "World"]  -- "Hello World"
```

### zipWith — 2 つのリストを結合

```haskell
-- 対応する要素の和
zipWith (+) [1,2,3] [4,5,6]  -- [5,7,9]

-- 対応する要素のペア
zip [1,2,3] ['a','b','c']  -- [(1,'a'),(2,'b'),(3,'c')]
```

---

## 8. Python 版との機能比較

### 配列操作の比較

| 操作 | Python | Haskell |
|------|--------|---------|
| 最大値 | `max(xs)` | `maximum xs` または `maxOfList xs` |
| 最小値 | `min(xs)` | `minimum xs` |
| 合計 | `sum(xs)` | `sum xs` |
| 長さ | `len(xs)` | `length xs` |
| 反転 | `list(reversed(xs))` | `reverse xs` |
| ソート | `sorted(xs)` | `sort xs` （Data.List）|
| フィルタ | `[x for x in xs if f(x)]` | `filter f xs` |
| マップ | `[f(x) for x in xs]` | `map f xs` |
| 畳み込み | `functools.reduce(f, xs, init)` | `foldl f init xs` |
| インデックスアクセス | `xs[i]` | `xs !! i` |
| スライス | `xs[a:b]` | `take (b-a) (drop a xs)` |
| 先頭追加 | `[x] + xs` | `x : xs` |
| 末尾追加 | `xs + [x]` | `xs ++ [x]` |

### 素数列挙のアプローチ比較

Python 版は命令型：

```python
# Python 版（エラトステネスの篩、配列更新）
def prime3(x: int) -> int:
    counter = 0
    ptr = 0
    prime = [None] * 500

    prime[ptr] = 2
    ptr += 1
    prime[ptr] = 3
    ptr += 1

    for n in range(5, 1001, 2):
        i = 1
        while prime[i] * prime[i] <= n:
            counter += 2
            if n % prime[i] == 0:
                break
            i += 1
        else:
            prime[ptr] = n
            ptr += 1
            counter += 1

    return counter
```

Haskell 版は関数型（宣言的）：

```haskell
-- Haskell 版（エラトステネスの篩、再帰 + リスト内包表記）
primeNumbers :: Int -> [Int]
primeNumbers n = sieve [2..n]
  where
    sieve [] = []
    sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
```

---

## 9. パターンマッチングとリスト

Haskell のパターンマッチングは、リスト操作において非常に強力です。

### リストのパターンマッチング

```haskell
-- 空リストと非空リストのパターン
describeList :: [a] -> String
describeList []     = "空リストです"
describeList [x]    = "1要素のリストです"
describeList [x, y] = "2要素のリストです"
describeList (x:xs) = "先頭が " ++ show x ++ " で残りが " ++ show (length xs) ++ " 要素のリストです"
-- ※ show を使うには Show 制約が必要
```

### コンスパターン

```haskell
-- head と tail を自分で実装
myHead :: [a] -> a
myHead (x:_) = x
myHead []    = error "空リスト"

myTail :: [a] -> [a]
myTail (_:xs) = xs
myTail []     = error "空リスト"

-- 安全な版
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

safeTail :: [a] -> Maybe [a]
safeTail []     = Nothing
safeTail (_:xs) = Just xs
```

### maxOfList の実装原理

`maxOfList` は先頭要素とコンスパターンを使います：

```haskell
maxOfList :: Ord a => [a] -> Maybe a
maxOfList []     = Nothing           -- 空リスト: Nothing
maxOfList (x:xs) = Just $ foldl max x xs  -- 非空リスト: 畳み込み
```

パターン `(x:xs)` は「先頭が `x`、残りが `xs`」というリストにマッチします。

---

## テスト実行結果

```bash
$ cabal test --test-show-details=always

Running 1 test suites...
Test suite haskell-algorithm-test: RUNNING...

Arrays
  maxOfList
    リストの最大値を返す
      ✓ passed (0.00s)
    降順リストの最大値
      ✓ passed (0.00s)
    同じ値のリスト
      ✓ passed (0.00s)
    文字のリストでも動作する
      ✓ passed (0.00s)
  cardinalNumber
    要素の頻度を数える
      ✓ passed (0.00s)
    空リストの頻度はすべて0
      ✓ passed (0.00s)
    単一要素のリスト
      ✓ passed (0.00s)
  primeNumbers
    n以下の素数リストを返す
      ✓ passed (0.00s)
    30 以下の素数
      ✓ passed (0.00s)

Finished in 0.0045 seconds
9 examples, 0 failures

Test suite haskell-algorithm-test: PASS
```

---

## まとめ

この章では、以下の配列・リスト操作を Haskell の TDD で実装しました：

| アルゴリズム | 関数 | Haskell の特徴 |
|-------------|------|--------------|
| リストの最大値 | `maxOfList` | `Maybe` 型、`foldl`、パターンマッチ |
| 頻度計算 | `cardinalNumber` | `map`, `filter`, `length` |
| 素数の列挙 | `primeNumbers` | 再帰、リスト内包表記、エラトステネスの篩 |

Haskell でリスト操作を実装する際の重要なポイント：

1. **Maybe 型で失敗を表現する** — 空リストなどのエッジケースを型システムで強制
2. **foldl/foldr で畳み込む** — ループの代わりに高階関数で集約
3. **リスト内包表記を活用する** — 宣言的で数学的な記法
4. **パターンマッチングでリストを分解する** — `(x:xs)` パターンが基本
5. **遅延評価で無限リストを扱う** — `take n primes` のような使い方

Python 版と比較することで、命令型と関数型の思考方法の違いが明確になりました。Haskell のアプローチは数学的な定義に近く、一度理解すれば非常に表現力豊かです。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
- 『プログラミング Haskell』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- [Haskell 標準ライブラリ（Prelude）](https://hackage.haskell.org/package/base/docs/Prelude.html)
- [Data.List ドキュメント](https://hackage.haskell.org/package/base/docs/Data-List.html)
