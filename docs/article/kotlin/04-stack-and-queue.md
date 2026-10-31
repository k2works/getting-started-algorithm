# 第 4 章 スタックとキュー

## はじめに

スタックとキューは、要素を追加・取り出す順序が異なる基本的なデータ構造です。この章では固定長配列を使い、ジェネリックなスタックとリングバッファ型キューを TDD で実装します。

- **スタック**: LIFO（Last In, First Out）。最後に追加した要素を最初に取り出します。
- **キュー**: FIFO（First In, First Out）。最初に追加した要素を最初に取り出します。

完成版のコードとテストは `apps/kotlin/src/main/kotlin/algorithm/StackQueue.kt` と `apps/kotlin/src/test/kotlin/algorithm/StackQueueTest.kt` にあります。記事のコードは学習時に各ファイルへ順に追加する抜粋です。

## 1. 固定長スタック

スタックは皿を積み重ねる様子に似ています。`push` で上に追加し、`pop` で一番上を取り出します。`peek` は取り出さずに一番上を参照します。容量を超える追加と空状態からの取り出し・参照は `IllegalStateException` とします。

### Red: 状態・LIFO・境界条件をテストする

```kotlin
@Test
fun `fixed stack tracks state and follows LIFO order`() {
    val stack = FixedStack<Int>(3)
    assertTrue(stack.isEmpty())
    assertFalse(stack.isFull())
    assertEquals(3, stack.capacity)

    stack.push(1)
    stack.push(2)
    stack.push(3)
    assertTrue(stack.isFull())
    assertEquals(3, stack.peek())
    assertEquals(3, stack.pop())
    assertEquals(2, stack.pop())
    assertEquals(1, stack.pop())
    assertTrue(stack.isEmpty())
}

@Test
fun `fixed stack rejects overflow underflow and zero capacity`() {
    val stack = FixedStack<String>(1)
    assertFailsWith<IllegalStateException> { stack.pop() }
    assertFailsWith<IllegalStateException> { stack.peek() }
    stack.push("one")
    assertFailsWith<IllegalStateException> { stack.push("two") }
    assertFailsWith<IllegalArgumentException> { FixedStack<Int>(0) }
}
```

### Green: ポインタで次の格納位置を管理する

```kotlin
class FixedStack<T : Any>(val capacity: Int) {
    private val elements: Array<Any?>
    private var pointer = 0

    init {
        require(capacity > 0) { "容量は 1 以上でなければなりません。" }
        elements = arrayOfNulls(capacity)
    }

    val size: Int
        get() = pointer

    fun push(value: T) {
        check(pointer < capacity) { "スタックは満杯です。" }
        elements[pointer++] = value
    }

    fun pop(): T {
        check(pointer > 0) { "スタックは空です。" }
        val index = --pointer
        val value = elements[index]
        elements[index] = null
        return value as T
    }

    fun peek(): T {
        check(pointer > 0) { "スタックは空です。" }
        return elements[pointer - 1] as T
    }
}
```

`pointer` は格納済み要素数であり、同時に次の `push` 位置を示します。スタックの使用範囲は `0 until pointer` です。`pop` 後にスロットを `null` に戻すことで、取り出したオブジェクトへの不要な参照を保持しません。

JVM では型パラメーター `T` の配列を直接生成できないため、内部に `Array<Any?>` を使い、取り出す位置が必ず格納済みであることを確認してから `T` に戻します。キャスト警告はこの不変条件が成立する操作に限って抑制します。`T : Any` により `null` を要素として格納できない API にしています。

### Refactor: 探索と状態操作を追加する

```kotlin
fun isEmpty(): Boolean = pointer == 0

fun isFull(): Boolean = pointer == capacity

fun find(value: T): Int {
    for (index in pointer - 1 downTo 0) {
        if (elements[index] == value) return index
    }
    return -1
}

fun count(value: T): Int {
    var matches = 0
    for (index in 0 until pointer) {
        if (elements[index] == value) matches++
    }
    return matches
}

fun contains(value: T): Boolean = find(value) >= 0

fun clear() {
    elements.fill(null)
    pointer = 0
}
```

`find` は一番上から探し、見つかった要素の配列インデックス（底から数えた 0 起点）を返します。重複値があれば、最上位にある一致が先に見つかります。探索と個数カウントは `O(n)` 時間、追加領域 `O(1)` です。`push`、`pop`、`peek`、状態確認はすべて `O(1)` です。

## 2. 固定長キューとリングバッファ

キューは列に並ぶ順序に似ています。`enque` で末尾に追加し、`deque` で先頭を取り出します。配列から取り出すたびに残りを左へずらす実装では、`deque` が `O(n)` になります。

リングバッファでは配列の末尾の次を先頭として扱います。`front` は次に取り出す位置、`rear` は次に追加する位置、`count` は格納中の要素数です。要素数を持つことで、`front == rear` の状態が空なのか満杯なのかを区別できます。

### Red: FIFO・満杯・折り返しをテストする

```kotlin
@Test
fun `fixed queue wraps around and can become full after wrap`() {
    val queue = FixedQueue<Int>(3)
    queue.enque(1)
    queue.enque(2)
    queue.enque(3)
    assertEquals(1, queue.deque())
    queue.enque(4)

    assertTrue(queue.isFull())
    assertEquals(2, queue.deque())
    assertEquals(3, queue.deque())
    assertEquals(4, queue.deque())
}
```

配列の末尾で `rear` が先頭に戻っても、取り出し順序は変わりません。空・満杯・容量 0 のケースもスタック同様にテストします。

### Green: インデックスを環状に進める

```kotlin
class FixedQueue<T : Any>(val capacity: Int) {
    private val elements: Array<Any?>
    private var front = 0
    private var rear = 0
    private var count = 0

    init {
        require(capacity > 0) { "容量は 1 以上でなければなりません。" }
        elements = arrayOfNulls(capacity)
    }

    fun enque(value: T) {
        check(count < capacity) { "キューは満杯です。" }
        elements[rear] = value
        rear = nextIndex(rear)
        count++
    }

    fun deque(): T {
        check(count > 0) { "キューは空です。" }
        val value = elements[front]
        elements[front] = null
        front = nextIndex(front)
        count--
        return value as T
    }

    private fun nextIndex(index: Int): Int = (index + 1) % capacity
}
```

追加・取り出しでは要素をシフトせず、インデックスと要素数だけを更新するため、どちらも `O(1)` 時間です。配列の固定領域は容量を `m` とすると `O(m)` です。`capacity > 0` をコンストラクターで保証するので、剰余演算が 0 除算になることはありません。

### Refactor: 論理順で参照・探索する

リングバッファでは、論理上の先頭からの位置と物理配列のインデックスが一致するとは限りません。オフセット `offset` の要素は `(front + offset) % capacity` で求めます。

```kotlin
fun peek(): T {
    check(count > 0) { "キューは空です。" }
    return elements[front] as T
}

fun find(value: T): Int {
    for (offset in 0 until count) {
        if (elements[(front + offset) % capacity] == value) return offset
    }
    return -1
}

fun clear() {
    elements.fill(null)
    front = 0
    rear = 0
    count = 0
}
```

キューの `find` は物理インデックスではなく、先頭から数えた論理インデックスを返します。`count` と `contains` も現在格納されている論理範囲だけを調べます。これらの走査操作は `O(n)` 時間、`O(1)` 追加領域です。

`clear` は要素参照を消去し、3 つの管理値を初期状態に戻します。クリア後に再び追加・取り出しできることもテストで確認します。

## 3. テスト実行

章のテストを実行します。

```bash
./gradlew test --tests algorithm.StackQueueTest
```

Kotlin プロジェクト全体の品質チェックは次のとおりです。

```bash
./gradlew check
```

## スタックとキューの比較

| 項目 | 固定長スタック | リングバッファ型キュー |
|:---|:---|:---|
| 取り出し順序 | LIFO | FIFO |
| 追加 | `push`、`O(1)` | `enque`、`O(1)` |
| 取り出し | `pop`、`O(1)` | `deque`、`O(1)` |
| 先頭の参照 | `peek`、`O(1)` | `peek`、`O(1)` |
| 探索・個数 | `O(n)` | `O(n)` |
| 領域 | 固定容量 `O(m)` | 固定容量 `O(m)` |
| 主な用途 | 深さ優先探索、呼び出し履歴 | 幅優先探索、到着順タスク処理 |

スタックとキューの違いは取り出し順序です。どちらも配列の端を適切に管理することで、基本操作を定数時間にできます。次章では再帰の基底条件と呼び出しの積み重なりを扱い、スタックとのつながりも確認します。
