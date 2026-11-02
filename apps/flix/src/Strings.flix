mod Strings {
    ///
    /// Returns the first matching UTF-16 code-unit index, or None.
    ///
    pub def bfMatch(text: String, pattern: String): Option[Int32] =
        let textLength = String.length(text);
        let patternLength = String.length(pattern);
        if (patternLength == 0) {
            Some(0)
        } else if (patternLength > textLength) {
            None
        } else region rc {
            let textChars = String.toArray(rc, text);
            let patternChars = String.toArray(rc, pattern);

            def search(start) =
                if (start > textLength - patternLength) {
                    None
                } else {
                    def compare(offset) =
                        if (offset >= patternLength) {
                            Some(start)
                        } else if (Array.get(start + offset, textChars) == Array.get(offset, patternChars)) {
                            compare(offset + 1)
                        } else {
                            search(start + 1)
                        };
                    compare(0)
                };

            search(0)
        }

    ///
    /// Builds the KMP prefix table and returns the first matching index.
    ///
    pub def kmpMatch(text: String, pattern: String): Option[Int32] =
        let textLength = String.length(text);
        let patternLength = String.length(pattern);
        if (patternLength == 0) {
            Some(0)
        } else if (patternLength > textLength) {
            None
        } else region rc {
            let textChars = String.toArray(rc, text);
            let patternChars = String.toArray(rc, pattern);
            let prefix = Array.repeat(rc, patternLength, 0);

            def build(i, matched) =
                if (i >= patternLength) {
                    ()
                } else {
                    def fallback(k) =
                        if (k > 0 and Array.get(k, patternChars) != Array.get(i, patternChars))
                            fallback(Array.get(k - 1, prefix))
                        else
                            k;

                    let k = fallback(matched);
                    let next = if (Array.get(k, patternChars) == Array.get(i, patternChars)) k + 1 else k;
                    Array.put(next, i, prefix);
                    build(i + 1, next)
                };

            def search(i, matched) =
                if (i >= textLength) {
                    None
                } else {
                    def fallback(k) =
                        if (k > 0 and Array.get(i, textChars) != Array.get(k, patternChars))
                            fallback(Array.get(k - 1, prefix))
                        else
                            k;

                    let k = fallback(matched);
                    if (Array.get(i, textChars) == Array.get(k, patternChars)) {
                        let next = k + 1;
                        if (next == patternLength)
                            Some(i - patternLength + 1)
                        else
                            search(i + 1, next)
                    } else {
                        search(i + 1, 0)
                    }
                };

            build(1, 0);
            search(0, 0)
        }

    ///
    /// Uses the Boyer-Moore bad-character rule to find the first match.
    ///
    pub def bmMatch(text: String, pattern: String): Option[Int32] =
        let textLength = String.length(text);
        let patternLength = String.length(pattern);
        if (patternLength == 0) {
            Some(0)
        } else if (patternLength > textLength) {
            None
        } else region rc {
            let textChars = String.toArray(rc, text);
            let patternChars = String.toArray(rc, pattern);

            def buildBadCharacterTable(i, table) =
                if (i >= patternLength) {
                    table
                } else {
                    let character = Array.get(i, patternChars);
                    buildBadCharacterTable(i + 1, Map.insert(character, i, table))
                };

            let badCharacterTable = buildBadCharacterTable(0, Map.empty());

            def search(start) =
                if (start > textLength - patternLength) {
                    None
                } else {
                    def compare(offset) =
                        if (offset < 0) {
                            Some(start)
                        } else {
                            let textCharacter = Array.get(start + offset, textChars);
                            let patternCharacter = Array.get(offset, patternChars);
                            if (textCharacter == patternCharacter) {
                                compare(offset - 1)
                            } else {
                                let lastOccurrence = match Map.get(textCharacter, badCharacterTable) {
                                    case None => -1
                                    case Some(index) => index
                                };
                                let shift = if (offset - lastOccurrence > 1) offset - lastOccurrence else 1;
                                search(start + shift)
                            }
                        };
                    compare(patternLength - 1)
                };

            search(0)
        }

    ///
    /// Counts the occurrences of each UTF-16 code unit.
    ///
    pub def countChars(s: String): Map[Char, Int32] =
        def countOccurrences(chars, counts) = match chars {
            case Nil => counts
            case character :: rest =>
                let nextCount = match Map.get(character, counts) {
                    case None => 1
                    case Some(currentCount) => currentCount + 1
                };
                countOccurrences(rest, Map.insert(character, nextCount, counts))
        };
        countOccurrences(String.toList(s), Map.empty())

    ///
    /// Returns a string with its UTF-16 code units in reverse order.
    ///
    pub def reverseString(s: String): String =
        let length = String.length(s);
        String.init(i -> String.get(length - i - 1, s), length)

    ///
    /// Tests whether the UTF-16 code units form a palindrome.
    ///
    pub def isPalindrome(s: String): Bool =
        let last = String.length(s) - 1;
        def compare(left, right) =
            if (left >= right)
                true
            else if (String.get(left, s) == String.get(right, s))
                compare(left + 1, right - 1)
            else
                false;
        compare(0, last)
}
