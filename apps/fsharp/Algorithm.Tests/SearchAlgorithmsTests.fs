module Chapter03Tests

open Xunit
open SearchAlgorithms

// 第3章 探索アルゴリズム テスト

module LinearSearchTests =
    [<Fact>]
    let ``while文で探索_見つかる``() = Assert.Equal(3, linearSearchWhile [|6; 4; 3; 2; 1; 2; 8|] 2)

    [<Fact>]
    let ``while文で探索_見つからない``() = Assert.Equal(-1, linearSearchWhile [|1; 2; 3|] 99)

    [<Fact>]
    let ``for文で探索_見つかる``() = Assert.Equal(3, linearSearchFor [|6; 4; 3; 2; 1; 2; 8|] 2)

    [<Fact>]
    let ``for文で探索_見つからない``() = Assert.Equal(-1, linearSearchFor [|1; 2; 3|] 99)

    [<Fact>]
    let ``番兵法で探索_見つかる``() = Assert.Equal(3, linearSearchSentinel [|6; 4; 3; 2; 1; 2; 8|] 2)

    [<Fact>]
    let ``番兵法で探索_見つからない``() = Assert.Equal(-1, linearSearchSentinel [|1; 2; 3|] 99)

module BinarySearchTests =
    [<Fact>]
    let ``中央の要素を探索``() = Assert.Equal(3, binarySearch [|1; 2; 3; 5; 7; 8; 9|] 5)

    [<Fact>]
    let ``先頭の要素を探索``() = Assert.Equal(0, binarySearch [|1; 2; 3; 5; 7; 8; 9|] 1)

    [<Fact>]
    let ``末尾の要素を探索``() = Assert.Equal(6, binarySearch [|1; 2; 3; 5; 7; 8; 9|] 9)

    [<Fact>]
    let ``見つからない``() = Assert.Equal(-1, binarySearch [|1; 2; 3; 5; 7; 8; 9|] 4)

module ChainedHashTests =
    let makeHash () =
        let h = ChainedHash(13)
        h.Add(1, "赤尾") |> ignore
        h.Add(5, "武田") |> ignore
        h.Add(10, "小野") |> ignore
        h.Add(12, "鈴木") |> ignore
        h.Add(14, "神崎") |> ignore
        h

    [<Fact>]
    let ``探索_見つかる``() =
        let h = makeHash()
        Assert.Equal(Some "赤尾", h.Search(1))
        Assert.Equal(Some "神崎", h.Search(14))

    [<Fact>]
    let ``探索_見つからない``() = Assert.Equal(None, makeHash().Search(100))

    [<Fact>]
    let ``追加して探索``() =
        let h = makeHash()
        h.Add(100, "山田") |> ignore
        Assert.Equal(Some "山田", h.Search(100))

    [<Fact>]
    let ``重複キーは追加できない``() = Assert.False(makeHash().Add(1, "重複"))

    [<Fact>]
    let ``削除``() =
        let h = makeHash()
        h.Add(100, "山田") |> ignore
        Assert.True(h.Remove(100))
        Assert.Equal(None, h.Search(100))

    [<Fact>]
    let ``衝突したノードの削除``() =
        let h = makeHash()
        Assert.True(h.Remove(1))
        Assert.True(h.Remove(14))
        Assert.Equal(None, h.Search(1))
        Assert.Equal(None, h.Search(14))

    [<Fact>]
    let ``存在しないキーの削除``() = Assert.False(makeHash().Remove(999))

module OpenHashTests =
    let makeHash () =
        let h = OpenHash(13)
        h.Add(1, "赤尾") |> ignore
        h.Add(5, "武田") |> ignore
        h.Add(10, "小野") |> ignore
        h.Add(12, "鈴木") |> ignore
        h.Add(14, "神崎") |> ignore
        h

    [<Fact>]
    let ``探索_見つかる``() = Assert.Equal(Some "赤尾", makeHash().Search(1))

    [<Fact>]
    let ``探索_見つからない``() = Assert.Equal(None, makeHash().Search(999))

    [<Fact>]
    let ``追加して探索``() =
        let h = makeHash()
        h.Add(100, "山田") |> ignore
        Assert.Equal(Some "山田", h.Search(100))

    [<Fact>]
    let ``重複キーは追加できない``() = Assert.False(makeHash().Add(1, "重複"))

    [<Fact>]
    let ``削除``() =
        let h = makeHash()
        h.Add(100, "山田") |> ignore
        Assert.True(h.Remove(100))
        Assert.Equal(None, h.Search(100))

    [<Fact>]
    let ``存在しないキーの削除``() = Assert.False(makeHash().Remove(999))

    [<Fact>]
    let ``テーブル満杯時の追加``() =
        let small = OpenHash(3)
        small.Add(0, "a") |> ignore
        small.Add(1, "b") |> ignore
        small.Add(2, "c") |> ignore
        Assert.False(small.Add(99, "d"))

    [<Fact>]
    let ``テーブル満杯時の存在しないキー削除``() =
        let small = OpenHash(3)
        small.Add(0, "a") |> ignore
        small.Add(1, "b") |> ignore
        small.Add(2, "c") |> ignore
        Assert.False(small.Remove(99))
