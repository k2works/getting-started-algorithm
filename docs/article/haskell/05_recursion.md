# 第 5 章 再帰アルゴリズム（Haskell 版）

## はじめに

前章ではスタックとキューを学びました。この章では「**再帰（Recursion）**」というアルゴリズム設計手法を TDD で実装します。

Haskell は再帰を非常に自然に表現できる言語です。パターンマッチング、末尾再帰最適化（GHC による自動変換）、リスト内包表記など、Haskell 固有の機能が再帰アルゴリズムの実装を簡潔かつ表現力豊かにします。

再帰アルゴリズムは、一般的に以下の 2 つの部分から構成されます：

1. **基底部（base case）**: 再帰呼び出しを終了する条件
2. **再帰部（recursive case）**: 問題を小さくして自分自身を呼び出す部分

Haskell ではパターンマッチングによってこれらを自然に記述できます。

### 目次

1. [階乗（累積器パターン）](#1-階乗累積器パターン)
2. [最大公約数（ユークリッドの互除法）](#2-最大公約数ユークリッドの互除法)
3. [ハノイの塔](#3-ハノイの塔)
4. [8 クイーン問題（リスト内包表記）](#4-8-クイーン問題リスト内包表記)
5. [末尾再帰最適化](#5-末尾再帰最適化)
6. [Python 版との比較](#6-python-版との比較)

---

## 1. 階乗（累積器パターン）

`n! = n × (n-1) × ... × 1` を再帰で実装します。

Haskell の実装では**累積器パターン（accumulator pattern）**を使って末尾再帰にしています。

### 末尾再帰とは

末尾再帰（tail recursion）とは、再帰呼び出しが関数の**最後の操作**になっている再帰のことです。GHC はこれを自動的にループに変換（末尾再帰最適化）するため、スタックオーバーフローが発生しません。

```
通常の再帰（末尾再帰でない）:
factorial 3 = 3 * factorial 2      ← 掛け算が残っている
            = 3 * (2 * factorial 1)
            = 3 * (2 * (1 * factorial 0))
            = 3 * (2 * (1 * 1))
            = 6

末尾再帰（累積器パターン）:
go 3 1 = go 2 3    ← 最後の操作が go の呼び出し
go 2 3 = go 1 6
go 1 6 = go 0 6
go 0 6 = 6         ← 累積器がそのまま返る
```

### Red — 失敗するテストを書く

```haskell
-- test/RecursionSpec.hs
module RecursionSpec (spec) where

import Test.Hspec
import Recursion

spec :: Spec
spec = do
  describe "Recursion" $ do
    describe "factorial" $ do
      it "階乗を計算する" $ do
        factorial 0  `shouldBe` 1
        factorial 1  `shouldBe` 1
        factorial 5  `shouldBe` 120
        factorial 10 `shouldBe` 3628800
```

### Green — テストを通す実装

```haskell
-- src/Recursion.hs
module Recursion (factorial) where

-- | 階乗（末尾再帰・累積器パターン）
factorial :: Integer -> Integer
factorial n = go n 1
  where
    go 0 acc = acc                -- 基底部: 累積器を返す
    go k acc = go (k - 1) (k * acc)  -- 再帰部: k を減らし acc に積む
```

### アルゴリズムの考え方

累積器パターンの展開：

```
factorial 5
= go 5 1
= go 4 5        (5 * 1 = 5)
= go 3 20       (4 * 5 = 20)
= go 2 60       (3 * 20 = 60)
= go 1 120      (2 * 60 = 120)
= go 0 120      (1 * 120 = 120)
= 120           (基底ケース)
```

通常の再帰と累積器パターンの比較：

```haskell
-- 通常の再帰（非末尾再帰）: スタックに計算が積み重なる
factorialNaive :: Integer -> Integer
factorialNaive 0 = 1
factorialNaive n = n * factorialNaive (n - 1)
--               ↑ 掛け算のために戻る必要がある

-- 末尾再帰（累積器パターン）: スタックに積み重ならない
factorial :: Integer -> Integer
factorial n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)
--             ↑ これが最後の操作 → 末尾再帰
```

**計算量**: O(n)（n 回の再帰呼び出し）

### `foldl` を使ったさらに簡潔な実装

Haskell では `foldl` を使って階乗をより宣言的に書けます：

```haskell
-- foldl を使った実装
factorialFold :: Integer -> Integer
factorialFold n = foldl (*) 1 [1..n]

-- product 関数を使った超簡潔版
factorialProduct :: Integer -> Integer
factorialProduct n = product [1..n]
```

---

## 2. 最大公約数（ユークリッドの互除法）

`gcd(a, b) = gcd(b, a mod b)` という関係を再帰で実装します。

### Red — 失敗するテストを書く

```haskell
describe "gcd'" $ do
  it "最大公約数を計算する" $ do
    gcd' 12 8  `shouldBe` 4
    gcd' 8 12  `shouldBe` 4
    gcd' 7 5   `shouldBe` 1
    gcd' 0 5   `shouldBe` 5
```

### Green — テストを通す実装

```haskell
-- | ユークリッドの互除法による最大公約数（末尾再帰）
gcd' :: Int -> Int -> Int
gcd' a 0 = a              -- 基底部: b が 0 なら a が GCD
gcd' a b = gcd' b (a `mod` b)  -- 再帰部: (a, b) → (b, a mod b)
```

### パターンマッチングの威力

Haskell のパターンマッチングにより、アルゴリズムの数学的定義をそのままコードに写せます：

```
数学的定義:
  gcd(a, 0) = a
  gcd(a, b) = gcd(b, a mod b)

Haskell コード:
  gcd' a 0 = a
  gcd' a b = gcd' b (a `mod` b)
```

これは Python 版のコードと本質的に同じですが、Haskell では`if-else` を使わずパターンマッチングで記述できます。

### アルゴリズムの展開

```
gcd' 22 8
= gcd' 8 6    (22 mod 8 = 6)
= gcd' 6 2    (8 mod 6 = 2)
= gcd' 2 0    (6 mod 2 = 0)
= 2           (基底ケース)
```

この再帰は **末尾再帰** です（最後の操作が `gcd' b (a mod b)` の呼び出し）。

**計算量**: O(log min(a, b))（対数的収束）

---

## 3. ハノイの塔

n 枚の円盤を `from` から `to` へ `via` を経由して移動する問題です。

```
ルール:
1. 一度に 1 枚しか移動できない
2. 大きい円盤を小さい円盤の上に置けない
```

### Red — 失敗するテストを書く

```haskell
describe "hanoi" $ do
  it "ハノイの塔の手順を返す" $ do
    let moves = hanoi 3 'A' 'C' 'B'
    length moves `shouldBe` 7           -- 2^3 - 1 = 7 手
    head moves   `shouldBe` ('A', 'C')
    last moves   `shouldBe` ('A', 'C')

  it "移動回数は 2^n - 1 である" $ do
    length (hanoi 1 'A' 'C' 'B') `shouldBe` 1   -- 2^1 - 1 = 1
    length (hanoi 2 'A' 'C' 'B') `shouldBe` 3   -- 2^2 - 1 = 3
    length (hanoi 4 'A' 'C' 'B') `shouldBe` 15  -- 2^4 - 1 = 15
```

### Green — テストを通す実装

```haskell
-- | ハノイの塔: (from, to) のペアリストを返す
hanoi :: Int -> a -> a -> a -> [(a, a)]
hanoi 0 _ _ _    = []          -- 基底部: 0 枚なら移動不要
hanoi n from to via =
  hanoi (n - 1) from via to   -- n-1 枚を via へ移動
  ++ [(from, to)]              -- 最大の円盤を to へ移動
  ++ hanoi (n - 1) via to from -- n-1 枚を to へ移動
```

### Haskell の型多相（Parametric Polymorphism）

`hanoi` の型シグネチャ `hanoi :: Int -> a -> a -> a -> [(a, a)]` に注目してください：

- `a` は**任意の型**を表す型変数
- `'A'`, `'B'`, `'C'`（文字）でも `"A"`, `"B"`, `"C"`（文字列）でも使える
- `1`, `2`, `3`（整数）でも使える

```haskell
-- 文字を使った呼び出し
hanoi 3 'A' 'C' 'B'
-- => [('A','C'), ('A','B'), ('C','B'), ('A','C'), ('B','A'), ('B','C'), ('A','C')]

-- 文字列を使った呼び出し
hanoi 2 "左" "右" "中"
-- => [("左","右"), ("左","中"), ("右","中")]
```

Python 版では文字列を使っていましたが、Haskell 版では任意の型で使えます。

### アルゴリズムの考え方

3 枚の場合（`hanoi 3 'A' 'C' 'B'`）の展開：

```
1. hanoi 2 'A' 'B' 'C'  (上の2枚を B に移動)
   1-1. A→C (hanoi 1 'A' 'C' 'B')
   1-2. A→B (最大の円盤)
   1-3. C→B (hanoi 1 'C' 'B' 'A')
2. A→C (最大の円盤を C に移動)
3. hanoi 2 'B' 'C' 'A'  (B の2枚を C に移動)
   3-1. B→A (hanoi 1 'B' 'A' 'C')
   3-2. B→C (最大の円盤)
   3-3. A→C (hanoi 1 'A' 'C' 'B')

結果: [A→C, A→B, C→B, A→C, B→A, B→C, A→C]
```

**計算量**: O(2^n)（移動回数は常に 2^n - 1）

---

## 4. 8 クイーン問題（リスト内包表記）

8×8 のチェス盤上に 8 個のクイーンを互いに攻撃できないように配置する問題です。

### Haskell のリスト内包表記

リスト内包表記は Python にも存在しますが、Haskell ではバックトラッキングを非常に自然に表現できます：

```haskell
-- Python のリスト内包表記
[x for x in range(10) if x % 2 == 0]  -- [0, 2, 4, 6, 8]

-- Haskell のリスト内包表記
[x | x <- [0..9], even x]  -- [0, 2, 4, 6, 8]
```

複数のジェネレータと条件を組み合わせることで、バックトラッキング探索が自動的に実現されます。

### Red — 失敗するテストを書く

```haskell
describe "eightQueens" $ do
  it "8クイーン問題の解の数を返す" $ do
    length eightQueens `shouldBe` 92  -- 全部で 92 通りの解
```

### Green — テストを通す実装

```haskell
-- | 8クイーン問題: 全ての解を返す（各解はクイーンの列インデックスリスト）
eightQueens :: [[Int]]
eightQueens = queens 8
  where
    queens 0 = [[]]       -- 基底部: 0 列なら空の配置のみ
    queens k = [ q : qs
               | qs <- queens (k - 1)    -- k-1 列の解 qs を生成
               , q  <- [0..7]            -- k 列目の行位置 q を試す
               , safe q qs               -- 安全なら採用
               ]

    -- q がすでに配置された qs と衝突しないか確認
    safe q qs = and [ q /= q'                -- 同じ行でない
                    && abs (q - q') /= d     -- 斜め方向でない
                    | (q', d) <- zip qs [1..]
                    ]
```

### リスト内包表記によるバックトラッキング

```haskell
queens k = [ q : qs
           | qs <- queens (k - 1)    -- 再帰的に k-1 列の全解を生成
           , q  <- [0..7]            -- 0〜7 の行位置を全て試す
           , safe q qs               -- 安全な配置のみフィルタ
           ]
```

この 4 行が「バックトラッキング付き深さ優先探索」を完全に表現しています：
- `qs <- queens (k - 1)` — 前の列の解を全て展開
- `q <- [0..7]` — 現在の列の全ての行位置を試す
- `safe q qs` — 制約を満たさない場合は自動的にスキップ

Python 版では明示的なバックトラッキング（`__flag` の設定と解除）が必要でしたが、Haskell ではリスト内包表記の条件として自然に表現できます。

### safe 関数の解説

```haskell
safe q qs = and [ q /= q'
                && abs (q - q') /= d
                | (q', d) <- zip qs [1..]
                ]
```

- `zip qs [1..]` — 各クイーンの位置 `q'` と距離 `d` のペアを生成
- `q /= q'` — 同じ行にいない（行の衝突チェック）
- `abs (q - q') /= d` — 斜め方向にいない（対角線の衝突チェック）
- `and [...]` — 全ての条件が真のときだけ `True`

**計算量**: O(n!) に近いが、枝刈りにより実際はずっと少ない

### 解の表示

```haskell
-- 解の数を確認
main :: IO ()
main = do
  let solutions = eightQueens
  putStrLn $ "解の数: " ++ show (length solutions)
  -- => 解の数: 92

  -- 最初の解を表示
  print (head solutions)
  -- => [0,4,7,5,2,6,1,3]
  -- 意味: 1列目は0行目、2列目は4行目、...にクイーンを配置
```

---

## 5. 末尾再帰最適化

### GHC による最適化

Haskell の GHC コンパイラは末尾再帰を自動的にループに変換します。これにより：

- スタックオーバーフローが発生しない
- メモリ使用量が O(1) になる（累積器パターンの場合）

```haskell
-- 末尾再帰でない（スタックが積み重なる）
sumNaive :: Int -> Int
sumNaive 0 = 0
sumNaive n = n + sumNaive (n - 1)
-- sumNaive 1000000 はスタックオーバーフローの可能性

-- 末尾再帰（GHC が最適化）
sumTail :: Int -> Int
sumTail n = go n 0
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k + acc)
-- sumTail 1000000 は安全に動作
```

### `seq` による正格評価

Haskell は**遅延評価（lazy evaluation）**がデフォルトのため、累積器パターンでもサンクが積み重なることがあります。`seq` や `$!` を使って正格評価を強制することが重要です：

```haskell
-- 遅延評価のため、sum が大きなサンクになる問題
sumLazy :: Int -> Int
sumLazy n = go n 0
  where
    go 0 acc = acc
    go k acc = go (k - 1) (acc + k)
    -- acc は評価されずにサンクが積み重なる

-- seq で正格評価を強制
sumStrict :: Int -> Int
sumStrict n = go n 0
  where
    go 0 acc = acc
    go k acc = acc `seq` go (k - 1) (acc + k)
    --         ↑ acc を強制評価してからループ

-- Data.List の foldl' は内部で seq を使う
import Data.List (foldl')
sumEfficient :: Int -> Int
sumEfficient n = foldl' (+) 0 [1..n]
```

### Haskell での再帰パターン一覧

| パターン | 例 | 特徴 |
|---------|-----|------|
| 直接再帰 | `factorial n = n * factorial (n-1)` | シンプル、スタック使用 |
| 末尾再帰 | `go 0 acc = acc; go k acc = go (k-1) (k*acc)` | GHC が最適化 |
| 相互再帰 | `isEven 0 = True; isEven n = isOdd (n-1)` | 2つの関数が互いに呼び合う |
| 真の再帰 | `fib n = fib (n-1) + fib (n-2)` | 複数の再帰呼び出し |

---

## 6. Python 版との比較

### 基本的な違い

| 観点 | Python | Haskell |
|------|--------|---------|
| パターンマッチング | `if/elif/else` | `case` またはトップレベルパターン |
| 末尾再帰最適化 | Python は自動最適化しない | GHC が自動最適化（TCO） |
| リスト内包表記 | あり（基本的） | あり（バックトラッキングに使える） |
| 遅延評価 | なし（正格評価） | デフォルト（遅延評価） |
| 型安全性 | 動的型付け | 静的型付け |

### 階乗の比較

**Python 版**:
```python
def factorial(n: int) -> int:
    if n <= 0:
        return 1
    return n * factorial(n - 1)
```

**Haskell 版（末尾再帰）**:
```haskell
factorial :: Integer -> Integer
factorial n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)
```

Python は `n > 1000` 程度でスタックオーバーフローが発生しますが、Haskell の末尾再帰版は任意の大きさの n に対して安全に動作します。

### GCD の比較

**Python 版**:
```python
def gcd(x: int, y: int) -> int:
    if y == 0:
        return x
    return gcd(y, x % y)
```

**Haskell 版**:
```haskell
gcd' :: Int -> Int -> Int
gcd' a 0 = a
gcd' a b = gcd' b (a `mod` b)
```

数学的定義に対応するパターンマッチングにより、Haskell 版はより直感的です。

### 8 クイーン問題の比較

**Python 版（明示的バックトラッキング）**:
```python
class EightQueen3:
    def set(self, i: int) -> None:
        for j in range(8):
            if (not self.__flag_a[j]
                and not self.__flag_b[i + j]
                and not self.__flag_c[i - j + 7]):
                self.__pos[i] = j
                if i == 7:
                    self.put()
                else:
                    self.__flag_a[j] = True
                    self.__flag_b[i + j] = True
                    self.__flag_c[i - j + 7] = True
                    self.set(i + 1)
                    # バックトラック
                    self.__flag_a[j] = False
                    self.__flag_b[i + j] = False
                    self.__flag_c[i - j + 7] = False
```

**Haskell 版（リスト内包表記）**:
```haskell
eightQueens :: [[Int]]
eightQueens = queens 8
  where
    queens 0 = [[]]
    queens k = [ q : qs
               | qs <- queens (k - 1)
               , q  <- [0..7]
               , safe q qs
               ]
    safe q qs = and [ q /= q' && abs (q - q') /= d
                    | (q', d) <- zip qs [1..] ]
```

Python 版では 30 行以上が必要なところ、Haskell 版はわずか 8 行です。バックトラッキングがリスト内包表記のセマンティクスに内包されています。

### ハノイの塔の比較

**Python 版**:
```python
def hanoi(n: int, src: str, dst: str, via: str) -> list[tuple[str, str]]:
    if n == 1:
        return [(src, dst)]
    moves = []
    moves.extend(hanoi(n - 1, src, via, dst))
    moves.append((src, dst))
    moves.extend(hanoi(n - 1, via, dst, src))
    return moves
```

**Haskell 版**:
```haskell
hanoi :: Int -> a -> a -> a -> [(a, a)]
hanoi 0 _ _ _    = []
hanoi n from to via =
  hanoi (n - 1) from via to
  ++ [(from, to)]
  ++ hanoi (n - 1) via to from
```

Haskell 版は型多相（`a` が任意の型）であり、文字だけでなく任意の型のラベルで使えます。また、リスト連結（`++`）を使った実装は数学的定義に忠実です。

---

## テスト実行結果

```bash
$ cd apps/haskell && cabal test

Recursion
  factorial
    階乗を計算する                   OK
  gcd'
    最大公約数を計算する               OK
  hanoi
    ハノイの塔の手順を返す             OK
  eightQueens
    8クイーン問題の解の数を返す         OK

Finished in 0.0834 seconds
4 examples, 0 failures
```

---

## 再帰アルゴリズムの比較

| アルゴリズム | 計算量 | 末尾再帰 | 特徴 |
|------------|--------|---------|------|
| 階乗 | O(n) | あり（累積器） | 累積器パターンで末尾再帰化 |
| GCD | O(log min(a,b)) | あり | パターンマッチングで数学的定義に忠実 |
| ハノイの塔 | O(2^n) | なし（2分岐） | リスト連結で表現 |
| 8 クイーン | O(n!) 未満 | なし | リスト内包表記でバックトラッキング |

---

## まとめ

この章では、Haskell における再帰アルゴリズムを学びました：

1. **累積器パターン（factorial）** — 累積器（accumulator）を使って末尾再帰を実現。GHC がループに変換し、スタックオーバーフローを防ぐ。

2. **パターンマッチング（gcd'）** — 数学的定義をそのままコードに写せる。基底部と再帰部をパターンで区別する。

3. **型多相（hanoi）** — 型変数 `a` により任意の型で使えるジェネリックな実装。

4. **リスト内包表記（eightQueens）** — バックトラッキング探索を 8 行で表現。Python 版と比べて大幅に簡潔。

5. **末尾再帰最適化（TCO）** — GHC が末尾再帰を自動でループに変換。遅延評価との組み合わせには `seq` や `foldl'` が有効。

Haskell の再帰は Python より自然に書けることが多く、特にリスト内包表記によるバックトラッキングは Haskell の強みです。

次の章では、ソートアルゴリズムについて学んでいきましょう。

## 参考文献

- 『プログラミング Haskell（第 2 版）』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- 『テスト駆動開発』 — Kent Beck
