# 第 8 章 リスト

## はじめに

この章では 3 種類の連結リストを Scala で実装します。Scala の `sealed trait` + `case class` または可変クラスを活用します。

## 連結リストとは

連結リストとは、各要素（ノード）がデータと次の要素への参照を持つデータ構造です。

| 操作 | 配列 | 連結リスト |
|------|------|-----------|
| ランダムアクセス | O(1) | O(n) |
| 先頭への挿入 | O(n) | O(1) |
| 末尾への挿入 | O(1) | O(n)（単方向）/ O(1)（双方向） |
| 途中への挿入 | O(n) | O(1)（位置が既知の場合） |
| 削除 | O(n) | O(1)（位置が既知の場合） |

---

## 1. 単方向連結リスト

```scala
private class SNode[T](val data: T, var next: SNode[T] | Null = null)

class SinglyLinkedList[T]:
  private var head: SNode[T] | Null = null

  def addFirst(data: T): Unit =
    head = SNode(data, head)

  def addLast(data: T): Unit =
    if head == null then head = SNode(data)
    else
      var ptr = head
      while ptr.next != null do ptr = ptr.next
      ptr.next = SNode(data)
```

`SNode[T] | Null` は Scala 3 の Union Type で null を型安全に扱います。

---

## 2. 双方向連結リスト（番兵ノード使用）

```scala
class DoublyLinkedList[T]:
  private val sentinel: DNode[T] = DNode(null.asInstanceOf[T])
  sentinel.prev = sentinel
  sentinel.next = sentinel

  def addLast(data: T): Unit =
    val node = DNode(data)
    node.prev = sentinel.prev
    node.next = sentinel
    sentinel.prev.next = node
    sentinel.prev = node
```

番兵ノードにより境界処理が不要になります。

---

## 3. 配列による連結リスト（カーソル版）

```scala
class ArrayLinkedList(capacity: Int):
  private val Null = -1
  private val data  = new Array[Int](capacity)
  private val next  = Array.fill(capacity)(Null)
  private val dnext = Array.fill(capacity)(Null)  // 削除リスト
```

ポインタの代わりに配列インデックスを使います。削除済みスロットを再利用します。

---

## テスト実行結果

```
Tests: succeeded 20, failed 0
```

## まとめ

| データ構造 | 挿入（先頭） | 挿入（末尾） | 削除 | Scala の実装手法 |
|-----------|------------|------------|------|-----------------|
| 単方向リスト | O(1) | O(n) | O(n) | Union Type `SNode[T] \| Null` |
| 双方向リスト | O(1) | O(1) | O(1) | 番兵ノード + 双方向参照 |
| 配列カーソル版 | O(1) | O(n) | O(1) | 整数インデックスで Next を管理 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
