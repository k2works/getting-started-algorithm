# 第 5 章 再帰アルゴリズム

## 5.1 はじめに

第 4 章ではスタックとキューを実装しました。この章では、関数が自分自身を呼び出して問題を小さく分ける再帰を学びます。階乗、ユークリッドの互除法、ハノイの塔に加え、複数回再帰、8 王妃問題、迷路探索を題材に、基底条件やバックトラッキングをテストで確かめます。

再帰関数には、呼び出しを止める **基底条件** と、より小さな問題にして自分自身を呼び出す **再帰ケース** が必要です。基底条件に到達しない入力は呼び出しが終わらず、最終的にスタックを使い切る可能性があります。

### この章の TODO リスト

- [x] 0 から 12 までの階乗を再帰で計算する
- [x] アキュムレーターを使う末尾再帰形と比較する
- [x] ユークリッドの互除法で GCD を求める
- [x] ハノイの塔の移動手順を再帰で作る
- [x] 複数回再帰を実装し、末尾再帰形と明示的な作業スタックに置き換える
- [x] 8 王妃問題を制約ごとの 3 段階で解く
- [x] 不変リストの迷路をバックトラッキングで探索する
- [x] 基底条件、範囲外入力、解の個数、迷路の壁をテストする

## 5.2 階乗

非負整数 n の階乗は、`n! = n × (n - 1)!` です。基底条件は `0! = 1` です。たとえば `5!` は `5 × 4 × 3 × 2 × 1` なので 120 になります。

### Red — 基底条件と通常の入力を書く

`test/TestRecursion.flix` にテストを追加します。

```flix
@Test
def factorial_zero(): Unit \ Assert =
    Assert.assertEq(expected = Some(1), Recursion.factorial(0))

@Test
def factorial_five(): Unit \ Assert =
    Assert.assertEq(expected = Some(120), Recursion.factorial(5))
```

### Green — 問題を 1 つずつ小さくする

`src/Recursion.flix` に実装します。

```flix
def maxFactorialInput(): Int32 = 12

pub def factorial(n: Int32): Option[Int32] =
    if (n < 0 or n > maxFactorialInput()) {
        None
    } else {
        def loop(value): Int32 =
            if (value <= 1)
                1
            else
                value * loop(value - 1);
        Some(loop(n))
    }
```

`loop(5)` は `5 * loop(4)`、`loop(4)` は `4 * loop(3)` と続き、`loop(1)` で 1 を返します。値を返すときに保留していた乗算を行い、最終的に 120 を得ます。`0` も `value <= 1` の基底条件に入るため、`0! = 1` です。

この実装では返り値を `Option[Int32]` にしています。負数は階乗の対象外として `None` を返し、`Int32` に収まらない値の計算も行いません。`12! = 479001600` は `Int32` に収まりますが、`13!` は範囲を超えるため、受け入れる最大値を 12 としています。固定幅整数のオーバーフローを通常の結果として誤って返さないための境界です。

再帰版は n 回の呼び出しを行うので時間計算量は O(n)、再帰の呼び出しスタックも O(n) です。

### Refactor — アキュムレーターを使う末尾再帰

階乗を計算する途中の積をアキュムレーター `acc` に保持すると、再帰呼び出しが関数の最後の処理になります。

```flix
pub def factorialIterative(n: Int32): Option[Int32] =
    if (n < 0 or n > maxFactorialInput()) {
        None
    } else {
        def loop(value, acc): Int32 =
            if (value > n)
                acc
            else
                loop(value + 1, acc * value);
        Some(loop(1, 1))
    }
```

この関数は `loop(1, 1)` から始まり、`acc` を `1 × 1`、`1 × 2`、`1 × 2 × 3` のように更新します。計算量は再帰版と同じ O(n) 時間です。再帰呼び出しの後に乗算を保留する必要がなくなるため、アルゴリズム上の状態をアキュムレーターへ集約できます。ただし、末尾再帰を実行環境が最適化するかどうかには依存せず、呼び出し深さが一定になるとはここでは仮定しません。

## 5.3 最大公約数 — ユークリッドの互除法

ユークリッドの互除法は、次の関係を使って最大公約数（GCD）を求めます。

```text
gcd(a, b) = gcd(b, a mod b)
gcd(a, 0) = a
```

### Red — 余りで問題が小さくなることを確認する

```flix
@Test
def gcd_basic(): Unit \ Assert =
    Assert.assertEq(expected = Some(2), Recursion.gcd(22, 8))

@Test
def gcd_coprime(): Unit \ Assert =
    Assert.assertEq(expected = Some(1), Recursion.gcd(7, 11))
```

### Green — 余りを次の再帰呼び出しへ渡す

```flix
pub def gcd(x: Int32, y: Int32): Option[Int32] =
    if (x < 0 or y < 0) {
        None
    } else {
        def loop(a, b) =
            if (b == 0)
                a
            else
                loop(b, a `Int32.remainder` b);
        Some(loop(x, y))
    }
```

`gcd(22, 8)` は `gcd(8, 6)`、`gcd(6, 2)`、`gcd(2, 0)` と進み、2 を返します。2 つの入力が 0 の場合は 0 を返す定義にしています。負数はこの関数の前提外として `None` です。入力の絶対値を取る方法では `Int32` の最小値を正数にできないため、ここでは負数を明示的に拒否しています。

両方の入力が正の場合、ユークリッドの互除法は余りを使うたびに値が小さくなり、時間計算量は O(log min(a, b)) です。どちらかが 0 なら再帰呼び出しは高々 1 回なので O(1) です。各呼び出しで保持する状態は 2 つの整数ですが、末尾再帰の呼び出しスタック最適化を仮定しない場合、正の入力では最大 O(log min(a, b)) のスタック領域を使います。

## 5.4 ハノイの塔

ハノイの塔では、サイズの異なる円盤を 3 本の棒の間で移動します。円盤 n 枚を移すには、次の 3 段階に分けられます。

1. 上の n - 1 枚を移動元から経由先へ移す
2. いちばん大きな円盤を移動元から移動先へ移す
3. n - 1 枚を経由先から移動先へ移す

一度に動かせる円盤は 1 枚で、大きな円盤を小さな円盤の上に置いてはいけません。

### Red — 移動手順と移動回数をテストする

`hanoi(1, "A", "C", "B")` の結果は、移動元 A から移動先 C への 1 回の移動です。

```flix
@Test
def hanoi_one_disk(): Unit \ Assert =
    Assert.assertEq(
        expected = ("A", "C") :: Nil,
        Recursion.hanoi(1, "A", "C", "B")
    )
```

3 枚の場合は、実際の移動順序も検証します。

```flix
@Test
def hanoi_three_disks(): Unit \ Assert =
    Assert.assertEq(
        expected =
            ("A", "C") ::
            ("A", "B") ::
            ("C", "B") ::
            ("A", "C") ::
            ("B", "A") ::
            ("B", "C") ::
            ("A", "C") ::
            Nil,
        Recursion.hanoi(3, "A", "C", "B")
    )
```

### Green — 2 つの小問題と中央の移動に分ける

```flix
pub def hanoi(n: Int32, src: String, dst: String, via: String): List[(String, String)] =
    def append(xs, ys) = match xs {
        case Nil => ys
        case head :: tail => head :: append(tail, ys)
    };

    def moveDisks(disks, source, target, auxiliary) =
        if (disks <= 0) {
            Nil
        } else {
            append(
                moveDisks(disks - 1, source, auxiliary, target),
                (source, target) :: moveDisks(disks - 1, auxiliary, target, source)
            )
        };

    moveDisks(n, src, dst, via)
```

`disks <= 0` が基底条件で、0 枚なら移動手順は空リストです。再帰ケースでは、最初の小問題の手順、中央の 1 手、2 つ目の小問題の手順をこの順に連結します。`append` は最初のリストを再帰的にたどって、新しい連結リストを作ります。引数の `n` が負数でも移動手順は空です。

円盤 n 枚の最小移動回数を `M(n)` とすると、`M(n) = 2M(n - 1) + 1` です。したがって移動回数は `2^n - 1`、移動手順の要素数と出力領域は O(2^n) です。

Flix の `List` は不変なので、2 つの手順を連結するには先頭側のリストをコピーします。この実装は各再帰段でリスト連結が発生し、リスト構築の時間は O(n × 2^n) です。移動手順を作るだけでも O(2^n) 個の出力が必要ですが、不変リストの連結コストがさらに加わる点に注意してください。再帰の深さは O(n) です。

## 5.5 再帰アルゴリズムの解析

階乗や GCD は 1 回の呼び出しから次の 1 回を呼び出す再帰でした。一方、次の関数は 1 回の呼び出しから 2 回の再帰呼び出しを行います。呼び出し順序を観察しやすくするため、Flix では共有状態を変更せず、結果を不変リストとして返します。

### Red — 呼び出し順序を結果で確認する

```flix
@Test
def recure_records_recursive_calls_in_order(): Unit \ Assert =
    Assert.assertEq(
        expected = 1 :: 2 :: 3 :: 1 :: 4 :: 1 :: 2 :: Nil,
        Recursion.recure(4)
    )
```

### Green — 2 つの再帰呼び出しを行う

`src/Recursion.flix` の `recure` は Python 版の `recure(4, [])` と同じ値を返します。

```flix
pub def recure(n: Int32): List[Int32] =
    def append(xs, ys) = match xs {
        case Nil => ys
        case head :: tail => head :: append(tail, ys)
    };

    def loop(value) =
        if (value <= 0) {
            Nil
        } else {
            append(loop(value - 1), value :: loop(value - 2))
        };

    loop(n)
```

各呼び出しは `value - 1` の結果を先に作り、現在の値を追加してから `value - 2` を処理します。結果の順序は呼び出し順をそのまま反映します。出力長は指数的に増え、リスト連結も行うため、この関数は小さい入力で再帰構造を観察する教材です。

### Refactor — 末尾再帰形と作業スタックに置き換える

`recureTailLoop` は 2 番目の再帰呼び出しを、`loop(value - 2, ...)` という末尾再帰に置き換えます。最初の枝 `recursive(value - 1)` は引き続き再帰です。

```flix
pub def recureTailLoop(n: Int32): List[Int32] =
    def append(xs, ys) = match xs {
        case Nil => ys
        case head :: tail => head :: append(tail, ys)
    };

    def recursive(value) =
        if (value <= 0) {
            Nil
        } else {
            append(recursive(value - 1), value :: recursive(value - 2))
        };

    def loop(value, output) =
        if (value <= 0) {
            output
        } else {
            loop(value - 2, append(append(output, recursive(value - 1)), value :: Nil))
        };

    loop(n, Nil)
```

再帰呼び出しの全体を外部データとして表すには、次に実行する操作を作業スタックへ積みます。`(true, value)` は `value` の呼び出し、`(false, value)` は出力への追加を表します。

```flix
def reverse(xs) = {
    def loop(source, acc) = match source {
        case Nil => acc
        case head :: tail => loop(tail, head :: acc)
    };
    loop(xs, Nil)
};

@Tailrec
def process(tasks, output) = match tasks {
    case Nil => reverse(output)
    case task :: tail =>
        let (isCall, value) = task;
        if (isCall) {
            if (value <= 0) {
                process(tail, output)
            } else {
                process(
                    (true, value - 1) :: (false, value) :: (true, value - 2) :: tail,
                    output
                )
            }
        } else {
            process(tail, value :: output)
        }
}
```

作業スタックは再帰木の残りを明示するため、処理順を保ったまま再帰呼び出しを展開できます。`@Tailrec` は `process` の呼び出しが末尾位置にあることをコンパイラに検査させます。作業リストと出力リストの領域は出力サイズに比例します。Python 版の可変リストと明示スタックを、Flix では不変リストと末尾再帰で表現した違いに注目してください。

## 5.6 8 王妃問題

8 王妃問題は、8×8 の盤面に王妃を 8 個置き、同じ行・列・対角線上に他の王妃がない配置を探す問題です。列ごとに 1 個だけ置く表現にすると、列の重複は構造上起きません。Flix 版では盤面サイズを引数にし、制約を 3 段階に分けて候補数を数えます。

### 第 1 段階 — 各列に任意の行を置く

4 列なら各列に 4 通りの行があるため、候補は `4⁴ = 256` 通りです。`queenPlacementCount` は配置を保存せず、再帰で候補数だけを数えます。

```flix
@Test
def queens_counts_each_constraint_stage(): Unit \ Assert =
    Assert.assertEq(expected = 256, Recursion.queenPlacementCount(4));
    Assert.assertEq(expected = 24, Recursion.queenRowPermutationCount(4))
```

`src/Recursion.flix` の第 1 段階では、各列の全候補を再帰的に数えます。

```flix
pub def queenPlacementCount(size: Int32): Int32 =
    if (size < 0) {
        0
    } else {
        def place(column) =
            if (column >= size) {
                1
            } else {
                def tryRows(row, count) =
                    if (row >= size) {
                        count
                    } else {
                        tryRows(row + 1, count + place(column + 1))
                    };
                tryRows(0, 0)
            };

        place(0)
    }
```

### 第 2 段階 — 同じ行を使わない

配置済みの行を不変リストで保持し、候補行が既出でない場合だけ次の列へ進みます。4 列では `4! = 24` 通りです。

```flix
def isRowUnused(row, positions) = match positions {
    case Nil => true
    case head :: tail => row != head and isRowUnused(row, tail)
};

def place(column, positions) =
    if (column >= size) {
        1
    } else {
        def tryRows(row, count) =
            if (row >= size) {
                count
            } else if (isRowUnused(row, positions)) {
                tryRows(row + 1, count + place(column + 1, row :: positions))
            } else {
                tryRows(row + 1, count)
            };
        tryRows(0, 0)
    };
```

### 第 3 段階 — 対角線も検査する

列ごとに 1 つずつ配置しているので、行 `r` と前の王妃の行 `p` の差が列間距離と等しい場合、同じ対角線上です。`queensSolutions` は行の重複と両方向の対角線を検査して、解だけを返します。

```flix
def isSafe(candidateRow, usedPositions) = {
    def check(previous, distance) = match previous {
        case Nil => true
        case previousRow :: tail =>
            if (
                candidateRow == previousRow or
                candidateRow - previousRow == distance or
                previousRow - candidateRow == distance
            ) {
                false
            } else {
                check(tail, distance + 1)
            }
    };
    check(usedPositions, 1)
};

def place(column, positions, solutions) =
    if (column >= size) {
        reverseRows(positions) :: solutions
    } else {
        def tryRows(candidateRow, acc) =
            if (candidateRow >= size) {
                acc
            } else if (isSafe(candidateRow, positions)) {
                tryRows(candidateRow + 1, place(column + 1, candidateRow :: positions, acc))
            } else {
                tryRows(candidateRow + 1, acc)
            };
        tryRows(0, solutions)
    };
```

```flix
@Test
def queens_find_all_solutions(): Unit \ Assert =
    Assert.assertEq(expected = 2, List.length(Recursion.queensSolutions(4)));
    Assert.assertEq(expected = 92, List.length(Recursion.queensSolutions(8)))
```

4 王妃問題には 2 解、8 王妃問題には 92 解あります。4 王妃問題では 2 つの配置そのものを比較し、8 王妃問題では全解数を確認します。各列で最大 n 個の候補を試すため、探索木の上限は O(nⁿ) です。行と対角線の制約で多くの枝を早期に打ち切ります。盤面サイズ n に対する再帰の深さと保持する配置は O(n)、解のリスト領域は解の個数と各解の長さに比例します。

## 5.7 迷路探索 — バックトラッキング

迷路は `List[List[Int32]]` で表し、`0` を通路、`0` 以外を壁とします。現在位置から上下左右へ進み、既に訪れた位置は再訪しません。Flix のリストは不変なので、探索済み位置のリストを各呼び出しへ渡し、失敗した枝で見つけた位置も次の枝へ引き継ぎます。これにより、探索済みの通路を何度も調べません。

```flix
@Test
def mazeSolve_finds_path(): Unit \ Assert =
    let maze =
        (1 :: 1 :: 1 :: 1 :: 1 :: Nil) ::
        (1 :: 0 :: 0 :: 0 :: 1 :: Nil) ::
        (1 :: 0 :: 1 :: 0 :: 1 :: Nil) ::
        (1 :: 0 :: 0 :: 0 :: 1 :: Nil) ::
        (1 :: 1 :: 1 :: 1 :: 1 :: Nil) ::
        Nil;
    Assert.assertTrue(Recursion.mazeSolve(maze, 1, 1, 3, 3))
```

`src/Recursion.flix` の `listAt` は、行や列の位置を不変リストから取り出します。探索結果と訪問済み状態を組にして返すことで、失敗した経路からも探索済み位置を次の方向へ引き継ぎます。

```flix
def listAt(xs: List[a], index: Int32): Option[a] =
    if (index < 0) {
        None
    } else {
        match xs {
            case Nil => None
            case head :: tail => if (index == 0) Some(head) else listAt(tail, index - 1)
        }
    }

pub def mazeSolve(
    maze: List[List[Int32]],
    row: Int32,
    col: Int32,
    goalRow: Int32,
    goalCol: Int32
): Bool =
    def contains(position, visited) = match visited {
        case Nil => false
        case (visitedRow, visitedCol) :: tail =>
            (position == (visitedRow, visitedCol)) or contains(position, tail)
    };

    def cellAt(r, c) = match listAt(maze, r) {
        case None => None
        case Some(cells) => listAt(cells, c)
    };

    def search(r, c, visited) =
        if (contains((r, c), visited)) {
            (false, visited)
        } else {
            match cellAt(r, c) {
                case Some(0) =>
                    let updatedVisited = (r, c) :: visited;
                    if (r == goalRow and c == goalCol) {
                        (true, updatedVisited)
                    } else {
                        def tryDirections(directions, seen) = match directions {
                            case Nil => (false, seen)
                            case (dr, dc) :: tail =>
                                let (found, nextSeen) = search(r + dr, c + dc, seen);
                                if (found) {
                                    (true, nextSeen)
                                } else {
                                    tryDirections(tail, nextSeen)
                                }
                        };

                        tryDirections(
                            (-1, 0) :: (1, 0) :: (0, -1) :: (0, 1) :: Nil,
                            updatedVisited
                        )
                    }
                case _ => (false, visited)
            }
        };

    let (found, _) = search(row, col, Nil);
    found
```

探索は、まず座標が訪問済みかを調べ、次に現在位置が通路かを確認します。ゴール判定を通路確認の後に行うため、壁のマスをゴールに指定しても成功にはなりません。テストでは到達可能なゴールと壁で塞がれたゴールを確認しています。

`V` を通路と壁を含むマス数とすると、探索済み位置の検索と行・列リストの参照はいずれも線形です。各位置を高々 1 回探索する実装の時間計算量は O(V²)、訪問済みリストと再帰スタックの領域は O(V) です。ハッシュ集合を使う Python 版より探索済み判定のコストは大きくなりますが、Flix の不変データで状態を明示する形を学べます。

## 5.8 テストと計算量

```bash
make test
make check
make format-check
```

`test/TestRecursion.flix` では、階乗の境界と範囲外入力、GCD の互いに素な数と 0、ハノイの塔の手順と移動回数、複数回再帰の出力順、8 王妃問題の解数、迷路の到達可否を検証します。

| アルゴリズム | 時間 | 追加領域 | 前提・境界 |
|---|---:|---:|---|
| 階乗（再帰） | O(n) | O(n) スタック | `0 <= n <= 12` |
| 階乗（アキュムレーター） | O(n) | 最大 O(n) スタック | `0 <= n <= 12`。末尾再帰最適化は仮定しない |
| GCD（ユークリッド） | 正の入力で O(log min(a, b))、0 を含む場合 O(1) | 正の入力で最大 O(log min(a, b)) スタック | `a, b >= 0` |
| ハノイの塔 | O(n × 2^n)（リスト連結を含む） | O(2^n) 出力 + O(n) スタック | n が増えると移動数が指数的に増える |
| 複数回再帰 `recure` | 指数時間（出力長も指数的） | O(n) スタック + 出力リスト | 小さい n で呼び出し順を観察する |
| 明示的な作業スタック | 出力サイズに比例 | O(出力サイズ) | `@Tailrec` で処理関数の末尾位置を検査 |
| 8 王妃問題 | O(nⁿ) が上限。制約で枝刈り | O(n) スタック・配置 + 出力 | n = 8 の解は 92 個 |
| 迷路探索 | O(V²) | O(V) | リストによる訪問済み判定。V は盤面のマス数 |

階乗や GCD は 1 回の呼び出しにつき 1 つの小さい問題へ進みます。一方、ハノイの塔と複数回再帰は 1 回の呼び出しから複数の再帰呼び出しを行うため、処理や出力が急増します。8 王妃問題と迷路探索では、制約や訪問済み状態を使った枝刈りが探索量を抑えます。再帰の形だけでなく、返り値のデータ構造とその操作も計算量に影響します。

## 5.9 まとめ

この章では、階乗と GCD で基底条件と線形・対数的な再帰を確認し、ハノイの塔と複数回再帰で複数の部分問題を組み合わせました。8 王妃問題では行・対角線の制約による枝刈りを行い、迷路探索では訪問済み状態を引き継いでバックトラッキングしました。

Flix では再帰の値を `Option` や不変な `List` で表現できます。`Option` は入力範囲外を明示し、`List` は移動手順、探索状態、作業スタックを安全に組み立てます。ただし、不変リストの連結や訪問済み判定のように、データ構造に固有のコストを含めて計算量を考える必要があります。

次章では、整列アルゴリズムを実装し、隣接要素の交換や分割統治による計算量の違いを比較します。
