using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第1章 基本的なアルゴリズム テスト</summary>
public class BasicAlgorithmsTest
{
    public class Max3Test
    {
        [Fact]
        public void 各パターンで最大値を返す()
        {
            int[][] cases = [
                [3, 2, 1, 3], [3, 2, 2, 3], [3, 1, 2, 3],
                [3, 2, 3, 3], [2, 1, 3, 3], [3, 3, 2, 3],
                [3, 3, 3, 3], [2, 2, 3, 3], [2, 3, 1, 3],
                [2, 3, 2, 3], [1, 3, 2, 3], [2, 3, 3, 3],
                [1, 2, 3, 3],
            ];
            foreach (var c in cases)
                Assert.Equal(c[3], BasicAlgorithms.Max3(c[0], c[1], c[2]));
        }
    }

    public class Med3Test
    {
        [Fact]
        public void 各パターンで中央値を返す()
        {
            int[][] cases = [
                [3, 2, 1, 2], [3, 2, 2, 2], [3, 1, 2, 2],
                [3, 2, 3, 3], [2, 1, 3, 2], [3, 3, 2, 3],
                [3, 3, 3, 3], [2, 2, 3, 2], [2, 3, 1, 2],
                [2, 3, 2, 2], [1, 3, 2, 2], [2, 3, 3, 3],
                [1, 2, 3, 2],
            ];
            foreach (var c in cases)
                Assert.Equal(c[3], BasicAlgorithms.Med3(c[0], c[1], c[2]));
        }
    }

    public class JudgeSignTest
    {
        [Fact]
        public void 正の値() => Assert.Equal("その値は正です。", BasicAlgorithms.JudgeSign(17));

        [Fact]
        public void 負の値() => Assert.Equal("その値は負です。", BasicAlgorithms.JudgeSign(-5));

        [Fact]
        public void ゼロ() => Assert.Equal("その値は0です。", BasicAlgorithms.JudgeSign(0));
    }

    public class Sum1ToNTest
    {
        [Fact]
        public void while文で総和() => Assert.Equal(15, BasicAlgorithms.Sum1ToNWhile(5));

        [Fact]
        public void for文で総和() => Assert.Equal(15, BasicAlgorithms.Sum1ToNFor(5));
    }

    public class AlternativeTest
    {
        [Fact]
        public void 剰余判定方式で12文字() => Assert.Equal("+-+-+-+-+-+-", BasicAlgorithms.Alternative1(12));

        [Fact]
        public void パターン繰り返し方式で12文字() => Assert.Equal("+-+-+-+-+-+-", BasicAlgorithms.Alternative2(12));

        [Fact]
        public void 奇数文字()
        {
            Assert.Equal("+-+-+", BasicAlgorithms.Alternative1(5));
            Assert.Equal("+-+-+", BasicAlgorithms.Alternative2(5));
        }
    }

    public class RectangleTest
    {
        [Fact]
        public void 面積32の長方形() => Assert.Equal("1x32 2x16 4x8 ", BasicAlgorithms.Rectangle(32));
    }

    public class MultiplicationTableTest
    {
        [Fact]
        public void 九九の表()
        {
            string expected =
                "---------------------------\n" +
                "  1  2  3  4  5  6  7  8  9\n" +
                "  2  4  6  8 10 12 14 16 18\n" +
                "  3  6  9 12 15 18 21 24 27\n" +
                "  4  8 12 16 20 24 28 32 36\n" +
                "  5 10 15 20 25 30 35 40 45\n" +
                "  6 12 18 24 30 36 42 48 54\n" +
                "  7 14 21 28 35 42 49 56 63\n" +
                "  8 16 24 32 40 48 56 64 72\n" +
                "  9 18 27 36 45 54 63 72 81\n" +
                "---------------------------";
            Assert.Equal(expected, BasicAlgorithms.MultiplicationTable());
        }
    }

    public class TriangleLbTest
    {
        [Fact]
        public void 直角三角形()
        {
            string expected = "*\n**\n***\n****\n*****\n";
            Assert.Equal(expected, BasicAlgorithms.TriangleLb(5));
        }
    }
}
