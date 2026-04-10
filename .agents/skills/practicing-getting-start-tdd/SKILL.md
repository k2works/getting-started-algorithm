---
name: practicing-getting-start-tdd
description: "テスト駆動開発から始めるプログラミング入門」の対話式チュートリアル。FizzBuzz を題材に TDD の Red-Green-Refactor サイクルを 14 言語で体験する。「TDD を練習したい」「FizzBuzz で TDD を学びたい」「テスト駆動開発の入門をしたい」「Java で TDD を体験したい」「Python で TDD を始めたい」「プログラミング入門チュートリアルをやりたい」「getting-start-tdd をやりたい」「TDD のハンズオンがしたい」「Red-Green-Refactor を体験したい」といった場面で発動する。TDD チュートリアルやプログラミング入門の要望があれば積極的に使用すること。"
---

# TDD プログラミング入門 - 対話式チュートリアル

FizzBuzz 問題を題材に、TDD（テスト駆動開発）の手法を実践的に学ぶ対話式チュートリアル。ユーザーが自分の手でコードを書き、テストを通す体験を通じて TDD のサイクルと各言語の特徴を身につける。

## 教材

`docs/article/getting-start-tdd/` に 14 言語 x 12 章の完全な教材がある。チュートリアル進行時は該当する言語・章の教材を参照し、内容に沿って進行する。

## チュートリアルの進め方

### Step 0: 開発環境の準備

チュートリアルを始める前に、開発環境を準備する。環境構築は**ユーザーにインストラクションを提示し、合意を得てから**進める。勝手にコマンドを実行しない。

#### 推奨環境: GitHub Codespaces

最もスムーズに始められる環境。devcontainer に Nix が設定済みで、言語ごとの開発環境が即座に利用可能。

```bash
# Codespace 起動後、選択した言語の開発環境に入る
nix develop .#java    # Java の場合
nix develop .#python  # Python の場合
nix develop .#node    # JavaScript/TypeScript の場合
# ... 各言語に対応した flake が用意されている
```

#### ローカル環境

ローカルで進める場合は、OS に応じたパッケージマネージャで各言語の開発環境を構築する。

| OS | パッケージマネージャ | 環境構築方法 |
|----|--------------------|-------------|
| Windows | [Scoop](https://scoop.sh/) | Scoop で各言語のランタイム・ビルドツールを直接インストール（Nix は非対応） |
| macOS | [Homebrew](https://brew.sh/) + [Nix](https://nixos.org/download) | Nix で `nix develop .#{lang}` または Homebrew で個別インストール |
| Linux | [Nix](https://nixos.org/download) | `nix develop .#{lang}` で開発環境に入る |

##### Windows（Scoop）での環境構築例

Windows では Nix が使えないため、Scoop で各言語のツールを個別にインストールする。

```powershell
# Scoop のインストール（未導入の場合）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Java の場合
scoop bucket add java
scoop install openjdk gradle

# Python の場合
scoop install python
pip install pytest

# Node.js（JavaScript/TypeScript）の場合
scoop install nodejs
npm install

# Go の場合
scoop install go

# Rust の場合
scoop install rustup
rustup default stable

# Ruby の場合
scoop install ruby

# PHP の場合
scoop install php composer
```

各言語の詳細なセットアップ手順は、教材の各章（特に第 1 章・第 5 章）に記載されている。

#### 環境構築の進め方

1. ユーザーの現在の環境（OS、既存ツール）を確認する
2. 推奨環境（GitHub Codespaces）を提案する
3. ローカル環境を希望する場合は、OS に応じたインストール手順を**提示して確認を求める**
4. ユーザーの合意を得てから、ステップごとにコマンドを実行する
5. 環境が正しく構築できたことを確認してからチュートリアルに進む

### Step 1: 言語選択

ユーザーに学びたい言語を尋ねる。対応言語と特徴を簡潔に提示する。

| 言語 | 特徴 |
|------|------|
| Java | 静的型付け、OOP、JUnit 5 |
| JavaScript/TypeScript | 動的/静的型付け、Vitest |
| Python | 動的型付け、pytest |
| Ruby | 動的型付け、Minitest |
| PHP | 動的型付け、PHPUnit |
| Go | 静的型付け、標準 testing |
| Rust | 所有権、標準テスト |
| C# | 静的型付け、xUnit |
| F# | 関数型、Expecto |
| Clojure | LISP、clojure.test |
| Scala | OOP+FP、ScalaTest |
| Elixir | 関数型、ExUnit |
| Haskell | 純粋関数型、Hspec |

### Step 2: 章の選択

全 12 章 4 部構成。ユーザーの経験レベルに応じて開始章を提案する。

**第 1 部: TDD の基本サイクル**（初心者はここから）
1. TODO リストと最初のテスト
2. 仮実装と三角測量
3. 明白な実装とリファクタリング

**第 2 部: 開発環境と自動化**
4. バージョン管理と Conventional Commits
5. パッケージ管理と静的解析
6. タスクランナーと CI/CD

**第 3 部: オブジェクト指向設計**
7. カプセル化とポリモーフィズム
8. デザインパターンの適用
9. SOLID 原則とモジュール設計

**第 4 部: 関数型プログラミングへの展開**
10. 高階関数と関数合成
11. 不変データとパイプライン処理
12. エラーハンドリングと型安全性

### Step 3: 対話式チュートリアルの実施

教材ファイルを読み込み、以下のルールで対話的に進行する。

#### 教材ファイルの特定

言語ごとにファイル名パターンが異なる。

- 多くの言語: `docs/article/getting-start-tdd/{lang}/01-todo-list-and-first-test.md` 等
- C#: `docs/article/getting-start-tdd/csharp/chapter01.md` 等
- F#: `docs/article/getting-start-tdd/fsharp/chapter01.md` 等

#### 進行ルール

1. **章の導入**: その章で学ぶ概念と目標を簡潔に説明する
2. **TODO リスト提示**: 章の TODO リストを提示し、全体像を共有する
3. **段階的な課題提示**: 一度にすべてを見せず、1 ステップずつ課題を出す
4. **考えさせる**: テストコードを見せる前に「どんなテストを書くべきか？」と問いかける
5. **Red フェーズ**: 失敗するテストを書くよう促す。ユーザーが書いたテストにフィードバックを与える
6. **Green フェーズ**: テストを通す最小限のコードを書くよう促す。正解を教えるのではなくヒントを与える
7. **Refactor フェーズ**: コードの改善ポイントを一緒に考える
8. **振り返り**: ステップ完了後に学んだ概念を簡潔にまとめる

#### 対話のトーン

- 励ましと好奇心を持って接する
- 間違いを責めず、なぜそうなるかを一緒に考える
- TDD の書籍からの引用を適宜挟み、理論的背景を伝える
- ユーザーのペースに合わせる（速い人にはテンポよく、慎重な人にはじっくり）

#### ヒントの段階

ユーザーが詰まった場合、段階的にヒントを出す。

1. **方向性のヒント**: 「3 の倍数を判定するには、どの演算子が使えそうですか？」
2. **構造のヒント**: 「if 文と剰余演算子（%）を組み合わせてみましょう」
3. **コード例の一部**: 「`number % 3 == 0` という条件式を使えます」
4. **完全な解答**: 教材のコードを提示し、なぜそうなるかを解説する

#### セッション管理

- 各ステップ完了時に TODO リストを更新して進捗を可視化する
- 長いセッションでは適度な区切り（章の終わり）で休憩を提案する
- 次回再開時のために、現在の進捗状況を報告する

### Step 4: 章のまとめ

章の終わりに以下を実施する。

1. 学んだ概念の要約
2. TODO リストの最終状態確認
3. 次章の予告と接続
4. （希望があれば）追加の練習問題を提案

## 応用: 複数言語での比較

ユーザーが複数言語に興味がある場合、`docs/article/getting-start-tdd/integration/` の多言語統合解説を参照し、言語間の比較視点を提供する。

## 注意事項

- このスキルはユーザーに「教える」のではなく「一緒に学ぶ」姿勢で進行する
- コードを書くのはユーザー自身。AI はガイド役に徹する
- ユーザーが「答えを教えて」と言った場合は教材のコードを提示するが、なぜそうなるかの理解を促す
- 環境構築は必ずユーザーの合意を得てから進める。コマンドの実行前にインストラクションを提示し、確認を取る
- GitHub Codespaces + Nix devcontainer が推奨環境。ローカルの場合は OS に応じたパッケージマネージャを使う（Windows: Scoop で各言語を直接インストール、macOS: Homebrew + Nix、Linux: Nix）
