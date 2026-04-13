module Chapter07Tests

open Xunit
open Strings

// 第7章 文字列処理 テスト

module BfMatchTests =
    [<Fact>]
    let ``見つかる``() = Assert.Equal(12, bfMatch "ABCXDEZCABACABAB" "ABAB")
    [<Fact>]
    let ``先頭で見つかる``() = Assert.Equal(0, bfMatch "ABCDE" "ABC")
    [<Fact>]
    let ``末尾で見つかる``() = Assert.Equal(2, bfMatch "ABCDE" "CDE")
    [<Fact>]
    let ``見つからない``() = Assert.Equal(-1, bfMatch "ABCDE" "XYZ")
    [<Fact>]
    let ``空パターン``() = Assert.Equal(0, bfMatch "ABCDE" "")
    [<Fact>]
    let ``パターンがテキストより長い``() = Assert.Equal(-1, bfMatch "AB" "ABCDE")
    [<Fact>]
    let ``単一文字``() = Assert.Equal(2, bfMatch "ABCDE" "C")

module KmpMatchTests =
    [<Fact>]
    let ``見つかる``() = Assert.Equal(12, kmpMatch "ABCXDEZCABACABAB" "ABAB")
    [<Fact>]
    let ``先頭で見つかる``() = Assert.Equal(0, kmpMatch "ABCDE" "ABC")
    [<Fact>]
    let ``見つからない``() = Assert.Equal(-1, kmpMatch "ABCDE" "XYZ")
    [<Fact>]
    let ``空パターン``() = Assert.Equal(0, kmpMatch "ABCDE" "")
    [<Fact>]
    let ``繰り返しパターン``() = Assert.Equal(0, kmpMatch "AAABAAAB" "AAAB")

module BmMatchTests =
    [<Fact>]
    let ``見つかる``() = Assert.Equal(12, bmMatch "ABCXDEZCABACABAB" "ABAB")
    [<Fact>]
    let ``先頭で見つかる``() = Assert.Equal(0, bmMatch "ABCDE" "ABC")
    [<Fact>]
    let ``見つからない``() = Assert.Equal(-1, bmMatch "ABCDE" "XYZ")
    [<Fact>]
    let ``空パターン``() = Assert.Equal(0, bmMatch "ABCDE" "")

module CountCharsTests =
    [<Fact>]
    let ``カウント``() =
        let result = countChars "hello world"
        Assert.Equal(3, result.['l'])
        Assert.Equal(2, result.['o'])
        Assert.Equal(1, result.[' '])
    [<Fact>]
    let ``空文字列``() = Assert.Empty(countChars "")

module ReverseStringTests =
    [<Fact>]
    let ``逆順``() = Assert.Equal("olleh", reverseString "hello")
    [<Fact>]
    let ``空文字列``() = Assert.Equal("", reverseString "")
    [<Fact>]
    let ``単一文字``() = Assert.Equal("a", reverseString "a")
    [<Fact>]
    let ``回文はそのまま``() = Assert.Equal("racecar", reverseString "racecar")

module IsPalindromeTests =
    [<Fact>]
    let ``回文``() = Assert.True(isPalindrome "racecar")
    [<Fact>]
    let ``回文でない``() = Assert.False(isPalindrome "hello")
    [<Fact>]
    let ``単一文字``() = Assert.True(isPalindrome "a")
    [<Fact>]
    let ``空文字列``() = Assert.True(isPalindrome "")
    [<Fact>]
    let ``偶数長の回文``() = Assert.True(isPalindrome "abba")
