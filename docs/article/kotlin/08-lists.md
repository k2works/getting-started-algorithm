# 第 8 章 リスト

## はじめに

配列は添字によるランダムアクセスが O(1) である一方、途中への挿入・削除では後続要素を移動する必要があります。連結リストは、要素と次の要素への参照を持つノードをつないで順序を表します。添字アクセスはできませんが、ノードへの参照があればリンクの付け替えだけで挿入・削除できます。

この章では、Kotlin のジェネリクスと nullable なリンクを使って単方向連結リストと双方向連結リストを実装します。単方向リストでは先頭・末尾の参照を、双方向リストでは前後の参照と番兵ノードを管理します。ノード自体は公開せず、リストがリンクの更新責務を持つ設計にします。

## 8.1 Red: 操作と境界条件をテストする

値を追加して順番を確認するだけでなく、空リストからの削除、1 要素になったときの先頭・末尾の一致、重複値の最初の削除、削除後の走査も確認します。リストが空なら削除は `null`、値が見つからなければ `remove` は `false` を返す契約です。

```kotlin
@Test
fun `singly linked list removes first last and first matching value`() {
    val list = SinglyLinkedList<Int>()
    assertNull(list.removeFirst())
    assertNull(list.removeLast())
    assertFalse(list.remove(1))

    list.addLast(1)
    list.addLast(2)
    list.addLast(2)
    list.addLast(3)

    assertTrue(list.remove(1))
    assertEquals(listOf(2, 2, 3), list.toList())
    assertTrue(list.remove(2))
    assertEquals(listOf(2, 3), list.toList())
    assertEquals(3, list.removeLast())
    assertEquals(2, list.removeLast())
    assertTrue(list.isEmpty())
}
```

`LinkedListsTest` では同じ種類のケースを双方向リストにも適用し、順方向・逆方向の走査結果を比べます。また `String` と `Int` の両方を格納し、型パラメーターで要素型を安全に扱えることも確認します。

## 8.2 単方向連結リスト

単方向リストのノードは値と次ノードへの nullable な参照を持ちます。リストは `head` と `tail` を保持し、空なら両方が `null`、要素があれば `head` が先頭、`tail` が末尾を指すよう更新します。

```kotlin
class SinglyLinkedList<T : Any> {
    private class Node<T>(val value: T, var next: Node<T>? = null)

    private var head: Node<T>? = null
    private var tail: Node<T>? = null

    var size: Int = 0
        private set

    fun addFirst(value: T) {
        val node = Node(value, head)
        head = node
        if (tail == null) tail = node
        size++
    }

    fun addLast(value: T) {
        val node = Node(value)
        val last = tail
        if (last == null) head = node else last.next = node
        tail = node
        size++
    }
}
```

`T : Any` としているため、要素として `null` は格納しません。これにより、`removeFirst()` / `removeLast()` が返す `null` を「リストが空だった」という結果に使えます。`Node` とリンクを非公開にし、外部からリンクを壊せないようにしています。

### 削除時のリンク更新

先頭削除では `head` を次ノードへ進めます。削除後に `head` が `null` になったら `tail` も `null` に戻します。末尾削除は、単方向リンクでは末尾の前ノードを直接参照できないため、先頭から探して `tail` を更新します。

```kotlin
fun removeFirst(): T? {
    val first = head ?: return null
    head = first.next
    if (head == null) tail = null
    size--
    return first.value
}

fun removeLast(): T? {
    val last = tail ?: return null
    if (head === last) {
        head = null
        tail = null
    } else {
        var previous = checkNotNull(head)
        while (previous.next !== last) {
            previous = checkNotNull(previous.next)
        }
        previous.next = null
        tail = previous
    }
    size--
    return last.value
}
```

値による削除と探索は先頭から順にノードを調べます。`remove(value)` は等しい値のうち最初のノードだけを削除します。先頭を削除する場合は `removeFirst()` に委譲し、それ以外では前ノードの `next` をつなぎ替えます。末尾を削除したときは `tail` も前ノードへ移します。

単方向リストの主な操作は次のとおりです。

| 操作 | 時間計算量 | 理由 |
|:---|:---:|:---|
| 先頭への追加・削除 | O(1) | `head` の更新だけ |
| 末尾への追加 | O(1) | `tail` を保持 |
| 末尾削除 | O(n) | 末尾の前ノードを走査 |
| 値の探索・削除 | O(n) | 最悪で全ノードを走査 |
| 全要素のリスト化 | O(n) | すべてのノードを順に走査 |

`tail` を持つことで末尾追加を O(1) にできますが、削除時には `tail` の一つ前を知る必要があり、単方向リンクだけでは走査が必要です。

## 8.3 双方向連結リスト

双方向リストのノードは `previous` と `next` の両方を持ちます。この実装では、空リストでも前後が自分自身を指す番兵ノードを使います。実データのノードを追加するときは、挿入位置の前後 2 つのリンクを更新します。

```kotlin
class DoublyLinkedList<T : Any> {
    private class Node<T : Any>(var value: T?) {
        lateinit var previous: Node<T>
        lateinit var next: Node<T>
    }

    private val sentinel = Node<T>(null).also {
        it.previous = it
        it.next = it
    }

    var size: Int = 0
        private set

    fun addFirst(value: T) = insertBetween(value, sentinel, sentinel.next)

    fun addLast(value: T) = insertBetween(value, sentinel.previous, sentinel)

    private fun insertBetween(value: T, previous: Node<T>, next: Node<T>) {
        val node = Node(value)
        node.previous = previous
        node.next = next
        previous.next = node
        next.previous = node
        size++
    }
}
```

番兵ノードは通常の要素ではありません。値を `null` にし、空リストでは `sentinel.next` と `sentinel.previous` の両方が番兵自身を指す状態にします。要素型は `T : Any` なので、実データの値と番兵を区別できます。`lateinit` はノード作成時に `previous` と `next` を直ちに設定する内部実装に限定しています。

先頭・末尾の削除は、それぞれ番兵の隣のノードを外します。ノードの前後をつなぎ直す処理を `unlink` に集約し、削除後のリンクも自分自身へ戻して、孤立したノードが古いリストを参照し続けないようにします。

```kotlin
private fun unlink(node: Node<T>): T {
    val value = checkNotNull(node.value)
    node.previous.next = node.next
    node.next.previous = node.previous
    node.previous = node
    node.next = node
    node.value = null
    size--
    return value
}
```

双方向リストでは、先頭・末尾の追加と削除は O(1) です。値による探索・削除は対象ノードを探す必要があるため O(n) です。対象ノードをすでに持っていればリンク付け替えは O(1) ですが、この API はノードを外部公開しないため、所有権と更新責務をリストの中に閉じています。前後 2 つのリンクを持つので、単方向リストより各ノードの追加領域は大きくなります。

## 8.4 配列と連結リストを使い分ける

`toList()` と `reversed()` はリストの内容から新しい Kotlin `List` を作ります。返したスナップショットを変更しても連結リストのリンクは変わりません。これは、内部ノードを公開せずに内容を確認できるようにするためです。

| 操作・特性 | 配列 | 単方向連結リスト | 双方向連結リスト |
|:---|:---:|:---:|:---:|
| 添字によるアクセス | O(1) | O(n) | O(n) |
| 先頭への追加・削除 | O(n) | O(1) | O(1) |
| 末尾への追加 | 償却 O(1) | O(1)（末尾参照あり） | O(1) |
| 末尾の削除 | O(1) | O(n) | O(1) |
| 値による探索 | O(n) | O(n) | O(n) |
| ノードごとのリンク領域 | なし | 次リンク 1 個 | 前後リンク 2 個 |

連結リストは任意の位置へ常に高速で挿入できるわけではありません。挿入箇所を見つける走査が必要なら、その探索時間は O(n) です。既に位置やノードへの参照を持っている場合に限り、リンクの更新自体が O(1) になります。

## テストの実行

リポジトリルートで Nix 環境に入り、Kotlin アプリケーションの対象テストを実行します。

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test --tests algorithm.LinkedListsTest
```

## まとめ

この章では、単方向リストと番兵ノードを使った双方向リストを実装しました。nullable なリンク、先頭・末尾参照、サイズを整合させて保つことが正しさの要点です。配列と連結リストのどちらを選ぶかは、添字アクセス、挿入・削除の頻度、メモリ使用量を合わせて判断します。次章では、ノードを階層的につなぐ木構造を学びます。
