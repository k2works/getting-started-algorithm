# イテレーション 4 完了報告書

## プロジェクト概要

| 項目 | 内容 |
|------|------|
| **イテレーション** | 4 |
| **ゴール** | C# 版を Python 版から展開し、TDD で実装する |
| **対象ストーリー** | US-004: C# 版を Python 版から展開する |
| **計画 SP** | 3 |
| **実績 SP** | 3 |
| **達成率** | 100% |

### 日程

| 項目 | 日付 |
|------|------|
| 計画期間 | Week 7-8（2 週間） |
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
| 累計完了 SP | 14 / 61 |
| 残 SP | 47 |

### リリースバーンダウン

```mermaid
xychart-beta
    title "リリースバーンダウンチャート"
    x-axis ["開始", "IT1", "IT2", "IT3", "IT4", "IT5", "IT6", "IT7", "IT8", "IT9", "IT10", "IT11", "IT12", "IT13", "IT14"]
    y-axis "残 SP" 0 --> 65
    line "計画" [61, 56, 53, 50, 47, 44, 41, 38, 33, 28, 23, 18, 13, 8, 0]
    line "実績" [61, 56, 53, 50, 47]
```

### ベロシティチャート

```mermaid
xychart-beta
    title "イテレーション別ベロシティ"
    x-axis ["IT1", "IT2", "IT3", "IT4"]
    y-axis "完了 SP" 0 --> 10
    bar "実績" [5, 3, 3, 3]
    line "平均" [5, 4, 3.67, 3.5]
```

---

## テスト結果

### C# テスト

| メトリクス | 値 |
|-----------|-----|
| テストファイル数 | 9 ファイル |
| テスト総数 | 238 |
| 通過数 | 238 |
| スキップ数 | 0 |
| 失敗数 | 0 |

### テスト内訳

| テストファイル | テスト対象 |
|--------------|-----------|
| `BasicAlgorithmsTests.cs` | 3 値最大値・中央値・条件判定・繰り返し・交互表示・九九の表 |
| `ArrayAlgorithmsTests.cs` | 配列最大値・反転・基数変換・素数列挙（3 版） |
| `SearchTests.cs` | 線形探索・番兵法・二分探索・チェイン法・オープンアドレス法ハッシュ |
| `StackQueueTests.cs` | FixedStack<T>・FixedQueue<T>（リングバッファ） |
| `RecursionTests.cs` | 階乗・GCD・再帰的総和・ハノイの塔・迷路探索・8 王妃問題 |
| `SortTests.cs` | バブル・選択・挿入・シェル・クイック・マージ・ヒープ・度数ソート |
| `StringAlgorithmsTests.cs` | BF・KMP・Boyer-Moore 文字列照合・文字カウント・逆順・回文 |
| `LinkedListTests.cs` | 単方向連結リスト・双方向連結リスト・カーソルによるリスト |
| `TreeTests.cs` | 二分探索木（挿入・削除・走査・最大値・最小値） |

### テスト増分

| イテレーション | テスト数 | 増分 |
|--------------|---------|------|
| 開始前 | 0 | - |
| IT-1（Python） | 239 | +239 |
| IT-2（TypeScript） | 259 | +259 |
| IT-3（Java） | 229 | +229 |
| IT-4（C#、今回） | 238 | +238 |
| **累計** | **965** | |

---

## 実施内容と評価

### ストーリー達成状況

| ストーリー | 結果 | 計画 SP | 実績 SP |
|-----------|------|---------|---------|
| US-004: C# 版を Python 版から展開する | ✅ 完了 | 3 | 3 |
| **合計** | | **3** | **3** |

### US-004 受入条件の達成状況

- [x] 全 9 章が Python 版を基に C# 版として再構成されている
- [x] 各章に TDD のコード例（テスト → 実装 → リファクタリング）が含まれている
- [x] `apps/csharp/` で全テストがパスする（238 テスト、全パス）

### Definition of Done

- [x] 全 9 章のファイルが `docs/article/csharp/` に存在
- [x] `apps/csharp/` のテストが全てパス（238 件）
- [x] コード例が実装と同期（記事記述 = 実装済み）
- [x] Python 版との内容差分チェック完了（全章）
- [x] mkdocs.yml の nav 更新済み
- [x] `ci-csharp.yml` を追加し自動テスト構築済み
- [x] GitHub Issue #4（US-004）クローズ済み

### 実装した主要コンポーネント

#### 記事（`docs/article/csharp/`）

| ファイル | 内容 | 行数 |
|---------|------|------|
| `index.md` | C# 版 概要・目次 | 55 |
| `01-basic-algorithms.md` | 基本的なアルゴリズム（最大値・中央値・繰り返し・多重ループ） | 500+ |
| `02-arrays.md` | 配列（最大値・反転・基数変換・素数列挙） | 500+ |
| `03-search-algorithms.md` | 探索アルゴリズム（線形・二分・ハッシュ法） | 500+ |
| `04-stacks-and-queues.md` | スタックとキュー（FixedStack・FixedQueue・リングバッファ） | 500+ |
| `05-recursion.md` | 再帰アルゴリズム（階乗・GCD・ハノイ・迷路・8 王妃問題） | 500+ |
| `06-sort-algorithms.md` | ソートアルゴリズム（8 種） | 500+ |
| `07-strings.md` | 文字列処理（BF・KMP・Boyer-Moore・カウント・逆順・回文） | 500+ |
| `08-linked-lists.md` | リスト（単方向・双方向・カーソル） | 500+ |
| `09-trees.md` | 木構造（二分探索木・ノード削除・走査） | 500+ |

#### 実装（`apps/csharp/Algorithm/`）

| ファイル | 主要実装 |
|---------|---------|
| `BasicAlgorithms.cs` | Max3・Med3・JudgeSign・Sum・Alternative・MultiplicationTable |
| `ArrayAlgorithms.cs` | MaxOf・Reverse・CardConv・Prime1/2/3 |
| `Search.cs` | LinearSearchWhile/For/Sentinel・BinarySearch・ChainedHash・OpenHash |
| `FixedStack.cs` | Push・Pop・Peek・Find・Count・Contains・Clear（ジェネリクス） |
| `FixedQueue.cs` | Enqueue・Dequeue・Peek・Find・Count・Contains・Clear（リングバッファ） |
| `Recursion.cs` | Factorial・Gcd・RecursiveSum・Hanoi・MazeSolve・EightQueen1/2/3 |
| `Sort.cs` | BubbleSort・SelectionSort・InsertionSort・ShellSort・QuickSort・MergeSort・HeapSort・CountingSort |
| `StringAlgorithms.cs` | BfMatch・KmpMatch・BmMatch・CountChars・ReverseString・IsPalindrome |
| `SinglyLinkedList.cs` | AddFirst・AddLast・Remove・RemoveFirst・RemoveLast・Contains（ジェネリクス） |
| `DoublyLinkedList.cs` | AddFirst・AddLast・Remove・Contains（ジェネリクス） |
| `ArrayLinkedList.cs` | AddFirst・AddLast・Search・RemoveFirst（カーソルによるリスト） |
| `BinarySearchTree.cs` | Insert・Delete・Contains・InOrder・PreOrder・PostOrder・Min・Max・Size（ジェネリクス） |

---

## フェーズ・累計進捗

### Phase 1 進捗（Python 原本 + OOP 言語展開）

| イテレーション | 言語 | 計画 SP | 実績 SP | 達成率 | 状態 |
|--------------|------|---------|---------|--------|------|
| IT-1 | Python（原本） | 5 | 5 | 100% | ✅ 完了 |
| IT-2 | TypeScript | 3 | 3 | 100% | ✅ 完了 |
| IT-3 | Java | 3 | 3 | 100% | ✅ 完了 |
| IT-4 | C# | 3 | 3 | 100% | ✅ 完了 |
| IT-5 | Ruby | 3 | - | - | 未着手 |
| IT-6 | PHP | 3 | - | - | 未着手 |
| **Phase 1 合計** | | **20** | **14** | **70%** | |

### 全フェーズ累計

| フェーズ | SP | 完了 SP | 達成率 |
|---------|-----|---------|--------|
| Phase 1 | 20 | 14 | 70% |
| Phase 2 | 33 | 0 | 0% |
| Phase 3 | 8 | 0 | 0% |
| **合計** | **61** | **14** | **23%** |

---

## ふりかえり

詳細は [イテレーション 4 ふりかえり](./retrospective-4.md) を参照。

### 主要改善アクション

| # | アクション | 実施イテレーション |
|---|-----------|----------------|
| T1 | LINQ 活用記事の補足（第 2・6 章） | IT-5 から |
| T2 | `dotnet test --collect` でカバレッジ計測を試す | IT-5 から |
| T3 | Ruby 版の Enumerable と C# LINQ の対比を意識した執筆 | IT-5 にて |

---

## 次のイテレーション（IT-5）への申し送り

- **対象ストーリー**: US-005 Ruby 版を Python 版から展開する（3 SP）
- **Ruby の特徴**: ブロック、Enumerable、`attr_accessor`、動的型付き
- **環境準備**: `nix develop .#ruby`（Ruby + RSpec 環境）の動作確認
- **記事品質**: Python 版と同等の記述量（各章 500 行以上）を最初から確保する

---

## 更新履歴

| 日付 | 更新内容 | 更新者 |
|------|---------|--------|
| 2026-04-12 | 初版作成 | - |
