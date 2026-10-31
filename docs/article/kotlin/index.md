# アルゴリズムから始める Kotlin 入門

## はじめに

この教材は「テスト駆動開発から始める Kotlin 入門」の続編です。TDD の基本サイクルを使い、アルゴリズムとデータ構造を Kotlin の型システム、コレクション、オブジェクト指向・関数型の表現を通して学びます。

前作を修了し、Kotlin の基本文法、Gradle によるテスト実行、Red → Green → Refactor を理解していることを前提とします。前作の環境構築や TDD の基本説明は繰り返さず、各章で扱う問題の仕様、テスト、実装、計算量に焦点を当てます。

## 開発環境

Kotlin と JDK 25、Gradle を使います。リポジトリルートで Nix 環境に入り、アプリケーションディレクトリから Gradle Wrapper を実行してください。

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test
```

## 章構成

1. [基本的なアルゴリズム](01-basic-algorithms.md) — 比較、条件分岐、繰り返し、多重ループ
2. [配列](02-arrays.md) — 配列の走査と最大値、要素の反転、基数変換、素数の列挙
3. [探索アルゴリズム](03-search-algorithms.md) — 線形探索、二分探索、ハッシュ法
4. [スタックとキュー](04-stack-and-queue.md) — LIFO / FIFO のデータ構造
5. [再帰アルゴリズム](05-recursion.md) — 階乗、GCD、ハノイ、複数回再帰、8 王妃、迷路探索
6. [ソートアルゴリズム](06-sort-algorithms.md) — バブル・選択・挿入・クイック・マージソート
7. [文字列処理](07-string-processing.md) — 文字列の基本操作と探索
8. [リスト](08-lists.md) — 単方向・双方向連結リスト
9. [木構造](09-tree-structures.md) — 二分探索木と最小ヒープ
