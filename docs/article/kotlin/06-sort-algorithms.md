# 第 6 章 ソートアルゴリズム

## はじめに

ソート（整列）は、値を昇順や降順に並べ替える処理です。この章では、バブル・選択・挿入・クイック・マージソートを TDD で実装し、各方式の計算量とデータ変更の契約を比較します。

バブル・選択・挿入・クイックソートは `IntArray` を直接変更します。マージソートは `List<T>` を受け取り、元のリストを変更せず、新しい整列済みリストを返します。完成版のコードとテストは `apps/kotlin/src/main/kotlin/algorithm/SortingAlgorithms.kt` と `apps/kotlin/src/test/kotlin/algorithm/SortingAlgorithmsTest.kt` にあります。

## 準備

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test --tests algorithm.SortingAlgorithmsTest
```

各 in-place ソートには、通常の入力に加えて空配列、単一要素、整列済み、逆順、重複値、`Int` の上下限をテストします。比較する配列はテストごとにコピーし、ソート関数が入力配列を変更する契約を確かめます。

## ソートの評価基準

- **時間計算量**: 比較や要素移動の回数が入力件数とともにどう増えるか。
- **空間計算量**: 入力以外に必要な領域。再帰呼び出しのスタックも含みます。
- **安定性**: 比較上等しい要素の元の順序を維持するか。
- **変更契約**: 入力を直接変更するか、新しい結果を返すか。

## 6.1 バブルソート

隣り合う要素を比較し、順序が逆なら交換します。1 回の走査で最大値が未整列部分の末尾へ移動します。

### Red: 期待する順序と境界をテストする

```kotlin
@Test
fun `bubble sort orders values in place`() {
    val values = intArrayOf(6, 4, 3, 7, 1, 9, 8)

    SortingAlgorithms.bubbleSort(values)

    assertEquals(listOf(1, 3, 4, 6, 7, 8, 9), values.toList())
}
```

### Green: 隣り合う値を交換する

```kotlin
fun bubbleSort(values: IntArray) {
    for (start in 0 until values.lastIndex) {
        var swapped = false
        for (index in values.lastIndex downTo start + 1) {
            if (values[index - 1] > values[index]) {
                swap(values, index - 1, index)
                swapped = true
            }
        }
        if (!swapped) return
    }
}
```

各パスの開始時点で、`start` より前は整列済みです。1 回も交換がなければ配列全体が整列済みなので、早期終了できます。最悪時間計算量は `O(n²)`、整列済み入力では `O(n)` です。隣接要素だけを交換し、等しい値は交換しないため安定です。追加領域は `O(1)` です。

## 6.2 選択ソート

未整列部分から最小値を探し、その部分の先頭と交換します。ソート済み部分が左から 1 要素ずつ広がります。

### Red: 最小値が先頭へ移ることをテストする

```kotlin
@Test
fun `selection sort orders values in place`() {
    val values = intArrayOf(6, 4, 3, 7, 1, 9, 8)

    SortingAlgorithms.selectionSort(values)

    assertEquals(listOf(1, 3, 4, 6, 7, 8, 9), values.toList())
}
```

### Green: 未整列部分の最小位置を選ぶ

```kotlin
fun selectionSort(values: IntArray) {
    for (start in 0 until values.lastIndex) {
        var minimumIndex = start
        for (index in start + 1..values.lastIndex) {
            if (values[index] < values[minimumIndex]) minimumIndex = index
        }
        if (minimumIndex != start) swap(values, start, minimumIndex)
    }
}
```

未整列部分の最小値を見つけるため、入力が整列済みでも比較回数は `O(n²)` です。交換は各パス最大 1 回です。離れた位置の要素を交換することがあるため安定ではありません。追加領域は `O(1)` です。

## 6.3 挿入ソート

左側を整列済みとして保ち、次の値をその範囲の正しい位置へ挿入します。カードを手に持って順序を整える操作に似ています。

### Red: 逆順や重複を含む入力をテストする

```kotlin
@Test
fun `insertion sort orders values in place`() {
    val values = intArrayOf(4, 3, 2, 1, 2)

    SortingAlgorithms.insertionSort(values)

    assertEquals(listOf(1, 2, 2, 3, 4), values.toList())
}
```

### Green: 大きい値を右へずらして挿入する

```kotlin
fun insertionSort(values: IntArray) {
    for (index in 1..values.lastIndex) {
        val value = values[index]
        var insertionIndex = index
        while (insertionIndex > 0 && values[insertionIndex - 1] > value) {
            values[insertionIndex] = values[insertionIndex - 1]
            insertionIndex--
        }
        values[insertionIndex] = value
    }
}
```

`insertionIndex` より左は常に整列済みです。値が等しい場合にずらさないので安定です。整列済み入力では `O(n)`、逆順では `O(n²)` です。入力規模が小さい場合や、ほぼ整列済みのデータに向いています。追加領域は `O(1)` です。

## 6.4 クイックソート

ピボットを選び、それより小さい値を左、大きい値を右へ分けてから、左右を再帰的にソートします。実装では区間の中央にある値をピボットとして使います。

### Red: 分割後の順序と大きな入力をテストする

```kotlin
@Test
fun `quick sort orders values in place`() {
    val values = intArrayOf(6, 4, 3, 7, 1, 9, 8)

    SortingAlgorithms.quickSort(values)

    assertEquals(listOf(1, 3, 4, 6, 7, 8, 9), values.toList())
}

@Test
fun `quick sort handles a large sorted array`() {
    val values = IntArray(10_000) { it }

    SortingAlgorithms.quickSort(values)

    assertEquals((0 until 10_000).toList(), values.toList())
}
```

### Green: 分割して左右を再帰的に整列する

```kotlin
fun quickSort(values: IntArray) {
    fun sort(left: Int, right: Int) {
        if (left >= right) return
        var low = left
        var high = right
        val pivot = values[left + (right - left) / 2]
        while (low <= high) {
            while (values[low] < pivot) low++
            while (values[high] > pivot) high--
            if (low <= high) {
                swap(values, low, high)
                low++
                high--
            }
        }
        sort(left, high)
        sort(low, right)
    }

    sort(0, values.lastIndex)
}
```

空配列や 1 要素の配列では、最初の `left >= right` で終了します。中央のピボットを使うと、昇順データでは均等に近い分割になります。ただし、任意の入力で均等な分割が保証されるわけではありません。平均時間計算量は `O(n log n)`、最悪は `O(n²)` です。再帰スタックは平均 `O(log n)`、最悪 `O(n)` で、要素交換を行うため安定ではありません。

## 6.5 マージソート

リストを半分に分割し、それぞれを整列してから、2 つの整列済み部分をマージします。分割統治法の代表例です。

### Red: 結果と入力の非破壊をテストする

```kotlin
@Test
fun `merge sort returns a sorted copy and preserves its input`() {
    val input = listOf(6, 4, 3, 7, 1, 9, 8)

    val sorted = SortingAlgorithms.mergeSort(input)

    assertEquals(listOf(1, 3, 4, 6, 7, 8, 9), sorted)
    assertEquals(listOf(6, 4, 3, 7, 1, 9, 8), input)
}
```

### Green: 整列済みの半分を安定してマージする

```kotlin
fun <T : Comparable<T>> mergeSort(input: List<T>): List<T> {
    val values = input.toMutableList()
    val buffer = values.toMutableList()

    fun sort(left: Int, right: Int) {
        if (left >= right) return
        val middle = left + (right - left) / 2
        sort(left, middle)
        sort(middle + 1, right)

        var leftIndex = left
        var rightIndex = middle + 1
        for (index in left..right) {
            when {
                leftIndex > middle -> buffer[index] = values[rightIndex++]
                rightIndex > right -> buffer[index] = values[leftIndex++]
                values[leftIndex] <= values[rightIndex] ->
                    buffer[index] = values[leftIndex++]
                else -> buffer[index] = values[rightIndex++]
            }
        }
        for (index in left..right) values[index] = buffer[index]
    }

    sort(0, values.lastIndex)
    return values.toList()
}
```

`List<T>` は読み取り専用インターフェースとして受け取り、内部コピーだけを変更します。比較結果が等しいときに左側を先に選ぶことで、安定性を保ちます。`Comparable<T>` を使っているため、整数だけでなく比較可能な値も整列できます。時間計算量は最悪を含め `O(n log n)`、作業用バッファに `O(n)` の領域を使います。

## 計算量と特性の比較

| アルゴリズム | 最良時間 | 平均時間 | 最悪時間 | 追加領域 | 安定 | 変更契約 |
|:---|:---:|:---:|:---:|:---:|:---:|:---|
| バブル | `O(n)` | `O(n²)` | `O(n²)` | `O(1)` | はい | `IntArray` を変更 |
| 選択 | `O(n²)` | `O(n²)` | `O(n²)` | `O(1)` | いいえ | `IntArray` を変更 |
| 挿入 | `O(n)` | `O(n²)` | `O(n²)` | `O(1)` | はい | `IntArray` を変更 |
| クイック | `O(n log n)` | `O(n log n)` | `O(n²)` | 平均 `O(log n)`、最悪 `O(n)` | いいえ | `IntArray` を変更 |
| マージ | `O(n log n)` | `O(n log n)` | `O(n log n)` | `O(n)` | はい | 入力 `List` を保持し、新しい `List` を返す |

`n = 10` なら `n²` は 100 程度ですが、`n = 1,000` では約 1,000,000、`n = 1,000,000` では約 1 兆の規模になります。データ件数が増えるほど、入力サイズに対する増え方の差が重要になります。

## まとめ

小さい配列やほぼ整列済みのデータには挿入ソートが扱いやすく、一般的な配列ではクイックソートが平均的に高速です。安定性と最悪時間の保証が必要な場合はマージソートが候補になります。どの方式を選ぶときも、計算量だけでなく、安定性、追加メモリ、入力を変更する契約を合わせて考えましょう。
