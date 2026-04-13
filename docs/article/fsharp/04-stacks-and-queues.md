# 第 4 章 スタックとキュー

## はじめに

スタックとキューは最も基本的なデータ構造です。F# のクラス型（`type`）と例外（`exception`）を使って実装します。

## スタックとキューとは

スタックとキューは、データを特定の順序で格納・取り出すための最も基本的なデータ構造です。

- **スタック（LIFO: Last In, First Out）**: 後から入れたものを最初に取り出す構造。皿を積み重ねるイメージ。関数呼び出し、式の評価、構文解析、バックトラッキング（深さ優先探索 DFS）などに使用されます。
- **キュー（FIFO: First In, First Out）**: 先に入れたものを最初に取り出す構造。行列に並ぶイメージ。タスクキュー、プロセススケジューリング、幅優先探索（BFS）などに使用されます。

主な操作：

| 操作 | スタック | キュー |
|------|---------|--------|
| 追加 | `Push` | `Enque` |
| 取り出し | `Pop` | `Deque` |
| 参照（先頭） | `Peek` | `Peek` |

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

## スタックとキューの比較

| 項目 | スタック | キュー |
|------|---------|--------|
| 取り出し順序 | LIFO（後入れ先出し） | FIFO（先入れ先出し） |
| 追加操作 | `Push` | `Enque` |
| 取り出し操作 | `Pop` | `Deque` |
| 主な用途 | 関数呼び出し、DFS | タスクキュー、BFS |
| 計算量（追加/取り出し） | O(1) | O(1) |

## まとめ

この章では、2 つの基本的なデータ構造をスタックとキューを F# で実装しました：

| データ構造 | 操作 | 計算量（平均） | 計算量（最悪） | F# の特徴 |
|-----------|------|-------------|-------------|-----------|
| スタック | Push/Pop/Peek | O(1) | O(1) | `exception` + ジェネリック型 `'T` |
| キュー | Enque/Deque/Peek | O(1) | O(1) | リングバッファで効率的な FIFO |

1. **スタック**: 後入れ先出し（LIFO）の原則に従うデータ構造。F# の `exception` で型安全なエラーハンドリングを実現。
2. **キュー**: 先入れ先出し（FIFO）の原則に従うデータ構造。リングバッファにより配列の物理的な末尾から先頭へ折り返し可能。

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
