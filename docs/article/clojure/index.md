# Clojure 版 アルゴリズムとデータ構造

Clojure（JVM 上で動く Lisp 系関数型言語）でアルゴリズムとデータ構造を TDD で学ぶシリーズです。

## 言語の特徴

- **JVM**: Java と同じ実行環境、Java ライブラリの活用可能
- **Lisp 系**: S 式によるホモイコニックな構文、マクロによるメタプログラミング
- **不変データ構造**: `vector`・`list`・`map`・`set` がデフォルトで不変
- **高階関数**: `map`・`filter`・`reduce` による宣言的なデータ変換
- **`loop/recur`**: 末尾再帰最適化による効率的な繰り返し処理
- **`atom`**: 可変状態の管理（必要最小限で使用）

## 章一覧

| 章 | タイトル | テスト数 |
|----|---------|---------|
| [第 1 章](01-basic-algorithms.md) | 基本的なアルゴリズム | 9 |
| [第 2 章](02-arrays.md) | 配列 | 6 |
| [第 3 章](03-search-algorithms.md) | 探索アルゴリズム | 4 |
| [第 4 章](04-stacks-and-queues.md) | スタックとキュー | 2 |
| [第 5 章](05-recursion.md) | 再帰アルゴリズム | 4 |
| [第 6 章](06-sort-algorithms.md) | ソートアルゴリズム | 7 |
| [第 7 章](07-strings.md) | 文字列処理 | 6 |
| [第 8 章](08-linked-lists.md) | リスト | 1 |
| [第 9 章](09-trees.md) | 木構造 | 8 |

合計テスト数: **50**（204 アサーション）

## 環境構築

```bash
nix develop .#clojure
cd apps/clojure
lein test
```

## Python 版・Scala 版との比較

| 特徴 | Python | Scala | Clojure |
|------|--------|-------|---------|
| 型システム | 動的型付け | 静的型付け（型推論） | 動的型付け |
| パラダイム | マルチパラダイム | 関数型 + OOP | 関数型（Lisp 系） |
| null 安全 | None | `Option[T]` | `nil` |
| データ構造 | ミュータブル | イミュータブル | イミュータブル |
| ループ | `for`・`while` | `for`・再帰 | `loop/recur`・`map`・`reduce` |
| テスト | pytest | ScalaTest | `clojure.test` |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
