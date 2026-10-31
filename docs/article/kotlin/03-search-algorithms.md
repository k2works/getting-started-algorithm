# 第 3 章 探索アルゴリズム

## はじめに

探索は、データの中から目的の値を見つける処理です。この章では `IntArray` に対する線形探索と二分探索、キーと値を対応づけるハッシュ表を実装します。線形探索と二分探索は見つかった位置を返し、見つからない場合は `-1` を返します。ハッシュ表は値を返し、見つからない場合は Kotlin の nullable 型 `String?` で `null` を返します。

完成版のコードとテストは `apps/kotlin/src/main/kotlin/algorithm/SearchAlgorithms.kt` と `apps/kotlin/src/test/kotlin/algorithm/SearchAlgorithmsTest.kt` にあります。記事のコードは学習時に各ファイルへ順に追加する抜粋です。

## 1. 線形探索

線形探索（sequential search）は配列の先頭から順に比較します。配列が整列されていなくても使え、重複した値がある場合は最初に見つかったインデックスを返します。

### Red: 成功・失敗・空配列をテストする

`SearchAlgorithmsTest.kt` に次のテストを追加します。

```kotlin
@Test
fun `linear search variants return the first matching index`() {
    val values = intArrayOf(6, 4, 3, 2, 1, 2, 8)
    assertEquals(3, SearchAlgorithms.linearSearchWhile(values, 2))
    assertEquals(3, SearchAlgorithms.linearSearchFor(values, 2))
    assertEquals(3, SearchAlgorithms.linearSearchSentinel(values, 2))
    assertEquals(0, SearchAlgorithms.linearSearchFor(intArrayOf(2, 2), 2))
}

@Test
fun `linear search variants handle missing values and empty arrays`() {
    val empty = intArrayOf()
    assertEquals(-1, SearchAlgorithms.linearSearchWhile(empty, 1))
    assertEquals(-1, SearchAlgorithms.linearSearchFor(empty, 1))
    assertEquals(-1, SearchAlgorithms.linearSearchSentinel(empty, 1))
}
```

`[6, 4, 3, 2, 1, 2, 8]` で `2` を探すと、最初の一致はインデックス `3` です。テストでは重複値があっても先頭の一致を返すことを明示しています。

### Green: while と for で順に調べる

`SearchAlgorithms` オブジェクトに関数を追加します。

```kotlin
fun linearSearchWhile(a: IntArray, key: Int): Int {
    var index = 0
    while (index < a.size) {
        if (a[index] == key) return index
        index++
    }
    return -1
}

fun linearSearchFor(a: IntArray, key: Int): Int {
    for (index in a.indices) {
        if (a[index] == key) return index
    }
    return -1
}
```

`while` 版はインデックスの初期化・条件・更新を明示します。`for` 版は `a.indices` を使い、有効なインデックスだけを走査します。最初の要素が一致する最良の場合は `O(1)`、未発見または末尾で一致する最悪の場合は `O(n)` です。追加領域は `O(1)` です。

### Refactor: 番兵法でループ内の終了判定をなくす

通常の線形探索は、各回で「配列の末尾に達したか」と「キーに一致したか」を調べます。番兵法では配列のコピー末尾にキーを置くことで、ループ内の比較を一致判定だけにします。

```kotlin
fun linearSearchSentinel(a: IntArray, key: Int): Int {
    val copy = a.copyOf(a.size + 1)
    copy[a.size] = key

    var index = 0
    while (copy[index] != key) index++
    return if (index == a.size) -1 else index
}
```

番兵に一致した場合は元配列にキーがなかったことを意味するため、元の長さと一致したインデックスを比べて `-1` を返します。配列を変更しないようにコピーしているため、追加領域は `O(n)` です。比較回数は少し減りますが、コピーのコストもあります。少量の整数配列では、通常版より常に速いという意味ではありません。最適化は測定結果と用途に基づいて判断します。

## 2. 二分探索

二分探索（binary search）は、ソート済み配列を対象に探索範囲を半分ずつ狭めます。**昇順に整列されていることが前提**です。前提が満たされない配列では、キーがあっても見つからない場合があります。

### Red: 中央・両端・不在・境界値をテストする

```kotlin
@Test
fun `binary search handles sorted values and boundaries`() {
    val values = intArrayOf(1, 2, 3, 5, 7, 8, 9)

    assertEquals(3, SearchAlgorithms.binarySearch(values, 5))
    assertEquals(0, SearchAlgorithms.binarySearch(values, 1))
    assertEquals(6, SearchAlgorithms.binarySearch(values, 9))
    assertEquals(-1, SearchAlgorithms.binarySearch(values, 4))
    assertEquals(-1, SearchAlgorithms.binarySearch(intArrayOf(), 1))
    assertEquals(1, SearchAlgorithms.binarySearch(
        intArrayOf(Int.MIN_VALUE, Int.MAX_VALUE), Int.MAX_VALUE,
    ))
}
```

### Green: 探索範囲の両端を更新する

```kotlin
fun binarySearch(a: IntArray, key: Int): Int {
    var left = 0
    var right = a.lastIndex
    while (left <= right) {
        val middle = left + (right - left) / 2
        when {
            a[middle] == key -> return middle
            a[middle] < key -> left = middle + 1
            else -> right = middle - 1
        }
    }
    return -1
}
```

未探索範囲を `[left, right]` とし、その範囲にキーがあれば必ず含まれるという不変条件を保ちます。中央の値がキーより小さければ左半分を捨て、大きければ右半分を捨てます。`left + (right - left) / 2` と書くことで、`left + right` の加算によるオーバーフローを避けます。

空配列では `right` が `-1` なのでループに入りません。各反復で探索範囲が半分になるため、時間計算量は `O(log n)`、追加領域は `O(1)` です。100 万件なら最大でもおよそ 20 回の範囲縮小で済みますが、配列のソートにかかる時間は別途必要です。

この実装は重複値がある場合に、見つかった要素のうち特定の端（最初・最後）を保証しません。最初の一致を返す仕様が必要なら、見つけた後も左側の範囲を調べる追加処理が必要です。

## 3. ハッシュ法

ハッシュ表はキーからバケット（格納位置）を計算し、キーと値を保存します。同じ位置を計算する異なるキーは「衝突」します。この章では整数キーと文字列値を使い、衝突を解決する 2 つの方法を実装します。

### 3.1 チェイン法

チェイン法は、各バケットに連結リストを置き、同じハッシュ値の要素をつなぎます。容量 5 の表では、キー `1` と `6` はどちらも `key mod 5 = 1` となり衝突します。

#### Red: 衝突、重複、削除をテストする

```kotlin
@Test
fun `chained hash resolves collisions and removes nodes`() {
    val hash = SearchAlgorithms.ChainedHash(5)
    assertTrue(hash.add(1, "赤尾"))
    assertTrue(hash.add(6, "神崎"))

    assertEquals("赤尾", hash.search(1))
    assertEquals("神崎", hash.search(6))
    assertEquals(null, hash.search(11))
    assertFalse(hash.add(6, "重複"))

    assertTrue(hash.remove(1))
    assertEquals("神崎", hash.search(6))
    assertFalse(hash.remove(1))
}
```

`add` は重複キーを追加せず `false` を返します。`search` は見つからない場合に `null` を返すため、戻り値の型は `String?` です。`String` の値として `null` を格納できない API にしているので、「キーなし」と値が曖昧になりません。

#### Green: バケットごとにノードを連結する

```kotlin
class ChainedHash(capacity: Int) {
    private class Node(val key: Int, val value: String, var next: Node?)
    private val table: Array<Node?>

    init {
        require(capacity > 0) { "容量は 1 以上でなければなりません。" }
        table = arrayOfNulls(capacity)
    }

    fun search(key: Int): String? {
        var node = table[hashValue(key)]
        while (node != null) {
            if (node.key == key) return node.value
            node = node.next
        }
        return null
    }

    fun add(key: Int, value: String): Boolean {
        val bucket = hashValue(key)
        var node = table[bucket]
        while (node != null) {
            if (node.key == key) return false
            node = node.next
        }
        table[bucket] = Node(key, value, table[bucket])
        return true
    }

    private fun hashValue(key: Int): Int = Math.floorMod(key, table.size)
}
```

実際の `remove` は、対象ノードをチェインから外すため、先行ノードを保持してリンクをつなぎ直します。バケットの先頭を削除する場合はテーブルの参照自体を更新します。ハッシュ計算に `Math.floorMod` を使うため、負数キーや `Int.MIN_VALUE` でも配列の有効なインデックスを得られます。

平均的に各チェインが短ければ探索・追加・削除は `O(1)` ですが、衝突が集中すると最悪 `O(n)` です。チェイン法の追加領域は格納要素数 `n` に比例して `O(n)` です。

### 3.2 オープンアドレス法（線形探索法）

オープンアドレス法は、衝突した場合に次のバケットを順番に探します。配列を周回し、空きバケットを探す方法を線形探索法と呼びます。

バケットは次の 3 状態を持ちます。

| 状態 | 意味 | 探索での扱い |
|:---|:---|:---|
| `EMPTY` | まだ使われていない | その先にキーはないので探索終了 |
| `OCCUPIED` | キーと値が格納されている | キーを比較 |
| `DELETED` | 削除済み | 探索を続行 |

#### Red: 削除後の探索・再利用・満杯をテストする

```kotlin
@Test
fun `open hash preserves collision chains after deletion`() {
    val hash = SearchAlgorithms.OpenHash(5)
    assertTrue(hash.add(1, "赤尾"))
    assertTrue(hash.add(6, "神崎"))
    assertTrue(hash.add(11, "武田"))

    assertTrue(hash.remove(6))
    assertEquals("武田", hash.search(11))
    assertEquals(null, hash.search(6))
    assertFalse(hash.add(11, "重複"))

    assertTrue(hash.add(16, "小野"))
    assertEquals("小野", hash.search(16))
}
```

キー `1`、`6`、`11` は同じバケットから始まり、順に次の場所へ格納されます。途中の `6` を削除しても、後続の `11` を探索できることが重要です。

#### Green: 削除済みを tombstone として残す

バケットを単に `EMPTY` に戻すと、探索はそこで終了し、後ろにある衝突キーを見失います。そのため削除時は `DELETED` にし、探索を継続します。追加時には最初に見つけた削除済みバケットを再利用できます。ただし、その後ろに同じキーがある可能性があるため、重複確認のために空きバケットまたは全周回まで探索します。

```kotlin
private enum class Status { EMPTY, OCCUPIED, DELETED }

private class Bucket {
    var key: Int? = null
    var value: String? = null
    var status = Status.EMPTY
}

fun search(key: Int): String? {
    var index = hashValue(key)
    repeat(table.size) {
        val bucket = table[index]
        when (bucket.status) {
            Status.EMPTY -> return null
            Status.OCCUPIED -> if (bucket.key == key) return bucket.value
            Status.DELETED -> Unit
        }
        index = (index + 1) % table.size
    }
    return null
}
```

テーブルが満杯でもループは容量回で停止します。`DELETED` の再利用を含む追加、削除、キー重複の確認は `SearchAlgorithms.OpenHash` に実装されています。容量は正の値に制限し、不正な容量で剰余演算や配列アクセスを開始しません。

オープンアドレス法は要素のほかに固定長テーブル `m` 個分の領域を使い、追加領域は `O(m)` です。平均計算量は衝突の少ない状態で `O(1)`、テーブルが満杯に近い場合や衝突が集中する場合は最悪 `O(n)` になります。

## 4. テスト実行

章のテストを実行します。

```bash
./gradlew test --tests algorithm.SearchAlgorithmsTest
```

すべての Kotlin テストを含む品質チェックは次のとおりです。

```bash
./gradlew check
```

## 探索アルゴリズムの比較

| 方法 | 前提条件 | 平均計算量 | 最悪計算量 | 追加領域 |
|:---|:---|:---|:---|:---|
| 線形探索 | なし | `O(n)` | `O(n)` | `O(1)` |
| 番兵法 | なし | `O(n)` | `O(n)` | `O(n)`（コピー） |
| 二分探索 | 昇順に整列済み | `O(log n)` | `O(log n)` | `O(1)` |
| チェイン法 | 正の容量 | `O(1)`（平均） | `O(n)` | `O(n)` |
| オープンアドレス法 | 正の容量 | `O(1)`（平均） | `O(n)` | `O(m)`（テーブル容量） |

二分探索にはソート済みデータが必要で、ハッシュ表には容量と衝突処理が必要です。どの方法が適切かは、データの並び、更新頻度、メモリ、繰り返し探索する回数を基準に選びます。次章ではスタックとキューを実装し、データの取り出し順序を制御する方法を学びます。
