# 第 5 章 再帰アルゴリズム

## はじめに

再帰（recursion）は、関数が自分自身を呼び出して問題を解く方法です。大きな問題を、同じ形をした小さな問題に分解します。再帰関数には、呼び出しを止める基底条件と、問題を小さくして自分自身を呼ぶ再帰ケースの両方が必要です。

この章では階乗、最大公約数、ハノイの塔に加え、複数の再帰呼び出しを持つ関数の反復化、8 王妃問題、迷路探索を実装します。Kotlin の `tailrec` が適用できる条件や、バックトラッキングで状態を戻す理由も確認します。完成版の実装とテストは `apps/kotlin/src/main/kotlin/algorithm/RecursionAlgorithms.kt` と `apps/kotlin/src/test/kotlin/algorithm/RecursionAlgorithmsTest.kt` にあります。

## 準備

```bash
nix develop .#kotlin
cd apps/kotlin
./gradlew test --tests algorithm.RecursionAlgorithmsTest
```

この章では複数の再帰分岐や探索も扱うため、階乗だけでなく探索結果の件数・盤面の制約・迷路の境界もテストします。

存在しない関数を呼び出すテストを先に書くと、Kotlin では Red の段階がコンパイルエラーになります。関数を実装してコンパイルとテストが通ることを確認し、次に境界値や別表現との一致をテストします。

## 5.1 階乗

非負整数 `n` の階乗は、`n! = n × (n - 1)!` で定義されます。`0! = 1` が基底条件です。結果を `Long` で返すとき、20! は収まりますが 21! は収まらないため、この実装では引数を `0..20` に限定します。

### Red: 基底条件と一般ケースをテストする

```kotlin
@Test
fun `factorial handles base and typical cases`() {
    assertEquals(1L, RecursionAlgorithms.factorial(0))
    assertEquals(1L, RecursionAlgorithms.factorial(1))
    assertEquals(120L, RecursionAlgorithms.factorial(5))
    assertEquals(3_628_800L, RecursionAlgorithms.factorial(10))
    assertEquals(2_432_902_008_176_640_000L, RecursionAlgorithms.factorial(20))
}
```

### Green: 再帰で計算する

```kotlin
fun factorial(n: Int): Long {
    require(n in 0..20)
    if (n <= 1) return 1
    return n * factorial(n - 1)
}
```

`factorial(5)` は `5 × factorial(4)` を呼び、最終的に `factorial(1)` が 1 を返します。その後、呼び出し元に戻りながら積を計算します。この関数は再帰呼び出しから戻った後に乗算するため、末尾再帰ではありません。

### Refactor: `tailrec` と反復版を比較する

Kotlin の `tailrec` は、再帰呼び出しが関数の最後の処理になる場合に使えます。コンパイラが呼び出しをループに変換するため、呼び出しスタックが再帰の深さに比例して増えるのを避けられます。

```kotlin
fun factorialTailRecursive(n: Int): Long {
    require(n in 0..20)
    tailrec fun calculate(remaining: Int, result: Long): Long =
        if (remaining <= 1) result else calculate(remaining - 1, result * remaining)

    return calculate(n, 1)
}
```

通常の反復版は状態を変数に保持します。

```kotlin
fun factorialIterative(n: Int): Long {
    require(n in 0..20)
    var result = 1L
    for (factor in 2..n) result *= factor
    return result
}
```

3 つの関数は同じ結果を返します。いずれも時間計算量は `O(n)`、反復版と末尾再帰版の追加領域は `O(1)` です。通常の再帰版は呼び出しスタックに `O(n)` の領域を使います。

## 5.2 最大公約数

ユークリッドの互除法では、`gcd(x, y) = gcd(y, x % y)` として問題を小さくします。`y` が 0 になったときの `x` が最大公約数です。この章では入力を非負整数とし、`gcd(0, 0)` は 0 と定義します。

### Red: 互除法のケースをテストする

```kotlin
@Test
fun `gcd handles common divisors and zero`() {
    assertEquals(2, RecursionAlgorithms.gcd(22, 8))
    assertEquals(4, RecursionAlgorithms.gcd(12, 4))
    assertEquals(1, RecursionAlgorithms.gcd(7, 11))
    assertEquals(5, RecursionAlgorithms.gcd(0, 5))
    assertEquals(0, RecursionAlgorithms.gcd(0, 0))
}
```

### Green: 末尾再帰で実装する

```kotlin
fun gcd(x: Int, y: Int): Int {
    require(x >= 0 && y >= 0)
    tailrec fun calculate(a: Int, b: Int): Int =
        if (b == 0) a else calculate(b, a % b)

    return calculate(x, y)
}
```

再帰呼び出しが最後の処理なので `tailrec` を付けられます。同じ計算を `while` で書くと、更新される値が明示的になります。

```kotlin
fun gcdIterative(x: Int, y: Int): Int {
    require(x >= 0 && y >= 0)
    var a = x
    var b = y
    while (b != 0) {
        val remainder = a % b
        a = b
        b = remainder
    }
    return a
}
```

正の引数では各ステップで値が小さくなり、ユークリッドの互除法の時間計算量は `O(log(min(x, y)))` です。0 を含む場合も定数回で終わります。末尾再帰版はコンパイラがループに変換します。反復版も追加領域 `O(1)` です。

## 5.3 ハノイの塔

ハノイの塔では、大小の円盤を 3 本の柱の間で移動します。大きい円盤を小さい円盤の上に置いてはいけません。`n` 枚を移動する問題は、次の 3 つに分けられます。

1. 上の `n - 1` 枚を移動元から補助の柱へ移す。
2. 最も大きい円盤を移動元から移動先へ移す。
3. `n - 1` 枚を補助の柱から移動先へ移す。

### Red: 移動手順と手数をテストする

```kotlin
@Test
fun `hanoi returns the expected moves for two disks`() {
    assertEquals(
        listOf("A->B", "A->C", "B->C"),
        RecursionAlgorithms.hanoi(2, "A", "C", "B"),
    )
}
```

0 枚なら移動は不要です。`n` 枚の最小手数は `2^n - 1` なので、複数の入力で手数の関係も検証します。また、生成された手順を実際に適用し、円盤の大小関係と最終位置を確認します。

### Green: 分割した手順を生成する

```kotlin
fun hanoi(disks: Int, source: String, destination: String, auxiliary: String): List<String> {
    require(disks >= 0)
    val moves = mutableListOf<String>()

    fun move(count: Int, from: String, to: String, via: String) {
        if (count == 0) return
        move(count - 1, from, via, to)
        moves.add("$from->$to")
        move(count - 1, via, to, from)
    }

    move(disks, source, destination, auxiliary)
    return moves
}
```

この再帰は 1 回の処理から 2 回の再帰呼び出しを行うため、`tailrec` にはできません。移動回数と返却するリストの大きさは `2^n - 1` で、時間・出力領域ともに `O(2^n)` です。円盤数を増やすと出力自体が急増するため、小さな入力で実行します。

移動元、移動先、補助の柱は別々の名前で指定します。同じ柱を複数の役割に指定すると、パズルの前提に合わない移動になります。

## 5.4 再帰アルゴリズムの解析

階乗や GCD のように 1 回の呼び出しから次の呼び出しを 1 回行うものだけでなく、1 回の処理中に複数回呼び出す「真に再帰的な関数」もあります。次の `multipleRecursion` は、`n - 1` の処理、`n` の追加、`n - 2` の処理の順に実行します。

### Red: 呼び出し順序の結果をテストする

```kotlin
@Test
fun `multiple recursion returns the expected sequence`() {
    assertEquals(
        listOf(1, 2, 3, 1, 4, 1, 2),
        RecursionAlgorithms.multipleRecursion(4),
    )
}
```

### Green: 2 つの再帰呼び出しを行う

```kotlin
fun multipleRecursion(n: Int): List<Int> {
    val result = mutableListOf<Int>()
    fun recur(value: Int) {
        if (value <= 0) return
        recur(value - 1)
        result.add(value)
        recur(value - 2)
    }
    recur(n)
    return result
}
```

`multipleRecursion(4)` では `recur(3)` が完了してから 4 を追加し、最後に `recur(2)` を実行します。複数の分岐の順序が結果に影響します。基底条件 `value <= 0` がないと再帰が終了しません。

### 再帰の一部をループにする

最後の `recur(value - 2)` を、呼び出し元に戻った後のループへ置き換えると、次のようになります。

```kotlin
fun multipleRecursionPartiallyIterative(n: Int): List<Int> {
    val result = mutableListOf<Int>()
    fun recur(value: Int) {
        var current = value
        while (current > 0) {
            recur(current - 1)
            result.add(current)
            current -= 2
        }
    }
    recur(n)
    return result
}
```

この変換では再帰呼び出しを一部残すため、スタック使用量は依然として入力の大きさに比例します。すべての再帰を取り除くには、呼び出しの途中状態を自分でスタックに保存します。

### 再帰を明示的なスタックで置き換える

```kotlin
fun multipleRecursionIterative(n: Int): List<Int> {
    data class Frame(val value: Int, val appendOnResume: Boolean)
    val result = mutableListOf<Int>()
    val frames = mutableListOf(Frame(n, appendOnResume = false))

    while (frames.isNotEmpty()) {
        val frame = frames.removeAt(frames.lastIndex)
        if (frame.appendOnResume) {
            result.add(frame.value)
        } else if (frame.value > 0) {
            frames.add(Frame(frame.value - 2, appendOnResume = false))
            frames.add(Frame(frame.value, appendOnResume = true))
            frames.add(Frame(frame.value - 1, appendOnResume = false))
        }
    }
    return result
}
```

スタックは後入れ先出しなので、再帰で実行したい順序と逆に処理を積みます。`appendOnResume` は、最初の再帰呼び出しから戻った後に値を追加する状態を表します。再帰版と明示スタック版は同じ系列の呼び出しを処理するため、時間計算量はいずれも指数時間です。明示スタック版は JVM の呼び出しスタックを避けますが、同じ処理状態をヒープ上のリストに保存します。

## 5.5 8 王妃問題

8 王妃問題は、8×8 の盤面に王妃を 8 個置き、互いに攻撃できない配置を探す問題です。各列に 1 個ずつ置けば列の衝突はなくなります。行や対角線の使用状況を追跡し、配置できない候補を枝刈りするバックトラッキングで解きます。

### Red: 制約を段階的に追加した件数をテストする

```kotlin
@Test
fun `eight queens progressively restrict placements`() {
    assertEquals(16_777_216, RecursionAlgorithms.countUnrestrictedEightQueens())
    assertEquals(40_320, RecursionAlgorithms.eightQueensWithUniqueRows().size)
    assertEquals(92, RecursionAlgorithms.solveEightQueens().size)
}
```

### Green 1: 制約なしの組み合わせを数える

各列について 8 行のどれかを選びます。`8^8` 通りをすべて配列として保持すると大量のメモリを使うため、Kotlin 版では配置数だけを数えます。

```kotlin
fun countUnrestrictedEightQueens(): Int {
    var count = 0
    fun place(column: Int) {
        for (row in 0 until 8) {
            if (column == 7) count++ else place(column + 1)
        }
    }
    place(0)
    return count
}
```

### Green 2: 同じ行を使わない

各行を最大 1 回だけ使うフラグを追加すると、配置数は順列の数 `8! = 40,320` になります。再帰から戻った後にフラグを解除することが重要です。

```kotlin
fun eightQueensWithUniqueRows(): List<IntArray> {
    val positions = IntArray(8)
    val usedRows = BooleanArray(8)
    val solutions = mutableListOf<IntArray>()
    fun place(column: Int) {
        for (row in 0 until 8) {
            if (usedRows[row]) continue
            positions[column] = row
            if (column == 7) {
                solutions.add(positions.copyOf())
            } else {
                usedRows[row] = true
                place(column + 1)
                usedRows[row] = false
            }
        }
    }
    place(0)
    return solutions
}
```

### Green 3: 行と対角線を使わない

列 `column`、行 `row` のマスは、`column + row` または `column - row + 7` が同じ別のマスと対角線上にあります。それぞれの対角線の使用状況を記録し、行・対角線のいずれにも衝突しない配置だけを再帰で進めます。全 92 解のそれぞれについても、行と対角線が重ならないことをテストします。

```kotlin
fun solveEightQueens(): List<IntArray> {
    val positions = IntArray(8)
    val usedRows = BooleanArray(8)
    val descending = BooleanArray(15)
    val ascending = BooleanArray(15)
    val solutions = mutableListOf<IntArray>()
    fun place(column: Int) {
        for (row in 0 until 8) {
            val downDiagonal = column + row
            val upDiagonal = column - row + 7
            if (usedRows[row] || descending[downDiagonal] || ascending[upDiagonal]) continue
            positions[column] = row
            usedRows[row] = true
            descending[downDiagonal] = true
            ascending[upDiagonal] = true
            if (column == 7) solutions.add(positions.copyOf()) else place(column + 1)
            usedRows[row] = false
            descending[downDiagonal] = false
            ascending[upDiagonal] = false
        }
    }
    place(0)
    return solutions
}
```

`positions.copyOf()` で解を記録することで、次のバックトラックで配列が書き換わっても、既に見つけた解を保持できます。サイズ `n` の一般化した問題では、探索の上限は `O(n!)` です。制約を早期に確認するほど、無効な盤面を深く探索する前に枝刈りできます。

## 5.6 迷路探索

迷路を二次元配列で表し、`0` を通路、`1` を壁として、開始位置からゴールまで到達できるかを深さ優先探索します。訪問済みセルを記録しないと、同じ通路を往復して再帰が止まらなくなる可能性があります。

### Red: 到達可能・不可能な迷路をテストする

```kotlin
@Test
fun `maze solver finds a route and rejects a disconnected goal`() {
    val maze = arrayOf(
        intArrayOf(1, 1, 1, 1, 1),
        intArrayOf(1, 0, 0, 0, 1),
        intArrayOf(1, 0, 1, 0, 1),
        intArrayOf(1, 0, 0, 0, 1),
        intArrayOf(1, 1, 1, 1, 1),
    )
    assertTrue(RecursionAlgorithms.mazeSolve(maze, 1, 1, 3, 3))
}
```

### Green: 上下左右を再帰的に探索する

```kotlin
fun mazeSolve(
    maze: Array<IntArray>,
    startRow: Int,
    startColumn: Int,
    goalRow: Int,
    goalColumn: Int,
): Boolean {
    val visited = Array(maze.size) { BooleanArray(maze[0].size) }
    fun search(row: Int, column: Int): Boolean {
        if (row == goalRow && column == goalColumn) return true
        visited[row][column] = true
        for ((rowOffset, columnOffset) in listOf(-1 to 0, 1 to 0, 0 to -1, 0 to 1)) {
            val nextRow = row + rowOffset
            val nextColumn = column + columnOffset
            if (nextRow in maze.indices && nextColumn in maze[0].indices &&
                maze[nextRow][nextColumn] == 0 && !visited[nextRow][nextColumn] &&
                search(nextRow, nextColumn)
            ) {
                return true
            }
        }
        return false
    }
    return search(startRow, startColumn)
}
```

実際の実装では、空・不揃いの行、範囲外の開始位置やゴールを事前に検証します。`visited` は探索呼び出しごとに作るので、同じ迷路を続けて解いても前回の探索状態は残りません。各セルを最大 1 回訪問するため、時間計算量は `O(行数 × 列数)`、訪問配列と再帰スタックも `O(行数 × 列数)` です。

## 5.7 まとめ

| アルゴリズム | 再帰の分解 | 時間計算量 | Kotlin でのポイント |
|:---|:---|:---:|:---|
| 階乗 | `n × factorial(n - 1)` | `O(n)` | 基底条件、`tailrec` と反復版の違い |
| 最大公約数 | `gcd(y, x % y)` | `O(log(min(x, y)))` | 末尾再帰は `tailrec` にできる |
| ハノイの塔 | `n - 1` 枚の問題を 2 回解く | `O(2^n)` | 末尾再帰ではなく、出力も指数的に増える |
| 複数回再帰 | `n - 1` と `n - 2` の呼び出し | 指数時間 | 呼び出し順序と明示スタック |
| 8 王妃問題 | 列ごとに候補を置き、衝突を枝刈り | `O(n!)` 上限 | 行・対角線フラグを復元する |
| 迷路探索 | 上下左右の未訪問セルを探索 | `O(行数 × 列数)` | visited 配列で再訪を防ぐ |

再帰では、終了する基底条件と、基底条件に近づく再帰ケースが重要です。再帰の形が問題を明確に表す一方、呼び出しスタックや出力サイズが大きくならないかも確認しましょう。

## テスト実行

```text
./gradlew test --tests algorithm.RecursionAlgorithmsTest
BUILD SUCCESSFUL
```

このテストでは、基底条件と境界値、再帰版と反復版の一致、8 王妃問題の解数と盤面制約、迷路の到達可能性を確認します。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
