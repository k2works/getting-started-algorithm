# 執筆計画アウトライン

## 概要

「アルゴリズムから始めるプログラミング入門」シリーズの執筆計画。Wiki 記事のうち最も完成度の高い Python 版を原本として再構成し、既存対象言語へ多言語展開する。加えて、TDD 入門を終えた読者向けに、なでしこ3 でアルゴリズムとデータ構造を学ぶ続編を執筆する。

## 対象言語

`ops/nix/environments/` に定義された言語環境と、続編で追加する言語：

| 環境名 | 言語 | Wiki 記事 | 展開元 | 備考 |
|--------|------|-----------|--------|------|
| python | Python | あり（原本） | - | マルチパラダイム、全言語の基準 |
| node | TypeScript | あり（補助参照） | Python | 静的型付き JS |
| java | Java | なし | Python | OOP 代表 |
| dotnet (C#) | C# | なし | Python | .NET OOP |
| ruby | Ruby | なし | Python | 動的型付き OOP |
| php | PHP | なし | Python | Web 特化 |
| go | Go | あり（補助参照） | Python | シンプル志向 |
| rust | Rust | なし | Python | 所有権・メモリ安全性 |
| dotnet (F#) | F# | あり（補助参照） | Python | .NET 関数型 |
| scala | Scala | なし | Python | OOP + FP ハイブリッド |
| clojure | Clojure | あり（補助参照） | Python | LISP + 関数型 |
| haskell | Haskell | あり（補助参照） | Python | 純粋関数型 |
| elixir | Elixir | なし | Python | BEAM VM、並行関数型 |
| nadesiko | なでしこ3 | なし（TDD 入門はあり） | Python と TDD 入門 | 日本語プログラミング。Nix 開発環境の追加が前提 |

## 環境構築方針

### Nix 開発環境

各言語の実行環境は **Nix** で管理する。`ops/nix/environments/` に定義された言語別の `devShell` を使用することで、開発環境の再現性を保証する。

```bash
# 言語別 Nix 環境に入る
nix develop .#python
nix develop .#java
nix develop .#node
nix develop .#ruby
nix develop .#php
nix develop .#go
nix develop .#rust
nix develop .#dotnet
nix develop .#clojure
nix develop .#scala
nix develop .#haskell
nix develop .#elixir
```

Nix 環境に入ることで、言語処理系・ビルドツール・パッケージマネージャーがすべて利用可能になる。ホスト環境に言語をインストールする必要はない。

### パッケージ管理・静的解析・タスクランナー

言語固有のパッケージ管理・静的解析・タスクランナーの設定は `tmp/getting-started-tdd/docs/article/{lang}/05` および `06` を参考にする。

参考元: `tmp/getting-started-tdd/docs/article/{lang}/`

- `05-package-management-and-static-analysis.md` — パッケージ管理と静的解析
- `06-task-runner-and-ci-cd.md` — タスクランナーと CI/CD

### 言語別環境構築仕様

| 言語 | パッケージ管理 | 設定ファイル | リンター/フォーマッター | タスクランナー | テストフレームワーク |
|------|--------------|------------|----------------------|-------------|----------------|
| Python | uv | `pyproject.toml`, `.ruff.toml` | Ruff, mypy | tox | pytest + pytest-cov |
| TypeScript | npm | `package.json`, `eslint.config.mjs`, `tsconfig.json` | ESLint, Prettier | npm scripts | Jest |
| Java | Gradle | `build.gradle` | Checkstyle, PMD, SpotBugs | Gradle tasks | JUnit 5 |
| C# | NuGet (dotnet) | `.csproj`, `.editorconfig` | dotnet format, Roslyn Analyzers | dotnet CLI | xUnit |
| Ruby | Bundler | `Gemfile`, `.rubocop.yml` | RuboCop | Rake | Minitest + SimpleCov |
| PHP | Composer | `composer.json`, `.php-cs-fixer.php` | PHP_CodeSniffer, PHPStan | Composer scripts | PHPUnit |
| Go | Go Modules | `go.mod` | golangci-lint | Makefile / go test | testing (標準) |
| Rust | Cargo | `Cargo.toml`, `rustfmt.toml` | Clippy, rustfmt | cargo | cargo test |
| F# | NuGet (dotnet) | `.fsproj`, `.editorconfig` | Fantomas, Roslyn Analyzers | dotnet CLI | xUnit |
| Scala | sbt | `build.sbt`, `project/plugins.sbt`, `.scalafmt.conf` | scalafmt, WartRemover | sbt tasks | ScalaTest |
| Clojure | Leiningen | `project.clj` | Eastwood, Kibit, cljfmt | Leiningen tasks | clojure.test |
| Haskell | Stack | `package.yaml`, `stack.yaml`, `.hlint.yaml` | HLint, stylish-haskell | stack | Hspec |
| Elixir | Mix | `mix.exs` | Credo, Dialyxir | mix tasks | ExUnit |

### 各言語の apps/ ディレクトリ構造

#### Python (`apps/python/`)

```
apps/python/
├── src/algorithm/          # プロダクションコード
├── tests/                  # テストコード
├── pyproject.toml          # uv + pytest + mypy 設定
├── .ruff.toml              # Ruff（リンター + フォーマッター）設定
└── tox.ini                 # タスクランナー（test/lint/type/format）
```

#### TypeScript (`apps/node/`)

```
apps/node/
├── src/algorithm/          # プロダクションコード
├── test/                   # テストコード
├── package.json            # npm 依存関係 + scripts
├── tsconfig.json           # TypeScript 設定
└── eslint.config.mjs       # ESLint 設定
```

#### Java (`apps/java/`)

```
apps/java/
├── src/main/java/algorithm/  # プロダクションコード
├── src/test/java/algorithm/  # テストコード
├── build.gradle              # Gradle ビルド + Checkstyle/PMD/SpotBugs
└── checkstyle.xml            # Checkstyle 設定
```

#### C# (`apps/dotnet/csharp/`)

```
apps/dotnet/csharp/
├── src/Algorithm/          # プロダクションコード
├── test/Algorithm.Tests/   # テストコード
├── Algorithm.sln           # ソリューションファイル
└── .editorconfig           # フォーマット設定
```

#### Ruby (`apps/ruby/`)

```
apps/ruby/
├── lib/algorithm/          # プロダクションコード
├── test/                   # テストコード
├── Gemfile                 # Bundler 依存関係
└── .rubocop.yml            # RuboCop 設定
```

#### PHP (`apps/php/`)

```
apps/php/
├── src/Algorithm/          # プロダクションコード（PSR-4）
├── tests/                  # テストコード
├── composer.json           # Composer 依存関係
└── phpunit.xml             # PHPUnit 設定
```

#### Go (`apps/go/`)

```
apps/go/
├── algorithm/              # プロダクションコード
├── go.mod                  # Go Modules
└── .golangci.yml           # golangci-lint 設定
```

#### Rust (`apps/rust/`)

```
apps/rust/
├── src/                    # プロダクションコード
├── tests/                  # 統合テスト
├── Cargo.toml              # Cargo 依存関係
└── rustfmt.toml            # rustfmt 設定
```

#### F# (`apps/dotnet/fsharp/`)

```
apps/dotnet/fsharp/
├── src/Algorithm/          # プロダクションコード
├── test/Algorithm.Tests/   # テストコード
├── Algorithm.sln           # ソリューションファイル
└── .editorconfig           # フォーマット設定（Fantomas）
```

#### Scala (`apps/scala/`)

```
apps/scala/
├── src/main/scala/         # プロダクションコード
├── src/test/scala/         # テストコード
├── build.sbt               # sbt ビルド + WartRemover
├── project/plugins.sbt     # sbt プラグイン（scalafmt 等）
└── .scalafmt.conf          # scalafmt 設定
```

#### Clojure (`apps/clojure/`)

```
apps/clojure/
├── src/algorithm/          # プロダクションコード
├── test/algorithm/         # テストコード
└── project.clj             # Leiningen プロジェクト設定
```

#### Haskell (`apps/haskell/`)

```
apps/haskell/
├── src/                    # プロダクションコード
├── test/                   # テストコード（Hspec）
├── package.yaml            # hpack 形式プロジェクト設定
├── stack.yaml              # Stack スナップショット設定
└── .hlint.yaml             # HLint 設定
```

#### Elixir (`apps/elixir/`)

```
apps/elixir/
├── lib/algorithm/          # プロダクションコード
├── test/                   # テストコード（ExUnit）
├── mix.exs                 # Mix プロジェクト設定
└── .credo.exs              # Credo 設定
```

## 執筆方針

### Python 原本方式

参考元の Wiki 記事は 6 言語（Python, TypeScript, Go, Haskell, Clojure, F#）で存在するが、**Python 版が最も完成度が高い**ため、以下の方針で進める。

1. **Python 版を原本として作成**: Wiki の Python 記事を基に `docs/article/python/` を執筆・実装する
2. **Python 版を基に多言語展開**: 完成した Python 版の構成・コード例・解説を基準として、他 11 言語へ展開する
3. **他の Wiki 記事は補助参照**: TypeScript, Go, Haskell, Clojure, F# の Wiki 記事は、言語固有のイディオムや表現の参考として活用する（構成の基準にはしない）

### 展開順序

```
Python（原本）
  ├── OOP 言語: TypeScript → Java → C# → Ruby → PHP
  ├── システム言語: Go → Rust
  └── 関数型言語: F# → Scala → Clojure → Haskell → Elixir
```

- OOP 言語は Python との構造的類似性が高いため、展開コストが低い
- システム言語・関数型言語は言語固有の設計判断が必要なため、後半に配置

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
| Elixir | パターンマッチング、パイプ演算子、BEAM 並行処理、イミュータブル |

### 日本語プログラミング言語

| 言語 | 特色 |
|------|------|
| なでしこ3 | 日本語の語順と助詞による引数指定、配列・辞書、無名関数とクロージャ。`gonako` による実行・lint・format・doctest |

## なでしこ3 版（TDD 入門の続編）

### 位置づけと対象読者

`tmp/getting-started-tdd/docs/article/nadesiko/` の「テスト駆動開発から始める なでしこ3 入門」を修了し、TDD の基本サイクルとなでしこ3 の変数・関数・条件分岐・繰り返しを理解した読者を対象とする。前作で学んだ TDD の手順や開発基盤を繰り返し説明するのではなく、アルゴリズムとデータ構造を題材に、Red → Green → Refactor を継続して実践する。

アルゴリズムの問題・章の範囲は Python 版と対応させて学習順序を一貫させる。アルゴリズムの仕様と題材は既存 Wiki 記事および Python 版を参照し、コード・テスト・解説はなでしこ3 の日本語構文とデータ表現に合わせて書き直す。

### 参照資料と前提条件

- TDD 入門の構成・用語・実装規約: `tmp/getting-started-tdd/docs/article/nadesiko/index.md` および各章
- TDD 入門の実装・テスト構成: `tmp/getting-started-tdd/apps/nadesiko/`
- アルゴリズムの仕様・章構成: 本アウトラインの「章構成」と対応する Wiki 記事、Python 版
- 読者の前提: なでしこ3 の基本文法、TDD の基本サイクル、Git の基本操作
- 実行環境: `gonako`、Go、`make`。前作に合わせて `gonako` 3.8.8 を基準とし、採用バージョンは環境構築時に再確認して固定する

現行リポジトリには `nadesiko` の Nix 開発環境がないため、記事・実装に着手する前に `ops/nix/environments/nadesiko/` と `flake.nix` の `.#nadesiko` を整備し、前作と同じ手順で `gonako` のバージョンを固定する。環境の実装は前作の設定を参照し、記事内の実行例はこのリポジトリで再現できるコマンドに限定する。

### 開発・テスト方針

- 記事は `docs/article/nadesiko/`、実装は `apps/nadesiko/` に配置し、前作の構成を引き継ぐ。
- なでしこ3 のソースは `.nako3` とし、実装を `src/`、テストを `test/` に分ける。
- `ASSERT等` を使ったテストを先に書き、各アルゴリズムの境界値・通常値・失敗条件を確認する。テスト実行は前作の `make test` とテストランナーを再利用する。
- `gonako lint`、`gonako format`、`gonako doctest` を活用し、構文・整形・記事中の実行例を確認する。各章の完了時に `make check` と記事・実装の同期を行う。
- 配列は参照型であり、更新系命令が元データに与える影響をテストで確認する。非破壊的な処理が必要な場合は、配列複製など前作で扱った方法を使う。
- クラス構文を前提とせず、辞書・関数・クロージャによる表現を選ぶ。再帰、配列、辞書の実際の `gonako` 対応命令は各章の執筆時に実行確認する。

### 章構成と執筆時の重点

| 章 | 記事ファイル | テーマ | なでしこ3 で扱う重点 |
|----|-------------|--------|------------------|
| 1 | `01-basic-algorithms.md` | 基本的なアルゴリズム | 3 値の最大値・中央値、条件分岐、繰り返しを小さなテストに分ける。日本語の語順と助詞を保った関数名・呼び出し方を示す |
| 2 | `02-arrays.md` | 配列 | 配列の基本操作・探索・並べ替えを扱う。配列追加などの破壊的操作と、元配列を保つ処理をテストで区別する |
| 3 | `03-search-algorithms.md` | 探索アルゴリズム | 線形探索・二分探索・ハッシュ法を実装する。空配列、未発見、重複値、整列済みという前提をテストで明確にする |
| 4 | `04-stack-and-queue.md` | スタックとキュー | 配列を用いた基本操作を TDD で実装し、空のときの振る舞いを仕様として決めてテストする |
| 5 | `05-recursion.md` | 再帰アルゴリズム | 基底条件と再帰呼び出しをテストで確かめ、再帰と反復を比較する。再帰関数の定義・実行を `gonako` で検証する |
| 6 | `06-sort-algorithms.md` | ソートアルゴリズム | バブル・選択・挿入・クイック・マージソートを扱う。空・単一要素・重複値を含む入力と、入力配列を変更するかを明示する |
| 7 | `07-string-processing.md` | 文字列処理 | 文字列の基本・探索・照合を扱う。日本語文字列と文字位置の扱いは、標準命令の仕様と実行結果を確認して記述する |
| 8 | `08-lists.md` | リスト | 線形・連結・循環・双方向リストを扱う。ノードを辞書で表現する場合はキーと更新責務を関数に閉じ込める |
| 9 | `09-tree-structures.md` | 木構造 | 二分木・探索木・ヒープを扱う。ノードの辞書表現、再帰走査、親子関係の不変条件をテストで確認する |

### ファイル構成

```text
docs/article/nadesiko/
├── index.md
├── 01-basic-algorithms.md
├── 02-arrays.md
├── 03-search-algorithms.md
├── 04-stack-and-queue.md
├── 05-recursion.md
├── 06-sort-algorithms.md
├── 07-string-processing.md
├── 08-lists.md
└── 09-tree-structures.md

apps/nadesiko/
├── src/                  # アルゴリズムの実装（.nako3）
├── test/                 # ASSERT等によるテスト（*_test.nako3）
├── Makefile              # make test / lint / format / doctest / check
└── doctest/              # gonako doctest 用の受け入れテスト
```

各章は前作と同じく、仕様と TODO リストの整理、テスト作成（Red）、最小実装（Green）、リファクタリング、実行例と実装の同期確認の順に執筆する。全 9 章の完了後に `index.md` と MkDocs ナビゲーションを更新する。

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
├── elixir/               # Elixir
│   ├── index.md
│   └── ...
├── nadesiko/             # なでしこ3（TDD 入門の続編）
│   ├── index.md
│   ├── 01-basic-algorithms.md
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
├── haskell/              # Haskell プロジェクト
├── elixir/               # Elixir プロジェクト
└── nadesiko/             # なでしこ3 プロジェクト
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
