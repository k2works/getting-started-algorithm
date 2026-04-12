using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第5章 再帰アルゴリズム テスト</summary>
public class RecursionTest
{
    public class FactorialTest
    {
        [Fact] public void factorial_0() => Assert.Equal(1, Recursion.Factorial(0));
        [Fact] public void factorial_1() => Assert.Equal(1, Recursion.Factorial(1));
        [Fact] public void factorial_5() => Assert.Equal(120, Recursion.Factorial(5));
        [Fact] public void factorial_10() => Assert.Equal(3628800, Recursion.Factorial(10));
    }

    public class GcdTest
    {
        [Fact] public void 基本() => Assert.Equal(2, Recursion.Gcd(22, 8));
        [Fact] public void 倍数() => Assert.Equal(4, Recursion.Gcd(12, 4));
        [Fact] public void 互いに素() => Assert.Equal(1, Recursion.Gcd(7, 11));
        [Fact] public void 同じ値() => Assert.Equal(15, Recursion.Gcd(15, 15));
    }

    public class RecursiveSumTest
    {
        [Fact] public void sum_1() => Assert.Equal(1, Recursion.RecursiveSum(1));
        [Fact] public void sum_5() => Assert.Equal(15, Recursion.RecursiveSum(5));
        [Fact] public void sum_10() => Assert.Equal(55, Recursion.RecursiveSum(10));
    }

    public class HanoiTest
    {
        [Fact] public void ハノイ1枚() => Assert.Equal(["A->C"], Recursion.Hanoi(1, "A", "C", "B"));
        [Fact] public void ハノイ2枚() => Assert.Equal(["A->B", "A->C", "B->C"], Recursion.Hanoi(2, "A", "C", "B"));
        [Fact] public void ハノイ3枚は7手() => Assert.Equal(7, Recursion.Hanoi(3, "A", "C", "B").Count);
        [Fact]
        public void ハノイn枚は2のn乗マイナス1手()
        { for (int n = 1; n <= 5; n++) Assert.Equal((1 << n) - 1, Recursion.Hanoi(n, "A", "C", "B").Count); }
    }

    public class MazeSolveTest
    {
        [Fact]
        public void 解ける迷路()
        {
            int[][] maze = [[1, 1, 1, 1, 1], [1, 0, 0, 0, 1], [1, 0, 1, 0, 1], [1, 0, 0, 0, 1], [1, 1, 1, 1, 1]];
            Assert.True(Recursion.MazeSolve(maze, 1, 1, 3, 3));
        }
        [Fact]
        public void 解けない迷路()
        {
            int[][] maze = [[1, 1, 1, 1, 1], [1, 0, 1, 0, 1], [1, 1, 1, 1, 1], [1, 0, 0, 0, 1], [1, 1, 1, 1, 1]];
            Assert.False(Recursion.MazeSolve(maze, 1, 1, 3, 1));
        }
    }

    public class EightQueenTest
    {
        [Fact]
        public void 全組み合わせは8の8乗()
        { var eq = new Recursion.EightQueen(); eq.Set(0); Assert.Equal((int)Math.Pow(8, 8), eq.GetCount()); }
        [Fact]
        public void 行制約ありは40320通り()
        { var eq2 = new Recursion.EightQueen2(); eq2.Set(0); Assert.Equal(40320, eq2.GetResult().Count); }
        [Fact]
        public void 完全解は92通り()
        { var eq3 = new Recursion.EightQueen3(); eq3.Set(0); Assert.Equal(92, eq3.GetResult().Count); }
    }
}
