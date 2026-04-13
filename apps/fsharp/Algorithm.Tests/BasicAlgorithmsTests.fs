module Chapter01Tests

open Xunit
open BasicAlgorithms

// 第1章 基本的なアルゴリズム テスト

module Max3Tests =
    [<Fact>]
    let ``各パターンで最大値を返す``() =
        let cases = [
            (3, 2, 1, 3); (3, 2, 2, 3); (3, 1, 2, 3)
            (3, 2, 3, 3); (2, 1, 3, 3); (3, 3, 2, 3)
            (3, 3, 3, 3); (2, 2, 3, 3); (2, 3, 1, 3)
            (2, 3, 2, 3); (1, 3, 2, 3); (2, 3, 3, 3)
            (1, 2, 3, 3)
        ]
        for (a, b, c, expected) in cases do
            Assert.Equal(expected, max3 a b c)

module Med3Tests =
    [<Fact>]
    let ``各パターンで中央値を返す``() =
        let cases = [
            (3, 2, 1, 2); (3, 2, 2, 2); (3, 1, 2, 2)
            (3, 2, 3, 3); (2, 1, 3, 2); (3, 3, 2, 3)
            (3, 3, 3, 3); (2, 2, 3, 2); (2, 3, 1, 2)
            (2, 3, 2, 2); (1, 3, 2, 2); (2, 3, 3, 3)
            (1, 2, 3, 2)
        ]
        for (a, b, c, expected) in cases do
            Assert.Equal(expected, med3 a b c)

module JudgeSignTests =
    [<Fact>]
    let ``正の値``() = Assert.Equal("その値は正です。", judgeSign 17)

    [<Fact>]
    let ``負の値``() = Assert.Equal("その値は負です。", judgeSign -5)

    [<Fact>]
    let ``ゼロ``() = Assert.Equal("その値は0です。", judgeSign 0)

module Sum1ToNTests =
    [<Fact>]
    let ``while文で総和``() = Assert.Equal(15, sum1ToNWhile 5)

    [<Fact>]
    let ``for文で総和``() = Assert.Equal(15, sum1ToNFor 5)

module AlternativeTests =
    [<Fact>]
    let ``剰余判定方式で12文字``() = Assert.Equal("+-+-+-+-+-+-", alternative1 12)

    [<Fact>]
    let ``パターン繰り返し方式で12文字``() = Assert.Equal("+-+-+-+-+-+-", alternative2 12)

    [<Fact>]
    let ``奇数文字``() =
        Assert.Equal("+-+-+", alternative1 5)
        Assert.Equal("+-+-+", alternative2 5)

module RectangleTests =
    [<Fact>]
    let ``面積32の長方形``() = Assert.Equal("1x32 2x16 4x8 ", rectangle 32)

module MultiplicationTableTests =
    [<Fact>]
    let ``九九の表``() =
        let expected =
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
            "---------------------------"
        Assert.Equal(expected, multiplicationTable())

module TriangleLbTests =
    [<Fact>]
    let ``直角三角形``() =
        let expected = "*\n**\n***\n****\n*****\n"
        Assert.Equal(expected, triangleLb 5)
