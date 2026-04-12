# イテレーション 5 完了報告書

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 5 |
| **ゴール** | Ruby 版を Python 版から展開し、TDD で実装する |
| **対象ストーリー** | US-005: Ruby 版を Python 版から展開する |
| **計画 SP** | 3 |
| **実績 SP** | 3 |
| **達成率** | 100% |

### 日程

| 項目 | 日付 |
|------|------|
| 計画期間 | Week 9-10（2 週間） |
| 実績開始日 | 2026-04-12 |
| 実績終了日 | 2026-04-12 |

### 要員

| 名前 | 予定作業日数 | 実績作業日数 |
|------|------------|------------|
| 開発者 + AI | 10 日 | 1 日（AI 支援により大幅短縮） |

---

## 指標

### ベロシティ

| 指標 | 値 |
|------|-----|
| 計画 SP | 3 |
| 実績 SP | 3 |
| 達成率 | 100% |
| 累計完了 SP | 17 / 61 |
| 残 SP | 44 |

### テスト品質

| 指標 | 値 |
|------|-----|
| テスト件数（RSpec） | 137 |
| テスト通過率 | 100%（137 / 137） |
| テストフレームワーク | RSpec 3.13.2 |
| Ruby バージョン | 3.3.10 |

---

## 成果物

### 作成ファイル一覧

#### 実装（apps/ruby/）

| ファイル | 内容 |
|---------|------|
| `Gemfile` | RSpec 依存関係定義 |
| `.rspec` | RSpec 設定 |
| `spec/spec_helper.rb` | RSpec ヘルパー |
| `lib/algorithm/basic_algorithms.rb` | 第 1 章: 基本的なアルゴリズム |
| `lib/algorithm/arrays.rb` | 第 2 章: 配列 |
| `lib/algorithm/search.rb` | 第 3 章: 探索アルゴリズム |
| `lib/algorithm/stack_queue.rb` | 第 4 章: スタックとキュー |
| `lib/algorithm/recursion.rb` | 第 5 章: 再帰アルゴリズム |
| `lib/algorithm/sort.rb` | 第 6 章: ソートアルゴリズム |
| `lib/algorithm/strings.rb` | 第 7 章: 文字列処理 |
| `lib/algorithm/linked_list.rb` | 第 8 章: リスト |
| `lib/algorithm/tree.rb` | 第 9 章: 木構造 |
| `spec/basic_algorithms_spec.rb` | 第 1 章テスト |
| `spec/arrays_spec.rb` | 第 2 章テスト |
| `spec/search_spec.rb` | 第 3 章テスト |
| `spec/stack_queue_spec.rb` | 第 4 章テスト |
| `spec/recursion_spec.rb` | 第 5 章テスト |
| `spec/sort_spec.rb` | 第 6 章テスト |
| `spec/strings_spec.rb` | 第 7 章テスト |
| `spec/linked_list_spec.rb` | 第 8 章テスト |
| `spec/tree_spec.rb` | 第 9 章テスト |

#### 記事（docs/article/ruby/）

| ファイル | 章 |
|---------|-----|
| `index.md` | Ruby 版概要 |
| `01-basic-algorithms.md` | 第 1 章: 基本的なアルゴリズム |
| `02-arrays.md` | 第 2 章: 配列 |
| `03-search-algorithms.md` | 第 3 章: 探索アルゴリズム |
| `04-stacks-and-queues.md` | 第 4 章: スタックとキュー |
| `05-recursion.md` | 第 5 章: 再帰アルゴリズム |
| `06-sort-algorithms.md` | 第 6 章: ソートアルゴリズム |
| `07-string-processing.md` | 第 7 章: 文字列処理 |
| `08-linked-lists.md` | 第 8 章: リスト |
| `09-trees.md` | 第 9 章: 木構造 |

---

## 受入条件の達成状況

| 受入条件 | 状態 |
|---------|------|
| 全 9 章が Python 版を基に Ruby 版として再構成されている | ✅ |
| 各章に TDD のコード例（テスト → 実装 → リファクタリング）が含まれている | ✅ |
| `apps/ruby/` で全テストがパスする（RSpec 137 テスト） | ✅ |
| mkdocs.yml の nav に Ruby 全 9 章が追加されている | ✅ |
| Python 版との差分が各記事に明記されている | ✅ |
| GitHub Issue #5（US-005）がクローズされている | ✅ |

---

## DoD（Definition of Done）チェック

- [x] `apps/ruby/` で全テストがパス（RSpec 137 テスト）
- [x] 9 章の記事ファイルが作成済み
- [x] mkdocs.yml の nav に Ruby 全 9 章が追加されている
- [x] Python 版との差分が各記事に明記されている
- [x] GitHub Issue #5（US-005）がクローズされている

---

## 学習内容

### Ruby と Python の主な違い

| 概念 | Python | Ruby |
|------|--------|------|
| モジュール | なし（関数として定義） | `module Algorithm` + `def self.メソッド名` |
| 例外 | `class MyErr(Exception):` | `class MyErr < StandardError; end` |
| for ループ | `for i in range(n):` | `n.times { \|i\| }` |
| 奇偶判定 | `n % 2 == 0` | `n.even?` / `n.odd?` |
| 逆順文字列 | `s[::-1]` | `s.reverse` |
| for...else | 固有構文 | フラグ変数で代替 |
| デフォルト値取得 | `d.get(key, default)` | `d.fetch(key, default)` |
| lambda | `lambda x: x * 2` | `lambda { \|x\| x * 2 }` / `->(x){ x * 2 }` |

### 習得した Ruby イディオム

- 後置 `if/unless` でガード節を簡潔に書く
- `n.times`、`(start..end).each`、`n.downto(0)` でループ
- `arr.dup` で配列の浅いコピー
- `<<` 演算子で配列/文字列への末尾追加
- `[a, b].max` で 2 つの値の最大値
- `private_class_method :name` でクラスメソッドをプライベート化

---

## 次のステップ

1. IT-6: PHP 版（US-006）の実装
2. CI ワークフロー（`ci-ruby.yml`）の追加
3. Phase 1 完了後の Release 0.1.0 準備

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-04-12 | 初版作成 | - |
