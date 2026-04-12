# アルゴリズムから始める PHP 入門

PHP を使ってアルゴリズムとデータ構造を TDD で学ぶシリーズです。

## 章構成

### 第 1 部: 基本

| 章 | テーマ |
|----|--------|
| [第 1 章 基本的なアルゴリズム](01-basic-algorithms.md) | 3 値の最大値・中央値、条件判定、繰り返し処理、多重ループ |
| [第 2 章 配列](02-arrays.md) | 配列の基本操作、探索、並べ替え |
| [第 3 章 探索アルゴリズム](03-search-algorithms.md) | 線形探索、二分探索、ハッシュ法 |

### 第 2 部: データ構造

| 章 | テーマ |
|----|--------|
| [第 4 章 スタックとキュー](04-stacks-and-queues.md) | スタックの概念と実装、キューの概念と実装 |
| [第 5 章 再帰アルゴリズム](05-recursion.md) | 再帰の基本、再帰と反復、再帰の応用 |

### 第 3 部: ソートと文字列

| 章 | テーマ |
|----|--------|
| [第 6 章 ソートアルゴリズム](06-sort-algorithms.md) | バブルソート、選択ソート、挿入ソート、クイックソート、マージソート |
| [第 7 章 文字列処理](07-string-processing.md) | 文字列の基本、探索、照合 |

### 第 4 部: 高度なデータ構造

| 章 | テーマ |
|----|--------|
| [第 8 章 リスト](08-linked-lists.md) | 線形リスト、連結リスト、循環リスト、双方向リスト |
| [第 9 章 木構造](09-trees.md) | 二分木、探索木、ヒープ |

## Python 版との違い

| 概念 | Python | PHP |
|------|--------|-----|
| 型宣言 | 型ヒント（任意） | `declare(strict_types=1)` + 型宣言（強制） |
| 静的メソッド | `@staticmethod def method():` | `public static function method(): type` |
| テスト | `pytest` | `PHPUnit 11` |
| DataProvider | `@pytest.mark.parametrize` | `#[DataProvider('method')]` |
| 整数除算 | `x // y` | `intdiv($x, $y)` |
| 文字列補間 | `f"{x}"` | `"{$x}"` / `sprintf()` |
| 配列参照渡し | なし（リストは参照型） | `array &$a`（参照渡し） |
| None | `None` | `null` |
| 例外 | `class MyErr(Exception)` | `\UnderflowException` / `\OverflowException` |
| 列挙型 | `Enum` クラス | `enum BucketStatus { ... }` |

## 実装コード

実装コードは [`apps/php/`](https://github.com/k2works/getting-started-algorithm/tree/main/apps/php) にあります。

## 環境

- PHP: 8.5.x
- テストフレームワーク: PHPUnit 11
- Nix devShell: `.#php`

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
