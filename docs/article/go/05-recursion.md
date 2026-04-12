# 第 5 章 再帰アルゴリズム

## はじめに

再帰とは、関数が自分自身を呼び出す手法です。Go でも再帰は自然に表現できます。

---

## 1. 再帰の基本

### 階乗

```go
func Factorial(n int) int {
    if n <= 0 {
        return 1
    }
    return n * Factorial(n-1)
}
```

### ユークリッドの互除法

```go
func Gcd(x, y int) int {
    if y == 0 {
        return x
    }
    return Gcd(y, x%y)
}
```

---

## 2. 再帰と反復

```go
// 再帰版
func RecursiveSum(n int) int {
    if n <= 0 {
        return 0
    }
    return n + RecursiveSum(n-1)
}
```

---

## 3. 再帰の応用

### ハノイの塔

Go では `[2]string` の固定長配列で移動手順を表現します。

```go
func Hanoi(n int, src, dst, via string) [][2]string {
    if n == 1 {
        return [][2]string{{src, dst}}
    }
    moves := Hanoi(n-1, src, via, dst)
    moves = append(moves, [2]string{src, dst})
    moves = append(moves, Hanoi(n-1, via, dst, src)...)
    return moves
}
```

### 迷路探索（バックトラッキング）

```go
func MazeSolve(maze [][]int, row, col, goalRow, goalCol int, visited map[[2]int]bool) bool {
    if visited == nil {
        visited = make(map[[2]int]bool)
    }
    if row == goalRow && col == goalCol {
        return true
    }
    visited[[2]int{row, col}] = true
    dirs := [4][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    for _, d := range dirs {
        nr, nc := row+d[0], col+d[1]
        if /* 境界内 */ nr >= 0 && nr < len(maze) && nc >= 0 && nc < len(maze[0]) &&
            maze[nr][nc] == 0 && !visited[[2]int{nr, nc}] {
            if MazeSolve(maze, nr, nc, goalRow, goalCol, visited) {
                return true
            }
        }
    }
    return false
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| タプルのリスト | `list[tuple[str, str]]` | `[][2]string` |
| set | `set()` | `map[[2]int]bool` |
| スプレッド追加 | `moves.extend(...)` | `append(moves, other...)` |
| None チェック | `if visited is None:` | `if visited == nil {` |
