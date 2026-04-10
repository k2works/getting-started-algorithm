"""第1章 基本的なアルゴリズム — テスト"""

from algorithm.basic_algorithms import (
    alternative_1,
    alternative_2,
    judge_sign,
    max3,
    med3,
    multiplication_table,
    rectangle,
    sum_1_to_n_for,
    sum_1_to_n_while,
    traiangle_lb,
)


class TestMax3:
    """3値の最大値"""

    def test_max3_cases(self):
        cases = [
            (3, 2, 1, 3),  # a > b > c
            (3, 2, 2, 3),  # a > b = c
            (3, 1, 2, 3),  # a > c > b
            (3, 2, 3, 3),  # a = c > b
            (2, 1, 3, 3),  # c > a > b
            (3, 3, 2, 3),  # a = b > c
            (3, 3, 3, 3),  # a = b = c
            (2, 2, 3, 3),  # c > a = b
            (2, 3, 1, 3),  # b > a > c
            (2, 3, 2, 3),  # b > a = c
            (1, 3, 2, 3),  # b > c > a
            (2, 3, 3, 3),  # b = c > a
            (1, 2, 3, 3),  # c > b > a
        ]
        for a, b, c, expected in cases:
            assert max3(a, b, c) == expected, (
                f"max3({a}, {b}, {c}) should be {expected}"
            )


class TestMed3:
    """3値の中央値"""

    def test_med3_cases(self):
        cases = [
            (3, 2, 1, 2),  # a > b > c
            (3, 2, 2, 2),  # a > b = c
            (3, 1, 2, 2),  # a > c > b
            (3, 2, 3, 3),  # a = c > b
            (2, 1, 3, 2),  # c > a > b
            (3, 3, 2, 3),  # a = b > c
            (3, 3, 3, 3),  # a = b = c
            (2, 2, 3, 2),  # c > a = b
            (2, 3, 1, 2),  # b > a > c
            (2, 3, 2, 2),  # b > a = c
            (1, 3, 2, 2),  # b > c > a
            (2, 3, 3, 3),  # b = c > a
            (1, 2, 3, 2),  # c > b > a
        ]
        for a, b, c, expected in cases:
            assert med3(a, b, c) == expected, (
                f"med3({a}, {b}, {c}) should be {expected}"
            )


class TestJudgeSign:
    """条件判定と分岐"""

    def test_positive(self):
        assert judge_sign(17) == "その値は正です。"

    def test_negative(self):
        assert judge_sign(-5) == "その値は負です。"

    def test_zero(self):
        assert judge_sign(0) == "その値は0です。"


class TestSum1ToN:
    """繰り返し処理 — 1からnまでの総和"""

    def test_sum_while(self):
        assert sum_1_to_n_while(5) == 15

    def test_sum_for(self):
        assert sum_1_to_n_for(5) == 15


class TestAlternative:
    """繰り返し処理 — 記号文字の交互表示"""

    def test_alternative_1(self):
        assert alternative_1(12) == "+-+-+-+-+-+-"

    def test_alternative_2(self):
        assert alternative_2(12) == "+-+-+-+-+-+-"

    def test_alternative_odd(self):
        assert alternative_1(5) == "+-+-+"
        assert alternative_2(5) == "+-+-+"


class TestRectangle:
    """繰り返し処理 — 長方形の辺の長さを列挙"""

    def test_rectangle(self):
        assert rectangle(32) == "1x32 2x16 4x8 "


class TestMultiplicationTable:
    """多重ループ — 九九の表"""

    def test_multiplication_table(self):
        expected = (
            "---------------------------\n"
            "  1  2  3  4  5  6  7  8  9\n"
            "  2  4  6  8 10 12 14 16 18\n"
            "  3  6  9 12 15 18 21 24 27\n"
            "  4  8 12 16 20 24 28 32 36\n"
            "  5 10 15 20 25 30 35 40 45\n"
            "  6 12 18 24 30 36 42 48 54\n"
            "  7 14 21 28 35 42 49 56 63\n"
            "  8 16 24 32 40 48 56 64 72\n"
            "  9 18 27 36 45 54 63 72 81\n"
            "---------------------------"
        )
        assert multiplication_table() == expected


class TestTraiangleLb:
    """多重ループ — 直角三角形の表示"""

    def test_traiangle_lb(self):
        expected = "*\n**\n***\n****\n*****\n"
        assert traiangle_lb(5) == expected
