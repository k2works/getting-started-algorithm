# 第 9 章 木構造

## はじめに

リストでは要素を一列につなぎました。この章では、データを階層的につなぐ木構造を扱います。二分探索木はキーの大小関係を使って探索・追加・削除を行い、最小ヒープは最小値を効率よく取り出します。

二分探索木のキーには `Comparable<K>` 制約を付け、格納値 `V` とキー `K` を分けます。空の部分木とノードを sealed class で表し、削除の 3 ケースと 3 種類の深さ優先走査をテストします。二分探索木は自動で平衡化しないため、入力順によって性能が変わる点にも注意します。

## 9.1 Red: 木の性質と境界をテストする

まず、空の木、重複キー、探索、走査順、削除の各ケース、最小・最大キーをテストします。キーと値を分けることで、探索順序はキーで決まり、取得するデータは値であることも確認します。

```kotlin
@Test
fun `binary search tree inserts searches and traverses in all orders`() {
    val tree = BinarySearchTree<Int, String>()

    for (key in listOf(5, 3, 7, 1, 4, 6, 8)) {
        assertTrue(tree.add(key, "value-$key"))
    }

    assertEquals("value-6", tree.search(6))
    assertNull(tree.search(9))
    assertEquals(1, tree.minKey())
    assertEquals(8, tree.maxKey())
    assertEquals(
        listOf(1, 3, 4, 5, 6, 7, 8).map { it to "value-$it" },
        tree.inorder(),
    )
}
```

削除テストは葉、子が 1 つのノード、子が 2 つのノード、根、存在しないキーを分けます。ヒープでは空・1 要素・重複値を含む追加と最小値の取り出しを確認します。実際のテストは `TreeStructuresTest` にあります。

## 9.2 二分探索木を実装する

二分探索木では、各ノードの左部分木のキーがノードのキーより小さく、右部分木のキーが大きくなります。同じ比較キーは重複として追加しません。中順走査では左部分木、ノード、右部分木の順に処理するため、キーの昇順になります。

### sealed class で空とノードを表す

```kotlin
private sealed class Node<K : Comparable<K>, V : Any> {
    class Empty<K : Comparable<K>, V : Any> : Node<K, V>()

    class Branch<K : Comparable<K>, V : Any>(
        var key: K,
        var value: V,
        var left: Node<K, V> = Empty(),
        var right: Node<K, V> = Empty(),
    ) : Node<K, V>()
}

private var root: Node<K, V> = Node.Empty()
```

`Node` は空を表す `Empty` とデータを持つ `Branch` に限定されます。左右の子も同じ型なので、子が存在しない状態を nullable にせず明示できます。`when` 式では sealed class の全ケースをコンパイラが検査します。

### 追加と探索

追加では、キーを現在ノードと比較し、小さければ左、大きければ右へ再帰的に進みます。空の位置に到達したら新しいノードを置きます。比較結果が等しい場合は追加せず `false` を返し、元の値を保持します。

```kotlin
fun add(key: K, value: V): Boolean {
    val (updatedRoot, added) = insert(root, key, value)
    root = updatedRoot
    if (added) size++
    return added
}

private fun insert(node: Node<K, V>, key: K, value: V): Pair<Node<K, V>, Boolean> =
    when (node) {
        is Node.Empty -> Node.Branch(key, value) to true
        is Node.Branch -> {
            val comparison = key.compareTo(node.key)
            when {
                comparison == 0 -> node to false
                comparison < 0 -> {
                    val (left, added) = insert(node.left, key, value)
                    node.left = left
                    node to added
                }
                else -> {
                    val (right, added) = insert(node.right, key, value)
                    node.right = right
                    node to added
                }
            }
        }
    }
```

探索は同じ比較を使って枝を選び、キーが一致すれば値を返します。空の部分木に到達したら `null` です。`V : Any` の制約により、`null` は値ではなく未発見を示せます。

```kotlin
fun search(key: K): V? {
    var current = root
    while (current is Node.Branch) {
        when {
            key == current.key -> return current.value
            key < current.key -> current = current.left
            else -> current = current.right
        }
    }
    return null
}
```

`K` は大小比較に一貫性のある `Comparable` 型を使います。追加・探索・削除の時間計算量は木の高さを `h` として O(h) です。均衡した木では `h = O(log n)`、片側に偏った木では `h = O(n)` になります。

### 削除の 3 ケース

削除対象のノードに応じて処理を分けます。

1. **葉**: 子を持たないので、その位置を `Empty` に置き換えます。
2. **子が 1 つ**: その子を削除位置の親につなぎます。
3. **子が 2 つ**: 右部分木の最小キー（中順後継）とキー・値を置き換え、後継ノードを右部分木から削除します。

```kotlin
private fun remove(node: Node<K, V>, key: K): Pair<Node<K, V>, Boolean> =
    when (node) {
        is Node.Empty -> node to false
        is Node.Branch -> {
            val comparison = key.compareTo(node.key)
            when {
                comparison < 0 -> {
                    val (left, removed) = remove(node.left, key)
                    node.left = left
                    node to removed
                }
                comparison > 0 -> {
                    val (right, removed) = remove(node.right, key)
                    node.right = right
                    node to removed
                }
                node.left is Node.Empty -> node.right to true
                node.right is Node.Empty -> node.left to true
                else -> {
                    val successor = minimum(node.right)
                    node.key = successor.key
                    node.value = successor.value
                    val (right, _) = remove(node.right, successor.key)
                    node.right = right
                    node to true
                }
            }
        }
    }
```

公開メソッドでは返された根を更新し、削除に成功したときだけ `size` を減らします。再帰関数が新しい部分木と成功状態を返すため、根そのものを削除するときも同じ処理で扱えます。削除も O(h) 時間、再帰呼び出しに O(h) スタック領域を使います。

### 走査と最小・最大キー

深さ優先走査の順番は次のとおりです。

| 走査 | 訪問順 | 用途 |
|:---|:---|:---|
| 前順（preorder） | ノード → 左 → 右 | 木の構造を先に記録 |
| 中順（inorder） | 左 → ノード → 右 | 二分探索木のキーを昇順に列挙 |
| 後順（postorder） | 左 → 右 → ノード | 子を処理してから親を処理 |

いずれも再帰的に部分木を走査し、結果を新しい `List<Pair<K, V>>` に格納します。時間計算量は O(n)、結果リストは O(n)、再帰スタックは O(h) です。最小キーは左端、最大キーは右端のノードです。木が空なら `minKey()` と `maxKey()` は `null` を返します。

## 9.3 配列で最小ヒープを実装する

最小ヒープは、親の値が子の値以下である完全二分木です。完全二分木は上の段から左詰めになるため、配列で隙間なく表現できます。インデックス `i` の親は `(i - 1) / 2`、左の子は `2i + 1`、右の子は `2i + 2` です。

```kotlin
class MinHeap<T : Comparable<T>> {
    private val elements = mutableListOf<T>()

    val size: Int
        get() = elements.size

    fun peek(): T? = elements.firstOrNull()

    fun add(value: T) {
        elements.add(value)
        siftUp(elements.lastIndex)
    }
}
```

追加した値は末尾に置き、親より小さい間、親と交換して上へ移動します。これを sift up と呼びます。`peek()` はヒープの根を返すだけなので O(1) です。

最小値を取り出すときは、根を保存し、末尾要素を根に移してから、子の小さい方と比較しながら下へ移動します。

```kotlin
fun removeMin(): T? {
    if (elements.isEmpty()) return null
    val minimum = elements[0]
    val last = elements.removeAt(elements.lastIndex)
    if (elements.isNotEmpty()) {
        elements[0] = last
        siftDown(0)
    }
    return minimum
}
```

追加と最小値削除はいずれも木の高さだけ移動するため O(log n) 時間、配列領域は O(n) です。重複値も許容します。空のヒープでの `peek()` と `removeMin()` は `null` を返します。

## 9.4 二分探索木とヒープを比較する

| 特性 | 二分探索木 | 最小ヒープ |
|:---|:---|:---|
| 保つ順序 | 左 < ノード < 右 | 親 ≤ 子 |
| 最小値 | 左端を探す | 根にある |
| 任意キーの探索 | O(h) | O(n) |
| 追加 | O(h) | O(log n) |
| 最小値の取得 | O(h) | O(1) |
| 最小値の削除 | O(h) | O(log n) |
| 最悪の高さ・構造 | 偏ると O(n) | 完全二分木で O(log n) 高さ |

二分探索木はキー順に全体を走査でき、特定キーの探索にも適しますが、自己平衡化しないため最悪計算量は O(n) です。ヒープは最小値の取得・削除を優先する構造で、任意の値を探したり、全要素をソート順で走査したりする用途には向きません。

## テストの実行

リポジトリルートで Nix 環境に入り、Kotlin アプリケーションの対象テストを実行します。

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test --tests algorithm.TreeStructuresTest
```

## まとめ

二分探索木は大小比較で探索範囲を絞り、ノード削除では子の数に応じてリンクを組み替えます。中順走査が昇順になるのは、左部分木・ノード・右部分木の順序と木の不変条件によります。最小ヒープは完全二分木を配列で表し、根の最小値を効率よく取り出します。用途に応じて、任意キーの探索・順序走査には探索木、最小値の優先取り出しにはヒープを選びましょう。
