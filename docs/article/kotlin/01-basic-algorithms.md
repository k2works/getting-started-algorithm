# 第 1 章 基本的なアルゴリズム

## はじめに

アルゴリズムとは、問題を解決するための明確な手順です。この章では、3 値の最大値と中央値、条件分岐、繰り返し、多重ループを題材に、Kotlin で基本的なアルゴリズムを実装します。

前作の「テスト駆動開発から始める Kotlin 入門」で学んだ TDD の Red → Green → Refactor を続けます。テストを先に書き、テストがコンパイルエラーや assertion failure で失敗する Red を確認し、最小限の実装で Green にします。その後、テストを保ったまま読みやすさや計算量を見直します。Kotlin では、テストコードがまだ存在しない関数を参照する場合、最初の Red は実行時エラーではなくコンパイルエラーになります。

この章の実装とテストは `apps/kotlin/` にあります。記事のコードは学習時に各ファイルへ順に追記する抜粋です。完成版の全コードは同じファイルで確認できます。

## 準備

```bash
# Kotlin と JDK 25、Gradle の開発環境に入る
nix develop .#kotlin

cd apps/kotlin

# テストを実行する
./gradlew test
```

プロジェクト構成は次のとおりです。

```text
apps/kotlin/
├── build.gradle.kts
├── settings.gradle.kts
├── src/main/kotlin/algorithm/BasicAlgorithms.kt
└── src/test/kotlin/algorithm/BasicAlgorithmsTest.kt
```

`kotlin.test` の `@Test` と `assertEquals` を使います。テストの第 1 引数は期待値、第 2 引数は実際の値です。Gradle Wrapper は Gradle のバージョンをプロジェクトで固定し、環境間で同じビルドを再現します。

## 1.1 アルゴリズムとは

アルゴリズムは入力から出力を得る手順です。テストでは、通常の入力に加えて、境界値や同じ値が並ぶ場合も確認します。Kotlin では型を宣言できるため、入力・戻り値の種類をコンパイル時に確認できます。

この章で作る関数は `BasicAlgorithms` オブジェクトにまとめます。`object` はシングルトンを宣言する Kotlin の構文で、インスタンスを作らずに `BasicAlgorithms.max3(...)` と呼び出せます。

## 1.2 3 値の最大値

3 つの整数から最大値を求めます。値の大小関係と同値の組み合わせ 13 パターンをテストします。

### Red: 失敗するテストを書く

`src/test/kotlin/algorithm/BasicAlgorithmsTest.kt` にテストを追加します。

```kotlin
package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals

class BasicAlgorithmsTest {
    @Test
    fun `max3 returns the maximum for every ordering and ties`() {
        val cases = listOf(
            listOf(3, 2, 1, 3), listOf(3, 2, 2, 3), listOf(3, 1, 2, 3),
            listOf(3, 2, 3, 3), listOf(2, 1, 3, 3), listOf(3, 3, 2, 3),
            listOf(3, 3, 3, 3), listOf(2, 2, 3, 3), listOf(2, 3, 1, 3),
            listOf(2, 3, 2, 3), listOf(1, 3, 2, 3), listOf(2, 3, 3, 3),
            listOf(1, 2, 3, 3),
        )

        cases.forEach { (a, b, c, expected) ->
            assertEquals(expected, BasicAlgorithms.max3(a, b, c))
        }
    }
}
```

`BasicAlgorithms.max3` がないため、テストを実行するとコンパイルエラーになります。存在しない関数への参照が失敗することを Red として確認します。

### Green: 順に比較する

`src/main/kotlin/algorithm/BasicAlgorithms.kt` を作成し、最初の値を最大候補として順番に比較します。

```kotlin
package algorithm

object BasicAlgorithms {
    fun max3(a: Int, b: Int, c: Int): Int {
        var maximum = a
        if (b > maximum) maximum = b
        if (c > maximum) maximum = c
        return maximum
    }
}
```

すべての分岐で最大値が更新されたときだけ候補を書き換えます。3 回の比較で処理が終わるため、時間計算量は `O(1)`、追加領域も `O(1)` です。

### Refactor: テストで境界を確かめる

`Int.MIN_VALUE` と `Int.MAX_VALUE` も比較だけで正しく扱えます。加算や減算を使わないため、整数のオーバーフローを起こしません。

```kotlin
assertEquals(Int.MAX_VALUE, BasicAlgorithms.max3(Int.MIN_VALUE, 0, Int.MAX_VALUE))
```

## 1.3 3 値の中央値

中央値は、値を小さい順に並べたとき中央に来る値です。最大値と同様に、すべての大小関係と同値を含む 13 ケースを確認します。

### Red: テストを先に書く

次のテストを `BasicAlgorithmsTest` に追加します。

```kotlin
@Test
fun `med3 returns the median for every ordering and ties`() {
    val cases = listOf(
        listOf(3, 2, 1, 2), listOf(3, 2, 2, 2), listOf(3, 1, 2, 2),
        listOf(3, 2, 3, 3), listOf(2, 1, 3, 2), listOf(3, 3, 2, 3),
        listOf(3, 3, 3, 3), listOf(2, 2, 3, 2), listOf(2, 3, 1, 2),
        listOf(2, 3, 2, 2), listOf(1, 3, 2, 2), listOf(2, 3, 3, 3),
        listOf(1, 2, 3, 2),
    )

    cases.forEach { (a, b, c, expected) ->
        assertEquals(expected, BasicAlgorithms.med3(a, b, c))
    }
}
```

関数がない状態ではコンパイルエラーになります。

### Green: 条件分岐で実装する

`BasicAlgorithms` に次の関数を追加します。`when` は条件を上から順に評価し、最初に真になった分岐の値を返す式です。

```kotlin
fun med3(a: Int, b: Int, c: Int): Int =
    when {
        a >= b && b >= c -> b
        a <= b && b <= c -> b
        b >= a && a >= c -> a
        b <= a && a <= c -> a
        c >= a && a >= b -> a
        else -> c
    }
```

この分岐は各入力の並びを漏れなく扱い、同じ値がある場合にも中央値を返します。固定数の比較なので、時間・空間計算量はともに `O(1)` です。

### Refactor: 分岐を簡潔にする

中央値は 3 つの値から最大値と最小値を除いた値でもあります。標準関数を使うと簡潔ですが、ここでは比較による条件分岐の学習を優先して、上の実装を残します。どちらの表現を選んでも、13 ケースと整数境界のテストを通すことが変更の安全網になります。

```kotlin
assertEquals(0, BasicAlgorithms.med3(Int.MIN_VALUE, 0, Int.MAX_VALUE))
```

## 1.4 条件判定と分岐

整数を正、負、ゼロの 3 種類に分類します。この分類は互いに重ならず、すべての整数を網羅します。

### Red: 3 種類をテストする

```kotlin
@Test
fun `judgeSign classifies positive negative and zero`() {
    assertEquals("その値は正です。", BasicAlgorithms.judgeSign(17))
    assertEquals("その値は負です。", BasicAlgorithms.judgeSign(-5))
    assertEquals("その値は0です。", BasicAlgorithms.judgeSign(0))
}
```

### Green: `when` で分類する

```kotlin
fun judgeSign(n: Int): String =
    when {
        n > 0 -> "その値は正です。"
        n < 0 -> "その値は負です。"
        else -> "その値は0です。"
    }
```

正でも負でもない整数は 0 です。`when` の `else` は残るケースを受け持ち、関数の戻り値が必ず `String` になることをコンパイラが確認します。

## 1.5 繰り返し処理

繰り返しを使って 1 から `n` までの総和を求めます。総和は `Long` で保持し、`Int` の入力範囲の総和が `Int` を超えるケースにも対応します。`n <= 0` なら対象範囲が空なので、結果は 0 です。

### Red: `while` と `for` の結果をテストする

```kotlin
@Test
fun `sum functions calculate the inclusive range and handle nonpositive input`() {
    assertEquals(15L, BasicAlgorithms.sum1ToNWhile(5))
    assertEquals(15L, BasicAlgorithms.sum1ToNFor(5))
    assertEquals(0L, BasicAlgorithms.sum1ToNWhile(0))
    assertEquals(0L, BasicAlgorithms.sum1ToNFor(0))
    assertEquals(0L, BasicAlgorithms.sum1ToNWhile(-3))
    assertEquals(0L, BasicAlgorithms.sum1ToNFor(-3))
}
```

### Green: 2 種類のループで合計する

```kotlin
fun sum1ToNWhile(n: Int): Long {
    var total = 0L
    var i = 1
    while (i <= n) {
        total += i
        i++
    }
    return total
}

fun sum1ToNFor(n: Int): Long {
    var total = 0L
    for (i in 1..n) {
        total += i
    }
    return total
}
```

どちらも `n` 回加算するため時間計算量は `O(n)`、追加領域は `O(1)` です。`while` は終了条件とカウンター更新を自分で管理し、`for` は範囲の反復を簡潔に表します。`1..n` は `n < 1` のとき空の範囲になります。

## 1.6 記号文字の交互表示

`+` と `-` を交互に並べる関数を、剰余を使う方法とペアを繰り返す方法で作ります。

### Red: 偶数・奇数・空の入力を確認する

```kotlin
@Test
fun `alternative functions create alternating signs`() {
    assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative1(12))
    assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative2(12))
    assertEquals("+-+-+", BasicAlgorithms.alternative1(5))
    assertEquals("+-+-+", BasicAlgorithms.alternative2(5))
    assertEquals("", BasicAlgorithms.alternative1(0))
    assertEquals("", BasicAlgorithms.alternative2(-2))
}
```

### Green: 文字を順に追加する

```kotlin
fun alternative1(n: Int): String = buildString {
    repeat(n.coerceAtLeast(0)) { index ->
        append(if (index % 2 == 0) '+' else '-')
    }
}
```

`String` は immutable なので、ループ内で `result += ...` を繰り返すと既存文字列のコピーが発生し、全体で `O(n²)` の時間になる場合があります。`buildString` は内部の `StringBuilder` に追加するため `O(n)` 時間、出力に比例する `O(n)` 領域で構築できます。

### Refactor: 文字のペアを繰り返す

```kotlin
fun alternative2(n: Int): String {
    val pairCount = n.coerceAtLeast(0) / 2
    return "+-".repeat(pairCount) + if (n > 0 && n % 2 != 0) "+" else ""
}
```

2 文字のペアを `n / 2` 回作り、奇数のときだけ `+` を足します。出力長に比例する `O(n)` 時間・空間で、文字ごとの条件判定をなくしています。

## 1.7 長方形の辺の組み合わせ

面積 `area` の整数因数の組を `1x32 2x16 4x8 ` のように列挙します。縦横を入れ替えた組を重複させないため、小さい辺だけを調べます。

### Red: 因数の組と境界値をテストする

```kotlin
@Test
fun `rectangle lists unique factor pairs up to the square root`() {
    assertEquals("1x32 2x16 4x8 ", BasicAlgorithms.rectangle(32))
    assertEquals("1x36 2x18 3x12 4x9 6x6 ", BasicAlgorithms.rectangle(36))
    assertEquals("1x1 ", BasicAlgorithms.rectangle(1))
    assertEquals("", BasicAlgorithms.rectangle(0))
    assertEquals("", BasicAlgorithms.rectangle(-8))
}
```

### Green: 平方根まで調べる

```kotlin
fun rectangle(area: Int): String {
    if (area <= 0) return ""

    return buildString {
        var side = 1
        while (side <= area / side) {
            if (area % side == 0) {
                append(side).append('x').append(area / side).append(' ')
            }
            side++
        }
    }
}
```

`side <= area / side` は `side * side <= area` と同じ範囲を、乗算のオーバーフローを避けて表します。調べる候補は平方根までなので時間計算量は `O(√area)`、結果を除く追加領域は `O(1)` です。返す文字列の領域は出力サイズに比例します。

## 1.8 多重ループ

多重ループでは、ある繰り返しの中で別の繰り返しを実行します。九九の表では外側のループが行、内側のループが列を作ります。

### Red: 表全体の書式をテストする

```kotlin
@Test
fun `multiplicationTable formats all products`() {
    val expected = listOf(
        "---------------------------",
        "  1  2  3  4  5  6  7  8  9",
        "  2  4  6  8 10 12 14 16 18",
        "  3  6  9 12 15 18 21 24 27",
        "  4  8 12 16 20 24 28 32 36",
        "  5 10 15 20 25 30 35 40 45",
        "  6 12 18 24 30 36 42 48 54",
        "  7 14 21 28 35 42 49 56 63",
        "  8 16 24 32 40 48 56 64 72",
        "  9 18 27 36 45 54 63 72 81",
        "---------------------------",
    ).joinToString("\n")

    assertEquals(expected, BasicAlgorithms.multiplicationTable())
}
```

### Green: 行と列を二重ループで作る

```kotlin
fun multiplicationTable(): String = buildString {
    append("-".repeat(27)).append('\n')
    for (row in 1..9) {
        for (column in 1..9) {
            append((row * column).toString().padStart(3))
        }
        append('\n')
    }
    append("-".repeat(27))
}
```

9 行 9 列の積を作るため、時間計算量は `O(9 × 9)`、一般化して表の辺の長さを `n` とすると `O(n²)` です。出力文字列を保持する領域も `O(n²)` です。改行は `'\n'` を明示し、OS によって期待値が変わらないようにしています。

### 直角三角形を作る

行番号に応じて `*` を増やす文字列を作ります。表示ではなく値として返すことで、テストで直接検証できます。

```kotlin
@Test
fun `triangle returns rows with a trailing newline`() {
    assertEquals("*\n**\n***\n****\n*****\n", BasicAlgorithms.triangle(5))
    assertEquals("", BasicAlgorithms.triangle(0))
    assertEquals("", BasicAlgorithms.triangle(-1))
}
```

```kotlin
fun triangle(n: Int): String = buildString {
    repeat(n.coerceAtLeast(0)) { index ->
        repeat(index + 1) { append('*') }
        append('\n')
    }
}
```

出力する星の合計は `1 + 2 + ... + n` なので、時間・出力領域ともに `O(n²)` です。

## 1.9 テストの実行

章の実装とテストを追加したら `apps/kotlin/` からテストを実行します。

```bash
./gradlew test
```

すべてのテストを含む品質チェックは次のとおりです。

```bash
./gradlew check
```

## まとめ

この章では、比較、条件分岐、繰り返し、多重ループを使い、次の題材を実装しました。

| 題材 | 学んだこと | 時間計算量 |
|------|------------|------------|
| 3 値の最大値・中央値 | 比較と条件分岐、同値の扱い | `O(1)` |
| 符号判定 | 条件による網羅的な分類 | `O(1)` |
| 1 から n までの総和 | `while` と範囲の `for` | `O(n)` |
| 交互記号 | 剰余、文字列ビルダー、反復 | `O(n)` |
| 長方形の辺 | 因数の列挙と探索範囲の削減 | `O(√n)` |
| 九九の表 | 二重ループと書式化 | `O(1)`（固定サイズ） |
| 三角形 | 入力サイズに応じた入れ子の反復 | `O(n²)` |

TDD では、小さなテストを追加して実装を育て、リファクタリング後も振る舞いが変わらないことを確認します。次章では配列を扱い、要素の走査・反転・基数変換・素数列挙を学びます。
