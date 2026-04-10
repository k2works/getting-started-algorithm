# 執筆ワークフロー

## 概要

本記事は `outline.md` に定義された構成に従い、章ごとに執筆と実装を同期しながら進める。

## ワークフロー図

```plantuml
@startuml
title 執筆ワークフロー

start

:章の選択;
note right
  outline.md から
  次の章を選択
end note

:参照記事の確認;
note right
  tmp/wiki/記事/アルゴリズム/
  アルゴリズムから始める{言語}入門/
  から該当記事を参照
end note

:執筆;
note right
  指定された言語で
  章の内容を執筆
end note

:レビュー;

if (修正が必要?) then (yes)
  :修正;
  -> 執筆;
else (no)
endif

:実装;
note right
  執筆内容に基づき
  TDD でコードを実装
end note

:同期確認;
note right
  執筆内容と実装の
  整合性を確認
end note

if (不整合あり?) then (yes)
  :執筆内容を更新;
  -> 同期確認;
else (no)
endif

:章の完了;

:mkdocs.yml 更新;
note right
  ナビゲーションに
  章を追加
end note

:ローカルプレビュー確認;

if (次の章あり?) then (yes)
  -> 章の選択;
else (no)
  :記事完成;
  stop
endif

@enduml
```

## 詳細フロー

```plantuml
@startuml
title 章ごとの執筆・実装サイクル

|執筆|
start
:outline.md から章を選択;
:参照記事を特定;

|参照|
:参照記事を読み込み;
note right
  tmp/wiki/記事/アルゴリズム/
  アルゴリズムから始める{言語}入門/
  - 第1章: 基本的なアルゴリズム
  - 第2章: 配列
  - 第3章: 探索アルゴリズム
  - 第4章: スタックとキュー
  - 第5章: 再帰アルゴリズム
  - 第6章: ソートアルゴリズム
  - 第7章: 文字列処理
  - 第8章: リスト
  - 第9章: 木構造
end note

|執筆|
:章の構成を確認;
:本文を執筆;
:コード例を作成;

|レビュー|
:内容レビュー;
:技術的正確性の確認;

|実装|
:Nix 環境に入る;
note right
  nix develop .#{lang}
end note
:apps/{lang}/ にプロジェクト作成;
note right
  apps/{lang}/ 配下に
  言語固有のプロジェクトを構築
end note
:テストファースト（Red）;
:最小実装（Green）;
:リファクタリング;
:動作確認;

|同期|
:執筆内容と実装の照合;

if (差異あり?) then (yes)
  :執筆内容を修正;
  :実装を修正;
else (no)
endif

:章の完了をマーク;

|公開|
:mkdocs.yml に章を追加;
:mkdocs serve でプレビュー;

if (表示問題あり?) then (yes)
  :問題を修正;
else (no)
endif

:index.md のリンクを有効化;

|執筆|
if (全章完了?) then (no)
  -> outline.md から章を選択;
else (yes)
  :最終レビュー;
  :mkdocs build;
  :記事公開;
  stop
endif

@enduml
```

## MkDocs 反映ワークフロー

```plantuml
@startuml
title MkDocs 反映フロー

start

:章ファイル作成;
note right
  docs/article/{lang}/
  NN-chapter-name.md
end note

:mkdocs.yml 更新;
note right
  nav セクションに
  新しい章を追加
end note

:index.md 更新;
note right
  目次リンクを
  有効化
end note

:ローカルプレビュー;
note right
  npm run docs:serve
  http://localhost:8000
end note

if (問題あり?) then (yes)
  :修正;
  -> ローカルプレビュー;
else (no)
endif

:コミット;

if (デプロイ?) then (yes)
  :npm run docs:build;
  :デプロイ実行;
else (no)
endif

stop

@enduml
```

### MkDocs 更新手順

#### 1. mkdocs.yml への章追加

```yaml
nav:
  - 記事:
      - 概要: article/index.md
      - Python:
          - 概要: article/python/index.md
          - 基本的なアルゴリズム: article/python/01-basic-algorithms.md
          - 配列: article/python/02-arrays.md
```

#### 2. ローカルプレビュー

```bash
# サーバー起動
npm run docs:serve

# ブラウザで確認
# http://localhost:8000
```

#### 3. ビルド・デプロイ

```bash
# 静的サイト生成
npm run docs:build
```

### MkDocs チェックリスト

- [ ] 章ファイルが正しいパスに配置されている
- [ ] mkdocs.yml の nav に章が追加されている
- [ ] index.md のリンクが正しい
- [ ] ローカルプレビューで表示確認済み
- [ ] PlantUML ダイアグラムが正しくレンダリングされる
- [ ] 内部リンクが正常に動作する

## 執筆ルール

### 1. 章の選択

- `outline.md` の順序に従って進める
- 言語間の依存はないため、1 言語ずつ全 9 章を通しで書いても、1 章ずつ全言語横断で書いてもよい
- 推奨: 1 言語ずつ第 1〜9 章を通しで執筆し、実装も同時に完成させる

### 2. 参照記事

Wiki 記事が存在する言語は参照元として活用する。

| 言語 | 参照先（Wiki） | ステータス |
|------|--------------|-----------|
| Python | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるPython入門/` | 原本 |
| TypeScript | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるTypeScript入門/` | あり |
| Go | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるGo入門/` | あり |
| Haskell | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるHaskell入門/` | あり |
| Clojure | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるClojure入門/` | あり |
| F# | `tmp/wiki/記事/アルゴリズム/アルゴリズムから始めるF#入門/` | あり |
| Java | - | 新規執筆 |
| C# | - | 新規執筆 |
| Ruby | - | 新規執筆 |
| PHP | - | 新規執筆 |
| Rust | - | 新規執筆 |
| Scala | - | 新規執筆 |

### 3. 執筆フォーマット

```markdown
# 第N章: 章タイトル

## N.1 セクションタイトル

本文...

### コード例

\```python
# テストコード
import unittest

class TestAlgorithm(unittest.TestCase):
    def test_example(self):
        # Arrange
        # Act
        # Assert
        pass
\```

### TDD サイクル

\```plantuml
@startuml
:Red: テスト作成;
:Green: 最小実装;
:Refactor: コード改善;
@enduml
\```

### 実装

<details>
<summary>実装コード</summary>

\```python
def algorithm():
    # ...
    pass
\```

</details>
```

- タスク項目などは一行開けて記述する

- NG

  ```markdown
    **受入条件**:
    - [ ] テストが通る
    - [ ] リファクタリング済み
  ```

- OK

  ```markdown
    **受入条件**:

    - [ ] テストが通る
    - [ ] リファクタリング済み
  ```

### 4. 実装同期チェックリスト

- [ ] `apps/{lang}/` にプロジェクトが作成されている
- [ ] テストコードが執筆内容と一致
- [ ] プロダクションコードが一致
- [ ] テスト実行結果が記事の記述と一致
- [ ] リファクタリング後のコードが反映済み
- [ ] 記事内のコード例が `apps/{lang}/` の実コードと同期している

## ファイル構成

### 記事（docs/article/）

```
docs/article/
├── index.md              # 記事トップページ（目次）
├── outline.md            # 執筆計画アウトライン
├── workflow.md           # 本ファイル（執筆ワークフロー）
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
├── node/                 # TypeScript
├── ruby/                 # Ruby
├── php/                  # PHP
├── go/                   # Go
├── rust/                 # Rust
├── csharp/               # C#
├── fsharp/               # F#
├── clojure/              # Clojure
├── scala/                # Scala
├── haskell/              # Haskell
└── all/                  # 多言語統合解説
```

### 実装コード（apps/）

各言語の実装コードは `apps/` ディレクトリ配下に言語ごとのディレクトリを作成して配置する。ディレクトリ名は `ops/nix/environments/` と一致させる。

```
apps/
├── java/                 # Java（Maven/Gradle プロジェクト）
│   ├── src/
│   │   ├── main/java/
│   │   └── test/java/
│   └── pom.xml or build.gradle
├── node/                 # TypeScript（npm プロジェクト）
│   ├── src/
│   ├── test/
│   └── package.json
├── python/               # Python（uv/poetry プロジェクト）
│   ├── src/
│   ├── tests/
│   └── pyproject.toml
├── ruby/                 # Ruby（Bundler プロジェクト）
│   ├── lib/
│   ├── test/
│   └── Gemfile
├── php/                  # PHP（Composer プロジェクト）
│   ├── src/
│   ├── tests/
│   └── composer.json
├── go/                   # Go（Go Modules プロジェクト）
│   ├── algorithm/
│   └── go.mod
├── rust/                 # Rust（Cargo プロジェクト）
│   ├── src/
│   ├── tests/
│   └── Cargo.toml
├── dotnet/               # C# / F#（.NET プロジェクト）
│   ├── src/
│   ├── test/
│   └── *.sln
├── clojure/              # Clojure（deps.edn プロジェクト）
│   ├── src/
│   ├── test/
│   └── deps.edn
├── scala/                # Scala（sbt プロジェクト）
│   ├── src/
│   └── build.sbt
└── haskell/              # Haskell（Cabal/Stack プロジェクト）
    ├── src/
    ├── test/
    └── package.yaml or *.cabal
```

### 記事と実装の対応関係

```
docs/article/{lang}/NN-chapter-name.md  ←→  apps/{lang}/
     （記事・解説）                          （実装コード）
```

記事内のコード例は `apps/{lang}/` の実際のコードと一致させる。実装を先に TDD で進め、動作確認済みのコードを記事に転記する。

## 開発環境

各言語の開発環境は Nix で管理する。

```bash
# 言語別環境に入る
nix develop .#java
nix develop .#node
nix develop .#python
nix develop .#ruby
nix develop .#php
nix develop .#go
nix develop .#rust
nix develop .#dotnet
nix develop .#clojure
nix develop .#scala
nix develop .#elixir
nix develop .#haskell
```

### 実装の始め方

```bash
# 1. Nix 環境に入る
nix develop .#python

# 2. apps/{lang}/ に移動（初回はディレクトリ作成）
cd apps/python

# 3. 言語固有のプロジェクトを初期化
#    例: Python の場合
#    uv init
#    例: Java の場合
#    gradle init --type java-application

# 4. TDD サイクル開始
#    テスト作成 → 実行（Red） → 実装（Green） → リファクタリング
```

## 進捗管理

| 言語 | 第 1 部 | 第 2 部 | 第 3 部 | 第 4 部 | ステータス |
|------|--------|--------|--------|--------|----------|
| Python | 未着手 | 未着手 | 未着手 | 未着手 | - |
| TypeScript | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Java | 未着手 | 未着手 | 未着手 | 未着手 | - |
| C# | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Ruby | 未着手 | 未着手 | 未着手 | 未着手 | - |
| PHP | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Go | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Rust | 未着手 | 未着手 | 未着手 | 未着手 | - |
| F# | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Scala | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Clojure | 未着手 | 未着手 | 未着手 | 未着手 | - |
| Haskell | 未着手 | 未着手 | 未着手 | 未着手 | - |
| 統合解説 | 未着手 | 未着手 | 未着手 | 未着手 | - |
