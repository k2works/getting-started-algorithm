# 執筆計画アウトライン

## 概要

「アルゴリズムから始めるプログラミング入門」シリーズの執筆計画。Wiki 記事（Python, TypeScript, Go, Haskell, Clojure, F#）の内容を再構成し、12 言語で統一的な章構成の記事として執筆する。

## 対象言語

`ops/nix/environments/` に定義された 12 言語環境：

| 環境名 | 言語 | Wiki 記事 | 備考 |
|--------|------|-----------|------|
| java | Java | なし | OOP 代表、新規執筆 |
| node | TypeScript | あり | 静的型付き JS |
| python | Python | あり | マルチパラダイム、原本 |
| ruby | Ruby | なし | 動的型付き OOP |
| php | PHP | なし | Web 特化 |
| go | Go | あり | シンプル志向 |
| rust | Rust | なし | 所有権・メモリ安全性 |
| dotnet (C#) | C# | なし | .NET OOP |
| dotnet (F#) | F# | あり | .NET 関数型 |
| clojure | Clojure | あり | LISP + 関数型 |
| scala | Scala | なし | OOP + FP ハイブリッド |
| haskell | Haskell | あり | 純粋関数型 |

## 章構成

Wiki 記事の 9 章構成をそのまま維持する。各章はアルゴリズムとデータ構造のテーマごとに分かれており、TDD で段階的に実装する。

### 第 1 部: 基本（第 1〜3 章）

基本的なアルゴリズム、配列操作、探索の基礎を学ぶ。

| 章 | テーマ | 内容 |
|----|--------|------|
| 1 | 基本的なアルゴリズム | 3 値の最大値・中央値、条件判定と分岐、繰り返し処理、多重ループ |
| 2 | 配列 | 配列の基本操作、配列の探索、要素の並べ替え |
| 3 | 探索アルゴリズム | 線形探索、二分探索、ハッシュ法 |

### 第 2 部: データ構造（第 4〜5 章）

スタック・キューと再帰アルゴリズムを学ぶ。

| 章 | テーマ | 内容 |
|----|--------|------|
| 4 | スタックとキュー | スタックの概念と実装、キューの概念と実装 |
| 5 | 再帰アルゴリズム | 再帰の基本、再帰と反復、再帰の応用 |

### 第 3 部: ソートと文字列（第 6〜7 章）

各種ソートアルゴリズムと文字列処理を学ぶ。

| 章 | テーマ | 内容 |
|----|--------|------|
| 6 | ソートアルゴリズム | バブルソート、選択ソート、挿入ソート、クイックソート、マージソート |
| 7 | 文字列処理 | 文字列の基本、文字列の探索、文字列の照合 |

### 第 4 部: 高度なデータ構造（第 8〜9 章）

リストと木構造を学ぶ。

| 章 | テーマ | 内容 |
|----|--------|------|
| 8 | リスト | 線形リスト、連結リスト、循環リスト、双方向リスト |
| 9 | 木構造 | 二分木、探索木、ヒープ |

## 言語ごとのバリエーション

### OOP 言語（手続き的・オブジェクト指向的アプローチ）

| 言語 | 特色 |
|------|------|
| Java | クラスベース OOP、コレクションフレームワーク |
| C# | LINQ、ジェネリクス、パターンマッチング |
| TypeScript | 静的型付き、Array メソッド、ジェネリクス |
| Python | リスト内包表記、ジェネレータ、動的型付き |
| Ruby | ブロック、Enumerable、動的型付き |
| PHP | SPL データ構造、ジェネレータ |

### システム言語（メモリ管理・パフォーマンス志向）

| 言語 | 特色 |
|------|------|
| Go | スライス、ゴルーチン対応データ構造、シンプルな構文 |
| Rust | 所有権、ライフタイム、Iterator トレイト、安全なメモリ管理 |

### 関数型言語（関数型・イミュータブルアプローチ）

| 言語 | 特色 |
|------|------|
| F# | 判別共用体、パイプライン演算子、パターンマッチング |
| Scala | sealed trait、case class、関数型コレクション |
| Clojure | 永続データ構造、REPL 駆動、マルチメソッド |
| Haskell | 代数的データ型、型クラス、遅延評価、モナド |

## ファイル構成

```
docs/article/
├── index.md              # 記事トップページ（目次）
├── outline.md            # 本ファイル（執筆計画）
├── workflow.md           # 執筆ワークフロー
├── python/               # Python（原本）
│   ├── index.md
│   ├── 01-basic-algorithms.md
│   ├── 02-arrays.md
│   ├── 03-search-algorithms.md
│   ├── 04-stack-and-queue.md
│   ├── 05-recursion.md
│   ├── 06-sort-algorithms.md
│   ├── 07-string-processing.md
│   ├── 08-lists.md
│   └── 09-tree-structures.md
├── java/                 # Java
│   ├── index.md
│   └── ...
├── node/                 # TypeScript
│   ├── index.md
│   └── ...
├── ruby/                 # Ruby
│   ├── index.md
│   └── ...
├── php/                  # PHP
│   ├── index.md
│   └── ...
├── go/                   # Go
│   ├── index.md
│   └── ...
├── rust/                 # Rust
│   ├── index.md
│   └── ...
├── csharp/               # C#
│   ├── index.md
│   └── ...
├── fsharp/               # F#
│   ├── index.md
│   └── ...
├── clojure/              # Clojure
│   ├── index.md
│   └── ...
├── scala/                # Scala
│   ├── index.md
│   └── ...
├── haskell/              # Haskell
│   ├── index.md
│   └── ...
└── all/                  # 多言語統合解説
    ├── index.md
    └── ...
```

## 実装コードの配置

各言語の実装コードは `apps/` ディレクトリに配置する。

```
apps/
├── java/                 # Java プロジェクト
├── node/                 # TypeScript プロジェクト
├── python/               # Python プロジェクト
├── ruby/                 # Ruby プロジェクト
├── php/                  # PHP プロジェクト
├── go/                   # Go プロジェクト
├── rust/                 # Rust プロジェクト
├── dotnet/               # C# / F# プロジェクト
├── clojure/              # Clojure プロジェクト
├── scala/                # Scala プロジェクト
└── haskell/              # Haskell プロジェクト
```

## Wiki 記事との対応

| 章 | Wiki ファイル名 | 記事ファイル名 |
|----|----------------|---------------|
| 第 1 章 | 第1章_基本的なアルゴリズム.md | 01-basic-algorithms.md |
| 第 2 章 | 第2章_配列.md | 02-arrays.md |
| 第 3 章 | 第3章_探索アルゴリズム.md | 03-search-algorithms.md |
| 第 4 章 | 第4章_スタックとキュー.md | 04-stack-and-queue.md |
| 第 5 章 | 第5章_再帰アルゴリズム.md | 05-recursion.md |
| 第 6 章 | 第6章_ソートアルゴリズム.md | 06-sort-algorithms.md |
| 第 7 章 | 第7章_文字列処理.md | 07-string-processing.md |
| 第 8 章 | 第8章_リスト.md | 08-lists.md |
| 第 9 章 | 第9章_木構造.md | 09-tree-structures.md |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 - 柴田望洋
- 『テスト駆動開発』 - Kent Beck
