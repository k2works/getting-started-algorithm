# 第 5 章 再帰アルゴリズム

## はじめに

前章ではスタックとキューというデータ構造を学びました。この章では「**再帰（Recursion）**」というアルゴリズム設計手法を TDD で実装します。

再帰とは、**ある関数が自分自身を呼び出す**ことで問題を解く手法です。大きな問題を同じ構造の小さな問題に分解し、最終的に自明な基底ケースに到達したら戻り始めます。

主な実装内容：

1. 階乗（Factorial）
2. 最大公約数（ユークリッドの互除法）
3. 再帰的な合計
4. ハノイの塔
5. 迷路探索（バックトラッキング）

---

## 1. 階乗

`n! = n × (n-1) × ... × 1` を再帰で実装します。

### Red — 失敗するテストを書く

```python
# tests/test_recursion.py
class TestFactorial:
    def test_factorial_0(self):
        assert factorial(0) == 1

    def test_factorial_5(self):
        assert factorial(5) == 120
```

### Green — テストを通す実装

```python
# src/algorithm/recursion.py
def factorial(n: int) -> int:
    """n の階乗を再帰的に計算

    >>> factorial(5)
    120
    """
    if n <= 0:
        return 1
    return n * factorial(n - 1)
```

### アルゴリズムの考え方

```plantuml
@startuml
title 階乗の再帰呼び出し

factorial(5)
note right: 5 * factorial(4)

factorial(4)
note right: 4 * factorial(3)

factorial(3)
note right: 3 * factorial(2)

factorial(2)
note right: 2 * factorial(1)

factorial(1)
note right: 1 * factorial(0)

factorial(0)
note right: return 1 （基底ケース）
@enduml
```

**計算量**: O(n)（n 回の再帰呼び出し）

---

## 2. 最大公約数（ユークリッドの互除法）

`gcd(a, b) = gcd(b, a % b)` という関係を再帰で実装します。

### Red — 失敗するテストを書く

```python
class TestGcd:
    def test_gcd_basic(self):
        assert gcd(22, 8) == 2

    def test_gcd_coprime(self):
        assert gcd(7, 11) == 1
```

### Green — テストを通す実装

```python
def gcd(x: int, y: int) -> int:
    """ユークリッドの互除法で最大公約数を求める

    >>> gcd(22, 8)
    2
    """
    if y == 0:
        return x
    return gcd(y, x % y)
```

**計算量**: O(log min(x, y))

---

## 3. ハノイの塔

n 枚の円盤を A から C へ B を経由して移動する問題です。

```
ルール:
1. 一度に 1 枚しか移動できない
2. 大きい円盤を小さい円盤の上に置けない
```

### Red — 失敗するテストを書く

```python
class TestHanoi:
    def test_hanoi_1(self):
        moves = hanoi(1, "A", "C", "B")
        assert moves == [("A", "C")]

    def test_hanoi_move_count(self):
        """n 枚のハノイの塔は 2^n - 1 回の移動が必要"""
        for n in range(1, 6):
            moves = hanoi(n, "A", "C", "B")
            assert len(moves) == 2**n - 1
```

### Green — テストを通す実装

```python
def hanoi(n: int, src: str, dst: str, via: str) -> list[tuple[str, str]]:
    """ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す"""
    if n == 1:
        return [(src, dst)]
    moves = []
    moves.extend(hanoi(n - 1, src, via, dst))  # n-1 枚を via へ
    moves.append((src, dst))                     # 最大の円盤を dst へ
    moves.extend(hanoi(n - 1, via, dst, src))   # n-1 枚を dst へ
    return moves
```

**計算量**: O(2^n)（移動回数 2^n - 1 回）

---

## 4. 迷路探索（バックトラッキング）

再帰的バックトラッキングで迷路を解きます。行き止まりに達したら戻り、別の経路を試みます。

### Red — 失敗するテストを書く

```python
class TestMazeSolve:
    def test_maze_solvable(self):
        maze = [
            [1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1],
            [1, 0, 1, 0, 1],
            [1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1],
        ]
        assert maze_solve(maze, 1, 1, 3, 3) is True
```

### Green — テストを通す実装

```python
def maze_solve(maze, row, col, goal_row, goal_col, visited=None):
    if visited is None:
        visited = set()
    if row == goal_row and col == goal_col:
        return True
    visited.add((row, col))
    for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nr, nc = row + dr, col + dc
        if (
            0 <= nr < len(maze) and 0 <= nc < len(maze[0])
            and maze[nr][nc] == 0
            and (nr, nc) not in visited
        ):
            if maze_solve(maze, nr, nc, goal_row, goal_col, visited):
                return True
    return False
```

---

## テスト実行結果

```bash
$ uv run pytest tests/test_recursion.py -v

...（17 テスト全パス）...

Name                        Stmts   Miss  Cover
-----------------------------------------------
src/algorithm/recursion.py     34      0   100%
-----------------------------------------------
17 passed in 0.12s
```

カバレッジ 100% 達成コロ助。

---

## 再帰アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| 階乗 | O(n) | 単純な線形再帰 |
| GCD（ユークリッド） | O(log min(x,y)) | 対数的収束 |
| ハノイの塔 | O(2^n) | 指数的成長 |
| 迷路探索 | O(行数 × 列数) | バックトラッキング |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
