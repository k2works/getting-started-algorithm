"""第7章 文字列処理 — テスト"""

from algorithm.strings import (
    bf_match,
    bm_match,
    count_chars,
    is_palindrome,
    kmp_match,
    reverse_string,
)


class TestBfMatch:
    """ブルートフォース文字列探索"""

    def test_found(self):
        assert bf_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_found_at_start(self):
        assert bf_match("ABCDE", "ABC") == 0

    def test_found_at_end(self):
        assert bf_match("ABCDE", "CDE") == 2

    def test_not_found(self):
        assert bf_match("ABCDE", "XYZ") == -1

    def test_empty_pattern(self):
        assert bf_match("ABCDE", "") == 0

    def test_pattern_longer_than_text(self):
        assert bf_match("AB", "ABCDE") == -1

    def test_single_char(self):
        assert bf_match("ABCDE", "C") == 2


class TestKmpMatch:
    """KMP 文字列探索"""

    def test_found(self):
        assert kmp_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_found_at_start(self):
        assert kmp_match("ABCDE", "ABC") == 0

    def test_not_found(self):
        assert kmp_match("ABCDE", "XYZ") == -1

    def test_empty_pattern(self):
        assert kmp_match("ABCDE", "") == 0

    def test_repeated_pattern(self):
        assert kmp_match("AAABAAAB", "AAAB") == 0


class TestBmMatch:
    """Boyer-Moore 文字列探索"""

    def test_found(self):
        assert bm_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_found_at_start(self):
        assert bm_match("ABCDE", "ABC") == 0

    def test_not_found(self):
        assert bm_match("ABCDE", "XYZ") == -1

    def test_empty_pattern(self):
        assert bm_match("ABCDE", "") == 0


class TestCountChars:
    """文字のカウント"""

    def test_count(self):
        result = count_chars("hello world")
        assert result["l"] == 3
        assert result["o"] == 2
        assert result[" "] == 1

    def test_empty_string(self):
        result = count_chars("")
        assert result == {}


class TestReverseString:
    """文字列の逆順"""

    def test_reverse(self):
        assert reverse_string("hello") == "olleh"

    def test_empty(self):
        assert reverse_string("") == ""

    def test_single(self):
        assert reverse_string("a") == "a"

    def test_palindrome_stays(self):
        assert reverse_string("racecar") == "racecar"


class TestIsPalindrome:
    """回文判定"""

    def test_palindrome(self):
        assert is_palindrome("racecar") is True

    def test_not_palindrome(self):
        assert is_palindrome("hello") is False

    def test_single_char(self):
        assert is_palindrome("a") is True

    def test_empty(self):
        assert is_palindrome("") is True

    def test_even_palindrome(self):
        assert is_palindrome("abba") is True
