# イテレーション 11 完了報告書

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 11 |
| **ゴール** | Scala 版を Python 版から展開し、TDD で実装する |
| **対象ストーリー** | US-011: Scala 版を Python 版から展開する |
| **計画 SP** | 5 |
| **実績 SP** | 5 |
| **達成率** | 100% |

### 日程

| 項目 | 日付 |
|------|------|
| 計画期間 | Week 21-22（2 週間） |
| 実績開始日 | 2026-04-13 |
| 実績終了日 | 2026-04-13 |

### 要員

| 名前 | 予定作業日数 | 実績作業日数 |
|------|------------|------------|
| 開発者 + AI | 10 日 | 1 日（AI 支援により大幅短縮） |

---

## 指標

### ベロシティ

| 指標 | 値 |
|------|-----|
| 計画 SP | 5 |
| 実績 SP | 5 |
| 達成率 | 100% |
| 累計完了 SP | 43 / 66 |
| 残 SP | 23 |

### バーンダウンチャート

```mermaid
xychart-beta
    title "リリースバーンダウン（計画 vs 実績）"
    x-axis ["開始", "IT1", "IT2", "IT3", "IT4", "IT5", "IT6", "IT7", "IT8", "IT9", "IT10", "IT11"]
    y-axis "残 SP" 0 --> 70
    line "計画" [66, 61, 58, 55, 52, 49, 46, 43, 38, 33, 28, 23]
    line "実績" [66, 61, 58, 55, 52, 49, 46, 41, 38, 33, 28, 23]
```

### ベロシティチャート

```mermaid
xychart-beta
    title "イテレーション別ベロシティ"
    x-axis ["IT1", "IT2", "IT3", "IT4", "IT5", "IT6", "IT7", "IT8", "IT9", "IT10", "IT11"]
    y-axis "完了 SP" 0 --> 8
    bar [5, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5]
    line [3.9, 3.9, 3.9, 3.9, 3.9, 3.9, 3.9, 3.9, 3.9, 3.9, 3.9]
```

**平均ベロシティ**: 3.9 SP / イテレーション（IT1-IT11 実績平均）

### テスト品質

| 指標 | 値 |
|------|-----|
| テスト件数（Scala 版） | 125 |
| テスト通過率 | 100%（125 / 125） |
| テストフレームワーク | ScalaTest（AnyFunSuite + Matchers） |
| Scala バージョン | Scala 3（インデントベース構文） |
| ビルドツール | sbt（Scala Build Tool） |

### テスト累計推移

| イテレーション | 言語 | テスト件数 | 累計 |
|---------------|------|----------|------|
| IT1 | Python | 39 | 39 |
| IT2 | TypeScript | 47 | 86 |
| IT3 | Java | 51 | 137 |
| IT4 | C# | 42 | 179 |
| IT5 | Ruby | 56 | 235 |
| IT6 | PHP | 145 | 380 |
| IT7 | Go | 60 | 440 |
| IT8 | C | 204 | 644 |
| IT9 | Rust | 285 | 929 |
| IT10 | F# | 242 | 1171 |
| IT11 | Scala | 125 | 1296 |

---

## 成果物

### 作成ファイル一覧

#### 実装（apps/scala/）

| ファイル | 内容 |
|---------|------|
| build.sbt | sbt ビルド設定（Scala 3 + ScalaTest 3.2.x） |
| src/main/scala/algorithm/BasicAlgorithms.scala | 最大値・中央値・条件判定・繰り返し・記号交互表示・長方形列挙・多重ループ |
| src/main/scala/algorithm/Arrays.scala | 配列操作・基数変換・素数列挙 3 版 |
| src/main/scala/algorithm/SearchAlgorithms.scala | 線形探索・番兵法・二分探索・ハッシュ法 |
| src/main/scala/algorithm/StacksAndQueues.scala | スタック・キュー・リング型キュー |
| src/main/scala/algorithm/Recursion.scala | 再帰基本・GCD・ハノイの塔・迷路・8 王妃問題・recure |
| src/main/scala/algorithm/SortAlgorithms.scala | バブル・選択・挿入・シェル・クイック・マージ・ヒープ・度数ソート |
| src/main/scala/algorithm/Strings.scala | BF 法・KMP 法・BM 法・文字数カウント・逆順・回文判定 |
| src/main/scala/algorithm/LinkedLists.scala | 単方向リスト・双方向リスト・配列カーソル版 |
| src/main/scala/algorithm/Trees.scala | BST・走査 3 種・ヒープ |
| src/test/scala/algorithm/（9 ファイル） | 全 125 テスト（章別テストファイル） |
| .github/workflows/ci-scala.yml | CI ワークフロー（`sbt test`） |

#### 記事（docs/article/scala/）

| ファイル | 内容 |
|---------|------|
| index.md | Scala 版概要・Python との比較表・環境構築手順 |
| 01-basic-algorithms.md | 基本的なアルゴリズム（繰り返し・記号交互表示・長方形列挙追加） |
| 02-arrays.md | 配列（TDD セクション・フローチャート・素数比較表追加） |
| 03-search-algorithms.md | 探索アルゴリズム |
| 04-stacks-and-queues.md | スタックとキュー |
| 05-recursion.md | 再帰アルゴリズム（recure・末尾再帰・フローチャート追加） |
| 06-sort-algorithms.md | ソートアルゴリズム（全 8 種 TDD + フローチャート） |
| 07-strings.md | 文字列処理 |
| 08-linked-lists.md | リスト |
| 09-trees.md | 木構造（ヒープセクション追加） |

---

## 実施内容と評価

### ストーリー別完了状況

| ストーリー | 結果 | 計画 SP | 実績 SP |
|-----------|------|---------|---------|
| US-011: Scala 版を Python 版から展開する | 完了 | 5 | 5 |
| **合計** | | **5** | **5** |

### US-011 受入条件の達成状況

1. [x] 全 9 章が Python 版を基に Scala 版として再構成されている
2. [x] 各章に TDD のコード例（テスト → 実装 → リファクタリング）が含まれている
3. [x] `apps/scala/` で全テストがパスする（125 テスト全通過）
4. [x] Scala の関数型スタイル（`case class`、`sealed trait`、パターンマッチ、`Option[T]`、`for` 内包表記）を活用した実装

### Definition of Done チェック

- [x] `apps/scala/` の全テストがパス（`sbt test`）— 125 テスト全通過
- [x] 全 9 章 + index.md が作成されている
- [x] mkdocs.yml の nav に Scala 版全 9 章が追加されている
- [x] ローカルプレビューで表示確認済み（`npx gulp mkdocs:build` でビルド成功）
- [x] 各章のコード例が実装コードと同期している
- [x] Python 版との記事記述量差分が 30% 以内（追記により解消：+2,209 行）
- [x] `.gitignore` に `target/`、`.bsp/` が登録済み
- [x] Scala の関数型スタイル（`case class`、パターンマッチ、`Option[T]`）を活用した実装

---

## 特記事項

- 初期実装後に Python 版との差分を精査し、全 6 章（第1・2・5・6・9 章）を大幅追記（7 ファイル、+2,209 行）した
- `recure`（真に再帰的な関数：2 箇所で再帰呼び出し）を追加実装した（IT-11 での新規実装）
- Scala 3 の Union Type（`Node | Null`）、コンテキスト境界（`[T: Ordering]`）、`enum` など Scala 3 固有機能を積極的に活用した
- ソートアルゴリズムを Python 版と同様の全 8 種（バブル・選択・挿入・シェル・クイック・マージ・ヒープ・度数）で実装した
- 第 9 章にヒープセクションを新設し、最大/最小ヒープ・`PriorityQueue` との連携・`heapSort` との関連を解説した

---

## フェーズ・累計進捗

### フェーズ別進捗

| フェーズ | 内容 | SP | 完了 SP | 進捗 |
|---------|------|-----|---------|------|
| Phase 1 | Python 原本 + OOP 言語展開（6 言語） | 20 | 20 | 100% |
| Phase 2 | システム言語 + 関数型言語展開（8 言語） | 38 | 23 | 60.5% |
| Phase 3 | 多言語統合解説 | 8 | 0 | 0% |
| **合計** | | **66** | **43** | **65.2%** |

### イテレーション別進捗

| イテレーション | 言語 | 計画 SP | 実績 SP | 達成率 |
|---------------|------|---------|---------|--------|
| IT1 | Python（原本） | 5 | 5 | 100% |
| IT2 | TypeScript | 3 | 3 | 100% |
| IT3 | Java | 3 | 3 | 100% |
| IT4 | C# | 3 | 3 | 100% |
| IT5 | Ruby | 3 | 3 | 100% |
| IT6 | PHP | 3 | 3 | 100% |
| IT7 | Go | 3 | 3 | 100% |
| IT8 | C | 5 | 5 | 100% |
| IT9 | Rust | 5 | 5 | 100% |
| IT10 | F# | 5 | 5 | 100% |
| IT11 | Scala | 5 | 5 | 100% |
| **累計** | | **43** | **43** | **100%** |

---

## ふりかえりへのリンク

詳細は [イテレーション 11 ふりかえり](./retrospective-11.md) を参照。

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-04-13 | 初版作成 | - |
