module Chapter04Tests

open Xunit
open StacksAndQueues

// 第4章 スタックとキュー テスト

module FixedStackTests =
    [<Fact>]
    let ``初期状態は空``() =
        let s = FixedStack<int>(64)
        Assert.True(s.IsEmpty())
        Assert.False(s.IsFull())

    [<Fact>]
    let ``pushしてpeek``() =
        let s = FixedStack<int>(64)
        s.Push(1)
        Assert.Equal(1, s.Peek())

    [<Fact>]
    let ``pushしてpop``() =
        let s = FixedStack<int>(64)
        s.Push(1)
        Assert.Equal(1, s.Pop())

    [<Fact>]
    let ``複数pushしてLIFO順にpop``() =
        let s = FixedStack<int>(64)
        s.Push(1); s.Push(2); s.Push(3)
        Assert.Equal(3, s.Pop())
        Assert.Equal(2, s.Pop())
        Assert.Equal(1, s.Pop())

    [<Fact>]
    let ``満杯判定``() =
        let s = FixedStack<int>(3)
        s.Push(1); s.Push(2); s.Push(3)
        Assert.True(s.IsFull())

    [<Fact>]
    let ``空のpopで例外``() =
        let s = FixedStack<int>(64)
        Assert.Throws<StackEmptyException>(fun () -> s.Pop() |> ignore) |> ignore

    [<Fact>]
    let ``満杯のpushで例外``() =
        let s = FixedStack<int>(2)
        s.Push(1); s.Push(2)
        Assert.Throws<StackFullException>(fun () -> s.Push(3)) |> ignore

    [<Fact>]
    let ``空のpeekで例外``() =
        let s = FixedStack<int>(64)
        Assert.Throws<StackEmptyException>(fun () -> s.Peek() |> ignore) |> ignore

    [<Fact>]
    let ``find``() =
        let s = FixedStack<int>(64)
        s.Push(10); s.Push(20); s.Push(30)
        Assert.Equal(1, s.Find(20))

    [<Fact>]
    let ``find_見つからない``() =
        let s = FixedStack<int>(64)
        s.Push(10)
        Assert.Equal(-1, s.Find(99))

    [<Fact>]
    let ``count``() =
        let s = FixedStack<int>(64)
        s.Push(5); s.Push(5); s.Push(10)
        Assert.Equal(2, s.Count(5))
        Assert.Equal(1, s.Count(10))
        Assert.Equal(0, s.Count(99))

    [<Fact>]
    let ``contains``() =
        let s = FixedStack<int>(64)
        s.Push(42)
        Assert.True(s.Contains(42))
        Assert.False(s.Contains(0))

    [<Fact>]
    let ``clear``() =
        let s = FixedStack<int>(64)
        s.Push(1); s.Push(2); s.Clear()
        Assert.True(s.IsEmpty())

    [<Fact>]
    let ``size``() =
        let s = FixedStack<int>(64)
        s.Push(1); s.Push(2)
        Assert.Equal(2, s.Size())

    [<Fact>]
    let ``capacity``() =
        let s = FixedStack<int>(64)
        Assert.Equal(64, s.GetCapacity())

module FixedQueueTests =
    [<Fact>]
    let ``初期状態は空``() =
        let q = FixedQueue<int>(64)
        Assert.True(q.IsEmpty())
        Assert.False(q.IsFull())

    [<Fact>]
    let ``enqueしてdeque``() =
        let q = FixedQueue<int>(64)
        q.Enque(1)
        Assert.Equal(1, q.Deque())

    [<Fact>]
    let ``複数enqueしてFIFO順にdeque``() =
        let q = FixedQueue<int>(64)
        q.Enque(1); q.Enque(2); q.Enque(3)
        Assert.Equal(1, q.Deque())
        Assert.Equal(2, q.Deque())
        Assert.Equal(3, q.Deque())

    [<Fact>]
    let ``peek``() =
        let q = FixedQueue<int>(64)
        q.Enque(10); q.Enque(20)
        Assert.Equal(10, q.Peek())

    [<Fact>]
    let ``満杯判定``() =
        let q = FixedQueue<int>(3)
        q.Enque(1); q.Enque(2); q.Enque(3)
        Assert.True(q.IsFull())

    [<Fact>]
    let ``空のdequeで例外``() =
        let q = FixedQueue<int>(64)
        Assert.Throws<QueueEmptyException>(fun () -> q.Deque() |> ignore) |> ignore

    [<Fact>]
    let ``満杯のenqueで例外``() =
        let q = FixedQueue<int>(2)
        q.Enque(1); q.Enque(2)
        Assert.Throws<QueueFullException>(fun () -> q.Enque(3)) |> ignore

    [<Fact>]
    let ``空のpeekで例外``() =
        let q = FixedQueue<int>(64)
        Assert.Throws<QueueEmptyException>(fun () -> q.Peek() |> ignore) |> ignore

    [<Fact>]
    let ``find``() =
        let q = FixedQueue<int>(64)
        q.Enque(10); q.Enque(20); q.Enque(30)
        Assert.Equal(0, q.Find(10))

    [<Fact>]
    let ``find_見つからない``() =
        let q = FixedQueue<int>(64)
        q.Enque(10)
        Assert.Equal(-1, q.Find(99))

    [<Fact>]
    let ``count``() =
        let q = FixedQueue<int>(64)
        q.Enque(5); q.Enque(5); q.Enque(10)
        Assert.Equal(2, q.Count(5))

    [<Fact>]
    let ``contains``() =
        let q = FixedQueue<int>(64)
        q.Enque(42)
        Assert.True(q.Contains(42))
        Assert.False(q.Contains(0))

    [<Fact>]
    let ``clear``() =
        let q = FixedQueue<int>(64)
        q.Enque(1); q.Enque(2); q.Clear()
        Assert.True(q.IsEmpty())

    [<Fact>]
    let ``size``() =
        let q = FixedQueue<int>(64)
        q.Enque(1); q.Enque(2)
        Assert.Equal(2, q.Size())

    [<Fact>]
    let ``capacity``() =
        let q = FixedQueue<int>(64)
        Assert.Equal(64, q.GetCapacity())

    [<Fact>]
    let ``リングバッファの折り返し``() =
        let q = FixedQueue<int>(3)
        q.Enque(1); q.Enque(2); q.Enque(3)
        q.Deque() |> ignore
        q.Enque(4)
        Assert.Equal(2, q.Deque())
        Assert.Equal(3, q.Deque())
        Assert.Equal(4, q.Deque())
