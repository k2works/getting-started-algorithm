# アルゴリズムから始める Ruby 入門

Ruby を使ってアルゴリズムとデータ構造を TDD で学ぶシリーズです。

## 章構成

### 第 1 部: 基本

| 章 | テーマ |
|----|--------|
| [第 1 章 基本的なアルゴリズム](01-basic-algorithms.md) | 3 値の最大値・中央値、条件判定、繰り返し処理、多重ループ |
| [第 2 章 配列](02-arrays.md) | 配列の基本操作、基数変換、素数列挙 |
| [第 3 章 探索アルゴリズム](03-search-algorithms.md) | 線形探索、二分探索、ハッシュ法 |

### 第 2 部: データ構造

| 章 | テーマ |
|----|--------|
| [第 4 章 スタックとキュー](04-stacks-and-queues.md) | 固定長スタック、固定長キュー（リングバッファ） |
| [第 5 章 再帰アルゴリズム](05-recursion.md) | 階乗、最大公約数、ハノイの塔、8 王妃問題 |

### 第 3 部: ソートと文字列

| 章 | テーマ |
|----|--------|
| [第 6 章 ソートアルゴリズム](06-sort-algorithms.md) | バブル、選択、挿入、シェル、クイック、マージ、ヒープ、度数ソート |
| [第 7 章 文字列処理](07-string-processing.md) | ブルートフォース、KMP、Boyer-Moore、文字カウント、回文判定 |

### 第 4 部: 高度なデータ構造

| 章 | テーマ |
|----|--------|
| [第 8 章 リスト](08-linked-lists.md) | 単方向連結リスト、双方向連結リスト、配列カーソル版リスト |
| [第 9 章 木構造](09-trees.md) | 二分探索木（挿入、探索、削除、走査） |

## 実装コード

実装コードは [`apps/ruby/`](https://github.com/k2works/getting-started-algorithm/tree/main/apps/ruby) にあります。

## 環境

- Ruby: 3.3.x
- テストフレームワーク: RSpec
- Nix devShell: `.#ruby`

```bash
# Nix 環境に入る
nix develop .#ruby

# テスト実行
cd apps/ruby
bundle install
bundle exec rspec
```

## Ruby の特徴

Python 版と比較した主な相違点:

| 概念 | Python | Ruby |
|------|--------|------|
| モジュール | なし（関数として定義） | `module Algorithm` + `def self.メソッド名` |
| 例外 | `class MyErr(Exception):` | `class MyErr < StandardError; end` |
| for ループ | `for i in range(n):` | `n.times { \|i\| }` / `(0...n).each` |
| 奇偶判定 | `n % 2 == 0` | `n.even?` / `n.odd?` |
| 配列の長さ | `len(a)` | `a.length` / `a.size` |
| 逆順文字列 | `s[::-1]` | `s.reverse` |
| ハッシュデフォルト値 | `d.get(key, default)` | `d.fetch(key, default)` |
| 型チェック | `isinstance(x, T)` | `x.is_a?(T)` |
| nil チェック | `x is None` | `x.nil?` |
| 同一性チェック | `x is y` | `x.equal?(y)` |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
