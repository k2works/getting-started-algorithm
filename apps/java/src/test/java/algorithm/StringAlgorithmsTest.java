package algorithm;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class StringAlgorithmsTest {

    @Nested
    class BfMatchTest {
        @Test void 見つかる() { assertEquals(12, StringAlgorithms.bfMatch("ABCXDEZCABACABAB", "ABAB")); }
        @Test void 先頭で見つかる() { assertEquals(0, StringAlgorithms.bfMatch("ABCDE", "ABC")); }
        @Test void 末尾で見つかる() { assertEquals(2, StringAlgorithms.bfMatch("ABCDE", "CDE")); }
        @Test void 見つからない() { assertEquals(-1, StringAlgorithms.bfMatch("ABCDE", "XYZ")); }
        @Test void 空パターン() { assertEquals(0, StringAlgorithms.bfMatch("ABCDE", "")); }
        @Test void パターンがテキストより長い() { assertEquals(-1, StringAlgorithms.bfMatch("AB", "ABCDE")); }
        @Test void 単一文字() { assertEquals(2, StringAlgorithms.bfMatch("ABCDE", "C")); }
    }

    @Nested
    class KmpMatchTest {
        @Test void 見つかる() { assertEquals(12, StringAlgorithms.kmpMatch("ABCXDEZCABACABAB", "ABAB")); }
        @Test void 先頭で見つかる() { assertEquals(0, StringAlgorithms.kmpMatch("ABCDE", "ABC")); }
        @Test void 見つからない() { assertEquals(-1, StringAlgorithms.kmpMatch("ABCDE", "XYZ")); }
        @Test void 空パターン() { assertEquals(0, StringAlgorithms.kmpMatch("ABCDE", "")); }
        @Test void 繰り返しパターン() { assertEquals(0, StringAlgorithms.kmpMatch("AAABAAAB", "AAAB")); }
    }

    @Nested
    class BmMatchTest {
        @Test void 見つかる() { assertEquals(12, StringAlgorithms.bmMatch("ABCXDEZCABACABAB", "ABAB")); }
        @Test void 先頭で見つかる() { assertEquals(0, StringAlgorithms.bmMatch("ABCDE", "ABC")); }
        @Test void 見つからない() { assertEquals(-1, StringAlgorithms.bmMatch("ABCDE", "XYZ")); }
        @Test void 空パターン() { assertEquals(0, StringAlgorithms.bmMatch("ABCDE", "")); }
    }

    @Nested
    class CountCharsTest {
        @Test
        void カウント() {
            Map<Character, Integer> result = StringAlgorithms.countChars("hello world");
            assertEquals(3, result.get('l'));
            assertEquals(2, result.get('o'));
            assertEquals(1, result.get(' '));
        }

        @Test
        void 空文字列() {
            assertTrue(StringAlgorithms.countChars("").isEmpty());
        }
    }

    @Nested
    class ReverseStringTest {
        @Test void 逆順() { assertEquals("olleh", StringAlgorithms.reverseString("hello")); }
        @Test void 空文字列() { assertEquals("", StringAlgorithms.reverseString("")); }
        @Test void 単一文字() { assertEquals("a", StringAlgorithms.reverseString("a")); }
        @Test void 回文はそのまま() { assertEquals("racecar", StringAlgorithms.reverseString("racecar")); }
    }

    @Nested
    class IsPalindromeTest {
        @Test void 回文() { assertTrue(StringAlgorithms.isPalindrome("racecar")); }
        @Test void 回文でない() { assertFalse(StringAlgorithms.isPalindrome("hello")); }
        @Test void 単一文字() { assertTrue(StringAlgorithms.isPalindrome("a")); }
        @Test void 空文字列() { assertTrue(StringAlgorithms.isPalindrome("")); }
        @Test void 偶数長の回文() { assertTrue(StringAlgorithms.isPalindrome("abba")); }
    }
}
