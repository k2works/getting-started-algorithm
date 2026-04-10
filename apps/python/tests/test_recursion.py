"""第5章 再帰アルゴリズム — テスト"""

from algorithm.recursion import (
    factorial,
    gcd,
    hanoi,
    maze_solve,
    recursive_sum,
)


class TestFactorial:
    """階乗"""

    def test_factorial_0(self):
        assert factorial(0) == 1

    def test_factorial_1(self):
        assert factorial(1) == 1

    def test_factorial_5(self):
        assert factorial(5) == 120

    def test_factorial_10(self):
        assert factorial(10) == 3628800


class TestGcd:
    """最大公約数（ユークリッドの互除法）"""

    def test_gcd_basic(self):
        assert gcd(22, 8) == 2

    def test_gcd_one_multiple(self):
        assert gcd(12, 4) == 4

    def test_gcd_coprime(self):
        assert gcd(7, 11) == 1

    def test_gcd_same(self):
        assert gcd(15, 15) == 15


class TestRecursiveSum:
    """再帰的な合計"""

    def test_sum_1(self):
        assert recursive_sum(1) == 1

    def test_sum_5(self):
        assert recursive_sum(5) == 15  # 1+2+3+4+5

    def test_sum_10(self):
        assert recursive_sum(10) == 55


class TestHanoi:
    """ハノイの塔"""

    def test_hanoi_1(self):
        moves = hanoi(1, "A", "C", "B")
        assert moves == [("A", "C")]

    def test_hanoi_2(self):
        moves = hanoi(2, "A", "C", "B")
        assert moves == [("A", "B"), ("A", "C"), ("B", "C")]

    def test_hanoi_3(self):
        moves = hanoi(3, "A", "C", "B")
        assert len(moves) == 7  # 2^3 - 1 = 7 回の移動

    def test_hanoi_move_count(self):
        """n 枚のハノイの塔は 2^n - 1 回の移動が必要"""
        for n in range(1, 6):
            moves = hanoi(n, "A", "C", "B")
            assert len(moves) == 2**n - 1


class TestMazeSolve:
    """迷路探索（再帰的バックトラッキング）"""

    def test_maze_solvable(self):
        maze = [
            [1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1],
            [1, 0, 1, 0, 1],
            [1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1],
        ]
        # (1,1) から (3,3) への経路が存在する
        assert maze_solve(maze, 1, 1, 3, 3) is True

    def test_maze_unsolvable(self):
        maze = [
            [1, 1, 1, 1, 1],
            [1, 0, 1, 0, 1],
            [1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1],
        ]
        # (1,1) から (3,1) への経路が存在しない
        assert maze_solve(maze, 1, 1, 3, 1) is False
