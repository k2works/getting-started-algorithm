# 第 5 章 再帰アルゴリズム

## はじめに

この章では再帰アルゴリズムを Scala で実装します。Scala では末尾再帰最適化（`@tailrec`）がサポートされていますが、ここでは基本的な再帰から始めます。

## 再帰とは

再帰とは、関数が自分自身を呼び出す手法です。基底条件（ベースケース）と再帰条件（再帰ステップ）の 2 つで構成されます。

---

## 1. 基本的な再帰

### 階乗

```scala
def factorial(n: Int): Int =
  if n <= 0 then 1 else n * factorial(n - 1)
```

### ユークリッドの互除法

```scala
def gcd(x: Int, y: Int): Int =
  if y == 0 then x else gcd(y, x % y)
```

---

## 2. ハノイの塔

```scala
def hanoi(n: Int, src: String, dst: String, via: String): List[String] =
  if n == 1 then List(s"$src->$dst")
  else hanoi(n - 1, src, via, dst) ++ List(s"$src->$dst") ++ hanoi(n - 1, via, dst, src)
```

Scala のリスト結合 `++` を使い、移動手順をリストとして返します。n=3 のとき 7 手で解けます。

---

## 3. 迷路探索（バックトラッキング）

```scala
def mazeSolve(maze: Array[Array[Int]], row: Int, col: Int,
              goalRow: Int, goalCol: Int): Boolean =
  val visited = Array.ofDim[Boolean](maze.length, maze(0).length)
  def solve(r: Int, c: Int): Boolean =
    if r == goalRow && c == goalCol then true
    else
      visited(r)(c) = true
      val dirs = Array((-1, 0), (1, 0), (0, -1), (0, 1))
      dirs.exists: (dr, dc) =>
        ...
  solve(row, col)
```

ローカル関数（`def` のネスト）で再帰を実装します。

---

## 4. 8 王妃問題

```scala
class EightQueen3:
  def set(i: Int): Unit =
    for j <- 0 until 8 do
      if !flagA(j) && !flagB(i + j) && !flagC(i - j + 7) then
        pos(i) = j
        if i == 7 then result += pos.clone()
        else
          flagA(j) = true; flagB(i + j) = true; flagC(i - j + 7) = true
          set(i + 1)
          flagA(j) = false; flagB(i + j) = false; flagC(i - j + 7) = false
```

完全解は 92 通りです。

---

## テスト実行結果

```
Tests: succeeded 13, failed 0
```

## まとめ

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| factorial | O(n) | 末尾再帰最適化可 |
| gcd | O(log n) | 末尾再帰 |
| hanoi | O(2^n) | n=3 で 7 手 |
| 迷路探索 | O(4^n) | バックトラッキング |
| 8 王妃問題 | O(n!) | 枝刈りで高速化 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
