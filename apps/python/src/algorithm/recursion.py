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


class EightQueen:
    """8 王妃問題（全組み合わせ列挙）

    各列に 1 個の王妃を配置する組み合わせを全列挙する。
    行・対角線の重複チェックなし。
    """

    def __init__(self):
        self.result = []
        self.__pos = [0] * 8

    def put(self) -> None:
        """現在の盤面を結果に追加"""
        self.result.append(self.__pos[:])

    def set(self, i: int) -> None:
        """i 列目に王妃を配置"""
        for j in range(8):
            self.__pos[i] = j
            if i == 7:
                self.put()
            else:
                self.set(i + 1)


class EightQueen2:
    """8 王妃問題（行制約あり）

    各行・各列に 1 個の王妃を配置する組み合わせを列挙する。
    対角線の重複チェックなし。
    """

    def __init__(self):
        self.result = []
        self.__pos = [0] * 8
        self.__flag = [False] * 8  # 各行に王妃が配置済みかのフラグ

    def put(self) -> None:
        """現在の盤面を結果に追加"""
        self.result.append(self.__pos[:])

    def set(self, i: int) -> None:
        """i 列目の適切な位置に王妃を配置"""
        for j in range(8):
            if not self.__flag[j]:
                self.__pos[i] = j
                if i == 7:
                    self.put()
                else:
                    self.__flag[j] = True
                    self.set(i + 1)
                    self.__flag[j] = False


class EightQueen3:
    """8 王妃問題（行・対角線制約あり）

    各行・各列・各対角線に 1 個の王妃を配置する完全な 8 王妃問題。
    92 通りの解を求める。
    """

    def __init__(self):
        self.result = []
        self.__pos = [0] * 8
        self.__flag_a = [False] * 8   # 各行のフラグ
        self.__flag_b = [False] * 15  # 右上がり対角線のフラグ
        self.__flag_c = [False] * 15  # 右下がり対角線のフラグ

    def put(self) -> None:
        """現在の盤面を結果に追加"""
        self.result.append(self.__pos[:])

    def set(self, i: int) -> None:
        """i 列目の適切な位置に王妃を配置"""
        for j in range(8):
            if (not self.__flag_a[j]
                    and not self.__flag_b[i + j]
                    and not self.__flag_c[i - j + 7]):
                self.__pos[i] = j
                if i == 7:
                    self.put()
                else:
                    self.__flag_a[j] = True
                    self.__flag_b[i + j] = True
                    self.__flag_c[i - j + 7] = True
                    self.set(i + 1)
                    self.__flag_a[j] = False
                    self.__flag_b[i + j] = False
                    self.__flag_c[i - j + 7] = False
