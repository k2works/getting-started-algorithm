"""第1章 基本的なアルゴリズム"""


def max3(a: int, b: int, c: int) -> int:
    """3つの整数値の最大値を返す

    >>> max3(1, 3, 2)
    3
    >>> max3(3, 3, 3)
    3
    """
    maximum = a
    if b > maximum:
        maximum = b
    if c > maximum:
        maximum = c
    return maximum


def med3(a: int, b: int, c: int) -> int:
    """3つの整数値の中央値を返す

    >>> med3(1, 3, 2)
    2
    >>> med3(3, 3, 3)
    3
    """
    if a >= b:
        if b >= c:
            return b
        elif a <= c:
            return a
        else:
            return c
    elif a > c:
        return a
    elif b > c:
        return c
    else:
        return b


def judge_sign(n: int) -> str:
    """整数値の符号を判定する

    >>> judge_sign(17)
    'その値は正です。'
    >>> judge_sign(-5)
    'その値は負です。'
    >>> judge_sign(0)
    'その値は0です。'
    """
    if n > 0:
        return "その値は正です。"
    elif n < 0:
        return "その値は負です。"
    else:
        return "その値は0です。"


def sum_1_to_n_while(n: int) -> int:
    """while 文で 1 から n までの総和を求める

    >>> sum_1_to_n_while(5)
    15
    """
    total = 0
    i = 1
    while i <= n:
        total += i
        i += 1
    return total


def sum_1_to_n_for(n: int) -> int:
    """for 文で 1 から n までの総和を求める

    >>> sum_1_to_n_for(5)
    15
    """
    total = 0
    for i in range(1, n + 1):
        total += i
    return total


def alternative_1(n: int) -> str:
    """記号文字 '+' と '-' を交互に表示する（剰余判定方式）

    >>> alternative_1(12)
    '+-+-+-+-+-+-'
    """
    result = ""
    for i in range(n):
        if i % 2:
            result += "-"
        else:
            result += "+"
    return result


def alternative_2(n: int) -> str:
    """記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）

    >>> alternative_2(12)
    '+-+-+-+-+-+-'
    """
    result = "+-" * (n // 2)
    if n % 2:
        result += "+"
    return result


def rectangle(area: int) -> str:
    """縦横が整数で面積が area の長方形の辺の長さを列挙する

    >>> rectangle(32)
    '1x32 2x16 4x8 '
    """
    result = ""
    for i in range(1, area + 1):
        if i * i > area:
            break
        if area % i:
            continue
        result += f"{i}x{area // i} "
    return result


def multiplication_table() -> str:
    """九九の表を返す

    >>> '1  2  3' in multiplication_table()
    True
    """
    result = "-" * 27 + "\n"
    for i in range(1, 10):
        for j in range(1, 10):
            result += f"{i * j:3}"
        result += "\n"
    result += "-" * 27
    return result


def traiangle_lb(n: int) -> str:
    """左下側が直角の二等辺三角形を返す

    >>> traiangle_lb(3)
    '*\\n**\\n***\\n'
    """
    result = ""
    for i in range(n):
        result += "*" * (i + 1) + "\n"
    return result
