using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第7章 文字列処理 テスト</summary>
public class StringAlgorithmsTest
{
    public class BfMatchTest
    {
        [Fact] public void 見つかる() => Assert.Equal(12, StringAlgorithms.BfMatch("ABCXDEZCABACABAB", "ABAB"));
        [Fact] public void 先頭で見つかる() => Assert.Equal(0, StringAlgorithms.BfMatch("ABCDE", "ABC"));
        [Fact] public void 末尾で見つかる() => Assert.Equal(2, StringAlgorithms.BfMatch("ABCDE", "CDE"));
        [Fact] public void 見つからない() => Assert.Equal(-1, StringAlgorithms.BfMatch("ABCDE", "XYZ"));
        [Fact] public void 空パターン() => Assert.Equal(0, StringAlgorithms.BfMatch("ABCDE", ""));
        [Fact] public void パターンがテキストより長い() => Assert.Equal(-1, StringAlgorithms.BfMatch("AB", "ABCDE"));
        [Fact] public void 単一文字() => Assert.Equal(2, StringAlgorithms.BfMatch("ABCDE", "C"));
    }

    public class KmpMatchTest
    {
        [Fact] public void 見つかる() => Assert.Equal(12, StringAlgorithms.KmpMatch("ABCXDEZCABACABAB", "ABAB"));
        [Fact] public void 先頭で見つかる() => Assert.Equal(0, StringAlgorithms.KmpMatch("ABCDE", "ABC"));
        [Fact] public void 見つからない() => Assert.Equal(-1, StringAlgorithms.KmpMatch("ABCDE", "XYZ"));
        [Fact] public void 空パターン() => Assert.Equal(0, StringAlgorithms.KmpMatch("ABCDE", ""));
        [Fact] public void 繰り返しパターン() => Assert.Equal(0, StringAlgorithms.KmpMatch("AAABAAAB", "AAAB"));
    }

    public class BmMatchTest
    {
        [Fact] public void 見つかる() => Assert.Equal(12, StringAlgorithms.BmMatch("ABCXDEZCABACABAB", "ABAB"));
        [Fact] public void 先頭で見つかる() => Assert.Equal(0, StringAlgorithms.BmMatch("ABCDE", "ABC"));
        [Fact] public void 見つからない() => Assert.Equal(-1, StringAlgorithms.BmMatch("ABCDE", "XYZ"));
        [Fact] public void 空パターン() => Assert.Equal(0, StringAlgorithms.BmMatch("ABCDE", ""));
    }

    public class CountCharsTest
    {
        [Fact]
        public void カウント()
        {
            var result = StringAlgorithms.CountChars("hello world");
            Assert.Equal(3, result['l']);
            Assert.Equal(2, result['o']);
            Assert.Equal(1, result[' ']);
        }
        [Fact] public void 空文字列() => Assert.Empty(StringAlgorithms.CountChars(""));
    }

    public class ReverseStringTest
    {
        [Fact] public void 逆順() => Assert.Equal("olleh", StringAlgorithms.ReverseString("hello"));
        [Fact] public void 空文字列() => Assert.Equal("", StringAlgorithms.ReverseString(""));
        [Fact] public void 単一文字() => Assert.Equal("a", StringAlgorithms.ReverseString("a"));
        [Fact] public void 回文はそのまま() => Assert.Equal("racecar", StringAlgorithms.ReverseString("racecar"));
    }

    public class IsPalindromeTest
    {
        [Fact] public void 回文() => Assert.True(StringAlgorithms.IsPalindrome("racecar"));
        [Fact] public void 回文でない() => Assert.False(StringAlgorithms.IsPalindrome("hello"));
        [Fact] public void 単一文字() => Assert.True(StringAlgorithms.IsPalindrome("a"));
        [Fact] public void 空文字列() => Assert.True(StringAlgorithms.IsPalindrome(""));
        [Fact] public void 偶数長の回文() => Assert.True(StringAlgorithms.IsPalindrome("abba"));
    }
}
