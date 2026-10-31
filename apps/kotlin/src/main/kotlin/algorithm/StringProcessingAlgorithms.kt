package algorithm

object StringProcessingAlgorithms {
    fun stringLength(text: String): Int = text.length

    fun countCharacters(text: String): Map<String, Int> {
        val counts = linkedMapOf<String, Int>()
        var index = 0
        while (index < text.length) {
            val codePoint = text.codePointAt(index)
            val character = String(Character.toChars(codePoint))
            counts[character] = (counts[character] ?: 0) + 1
            index += Character.charCount(codePoint)
        }
        return counts
    }

    fun reverse(text: String): String {
        val result = StringBuilder(text.length)
        var index = text.length
        while (index > 0) {
            val codePoint = text.codePointBefore(index)
            result.appendCodePoint(codePoint)
            index -= Character.charCount(codePoint)
        }
        return result.toString()
    }

    fun isPalindrome(text: String): Boolean = text == reverse(text)

    fun bruteForceSearch(text: String, pattern: String): Int {
        val textLength = text.length
        val patternLength = pattern.length
        if (patternLength == 0) return 0

        for (start in 0..textLength - patternLength) {
            var matched = 0
            while (matched < patternLength && text[start + matched] == pattern[matched]) {
                matched++
            }
            if (matched == patternLength) return start
        }
        return -1
    }

    fun kmpSearch(text: String, pattern: String): Int {
        val patternLength = pattern.length
        if (patternLength == 0) return 0

        val prefixLengths = buildKmpTable(pattern)
        var matched = 0
        for (index in text.indices) {
            while (matched > 0 && text[index] != pattern[matched]) {
                matched = prefixLengths[matched - 1]
            }
            if (text[index] == pattern[matched]) matched++
            if (matched == patternLength) return index - patternLength + 1
        }
        return -1
    }

    fun boyerMooreSearch(text: String, pattern: String): Int {
        val textLength = text.length
        val patternLength = pattern.length
        if (patternLength == 0) return 0

        val lastOccurrence = mutableMapOf<Char, Int>()
        for (index in pattern.indices) {
            lastOccurrence[pattern[index]] = index
        }

        var start = 0
        while (start <= textLength - patternLength) {
            var patternIndex = patternLength - 1
            while (patternIndex >= 0 && pattern[patternIndex] == text[start + patternIndex]) {
                patternIndex--
            }
            if (patternIndex < 0) return start

            val mismatch = text[start + patternIndex]
            val previousOccurrence = lastOccurrence[mismatch] ?: -1
            start += (patternIndex - previousOccurrence).coerceAtLeast(1)
        }
        return -1
    }

    private fun buildKmpTable(pattern: String): IntArray {
        val prefixLengths = IntArray(pattern.length)
        var prefixLength = 0
        for (index in 1 until pattern.length) {
            while (prefixLength > 0 && pattern[index] != pattern[prefixLength]) {
                prefixLength = prefixLengths[prefixLength - 1]
            }
            if (pattern[index] == pattern[prefixLength]) prefixLength++
            prefixLengths[index] = prefixLength
        }
        return prefixLengths
    }
}
