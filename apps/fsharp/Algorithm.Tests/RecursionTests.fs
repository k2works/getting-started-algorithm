module Chapter05Tests

open Xunit
open Recursion

// 第5章 再帰アルゴリズム テスト

module FactorialTests =
    [<Fact>]
    let ``factorial_0``() = Assert.Equal(1, factorial 0)

    [<Fact>]
    let ``factorial_1``() = Assert.Equal(1, factorial 1)

    [<Fact>]
    let ``factorial_5``() = Assert.Equal(120, factorial 5)

    [<Fact>]
    let ``factorial_10``() = Assert.Equal(3628800, factorial 10)

module GcdTests =
    [<Fact>]
    let ``基本``() = Assert.Equal(2, gcd 22 8)

    [<Fact>]
    let ``倍数``() = Assert.Equal(4, gcd 12 4)

    [<Fact>]
    let ``互いに素``() = Assert.Equal(1, gcd 7 11)

    [<Fact>]
    let ``同じ値``() = Assert.Equal(15, gcd 15 15)

module RecursiveSumTests =
    [<Fact>]
    let ``sum_1``() = Assert.Equal(1, recursiveSum 1)

    [<Fact>]
    let ``sum_5``() = Assert.Equal(15, recursiveSum 5)

    [<Fact>]
    let ``sum_10``() = Assert.Equal(55, recursiveSum 10)

module HanoiTests =
    [<Fact>]
    let ``ハノイ1枚``() = Assert.Equal<string list>(["A->C"], hanoi 1 "A" "C" "B")

    [<Fact>]
    let ``ハノイ2枚``() = Assert.Equal<string list>(["A->B"; "A->C"; "B->C"], hanoi 2 "A" "C" "B")

    [<Fact>]
    let ``ハノイ3枚は7手``() = Assert.Equal(7, hanoi 3 "A" "C" "B" |> List.length)

    [<Fact>]
    let ``ハノイn枚は2のn乗マイナス1手``() =
        for n in 1..5 do
            Assert.Equal((1 <<< n) - 1, hanoi n "A" "C" "B" |> List.length)

module MazeSolveTests =
    [<Fact>]
    let ``解ける迷路``() =
        let maze = [|[|1;1;1;1;1|];[|1;0;0;0;1|];[|1;0;1;0;1|];[|1;0;0;0;1|];[|1;1;1;1;1|]|]
        Assert.True(mazeSolve maze 1 1 3 3)

    [<Fact>]
    let ``解けない迷路``() =
        let maze = [|[|1;1;1;1;1|];[|1;0;1;0;1|];[|1;1;1;1;1|];[|1;0;0;0;1|];[|1;1;1;1;1|]|]
        Assert.False(mazeSolve maze 1 1 3 1)

module EightQueenTests =
    [<Fact>]
    let ``全組み合わせは8の8乗``() =
        let eq = EightQueen()
        eq.Set(0)
        Assert.Equal(int (System.Math.Pow(8.0, 8.0)), eq.GetCount())

    [<Fact>]
    let ``行制約ありは40320通り``() =
        let eq2 = EightQueen2()
        eq2.Set(0)
        Assert.Equal(40320, eq2.GetResult() |> List.length)

    [<Fact>]
    let ``完全解は92通り``() =
        let eq3 = EightQueen3()
        eq3.Set(0)
        Assert.Equal(92, eq3.GetResult() |> List.length)
