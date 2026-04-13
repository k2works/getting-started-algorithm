# 第 3 章 探索アルゴリズム

## はじめに

この章では線形探索・二分探索・ハッシュ法を Scala で実装します。Scala の `Option[T]` を活用して NULL 安全な検索結果を表現します。

## 探索とは

探索とは、データの集合から特定の条件を満たす要素を見つける操作です。

| 探索法 | 平均計算量 | 最悪計算量 | 前提条件 |
|--------|-----------|-----------|---------|
| 線形探索 | O(n) | O(n) | なし |
| 二分探索 | O(log n) | O(log n) | ソート済み |
| ハッシュ法 | O(1) | O(n) | ハッシュ関数 |

---

## 1. 線形探索

```scala
def linearSearchFor(a: Array[Int], key: Int): Int =
  for i <- a.indices do
    if a(i) == key then return i
  -1
```

### 番兵法

```scala
def linearSearchSentinel(a: Array[Int], key: Int): Int =
  val b = a :+ key  // 末尾に番兵を追加
  var i = 0
  while b(i) != key do i += 1
  if i == a.length then -1 else i
```

---

## 2. 二分探索

```scala
def binarySearch(a: Array[Int], key: Int): Int =
  var pl = 0
  var pr = a.length - 1
  while pl <= pr do
    val pc = (pl + pr) / 2
    if a(pc) == key then return pc
    else if a(pc) < key then pl = pc + 1
    else pr = pc - 1
  -1
```

---

## 3. ハッシュ法

### チェイン法

```scala
class ChainedHash(capacity: Int):
  private case class Node(key: Int, value: String, var next: Node | Null = null)
  private val table = new Array[Node | Null](capacity)

  def search(key: Int): Option[String] = ...
  def add(key: Int, value: String): Boolean = ...
  def remove(key: Int): Boolean = ...
```

`Node | Null` は Scala 3 の Union Type による null 安全な参照です。

### オープンアドレス法

```scala
class OpenHash(capacity: Int):
  private enum Status { case Occupied, Empty, Deleted }
```

`enum` は Scala 3 の sealed trait + case object の簡略記法です。

---

## テスト実行結果

```
Tests: succeeded 16, failed 0
```

## まとめ

| 探索法 | 平均計算量 | Scala の実装ポイント |
|--------|-----------|---------------------|
| 線形探索 | O(n) | `for` 内包表記 + `return` |
| 二分探索 | O(log n) | 配列がソート済みであること |
| チェイン法 | O(1) | Union Type `Node | Null` |
| オープンアドレス法 | O(1) | `enum` でステータス管理 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
