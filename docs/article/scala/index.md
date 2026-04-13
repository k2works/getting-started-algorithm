# Scala 版 アルゴリズムとデータ構造

Scala（JVM 上で動く関数型・オブジェクト指向ハイブリッド言語）でアルゴリズムとデータ構造を TDD で学ぶシリーズです。

## 言語の特徴

- **JVM**: Java と同じ実行環境、Java ライブラリの活用可能
- **静的型付け**: 型推論で簡潔に書ける
- **関数型**: イミュータブルなデータ、高階関数、`Option[T]`
- **オブジェクト指向**: `class`、`trait`、`object`
- **Scala 3**: 新しいインデントベース構文、`enum`、Union Type

## 章一覧

| 章 | タイトル | テスト数 |
|----|---------|---------|
| [第 1 章](01-basic-algorithms.md) | 基本的なアルゴリズム | 13 |
| [第 2 章](02-arrays.md) | 配列 | 10 |
| [第 3 章](03-search-algorithms.md) | 探索アルゴリズム | 16 |
| [第 4 章](04-stacks-and-queues.md) | スタックとキュー | 17 |
| [第 5 章](05-recursion.md) | 再帰アルゴリズム | 13 |
| [第 6 章](06-sort-algorithms.md) | ソートアルゴリズム | 11 |
| [第 7 章](07-strings.md) | 文字列処理 | 13 |
| [第 8 章](08-linked-lists.md) | リスト | 20 |
| [第 9 章](09-trees.md) | 木構造 | 12 |

合計テスト数: **123**

## 環境構築

```bash
nix develop .#scala
cd apps/scala
sbt test
```

## Python 版・Java 版との比較

| 特徴 | Python | Java | Scala |
|------|--------|------|-------|
| 型システム | 動的型付け | 静的型付け | 静的型付け（型推論） |
| null 安全 | None | null | `Option[T]` / Union Type |
| パターンマッチ | match（3.10+） | switch（21+） | `match { case ... }` |
| 関数型 | 限定的 | Stream API | 完全サポート |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
