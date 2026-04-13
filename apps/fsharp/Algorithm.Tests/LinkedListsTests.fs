module Chapter08Tests

open Xunit
open LinkedLists

// 第8章 リスト テスト

module SinglyLinkedListTests =
    [<Fact>]
    let ``初期状態は空``() =
        let lst = SinglyLinkedList<int>()
        Assert.Equal(0, lst.Size())
        Assert.True(lst.IsEmpty())

    [<Fact>]
    let ``addFirst``() =
        let lst = SinglyLinkedList<int>()
        lst.AddFirst(1)
        Assert.Equal(1, lst.Size())

    [<Fact>]
    let ``addLast``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1)
        lst.AddLast(2)
        Assert.Equal(2, lst.Size())

    [<Fact>]
    let ``探索_見つかる``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(10); lst.AddLast(20); lst.AddLast(30)
        Assert.True(lst.Contains(20))

    [<Fact>]
    let ``探索_見つからない``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(10)
        Assert.False(lst.Contains(99))

    [<Fact>]
    let ``removeFirst``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2)
        lst.RemoveFirst()
        Assert.Equal(1, lst.Size())
        Assert.False(lst.Contains(1))

    [<Fact>]
    let ``removeLast``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2)
        lst.RemoveLast()
        Assert.Equal(1, lst.Size())
        Assert.False(lst.Contains(2))

    [<Fact>]
    let ``removeByValue``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2); lst.AddLast(3)
        Assert.True(lst.Remove(2))
        Assert.False(lst.Contains(2))
        Assert.Equal(2, lst.Size())

    [<Fact>]
    let ``contains``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(42)
        Assert.True(lst.Contains(42))
        Assert.False(lst.Contains(0))

    [<Fact>]
    let ``removeFirst_空で例外``() =
        let lst = SinglyLinkedList<int>()
        Assert.Throws<SinglyListEmptyException>(fun () -> lst.RemoveFirst()) |> ignore

    [<Fact>]
    let ``removeLast_空で例外``() =
        let lst = SinglyLinkedList<int>()
        Assert.Throws<SinglyListEmptyException>(fun () -> lst.RemoveLast()) |> ignore

    [<Fact>]
    let ``イテレーション``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2); lst.AddLast(3)
        Assert.Equal<int list>([1; 2; 3], lst.ToList())

    [<Fact>]
    let ``clear``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2)
        lst.Clear()
        Assert.True(lst.IsEmpty())

    [<Fact>]
    let ``removeLast_単一要素``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1)
        lst.RemoveLast()
        Assert.True(lst.IsEmpty())

    [<Fact>]
    let ``remove_空リスト``() =
        let lst = SinglyLinkedList<int>()
        Assert.False(lst.Remove(1))

    [<Fact>]
    let ``remove_存在しない値``() =
        let lst = SinglyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2)
        Assert.False(lst.Remove(99))
        Assert.Equal(2, lst.Size())

module DoublyLinkedListTests =
    [<Fact>]
    let ``初期状態は空``() =
        let lst = DoublyLinkedList<int>()
        Assert.Equal(0, lst.Size())
        Assert.True(lst.IsEmpty())

    [<Fact>]
    let ``addFirst``() =
        let lst = DoublyLinkedList<int>()
        lst.AddFirst(1)
        Assert.Equal(1, lst.Size())

    [<Fact>]
    let ``addLast``() =
        let lst = DoublyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2)
        Assert.Equal(2, lst.Size())

    [<Fact>]
    let ``contains``() =
        let lst = DoublyLinkedList<int>()
        lst.AddLast(10); lst.AddLast(20)
        Assert.True(lst.Contains(20))
        Assert.False(lst.Contains(99))

    [<Fact>]
    let ``remove``() =
        let lst = DoublyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2); lst.AddLast(3)
        Assert.True(lst.Remove(2))
        Assert.False(lst.Contains(2))
        Assert.Equal(2, lst.Size())

    [<Fact>]
    let ``イテレーション``() =
        let lst = DoublyLinkedList<int>()
        lst.AddLast(1); lst.AddLast(2); lst.AddLast(3)
        Assert.Equal<int list>([1; 2; 3], lst.ToList())

    [<Fact>]
    let ``clear``() =
        let lst = DoublyLinkedList<int>()
        lst.AddLast(1)
        lst.Clear()
        Assert.True(lst.IsEmpty())

    [<Fact>]
    let ``remove_空リスト``() =
        let lst = DoublyLinkedList<int>()
        Assert.False(lst.Remove(99))

module ArrayLinkedListTests =
    [<Fact>]
    let ``初期化``() =
        Assert.Equal(0, ArrayLinkedList(100).Size())

    [<Fact>]
    let ``addFirst``() =
        let al = ArrayLinkedList(100)
        al.AddFirst(1); al.AddFirst(2)
        Assert.Equal(2, al.Size())

    [<Fact>]
    let ``addFirst_順序``() =
        let al = ArrayLinkedList(100)
        al.AddFirst(1); al.AddFirst(2); al.AddFirst(3)
        Assert.Equal(3, al.GetHeadData())

    [<Fact>]
    let ``addLast``() =
        let al = ArrayLinkedList(100)
        al.AddLast(1); al.AddLast(2)
        Assert.Equal(2, al.Size())

    [<Fact>]
    let ``addLast_順序``() =
        let al = ArrayLinkedList(100)
        al.AddLast(1); al.AddLast(2); al.AddLast(3)
        Assert.Equal(1, al.GetHeadData())

    [<Fact>]
    let ``search_見つかる``() =
        let al = ArrayLinkedList(100)
        al.AddLast(10); al.AddLast(20); al.AddLast(30)
        Assert.True(al.Search(20) >= 0)

    [<Fact>]
    let ``search_見つからない``() =
        let al = ArrayLinkedList(100)
        al.AddLast(10)
        Assert.Equal(-1, al.Search(99))

    [<Fact>]
    let ``removeFirst``() =
        let al = ArrayLinkedList(100)
        al.AddLast(1); al.AddLast(2); al.AddLast(3)
        al.RemoveFirst()
        Assert.Equal(2, al.Size())
        Assert.Equal(-1, al.Search(1))

    [<Fact>]
    let ``removeFirst_空``() =
        let al = ArrayLinkedList(100)
        al.RemoveFirst()
        Assert.Equal(0, al.Size())

    [<Fact>]
    let ``削除スロットの再利用``() =
        let al = ArrayLinkedList(100)
        al.AddFirst(1); al.AddFirst(2)
        al.RemoveFirst()
        al.AddFirst(3)
        Assert.Equal(2, al.Size())

    [<Fact>]
    let ``容量超過``() =
        let al = ArrayLinkedList(2)
        al.AddFirst(1); al.AddFirst(2); al.AddFirst(3)
        Assert.Equal(2, al.Size())
