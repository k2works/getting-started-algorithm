# 第 4 章 スタックとキュー

## はじめに

この章では固定長スタックと固定長キュー（リングバッファ）を Scala で実装します。型パラメータ `[T]` でジェネリクスを表現します。

## スタックとキューとは

| 構造 | 特性 | 主な操作 | 計算量 |
|------|------|---------|--------|
| スタック | LIFO（後入れ先出し） | push/pop/peek | O(1) |
| キュー | FIFO（先入れ先出し） | enqueue/dequeue/peek | O(1) |

---

## 1. 固定長スタック

```scala
class FixedStack[T](capacity: Int):
  private val stk = new Array[Any](capacity)
  private var ptr = 0

  def push(value: T): Unit =
    if isFull then throw StackFullException()
    stk(ptr) = value
    ptr += 1

  def pop(): T =
    if isEmpty then throw StackEmptyException()
    ptr -= 1
    stk(ptr).asInstanceOf[T]
```

`asInstanceOf[T]` は型キャストです。`Array[Any]` を使う理由は、Scala の型消去（type erasure）のためです。

---

## 2. 固定長キュー（リングバッファ）

```scala
class FixedQueue[T](capacity: Int):
  private val que   = new Array[Any](capacity)
  private var front = 0
  private var rear  = 0
  private var num   = 0

  def enqueue(value: T): Unit =
    if isFull then throw QueueFullException()
    que(rear) = value
    rear = (rear + 1) % capacity
    num += 1

  def dequeue(): T =
    if isEmpty then throw QueueEmptyException()
    val value = que(front).asInstanceOf[T]
    front = (front + 1) % capacity
    num -= 1
    value
```

リングバッファは `% capacity` でインデックスを循環させます。

---

## テスト実行結果

```
Tests: succeeded 17, failed 0
```

## まとめ

| 操作 | スタック | キュー |
|------|---------|-------|
| push/enqueue | O(1) | O(1) |
| pop/dequeue | O(1) | O(1) |
| peek | O(1) | O(1) |
| find | O(n) | O(n) |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
