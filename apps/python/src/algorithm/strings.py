"""第7章 文字列処理"""


def bf_match(text: str, pattern: str) -> int:
    """ブルートフォース文字列探索

    テキスト中でパターンが最初に現れる位置を返す。
    見つからない場合は -1 を返す。

    計算量: O(n * m)

    >>> bf_match("ABCXDEZCABACABAB", "ABAB")
    12
    """
    n = len(text)
    m = len(pattern)
    if m == 0:
        return 0
    for i in range(n - m + 1):
        j = 0
        while j < m and text[i + j] == pattern[j]:
            j += 1
        if j == m:
            return i
    return -1


def _build_kmp_table(pattern: str) -> list[int]:
    """KMP 法の失敗関数テーブルを構築"""
    m = len(pattern)
    table = [0] * m
    k = 0
    for i in range(1, m):
        while k > 0 and pattern[k] != pattern[i]:
            k = table[k - 1]
        if pattern[k] == pattern[i]:
            k += 1
        table[i] = k
    return table


def kmp_match(text: str, pattern: str) -> int:
    """KMP（Knuth-Morris-Pratt）文字列探索

    失敗関数テーブルを使い、比較の重複を避ける。

    計算量: O(n + m)

    >>> kmp_match("ABCXDEZCABACABAB", "ABAB")
    12
    """
    n = len(text)
    m = len(pattern)
    if m == 0:
        return 0

    table = _build_kmp_table(pattern)
    j = 0
    for i in range(n):
        while j > 0 and text[i] != pattern[j]:
            j = table[j - 1]
        if text[i] == pattern[j]:
            j += 1
        if j == m:
            return i - m + 1
    return -1


def bm_match(text: str, pattern: str) -> int:
    """Boyer-Moore 文字列探索（Bad Character ルールのみ）

    パターンを右から左へ比較し、不一致時にスキップ量を最大化する。

    計算量: 平均 O(n / m)、最悪 O(n * m)

    >>> bm_match("ABCXDEZCABACABAB", "ABAB")
    12
    """
    n = len(text)
    m = len(pattern)
    if m == 0:
        return 0

    # Bad Character テーブル: 各文字の最後の出現位置
    bad_char: dict[str, int] = {}
    for i, c in enumerate(pattern):
        bad_char[c] = i

    s = 0  # テキスト内のシフト量
    while s <= n - m:
        j = m - 1
        while j >= 0 and pattern[j] == text[s + j]:
            j -= 1
        if j < 0:
            return s
        else:
            skip = j - bad_char.get(text[s + j], -1)
            s += max(1, skip)
    return -1


def count_chars(s: str) -> dict[str, int]:
    """文字列中の各文字の出現回数を辞書で返す

    >>> count_chars("hello")
    {'h': 1, 'e': 1, 'l': 2, 'o': 1}
    """
    result: dict[str, int] = {}
    for c in s:
        result[c] = result.get(c, 0) + 1
    return result


def reverse_string(s: str) -> str:
    """文字列を逆順にして返す

    >>> reverse_string("hello")
    'olleh'
    """
    return s[::-1]


def is_palindrome(s: str) -> bool:
    """文字列が回文かどうかを判定

    >>> is_palindrome("racecar")
    True
    >>> is_palindrome("hello")
    False
    """
    return s == s[::-1]
