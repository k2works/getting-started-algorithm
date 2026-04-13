module Chapter09Tests

open Xunit
open Trees

// 第9章 木構造 テスト

module BinarySearchTreeTests =
    [<Fact>]
    let ``初期状態は空``() =
        Assert.True(BinarySearchTree<int>().IsEmpty())

    [<Fact>]
    let ``insertしてcontains``() =
        let bst = BinarySearchTree<int>()
        bst.Insert(5)
        Assert.True(bst.Contains(5))

    [<Fact>]
    let ``存在しないキー``() =
        Assert.False(BinarySearchTree<int>().Contains(99))

    [<Fact>]
    let ``複数insert``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1; 4; 6; 8] do bst.Insert(v)
        for v in [5; 3; 7; 1; 4; 6; 8] do Assert.True(bst.Contains(v))

    [<Fact>]
    let ``中順探索は昇順``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1; 4; 6; 8] do bst.Insert(v)
        Assert.Equal<int list>([1; 3; 4; 5; 6; 7; 8], bst.InOrder())

    [<Fact>]
    let ``前順探索``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        Assert.Equal<int list>([5; 3; 7], bst.PreOrder())

    [<Fact>]
    let ``後順探索``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        Assert.Equal<int list>([3; 7; 5], bst.PostOrder())

    [<Fact>]
    let ``min``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1; 4] do bst.Insert(v)
        Assert.Equal(1, bst.Min())

    [<Fact>]
    let ``max``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1; 4] do bst.Insert(v)
        Assert.Equal(7, bst.Max())

    [<Fact>]
    let ``min_空で例外``() =
        Assert.Throws<BSTEmptyException>(fun () -> BinarySearchTree<int>().Min() |> ignore) |> ignore

    [<Fact>]
    let ``max_空で例外``() =
        Assert.Throws<BSTEmptyException>(fun () -> BinarySearchTree<int>().Max() |> ignore) |> ignore

    [<Fact>]
    let ``葉ノードの削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        bst.Delete(3)
        Assert.False(bst.Contains(3))
        Assert.True(bst.Contains(5))
        Assert.True(bst.Contains(7))

    [<Fact>]
    let ``子が1つのノードの削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1] do bst.Insert(v)
        bst.Delete(3)
        Assert.False(bst.Contains(3))
        Assert.True(bst.Contains(1))

    [<Fact>]
    let ``子が2つのノードの削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 1; 4] do bst.Insert(v)
        bst.Delete(3)
        Assert.False(bst.Contains(3))
        for v in [1; 4; 5; 7] do Assert.True(bst.Contains(v))

    [<Fact>]
    let ``根ノードの削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        bst.Delete(5)
        Assert.False(bst.Contains(5))
        Assert.True(bst.Contains(3))
        Assert.True(bst.Contains(7))
        Assert.Equal<int list>([3; 7], bst.InOrder())

    [<Fact>]
    let ``存在しないキーの削除``() =
        let bst = BinarySearchTree<int>()
        bst.Insert(5)
        bst.Delete(99)
        Assert.True(bst.Contains(5))

    [<Fact>]
    let ``size``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        Assert.Equal(3, bst.Size())

    [<Fact>]
    let ``contains``() =
        let bst = BinarySearchTree<int>()
        bst.Insert(42)
        Assert.True(bst.Contains(42))
        Assert.False(bst.Contains(0))

    [<Fact>]
    let ``根のみ削除で空``() =
        let bst = BinarySearchTree<int>()
        bst.Insert(5)
        bst.Delete(5)
        Assert.True(bst.IsEmpty())

    [<Fact>]
    let ``重複キー挿入は無視``() =
        let bst = BinarySearchTree<int>()
        bst.Insert(5); bst.Insert(5)
        Assert.Equal(1, bst.Size())

    [<Fact>]
    let ``右子のみのノード削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7; 8] do bst.Insert(v)
        bst.Delete(7)
        Assert.False(bst.Contains(7))
        Assert.True(bst.Contains(8))

    [<Fact>]
    let ``深い後継ノードの削除``() =
        let bst = BinarySearchTree<int>()
        for v in [10; 5; 20; 15; 25; 12; 18] do bst.Insert(v)
        bst.Delete(10)
        Assert.False(bst.Contains(10))
        Assert.Equal<int list>([5; 12; 15; 18; 20; 25], bst.InOrder())

    [<Fact>]
    let ``右子として親に繋がるノード削除``() =
        let bst = BinarySearchTree<int>()
        for v in [5; 3; 7] do bst.Insert(v)
        bst.Delete(7)
        Assert.False(bst.Contains(7))
        Assert.True(bst.Contains(5))
