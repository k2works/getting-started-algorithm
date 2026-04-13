# 第 1 章 基本的なアルゴリズム

## はじめに

この章では Scala で基本的なアルゴリズムを TDD で実装します。Scala 3 のシンプルな構文（インデントベース、`def`、`for` 内包表記）を活用しながら、アルゴリズムの基礎を学びます。

## 準備

### 環境構築

```bash
# Nix 環境に入る（Scala + sbt が利用可能になる）
nix develop .#scala

# プロジェクトディレクトリへ移動
cd apps/scala

# テスト実行
sbt test
```

### プロジェクト構成

```
apps/scala/
├── build.sbt
├── project/build.properties
└── src/
    ├── main/scala/algorithm/
    │   └── BasicAlgorithms.scala
    └── test/scala/algorithm/
        └── BasicAlgorithmsTest.scala
```

---

## 1. アルゴリズムとは

アルゴリズムとは、問題を解決するための明確な手順です。Scala では`object`（シングルトン）に`def`でアルゴリズムを定義します。

---

## 2. 3 値の最大値

### TDD サイクル

**Red（失敗するテスト）**:

```scala
test("max3: 各パターンで最大値を返す"):
  BasicAlgorithms.max3(3, 2, 1) shouldBe 3
  BasicAlgorithms.max3(1, 2, 3) shouldBe 3
```

**Green（最小限の実装）**:

```scala
object BasicAlgorithms:
  def max3(a: Int, b: Int, c: Int): Int =
    var maximum = a
    if b > maximum then maximum = b
    if c > maximum then maximum = c
    maximum
```

---

## 3. 中央値

```scala
def med3(a: Int, b: Int, c: Int): Int =
  if a >= b then
    if b >= c then b
    else if a <= c then a
    else c
  else if a > c then a
  else if b > c then c
  else b
```

---

## 4. 条件判定・繰り返し

```scala
def judgeSign(n: Int): String =
  if n > 0 then "その値は正です。"
  else if n < 0 then "その値は負です。"
  else "その値は0です。"

def sum1ToNFor(n: Int): Int = (1 to n).sum
```

`(1 to n).sum` は Scala のコレクション API を活用した簡潔な記法です。

---

## テスト実行結果

```
Tests: succeeded 13, failed 0
```

## まとめ

| 操作 | 計算量 |
|------|--------|
| max3 | O(1) |
| med3 | O(1) |
| sum1ToN | O(n) |

Scala の `if/else` は式（値を返す）であり、`match` と組み合わせることでパターンマッチングを簡潔に書けます。

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
