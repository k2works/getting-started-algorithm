module Chapter02Tests

open Xunit
open Arrays

// 第2章 配列 テスト

module MaxOfTests =
    [<Fact>]
    let ``複数要素の最大値``() = Assert.Equal(192, maxOf [|172; 153; 192; 140; 165|])

    [<Fact>]
    let ``単一要素``() = Assert.Equal(42, maxOf [|42|])

    [<Fact>]
    let ``全て同じ値``() = Assert.Equal(5, maxOf [|5; 5; 5|])

module ReverseArrayTests =
    [<Fact>]
    let ``奇数長の配列を反転``() =
        let a = [|2; 5; 1; 3; 9; 6; 7|]
        reverseArray a
        Assert.Equal<int[]>([|7; 6; 9; 3; 1; 5; 2|], a)

    [<Fact>]
    let ``偶数長の配列を反転``() =
        let a = [|1; 2; 3; 4|]
        reverseArray a
        Assert.Equal<int[]>([|4; 3; 2; 1|], a)

    [<Fact>]
    let ``単一要素``() =
        let a = [|42|]
        reverseArray a
        Assert.Equal<int[]>([|42|], a)

module CardConvTests =
    [<Fact>]
    let ``二進数変換``() = Assert.Equal("11101", cardConv 29 2)

    [<Fact>]
    let ``八進数変換``() = Assert.Equal("35", cardConv 29 8)

    [<Fact>]
    let ``十六進数変換``() = Assert.Equal("FF", cardConv 255 16)

module PrimeTests =
    [<Fact>]
    let ``素数列挙第1版の除算回数``() = Assert.Equal(78022, prime1 1000)

    [<Fact>]
    let ``素数列挙第2版の除算回数``() = Assert.Equal(14622, prime2 1000)

    [<Fact>]
    let ``素数列挙第3版の除算回数``() = Assert.Equal(3774, prime3 1000)
