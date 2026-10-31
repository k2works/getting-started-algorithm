# 第 2 章 配列

## はじめに

配列は、同じ型の値をインデックスで管理する基本的なデータ構造です。この章では Kotlin の `IntArray` を使い、最大値の探索、配列の反転、基数変換、素数判定の効率改善を TDD で学びます。

前章と同様、記事中のコードは `apps/kotlin/` にある完成版からの抜粋です。テストと実装はそれぞれ `src/test/kotlin/algorithm/ArrayAlgorithmsTest.kt` と `src/main/kotlin/algorithm/ArrayAlgorithms.kt` にあります。

## 準備

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test
```

Kotlin の `IntArray` は整数を格納する固定長配列です。宣言後に長さは変えられませんが、要素は変更できます。インデックスは 0 から始まり、最後のインデックスは `lastIndex` です。

```kotlin
val scores = intArrayOf(72, 85, 91)
println(scores[0])       // 72
println(scores.size)     // 3
println(scores.lastIndex) // 2
scores[1] = 88           // 要素は変更できる

val copied = scores.copyOf() // 別の配列を作る
```

`Array<Int>` も使えますが、プリミティブ整数を扱うアルゴリズムでは `IntArray` を使うと、型が明確でボクシングも避けられます。`IntArray` の等価性は参照ではなく内容で比較したいため、テストでは `toList()` に変換して確認します。

## 1. 配列の最大値

配列を先頭から走査し、これまでに見つけた最大値を更新します。空配列には最大値がないため、この実装では `IllegalArgumentException` を送出する仕様にします。

### Red: テストを先に書く

```kotlin
@Test
fun `maxOf returns largest element`() {
    assertEquals(192, ArrayAlgorithms.maxOf(intArrayOf(172, 153, 192, 140, 165)))
    assertEquals(42, ArrayAlgorithms.maxOf(intArrayOf(42)))
    assertEquals(5, ArrayAlgorithms.maxOf(intArrayOf(5, 5, 5)))
    assertEquals(-1, ArrayAlgorithms.maxOf(intArrayOf(-9, -1, -4)))
    assertFailsWith<IllegalArgumentException> {
        ArrayAlgorithms.maxOf(intArrayOf())
    }
}
```

### Green: 先頭を最大候補にする

```kotlin
fun maxOf(a: IntArray): Int {
    require(a.isNotEmpty()) { "配列は空にできません。" }

    var maximum = a[0]
    for (i in 1 until a.size) {
        if (a[i] > maximum) maximum = a[i]
    }
    return maximum
}
```

最初の要素を最大値と仮定し、残りを 1 回ずつ比較します。走査中は「`maximum` は調べ終えた範囲の最大値である」という不変条件が成り立ちます。比較回数は `n - 1` 回なので時間計算量は `O(n)`、追加領域は `O(1)` です。

## 2. 配列の反転

新しい配列を作らず、左右対称の要素を交換して入力配列自体を反転します。したがって、この関数は呼び出し元の配列を変更します。

### Red: 奇数・偶数・境界のケースを書く

```kotlin
@Test
fun `reverse changes array order in place`() {
    val odd = intArrayOf(2, 5, 1, 3, 9, 6, 7)
    ArrayAlgorithms.reverse(odd)
    assertEquals(listOf(7, 6, 9, 3, 1, 5, 2), odd.toList())

    val even = intArrayOf(1, 2, 3, 4)
    ArrayAlgorithms.reverse(even)
    assertEquals(listOf(4, 3, 2, 1), even.toList())

    val singleton = intArrayOf(42)
    ArrayAlgorithms.reverse(singleton)
    assertEquals(listOf(42), singleton.toList())

    val empty = intArrayOf()
    ArrayAlgorithms.reverse(empty)
    assertEquals(emptyList(), empty.toList())
}
```

### Green: 両端から中央へ交換する

```kotlin
fun reverse(a: IntArray) {
    var left = 0
    var right = a.lastIndex
    while (left < right) {
        val temporary = a[left]
        a[left] = a[right]
        a[right] = temporary
        left++
        right--
    }
}
```

各交換で未処理部分が両端から 1 要素ずつ縮まります。奇数長では中央の要素をそのまま残し、空配列や 1 要素の配列ではループに入りません。交換回数は最大 `n / 2` 回なので時間計算量は `O(n)`、追加領域は一時変数だけの `O(1)` です。

## 3. 基数変換

整数を `radix` 進数の文字列に変換します。`x` を基数で繰り返し割り、余りを下位の桁から取得して最後に反転します。この実装は 0 以上の `Int` と基数 2〜36 を受け取り、16 進数以上の桁は大文字で表します。

### Red: 代表的な基数と入力境界を確認する

```kotlin
@Test
fun `cardConv converts nonnegative integers to bases from two through thirty six`() {
    assertEquals("11101", ArrayAlgorithms.cardConv(29, 2))
    assertEquals("35", ArrayAlgorithms.cardConv(29, 8))
    assertEquals("FF", ArrayAlgorithms.cardConv(255, 16))
    assertEquals("0", ArrayAlgorithms.cardConv(0, 2))
    assertEquals("Z", ArrayAlgorithms.cardConv(35, 36))
    assertEquals("ZIK0ZJ", ArrayAlgorithms.cardConv(Int.MAX_VALUE, 36))
}

@Test
fun `cardConv rejects negative values and invalid bases`() {
    assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(-1, 10) }
    assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(10, 1) }
    assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(10, 37) }
}
```

### Green: 余りを桁文字に変換する

```kotlin
private const val DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

fun cardConv(x: Int, radix: Int): String {
    require(x >= 0) { "変換する値は 0 以上でなければなりません。" }
    require(radix in 2..DIGITS.length) { "基数は 2 から 36 の範囲で指定してください。" }
    if (x == 0) return "0"

    var value = x
    val result = StringBuilder()
    while (value > 0) {
        result.append(DIGITS[value % radix])
        value /= radix
    }
    return result.reverse().toString()
}
```

29 を 2 進数にする場合、余りは順に `1, 0, 1, 1, 1` となり、下位の桁から並んでいます。`StringBuilder` に追加して最後に反転するため、繰り返し文字列を連結する方法より効率的です。桁数は `log_radix(x)` に比例し、時間・出力領域ともに `O(log_radix(x))` です。0 はループに入らないので、個別に `"0"` を返します。

## 4. 素数判定の試行回数を比べる

この節では、上限 `x` 以下の素数を内部で見つけながら、素数判定に使った剰余演算（`%`）の回数を返します。返り値は素数の個数や素数リストではなく、アルゴリズム比較のための測定値です。

### Red: 3 つの版の測定値を書く

```kotlin
@Test
fun `prime versions report modulo operation counts`() {
    assertEquals(78_022L, ArrayAlgorithms.prime1(1_000))
    assertEquals(14_622L, ArrayAlgorithms.prime2(1_000))
    assertEquals(1_804L, ArrayAlgorithms.prime3(1_000))
    assertEquals(0L, ArrayAlgorithms.prime1(1))
    assertEquals(0L, ArrayAlgorithms.prime2(2))
    assertEquals(0L, ArrayAlgorithms.prime3(3))
}
```

ここでは各版で同じ操作、つまり `%` による割り切れ判定だけを数えます。ループ条件の評価などを数える別の測定方法とは値が異なります。

### Green: 版 1 — すべての整数で試す

```kotlin
fun prime1(x: Int): Long {
    var divisions = 0L
    for (n in 2..x) {
        for (divisor in 2 until n) {
            divisions++
            if (n % divisor == 0) break
        }
    }
    return divisions
}
```

各候補 `n` を 2 から `n - 1` までの整数で調べます。素数では多くの除算が必要になるため、上限に対する時間計算量は `O(n²)` です。

### Refactor: 版 2 — 偶数を除き、既知の素数で試す

```kotlin
fun prime2(x: Int): Long {
    var divisions = 0L
    val primes = mutableListOf(2)
    for (n in 3..x step 2) {
        var isPrime = true
        for (i in 1 until primes.size) {
            divisions++
            if (n % primes[i] == 0) {
                isPrime = false
                break
            }
        }
        if (isPrime) primes.add(n)
    }
    return divisions
}
```

2 より大きい偶数は素数ではないため候補から除外します。また、合成数を割り切る最小の約数は素数なので、すでに見つけた奇素数だけで判定できます。素数リストは必要な分だけ `MutableList` に保持し、固定長配列の容量制限を避けています。

### Refactor: 版 3 — 平方根以下の既知の素数だけ試す

```kotlin
fun prime3(x: Int): Long {
    var divisions = 0L
    val primes = mutableListOf(2, 3)
    for (n in 5..x step 2) {
        var isPrime = true
        var i = 1
        while (i < primes.size && primes[i] <= n / primes[i]) {
            divisions++
            if (n % primes[i] == 0) {
                isPrime = false
                break
            }
            i++
        }
        if (isPrime) primes.add(n)
    }
    return divisions
}
```

合成数 `n` は `n = a × b` と表せます。このとき少なくとも一方は `√n` 以下なので、平方根より大きい約数まで調べる必要はありません。条件を `primes[i] * primes[i] <= n` ではなく `primes[i] <= n / primes[i]` と書き、乗算のオーバーフローを避けています。`i < primes.size` を先に評価することで、リストにない要素へのアクセスも防ぎます。

1000 以下で測定すると、剰余演算は版 1 の 78,022 回から版 3 の 1,804 回に減ります。版 2 は 14,622 回です。版 2 は奇数だけを候補にして既知の素数で試し、版 3 はさらに平方根までで打ち切るためです。

| 版 | 上限 1000 の `%` 回数 | 主な改善 |
|:---|---:|:---|
| 1 | 78,022 | 2 から候補の直前まで試す |
| 2 | 14,622 | 偶数を除き、既知の素数で試す |
| 3 | 1,804 | 平方根以下の既知の素数だけ試す |

### 計算量の比較

`n` を上限値としたおおよその上界です。実際の試行回数は、見つかった約数で早期終了するかどうかにも左右されます。

| 版 | 時間計算量の目安 | 補足 |
|:---|:---|:---|
| 1 | `O(n²)` | 全整数を候補とし、約数も全整数を試す |
| 2 | `O(n²)` より小さい | 候補を奇数にし、約数候補を素数に絞る |
| 3 | `O(n√n)` より小さい | 約数候補を平方根以下の素数に絞る |

漸近的な上界だけでなく、同じ入力で同じ操作を数えることで、改善の効果を具体的に比較できます。

## テスト実行

章のテストだけを実行する場合は、`apps/kotlin/` から次のコマンドを実行します。

```bash
./gradlew test --tests algorithm.ArrayAlgorithmsTest
```

## 第 2 章のまとめ

| 題材 | Kotlin の要点 | 時間計算量 | 追加領域 |
|:---|:---|:---|:---|
| 最大値 | `IntArray` を走査、空配列を拒否 | `O(n)` | `O(1)` |
| 配列の反転 | 要素を in-place で交換 | `O(n)` | `O(1)` |
| 基数変換 | 余りと `StringBuilder` を利用 | `O(log_radix(x))` | 出力に比例 |
| 素数判定 1 | 全ての整数を試す | `O(n²)` | `O(1)` 以外に素数リストなし |
| 素数判定 2 | 奇数と既知の素数を利用 | `O(n²)` より小さい | `O(π(n))` |
| 素数判定 3 | 平方根以下で打ち切る | `O(n√n)` より小さい | `O(π(n))` |

`IntArray` は固定長でも、要素を変更できる可変データです。関数が入力配列を変更するのか、新しい値を返すのかを仕様とテストで明確にすることが重要です。次章では線形探索、二分探索、ハッシュ法を通じて、データの探し方と探索効率を学びます。
