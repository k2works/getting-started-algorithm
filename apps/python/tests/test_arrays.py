"""第2章 配列 — テスト"""

from algorithm.arrays import (
    card_conv,
    max_of,
    prime1,
    prime2,
    prime3,
    reverse_array,
)


class TestMaxOf:
    """配列の要素の最大値"""

    def test_max_of(self):
        assert max_of([172, 153, 192, 140, 165]) == 192

    def test_max_of_single(self):
        assert max_of([42]) == 42

    def test_max_of_equal(self):
        assert max_of([5, 5, 5]) == 5


class TestReverseArray:
    """配列の要素の並びを反転"""

    def test_reverse_array(self):
        a = [2, 5, 1, 3, 9, 6, 7]
        reverse_array(a)
        assert a == [7, 6, 9, 3, 1, 5, 2]

    def test_reverse_array_even(self):
        a = [1, 2, 3, 4]
        reverse_array(a)
        assert a == [4, 3, 2, 1]

    def test_reverse_array_single(self):
        a = [42]
        reverse_array(a)
        assert a == [42]


class TestCardConv:
    """基数変換"""

    def test_binary(self):
        assert card_conv(29, 2) == "11101"

    def test_octal(self):
        assert card_conv(29, 8) == "35"

    def test_hex(self):
        assert card_conv(255, 16) == "FF"


class TestPrime:
    """素数の列挙"""

    def test_prime1(self):
        assert prime1(1000) == 78022

    def test_prime2(self):
        assert prime2(1000) == 14622

    def test_prime3(self):
        assert prime3(1000) == 3774
