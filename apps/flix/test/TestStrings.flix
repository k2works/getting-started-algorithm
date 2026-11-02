mod TestStrings {
    /// 力まかせ法は最初に一致した位置を返す。
    @Test
    def bfMatch_found(): Unit \ Assert =
        Assert.assertEq(expected = Some(12), Strings.bfMatch("ABCXDEZCABACABAB", "ABAB"))

    /// 力まかせ法は一致しない場合に None を返す。
    @Test
    def bfMatch_not_found(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.bfMatch("ABCDE", "XYZ"))

    /// 力まかせ法は空パターンを先頭位置で見つける。
    @Test
    def bfMatch_empty_pattern(): Unit \ Assert =
        Assert.assertEq(expected = Some(0), Strings.bfMatch("ABC", ""))

    /// 力まかせ法は空テキストに非空パターンを見つけない。
    @Test
    def bfMatch_empty_text(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.bfMatch("", "A"))

    /// 力まかせ法は重なり合う候補を順に調べる。
    @Test
    def bfMatch_overlapping_prefixes(): Unit \ Assert =
        Assert.assertEq(expected = Some(2), Strings.bfMatch("aaaaab", "aaab"))

    /// KMP 法はパターン内の接頭辞と接尾辞を再利用する。
    @Test
    def kmpMatch_found_after_fallback(): Unit \ Assert =
        Assert.assertEq(expected = Some(2), Strings.kmpMatch("abababac", "ababac"))

    /// KMP 法は見つからないパターンに None を返す。
    @Test
    def kmpMatch_not_found(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.kmpMatch("ABCDE", "XYZ"))

    /// KMP 法は空パターンを先頭位置で見つける。
    @Test
    def kmpMatch_empty_pattern(): Unit \ Assert =
        Assert.assertEq(expected = Some(0), Strings.kmpMatch("", ""))

    /// KMP 法はテキストより長いパターンを見つけない。
    @Test
    def kmpMatch_pattern_longer_than_text(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.kmpMatch("AB", "ABC"))

    /// KMP 法は日本語の文字列を検索する。
    @Test
    def kmpMatch_japanese(): Unit \ Assert =
        Assert.assertEq(expected = Some(3), Strings.kmpMatch("こんにちは世界", "ちは"))

    /// Boyer-Moore 法は右から比較して最初の一致を返す。
    @Test
    def bmMatch_found(): Unit \ Assert =
        Assert.assertEq(expected = Some(12), Strings.bmMatch("ABCXDEZCABACABAB", "ABAB"))

    /// Boyer-Moore 法はパターン内の文字が右側にある場合も進める。
    @Test
    def bmMatch_repeated_pattern_characters(): Unit \ Assert =
        Assert.assertEq(expected = Some(3), Strings.bmMatch("ABAAABCD", "AABC"))

    /// Boyer-Moore 法はテキストより長いパターンを見つけない。
    @Test
    def bmMatch_pattern_longer_than_text(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.bmMatch("AB", "ABC"))

    /// Boyer-Moore 法は一致しないパターンに None を返す。
    @Test
    def bmMatch_not_found(): Unit \ Assert =
        Assert.assertEq(expected = None, Strings.bmMatch("ABCDE", "XYZ"))

    /// Boyer-Moore 法は空パターンを先頭位置で見つける。
    @Test
    def bmMatch_empty_pattern(): Unit \ Assert =
        Assert.assertEq(expected = Some(0), Strings.bmMatch("", ""))

    /// 文字カウントは日本語を含む各文字の出現回数を返す。
    @Test
    def countChars_counts_each_character(): Unit \ Assert =
        let counts = Strings.countChars("こんにちはこ");
        Assert.assertEq(expected = Some(2), Map.get('こ', counts));
        Assert.assertEq(expected = Some(1), Map.get('ん', counts));
        Assert.assertEq(expected = Some(1), Map.get('ち', counts))

    /// 文字カウントは空文字列に空の Map を返す。
    @Test
    def countChars_empty(): Unit \ Assert =
        Assert.assertEq(expected = Nil, Map.toList(Strings.countChars("")))

    /// 文字列を逆順にする。
    @Test
    def reverseString_reverses_characters(): Unit \ Assert =
        Assert.assertEq(expected = "cba", Strings.reverseString("abc"))

    /// 空文字列と単一文字の逆順を扱う。
    @Test
    def reverseString_handles_boundaries(): Unit \ Assert =
        Assert.assertEq(expected = "", Strings.reverseString(""));
        Assert.assertEq(expected = "雪", Strings.reverseString("雪"))

    /// 回文判定は ASCII 文字列を判定する。
    @Test
    def isPalindrome_ascii(): Unit \ Assert =
        Assert.assertEq(expected = true, Strings.isPalindrome("level"));
        Assert.assertEq(expected = false, Strings.isPalindrome("hello"))

    /// 回文判定は日本語の文字列を扱う。
    @Test
    def isPalindrome_japanese(): Unit \ Assert =
        Assert.assertEq(expected = true, Strings.isPalindrome("たけやぶやけた"))
}
