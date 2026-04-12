using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第2章 配列 テスト</summary>
public class ArrayAlgorithmsTest
{
    public class MaxOfTest
    {
        [Fact] public void 複数要素の最大値() => Assert.Equal(192, ArrayAlgorithms.MaxOf([172, 153, 192, 140, 165]));
        [Fact] public void 単一要素() => Assert.Equal(42, ArrayAlgorithms.MaxOf([42]));
        [Fact] public void 全て同じ値() => Assert.Equal(5, ArrayAlgorithms.MaxOf([5, 5, 5]));
    }

    public class ReverseArrayTest
    {
        [Fact]
        public void 奇数長の配列を反転()
        {
            int[] a = [2, 5, 1, 3, 9, 6, 7];
            ArrayAlgorithms.Reverse(a);
            Assert.Equal([7, 6, 9, 3, 1, 5, 2], a);
        }

        [Fact]
        public void 偶数長の配列を反転()
        {
            int[] a = [1, 2, 3, 4];
            ArrayAlgorithms.Reverse(a);
            Assert.Equal([4, 3, 2, 1], a);
        }

        [Fact]
        public void 単一要素()
        {
            int[] a = [42];
            ArrayAlgorithms.Reverse(a);
            Assert.Equal([42], a);
        }
    }

    public class CardConvTest
    {
        [Fact] public void 二進数変換() => Assert.Equal("11101", ArrayAlgorithms.CardConv(29, 2));
        [Fact] public void 八進数変換() => Assert.Equal("35", ArrayAlgorithms.CardConv(29, 8));
        [Fact] public void 十六進数変換() => Assert.Equal("FF", ArrayAlgorithms.CardConv(255, 16));
    }

    public class PrimeTest
    {
        [Fact] public void 素数列挙第1版の除算回数() => Assert.Equal(78022, ArrayAlgorithms.Prime1(1000));
        [Fact] public void 素数列挙第2版の除算回数() => Assert.Equal(14622, ArrayAlgorithms.Prime2(1000));
        [Fact] public void 素数列挙第3版の除算回数() => Assert.Equal(3774, ArrayAlgorithms.Prime3(1000));
    }
}
