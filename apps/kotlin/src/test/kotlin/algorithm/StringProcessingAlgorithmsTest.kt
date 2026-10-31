package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals

class StringProcessingAlgorithmsTest {
    private val searches: List<Pair<String, (String, String) -> Int>> = listOf(
        "brute force" to StringProcessingAlgorithms::bruteForceSearch,
        "KMP" to StringProcessingAlgorithms::kmpSearch,
        "Boyer-Moore" to StringProcessingAlgorithms::boyerMooreSearch,
    )

    @Test
    fun `string length counts UTF-16 code units`() {
        assertEquals(0, StringProcessingAlgorithms.stringLength(""))
        assertEquals(5, StringProcessingAlgorithms.stringLength("A😀日本"))
    }

    @Test
    fun `character counts use Unicode code points`() {
        assertEquals(
            mapOf("😀" to 2, "a" to 1),
            StringProcessingAlgorithms.countCharacters("😀a😀"),
        )
        assertEquals(emptyMap(), StringProcessingAlgorithms.countCharacters(""))
    }

    @Test
    fun `reverse preserves supplementary characters`() {
        assertEquals("b😀a", StringProcessingAlgorithms.reverse("a😀b"))
        assertEquals("", StringProcessingAlgorithms.reverse(""))
    }

    @Test
    fun `palindrome check compares Unicode code points`() {
        assertEquals(true, StringProcessingAlgorithms.isPalindrome("たけやぶやけた"))
        assertEquals(true, StringProcessingAlgorithms.isPalindrome("😀a😀"))
        assertEquals(false, StringProcessingAlgorithms.isPalindrome("algorithm"))
        assertEquals(true, StringProcessingAlgorithms.isPalindrome(""))
    }

    @Test
    fun `search algorithms find patterns and return UTF-16 indices`() {
        val cases = listOf(
            Triple("ABCXDEZCABACABAB", "ABAB", 12),
            Triple("ABCDE", "ABC", 0),
            Triple("ABCDE", "CDE", 2),
            Triple("ABCDE", "C", 2),
            Triple("aaaaab", "aaab", 2),
            Triple("日本語の文字列", "文字", 4),
            Triple("A😀B", "😀", 1),
            Triple("A😀B", "B", 3),
            Triple("ABCDE", "XYZ", -1),
            Triple("AB", "ABCDE", -1),
            Triple("ABCDE", "", 0),
            Triple("", "A", -1),
        )

        for ((name, search) in searches) {
            for ((text, pattern, expected) in cases) {
                assertEquals(expected, search(text, pattern), "$name: $text / $pattern")
            }
        }
    }
}
