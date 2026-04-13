# アルゴリズムから始める Haskell 入門

Haskell を使ってアルゴリズムとデータ構造を TDD で学ぶシリーズです。

Haskell は純粋関数型プログラミング言語です。代数的データ型（ADT）、強力な型クラスシステム、遅延評価、そして副作用を `IO` モナドで明示する設計により、アルゴリズムの本質を型で表現し、コンパイル時に多くのバグを検出できます。

## Haskell の主な特徴

| 特徴 | 説明 |
|------|------|
| **純粋関数型** | 同じ引数には必ず同じ結果（参照透明性）。副作用は `IO` 型で明示 |
| **強力な型システム** | コンパイル時の型検査。型クラスによるアドホック多相 |
| **代数的データ型（ADT）** | `data Tree a = Leaf \| Node a (Tree a) (Tree a)` で木構造を型で表現 |
| **パターンマッチング** | 構造に応じた宣言的な処理。コンパイラが網羅性を検査 |
| **遅延評価** | 必要になるまで計算しない。無限リストが扱える |
| **型推論** | 多くの場合、型注釈を省略できる |
| **高階関数** | `map`、`filter`、`foldr` などの強力な関数合成 |

## 環境構築

### Nix 開発シェルを使う（推奨）

```bash
# プロジェクトルートで Haskell 開発シェルに入る
nix develop .#haskell

# Haskell のバージョン確認
ghc --version
cabal --version
```

### cabal でテストを実行する

```bash
# apps/haskell ディレクトリに移動
cd apps/haskell

# 依存パッケージのインストール
cabal install --only-dependencies

# ビルド
cabal build

# テスト実行
cabal test

# テスト詳細を表示
cabal test --test-show-details=streaming

# 特定のテストのみ実行
cabal test --test-options="--match /Strings/"
```

### テストフレームワーク

このプロジェクトでは **Hspec** を使用します：

```haskell
import Test.Hspec

spec :: Spec
spec = do
  describe "bruteForceSearch" $ do
    it "総当たり法で部分文字列を探す" $ do
      bruteForceSearch "mississippi" "issi" `shouldBe` Just 1
      bruteForceSearch "mississippi" "xxx"  `shouldBe` Nothing
```

## 章構成

### 第 1 部: 基本

| 章 | テーマ |
|----|--------|
| [第 1 章 基本的なアルゴリズム](01_basic_algorithms.md) | 3 値の最大値・中央値、条件判定、繰り返し処理、多重ループ |
| [第 2 章 配列](02_arrays.md) | リスト操作、基数変換、素数列挙 |
| [第 3 章 探索アルゴリズム](03_search_algorithms.md) | 線形探索、二分探索、ハッシュ法 |

### 第 2 部: データ構造

| 章 | テーマ |
|----|--------|
| [第 4 章 スタックとキュー](04_stacks_and_queues.md) | スタックの概念と実装、キューの概念と実装 |
| [第 5 章 再帰アルゴリズム](05_recursion.md) | 再帰の基本、再帰と反復、再帰の応用 |

### 第 3 部: ソートと文字列

| 章 | テーマ |
|----|--------|
| [第 6 章 ソートアルゴリズム](06_sort_algorithms.md) | バブルソート、選択ソート、挿入ソート、クイックソート、マージソート |
| [第 7 章 文字列処理](07_strings.md) | BF 法、KMP 法、BM 法、文字数カウント、逆順、回文判定 |

### 第 4 部: 高度なデータ構造

| 章 | テーマ |
|----|--------|
| [第 8 章 連結リスト](08_linked_lists.md) | IORef による可変リスト、単方向リスト、双方向リスト |
| [第 9 章 木構造](09_trees.md) | 代数的データ型による BST、走査 3 種、最小値・最大値、削除 |

## Python 版との対応

| 概念 | Python | Haskell |
|------|--------|---------|
| 型宣言 | 型ヒント（任意） | 静的型付き（コンパイル時検査） |
| テスト | `pytest` | `hspec` + `cabal test` |
| クラス | `class Foo:` | `data Foo = ...` + 関数 |
| 例外 | `raise Exception` | `Maybe a` / `Either e a` |
| リスト | `list`（動的配列） | `[a]`（連結リスト、不変） |
| 辞書 | `dict` | `Data.Map.Strict` |
| None | `None` | `Nothing`（`Maybe a`） |
| 可変状態 | デフォルトで可変 | `IORef a`（`IO` モナド内） |
| ループ | `for` / `while` | 再帰 / `map` / `foldr` |
| 文字列 | `str` | `String = [Char]` |
| パターンマッチ | `match`（Python 3.10+） | `case` + 関数定義（強力） |
| 並列処理 | `threading` / `asyncio` | `STM`、`Async` |
| 木構造 | クラスのポインタ | 代数的データ型（ADT） |

## Haskell の主要な型

```haskell
-- Maybe: 失敗を安全に表現
data Maybe a = Nothing | Just a

-- Either: エラーと成功を表現
data Either e a = Left e | Right a

-- IORef: 可変参照（IO モナド内）
newtype IORef a = IORef (STRef RealWorld a)

-- BST: 代数的データ型による木構造
data BST a = Empty | Node a (BST a) (BST a)
```

## TDD のサイクル

Haskell での TDD は **Red → Green → Refactor** のサイクルで進めます：

```
1. Red   — 失敗するテストを書く
   hspec でテストを記述 → コンパイルエラー or テスト失敗

2. Green — テストを通す最小限の実装
   関数を実装 → cabal test で確認

3. Refactor — 設計を改善する
   型シグネチャの改善、ポイントフリースタイルへの変換など
```

## 実装コード

実装コードは [`apps/haskell/`](https://github.com/k2works/getting-started-algorithm/tree/main/apps/haskell) にあります。

```
apps/haskell/
├── src/
│   ├── BasicAlgorithms.hs   # 第 1 章
│   ├── Arrays.hs            # 第 2 章
│   ├── SearchAlgorithms.hs  # 第 3 章
│   ├── StacksAndQueues.hs   # 第 4 章
│   ├── Recursion.hs         # 第 5 章
│   ├── SortAlgorithms.hs    # 第 6 章
│   ├── Strings.hs           # 第 7 章
│   ├── LinkedLists.hs       # 第 8 章
│   └── Trees.hs             # 第 9 章
└── test/
    ├── BasicAlgorithmsSpec.hs
    ├── ArraysSpec.hs
    ├── SearchAlgorithmsSpec.hs
    ├── StacksAndQueuesSpec.hs
    ├── RecursionSpec.hs
    ├── SortAlgorithmsSpec.hs
    ├── StringsSpec.hs
    ├── LinkedListsSpec.hs
    └── TreesSpec.hs
```

## 参考文献

- 『アルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
- 『Real World Haskell』 — Bryan O'Sullivan
- 『プログラミング Haskell（第 2 版）』 — Graham Hutton
- [Haskell 公式サイト](https://www.haskell.org/)
- [Hspec ドキュメント](https://hspec.github.io/)
- [Hackage（Haskell パッケージリポジトリ）](https://hackage.haskell.org/)
