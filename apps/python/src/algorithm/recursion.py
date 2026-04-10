"""第5章 再帰アルゴリズム"""


def factorial(n: int) -> int:
    """n の階乗を再帰的に計算

    >>> factorial(5)
    120
    """
    if n <= 0:
        return 1
    return n * factorial(n - 1)


def gcd(x: int, y: int) -> int:
    """ユークリッドの互除法で最大公約数を求める

    >>> gcd(22, 8)
    2
    """
    if y == 0:
        return x
    return gcd(y, x % y)


def recursive_sum(n: int) -> int:
    """1 から n までの和を再帰的に計算

    >>> recursive_sum(5)
    15
    """
    if n <= 0:
        return 0
    return n + recursive_sum(n - 1)


def hanoi(n: int, src: str, dst: str, via: str) -> list[tuple[str, str]]:
    """ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す

    >>> hanoi(1, 'A', 'C', 'B')
    [('A', 'C')]
    """
    if n == 1:
        return [(src, dst)]
    moves = []
    moves.extend(hanoi(n - 1, src, via, dst))
    moves.append((src, dst))
    moves.extend(hanoi(n - 1, via, dst, src))
    return moves


def maze_solve(
    maze: list[list[int]],
    row: int,
    col: int,
    goal_row: int,
    goal_col: int,
    visited: set[tuple[int, int]] | None = None,
) -> bool:
    """迷路をバックトラッキングで解く

    maze[r][c] == 0: 通路, 1: 壁
    Returns True if goal is reachable from (row, col).

    >>> maze = [[1,1,1],[1,0,1],[1,1,1]]
    >>> maze_solve(maze, 1, 1, 1, 1)
    True
    """
    if visited is None:
        visited = set()

    if row == goal_row and col == goal_col:
        return True

    rows = len(maze)
    cols = len(maze[0])
    visited.add((row, col))

    for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nr, nc = row + dr, col + dc
        if (
            0 <= nr < rows
            and 0 <= nc < cols
            and maze[nr][nc] == 0
            and (nr, nc) not in visited
        ):
            if maze_solve(maze, nr, nc, goal_row, goal_col, visited):
                return True

    return False
