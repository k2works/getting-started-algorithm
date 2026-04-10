"""第2章 配列"""

from collections.abc import MutableSequence, Sequence
from typing import Any


def max_of(a: Sequence) -> Any:
    """シーケンスaの要素の最大値を返す

    >>> max_of([172, 153, 192, 140, 165])
    192
    """
    maximum = a[0]
    for i in range(1, len(a)):
        if a[i] > maximum:
            maximum = a[i]
    return maximum


def reverse_array(a: MutableSequence) -> None:
    """ミュータブルなシーケンスaの要素の並びを反転する

    >>> a = [2, 5, 1, 3, 9, 6, 7]
    >>> reverse_array(a)
    >>> a
    [7, 6, 9, 3, 1, 5, 2]
    """
    n = len(a)
    for i in range(n // 2):
        a[i], a[n - i - 1] = a[n - i - 1], a[i]


def card_conv(x: int, r: int) -> str:
    """整数値xをr進数に変換した数値を表す文字列を返す

    >>> card_conv(29, 2)
    '11101'
    >>> card_conv(255, 16)
    'FF'
    """
    d = ""
    dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    while x > 0:
        d += dchar[x % r]
        x //= r

    return d[::-1]


def prime1(x: int) -> int:
    """x以下の素数を列挙する（第1版）— 除算回数を返す

    >>> prime1(1000)
    78022
    """
    counter = 0
    for n in range(2, x + 1):
        for i in range(2, n):
            counter += 1
            if n % i == 0:
                break
    return counter


def prime2(x: int) -> int:
    """x以下の素数を列挙する（第2版）— 除算回数を返す

    奇数のみを候補にし、すでに見つけた素数で割り切れるか確認する。

    >>> prime2(1000)
    14622
    """
    counter = 0
    ptr = 0
    prime = [None] * 500

    prime[ptr] = 2
    ptr += 1

    for n in range(3, x + 1, 2):
        for i in range(1, ptr):
            counter += 1
            if n % prime[i] == 0:
                break
        else:
            prime[ptr] = n
            ptr += 1

    return counter


def prime3(x: int) -> int:
    """x以下の素数を列挙する（第3版）— 除算回数を返す

    平方根以下の素数でのみ割り切れるか確認することで効率化する。

    >>> prime3(1000)
    3774
    """
    counter = 0
    ptr = 0
    prime = [None] * 500

    prime[ptr] = 2
    ptr += 1
    prime[ptr] = 3
    ptr += 1

    for n in range(5, 1001, 2):
        i = 1
        while prime[i] * prime[i] <= n:
            counter += 2
            if n % prime[i] == 0:
                break
            i += 1
        else:
            prime[ptr] = n
            ptr += 1
            counter += 1

    return counter
