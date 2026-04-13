# 第 4 章 スタックとキュー

## はじめに

スタックとキューは最も基本的なデータ構造です。F# のクラス型（`type`）と例外（`exception`）を使って実装します。

---

## 1. スタック

LIFO（Last In, First Out）構造。push で積み、pop で取り出します。

### 例外の定義

```fsharp
exception StackEmptyException of string
exception StackFullException of string
```

F# の `exception` はモジュールレベルで定義します。

### 実装

```fsharp
type FixedStack<'T when 'T : equality>(capacity: int) =
    let stk = Array.zeroCreate<'T> capacity
    let mutable ptr = 0

    member _.Size() = ptr
    member _.IsEmpty() = ptr = 0
    member _.IsFull() = ptr = capacity

    member _.Push(value: 'T) =
        if ptr = capacity then raise (StackFullException "スタックは満杯です")
        stk.[ptr] <- value
        ptr <- ptr + 1

    member _.Pop() =
        if ptr = 0 then raise (StackEmptyException "スタックは空です")
        ptr <- ptr - 1
        stk.[ptr]

    member _.Peek() =
        if ptr = 0 then raise (StackEmptyException "スタックは空です")
        stk.[ptr - 1]
```

`'T` は F# のジェネリック型パラメータです。`when 'T : equality` は等値比較可能な型制約です。

### テスト例

```fsharp
[<Fact>]
let ``Push して Pop``() =
    let s = FixedStack<int>(5)
    s.Push(1); s.Push(2)
    Assert.Equal(2, s.Pop())
    Assert.Equal(1, s.Pop())

[<Fact>]
let ``空の Pop で例外``() =
    let s = FixedStack<int>(5)
    Assert.Throws<StackEmptyException>(fun () -> s.Pop() |> ignore) |> ignore
```

---

## 2. キュー

FIFO（First In, First Out）構造。リングバッファで実装します。

```fsharp
type FixedQueue<'T when 'T : equality>(capacity: int) =
    let que = Array.zeroCreate<'T> capacity
    let mutable num = 0   // 要素数
    let mutable front = 0 // 先頭インデックス
    let mutable rear = 0  // 末尾インデックス

    member _.Size() = num
    member _.IsEmpty() = num = 0
    member _.IsFull() = num = capacity

    member _.Enqueue(value: 'T) =
        if num = capacity then raise (QueueFullException "キューは満杯です")
        que.[rear] <- value
        rear <- (rear + 1) % capacity
        num <- num + 1

    member _.Dequeue() =
        if num = 0 then raise (QueueEmptyException "キューは空です")
        let value = que.[front]
        front <- (front + 1) % capacity
        num <- num - 1
        value
```

リングバッファでは `% capacity` によって配列の末尾から先頭に折り返します。

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 31、スキップ: 0、合計: 31
```

## まとめ

| データ構造 | 操作 | 時間計算量 | F# の特徴 |
|-----------|------|-----------|-----------|
| スタック | push/pop/peek | O(1) | `exception` + ジェネリック型 `'T` |
| キュー | enqueue/dequeue | O(1) | リングバッファで効率的な FIFO |
