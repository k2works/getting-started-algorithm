# 第 1 章 基本的なアルゴリズム（Haskell 版）

## はじめに

プログラミングを学ぶ上で、アルゴリズムの理解は非常に重要です。アルゴリズムとは、問題を解決するための手順や方法のことです。この章では、Haskell を使って基本的なアルゴリズムを学びながら、テスト駆動開発（TDD）の手法を用いて実装していきます。

Haskell は純粋関数型プログラミング言語です。副作用がなく、同じ引数を渡せば必ず同じ結果が返ってくる「参照透明性」が保証されています。この特徴はアルゴリズムの実装と理解において大きな利点となります。また、強力な型システムと型推論により、コンパイル時に多くのバグを検出できます。

テスト駆動開発とは、コードを書く前にまずテストを書き、そのテストが通るようにコードを実装していく開発手法です。Red-Green-Refactor というサイクルを繰り返しながら、確実に動作するコードを段階的に作り上げます。

---

## 準備

### 環境構築

```bash
# Nix 環境に入る（GHC 9.10.3 + cabal が利用可能になる）
nix develop .#haskell

# プロジェクトディレクトリへ移動
cd apps/haskell

# 依存パッケージのインストールとビルド
cabal build

# テスト実行
cabal test
```

### プロジェクト構成

```
apps/haskell/
├── haskell-algorithm.cabal    # プロジェクト設定
├── cabal.project              # Cabal プロジェクト設定
├── src/
│   ├── BasicAlgorithms.hs     # 基本アルゴリズム実装
│   ├── Arrays.hs              # 配列操作実装
│   └── SearchAlgorithms.hs    # 探索アルゴリズム実装
└── test/
    ├── Spec.hs                # テストエントリポイント
    ├── BasicAlgorithmsSpec.hs # 基本アルゴリズムテスト
    ├── ArraysSpec.hs          # 配列操作テスト
    └── SearchAlgorithmsSpec.hs # 探索アルゴリズムテスト
```

### テスト実行コマンド

```bash
# テスト実行
cabal test

# 特定テストスイートのみ実行
cabal test haskell-algorithm-test

# 詳細出力付きでテスト実行
cabal test --test-show-details=always

# ビルドと同時にテスト実行
cabal build && cabal test
```

### cabal ファイルの設定

```
cabal-version:       3.0
name:                haskell-algorithm
version:             0.1.0.0

common shared-properties
  default-language: GHC2021
  ghc-options: -Wall -Wno-missing-signatures

library
  import:           shared-properties
  hs-source-dirs:   src
  exposed-modules:
      BasicAlgorithms
    , Arrays
    , SearchAlgorithms
  build-depends:
      base >= 4.18 && < 5
    , containers >= 0.6

test-suite haskell-algorithm-test
  import:           shared-properties
  type:             exitcode-stdio-1.0
  hs-source-dirs:   test
  main-is:          Spec.hs
  build-depends:
      base >= 4.18 && < 5
    , haskell-algorithm
    , hspec >= 2.0
    , hspec-discover >= 2.0
```

---

## Haskell の基本的な特徴

Haskell はアルゴリズムを学ぶ上で独特の視点を提供します。

### 純粋関数型

Haskell の関数は数学的な関数と同じ意味を持ちます。副作用がなく、同じ引数に対して常に同じ結果を返します。これにより、テストが非常に書きやすくなります。

```haskell
-- 純粋関数の例：引数に対して常に同じ結果を返す
add :: Int -> Int -> Int
add x y = x + y
```

### 強力な型システムと型推論

Haskell の型システムは非常に強力です。型クラス（`Ord`, `Eq` など）を使うことで、複数の型に対して動作する多相的な関数を定義できます。

```haskell
-- Ord 型クラスを使って任意の比較可能な型で動作する関数
maximum3 :: Ord a => a -> a -> a -> a
maximum3 a b c = max a (max b c)
```

### パターンマッチング

Haskell のパターンマッチングは非常に表現力が高く、条件分岐を宣言的に記述できます。

```haskell
-- パターンマッチングの例
describe :: Int -> String
describe 0 = "ゼロ"
describe 1 = "一"
describe n
  | n < 0     = "負の数"
  | otherwise = "正の数"
```

### ガード節

複数の条件を読みやすく記述するガード節（`|`）が利用できます。

```haskell
-- ガード節の例
classify :: Int -> String
classify n
  | n < 0    = "負"
  | n == 0   = "ゼロ"
  | n < 10   = "小さい正"
  | otherwise = "大きい正"
```

---

## 1. アルゴリズムとは

アルゴリズムとは、問題を解決するための明確な手順のことです。コンピュータプログラムは、アルゴリズムを実行可能な形で表現したものと言えます。

良いアルゴリズムは以下の特徴を持ちます：

- 入力と出力が明確である
- 各ステップが明確である
- 有限のステップで終了する
- 効率的である

Haskell においては、これらの特徴がより形式的に表現されます。型シグネチャが入力と出力を明確に宣言し、パターンマッチングが各ステップを宣言的に記述し、遅延評価が無限リストなどを扱えるようにします。

---

## 2. 3 値の最大値

3 つの値の中から最大値を求めるアルゴリズムを TDD で実装します。

### TDD サイクル — Red（失敗するテストを書く）

まず、期待する動作をテストとして記述します。Haskell では HSpec フレームワークを使います。

```haskell
-- test/BasicAlgorithmsSpec.hs
module BasicAlgorithmsSpec (spec) where

import Test.Hspec
import BasicAlgorithms

spec :: Spec
spec = do
  describe "BasicAlgorithms" $ do
    describe "max3" $ do
      it "3つの数値の最大値を返す" $ do
        max3 3 2 1 `shouldBe` 3
        max3 1 3 2 `shouldBe` 3
        max3 1 2 3 `shouldBe` 3
        max3 2 2 2 `shouldBe` 2
```

この時点ではまだ実装がないため、コンパイルエラーが発生します（Red フェーズ）。

### TDD サイクル — Green（テストを通す最小限の実装）

テストを通過させる実装を書きます。Haskell では `max` 関数を組み合わせることで簡潔に実装できます。

```haskell
-- src/BasicAlgorithms.hs
module BasicAlgorithms (max3, mid3) where

max3 :: Ord a => a -> a -> a -> a
max3 a b c = max a (max b c)
```

型シグネチャの `Ord a => a -> a -> a -> a` の意味：

- `Ord a =>` — 型変数 `a` は `Ord` 型クラスのインスタンスである（大小比較が可能）
- `a -> a -> a -> a` — `a` 型の値を 3 つ受け取り、`a` 型の値を返す

### TDD サイクル — Refactor（リファクタリング）

Haskell の `max` 関数は標準ライブラリに用意されています。これを組み合わせることで非常に簡潔な実装になります。さらに関数の合成を使って表現することもできます。

```haskell
-- 関数合成を使った表現（同等の実装）
max3' :: Ord a => a -> a -> a -> a
max3' a b c = maximum [a, b, c]
-- または
max3'' :: Ord a => a -> a -> a -> a
max3'' = \a b c -> foldr1 max [a, b, c]
```

### アルゴリズムの考え方

Haskell の `max3` は `max` 関数を入れ子にした構造です：

```
max3 a b c
  = max a (max b c)
  = max a (まずbとcの最大値を求める)
  = aとbcの最大値の中の最大値
```

Python 版と Haskell 版の比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 実装スタイル | 命令型（変数更新） | 関数型（式の合成） |
| 型指定 | 型ヒント（`int`）| 型クラス（`Ord a`）|
| 多相性 | 限定的 | `Ord a` で任意の比較可能な型 |
| `max` の利用 | 組み込み関数 | 同様に組み込み関数 |

```python
# Python 版
def max3(a: int, b: int, c: int) -> int:
    maximum = a
    if b > maximum:
        maximum = b
    if c > maximum:
        maximum = c
    return maximum
```

```haskell
-- Haskell 版
max3 :: Ord a => a -> a -> a -> a
max3 a b c = max a (max b c)
```

Haskell 版は副作用なしで式として計算結果を直接返します。

---

## 3. 3 値の中央値

3 つの値の中央値（3 つの値を大きさの順に並べたときに真ん中に来る値）を求めます。

### TDD サイクル — Red

```haskell
-- test/BasicAlgorithmsSpec.hs（続き）
    describe "mid3" $ do
      it "3つの数値の中央値を返す" $ do
        mid3 3 2 1 `shouldBe` 2
        mid3 1 3 2 `shouldBe` 2
        mid3 1 2 3 `shouldBe` 2
        mid3 2 2 2 `shouldBe` 2
```

全 13 パターンの網羅的なテストケース：

```haskell
    describe "mid3 全パターン" $ do
      it "a > b > c のとき b を返す" $ mid3 3 2 1 `shouldBe` 2
      it "a > b = c のとき b を返す" $ mid3 3 2 2 `shouldBe` 2
      it "a > c > b のとき c を返す" $ mid3 3 1 2 `shouldBe` 2
      it "a = c > b のとき a を返す" $ mid3 3 2 3 `shouldBe` 3
      it "c > a > b のとき a を返す" $ mid3 2 1 3 `shouldBe` 2
      it "a = b > c のとき a を返す" $ mid3 3 3 2 `shouldBe` 3
      it "a = b = c のとき a を返す" $ mid3 3 3 3 `shouldBe` 3
      it "c > a = b のとき a を返す" $ mid3 2 2 3 `shouldBe` 2
      it "b > a > c のとき a を返す" $ mid3 2 3 1 `shouldBe` 2
      it "b > a = c のとき a を返す" $ mid3 2 3 2 `shouldBe` 2
      it "b > c > a のとき c を返す" $ mid3 1 3 2 `shouldBe` 2
      it "b = c > a のとき b を返す" $ mid3 2 3 3 `shouldBe` 3
      it "c > b > a のとき b を返す" $ mid3 1 2 3 `shouldBe` 2
```

### TDD サイクル — Green

```haskell
-- src/BasicAlgorithms.hs
mid3 :: Ord a => a -> a -> a -> a
mid3 a b c
  | (a >= b && a <= c) || (a >= c && a <= b) = a
  | (b >= a && b <= c) || (b >= c && b <= a) = b
  | otherwise = c
```

ガード節（`|`）を使うことで、各条件を宣言的に記述できます。

### TDD サイクル — Refactor

`sort` を使ったよりシンプルな実装も可能です：

```haskell
import Data.List (sort)

-- ソートして中央値を取得する実装
mid3' :: Ord a => a -> a -> a -> a
mid3' a b c = sort [a, b, c] !! 1
```

ただし、この実装は効率はやや劣ります（O(n log n) vs O(1)）。実際の実装ではガード節を使った版が適切です。

### アルゴリズムの考え方

ガード節による条件分岐の構造：

```
mid3 a b c
  条件1: a が b と c の間にある → a を返す
  条件2: b が a と c の間にある → b を返す
  それ以外（c が a と b の間にある）→ c を返す
```

| 条件 | 中央値 |
|------|--------|
| `(a >= b && a <= c) \|\| (a >= c && a <= b)` | `a` |
| `(b >= a && b <= c) \|\| (b >= c && b <= a)` | `b` |
| それ以外 | `c` |

Python 版との比較：

| 項目 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| 条件分岐 | `if/elif/else` | ガード節（`\|`） |
| ネスト | 深いネスト | フラットなガード節 |
| 可読性 | 手続き的 | 宣言的 |
| パターンマッチ | 使用しない | ガード節で対応 |

```python
# Python 版
def med3(a: int, b: int, c: int) -> int:
    if a >= b:
        if b >= c:
            return b
        elif a <= c:
            return a
        else:
            return c
    elif a > c:
        return a
    elif b > c:
        return c
    else:
        return b
```

```haskell
-- Haskell 版
mid3 :: Ord a => a -> a -> a -> a
mid3 a b c
  | (a >= b && a <= c) || (a >= c && a <= b) = a
  | (b >= a && b <= c) || (b >= c && b <= a) = b
  | otherwise = c
```

Haskell 版はガード節により各条件が独立して読みやすくなっています。

---

## 4. 型クラスの活用

Haskell の `max3` と `mid3` は `Ord a =>` 制約により、`Int` だけでなく様々な型で動作します。

```haskell
-- Int で使用
max3 (3 :: Int) 2 1  -- 3

-- Double で使用
max3 (3.14 :: Double) 2.71 1.41  -- 3.14

-- Char で使用（文字の比較）
max3 'z' 'a' 'm'  -- 'z'

-- String で使用（辞書順比較）
max3 "banana" "apple" "cherry"  -- "cherry"
```

Python 版も型ヒントなしで同様の多相性を持ちますが、Haskell は型レベルで保証されます。

```python
# Python 版（型ヒントなしで動作）
max3(3, 2, 1)          # 3
max3(3.14, 2.71, 1.41) # 3.14
max3('z', 'a', 'm')    # 'z'
```

---

## 5. 完全なテストスイート

実際のテストファイルの全体構造：

```haskell
-- test/BasicAlgorithmsSpec.hs
module BasicAlgorithmsSpec (spec) where

import Test.Hspec
import BasicAlgorithms

spec :: Spec
spec = do
  describe "BasicAlgorithms" $ do
    describe "max3" $ do
      it "3つの数値の最大値を返す" $ do
        -- 最小値が異なる位置にある場合
        max3 3 2 1 `shouldBe` (3 :: Int)  -- a が最大
        max3 1 3 2 `shouldBe` (3 :: Int)  -- b が最大
        max3 1 2 3 `shouldBe` (3 :: Int)  -- c が最大
        -- すべて等しい場合
        max3 2 2 2 `shouldBe` (2 :: Int)

      it "浮動小数点数でも動作する" $ do
        max3 (3.14 :: Double) 2.71 1.41 `shouldBe` 3.14

      it "文字でも動作する" $ do
        max3 'z' 'a' 'm' `shouldBe` 'z'

    describe "mid3" $ do
      it "3つの数値の中央値を返す" $ do
        mid3 3 2 1 `shouldBe` (2 :: Int)  -- a > b > c → b
        mid3 1 3 2 `shouldBe` (2 :: Int)  -- b > c > a → c
        mid3 1 2 3 `shouldBe` (2 :: Int)  -- c > b > a → b
        mid3 2 2 2 `shouldBe` (2 :: Int)  -- a = b = c → a

      it "浮動小数点数でも動作する" $ do
        mid3 (3.0 :: Double) 1.0 2.0 `shouldBe` 2.0
```

---

## 6. HSpec の基本

Haskell のテストフレームワーク HSpec について説明します。

### describe と it

`describe` でテスト対象を説明し、`it` で具体的な動作を記述します。

```haskell
spec :: Spec
spec = do
  describe "関数名" $ do
    it "期待する動作の説明" $ do
      -- テスト内容
      実際の値 `shouldBe` 期待値
```

### よく使うマッチャー

```haskell
-- 等値比較
x `shouldBe` 42

-- 真偽値
True `shouldBe` True
x `shouldSatisfy` (> 0)

-- リスト
[1,2,3] `shouldBe` [1,2,3]
[1,2,3] `shouldContain` [2]

-- Nothing / Just
result `shouldBe` Nothing
result `shouldBe` Just 42

-- 例外（IOアクション）
evaluate (head []) `shouldThrow` anyException
```

### テスト実行と出力

```bash
$ cabal test --test-show-details=always

BasicAlgorithms
  max3
    3つの数値の最大値を返す
      ✓ passed (0.00s)
  mid3
    3つの数値の中央値を返す
      ✓ passed (0.00s)

2 examples, 0 failures
```

---

## 7. Haskell モジュールシステム

Haskell ではモジュールシステムを使ってコードを整理します。

### モジュールの定義

```haskell
-- src/BasicAlgorithms.hs
module BasicAlgorithms (max3, mid3) where
--      ^モジュール名   ^公開する関数リスト
```

括弧内に列挙した関数のみが外部から使用可能になります（カプセル化）。

### モジュールのインポート

```haskell
-- 特定の関数のみインポート
import BasicAlgorithms (max3, mid3)

-- モジュール全体をインポート
import BasicAlgorithms

-- 修飾付きインポート（名前衝突を避ける）
import qualified BasicAlgorithms as BA

-- 標準ライブラリのインポート例
import Data.List (sort, nub)
import qualified Data.Set as Set
```

---

## 8. 関数型プログラミングの思考方法

Haskell でアルゴリズムを実装する際は、命令型の「どのようにするか」ではなく、関数型の「何であるか」の視点で考えます。

### 命令型 vs 関数型

**命令型（Python）の思考**：
1. 変数 `maximum` を `a` で初期化する
2. `b` が `maximum` より大きければ `maximum` を更新する
3. `c` が `maximum` より大きければ `maximum` を更新する
4. `maximum` を返す

**関数型（Haskell）の思考**：
- `max3 a b c` は `a` と「`b` と `c` の最大値」の最大値である
- `mid3 a b c` は、`a` が `b` と `c` の間にあれば `a`、そうでなければ...（条件の宣言）

### where 節とレット式

Haskell では補助的な定義を `where` 節や `let` 式で記述できます。

```haskell
-- where 節を使った例
mid3WithSort :: Ord a => a -> a -> a -> a
mid3WithSort a b c = sorted !! 1
  where
    sorted = sort [a, b, c]
    sort [] = []
    sort (x:xs) = sort smaller ++ [x] ++ sort larger
      where
        smaller = filter (<= x) xs
        larger  = filter (> x) xs

-- let 式を使った例
mid3WithLet :: Ord a => a -> a -> a -> a
mid3WithLet a b c =
  let sorted = [minimum [a,b,c], mid, maximum [a,b,c]]
      mid = a + b + c - minimum [a,b,c] - maximum [a,b,c]
  in sorted !! 1
```

---

## テスト実行結果

```bash
$ cabal test --test-show-details=always

Running 1 test suites...
Test suite haskell-algorithm-test: RUNNING...

BasicAlgorithms
  max3
    3つの数値の最大値を返す
      ✓ passed (0.00s)
  mid3
    3つの数値の中央値を返す
      ✓ passed (0.00s)

Finished in 0.0012 seconds
2 examples, 0 failures

Test suite haskell-algorithm-test: PASS
Test suite logged to:
  dist-newstyle/build/.../test/haskell-algorithm-test.log
1 of 1 test suites (1 of 1 test cases) passed.
```

---

## Python 版との総合比較

| 観点 | Python 版 | Haskell 版 |
|------|-----------|-----------|
| パラダイム | 命令型・オブジェクト指向 | 純粋関数型 |
| 型システム | 動的型付け（型ヒントで補完） | 静的型付け（強力な型推論）|
| 多相性 | ダックタイピング | 型クラス制約 |
| 副作用 | 許可 | デフォルトで禁止（IO モナドで管理）|
| 条件分岐 | `if/elif/else` | ガード節・パターンマッチ |
| テスト | pytest | HSpec |
| 関数適用 | `f(a, b)` | `f a b`（スペース区切り） |
| コードの簡潔さ | 比較的冗長 | 非常に簡潔 |
| 学習曲線 | 緩やか | 急峻 |

### 実装コードの比較

**max3 の実装比較**：

```python
# Python 版（命令型スタイル）
def max3(a: int, b: int, c: int) -> int:
    maximum = a
    if b > maximum:
        maximum = b
    if c > maximum:
        maximum = c
    return maximum
```

```haskell
-- Haskell 版（関数型スタイル）
max3 :: Ord a => a -> a -> a -> a
max3 a b c = max a (max b c)
```

**mid3 の実装比較**：

```python
# Python 版（深いネスト）
def med3(a: int, b: int, c: int) -> int:
    if a >= b:
        if b >= c:
            return b
        elif a <= c:
            return a
        else:
            return c
    elif a > c:
        return a
    elif b > c:
        return c
    else:
        return b
```

```haskell
-- Haskell 版（フラットなガード節）
mid3 :: Ord a => a -> a -> a -> a
mid3 a b c
  | (a >= b && a <= c) || (a >= c && a <= b) = a
  | (b >= a && b <= c) || (b >= c && b <= a) = b
  | otherwise = c
```

---

## まとめ

この章では、以下の基本的なアルゴリズムを Haskell の TDD で実装しました：

| アルゴリズム | 関数 | Haskell の特徴 |
|-------------|------|--------------|
| 3 値の最大値 | `max3` | `max` 関数の入れ子、型クラス `Ord` |
| 3 値の中央値 | `mid3` | ガード節による条件分岐 |

Haskell でアルゴリズムを実装する際の重要なポイント：

1. **型シグネチャを先に書く** — 入力と出力の型を宣言することで設計が明確になる
2. **型クラスで多相性を表現する** — `Ord a =>` により任意の比較可能な型に対応できる
3. **ガード節で条件を宣言的に記述する** — ネストした if/else より読みやすい
4. **標準ライブラリを活用する** — `max`, `min`, `sort` などの豊富な関数群
5. **TDD サイクルを守る** — Red-Green-Refactor で確実に動作するコードを構築する

TDD の Red-Green-Refactor サイクルを通じて、テストが仕様の役割を果たし、確実に動作するコードを構築できることを確認しました。Haskell の型システムとコンパイル時チェックにより、実行前に多くのバグを検出できることも大きな利点です。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
- 『プログラミング Haskell』 — Graham Hutton
- 『すごい Haskell たのしく学ぼう！』 — Miran Lipovača
- [Haskell 公式ドキュメント](https://www.haskell.org/documentation/)
- [HSpec ドキュメント](https://hspec.github.io/)
