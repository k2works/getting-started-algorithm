# 第 8 章 リスト

## はじめに

この章では 3 種類の連結リストを F# で実装します。F# の型システムの制約（ネスト型・例外はモジュールレベル）に対応した実装を学びます。

---

## 1. 単方向連結リスト

各ノードが次のノードへのポインタを持つ線形構造です。

### 例外とノード型の定義

```fsharp
// F# では例外とネスト型はモジュールレベルに定義する
exception SinglyListEmptyException of string

[<AllowNullLiteral>]
type private SNode<'T>(data: 'T, next: SNode<'T>) =
    let mutable _next = next
    member _.Data = data
    member _.Next with get() = _next and set v = _next <- v
```

`[<AllowNullLiteral>]` 属性により、F# の参照型を `null` に設定できます。

### リストの実装

```fsharp
type SinglyLinkedList<'T when 'T : equality>() =
    let mutable head: SNode<'T> = null
    let mutable size = 0

    member _.AddFirst(data: 'T) =
        head <- SNode<'T>(data, head)
        size <- size + 1

    member _.AddLast(data: 'T) =
        if head = null then head <- SNode<'T>(data, null)
        else
            let mutable ptr = head
            while ptr.Next <> null do ptr <- ptr.Next
            ptr.Next <- SNode<'T>(data, null)
        size <- size + 1

    member _.ToList() =
        let result = System.Collections.Generic.List<'T>()
        let mutable ptr = head
        while ptr <> null do
            result.Add(ptr.Data)
            ptr <- ptr.Next
        result |> Seq.toList
```

`ToList()` の戻り値は F# の `int list` 型です。

---

## 2. 双方向連結リスト（番兵ノード使用）

各ノードが前後のポインタを持ちます。番兵ノードで境界処理を簡略化します。

```fsharp
[<AllowNullLiteral>]
type private DNode<'T>(data: 'T) =
    let mutable _prev: DNode<'T> = null
    let mutable _next: DNode<'T> = null
    member _.Data = data
    member _.Prev with get() = _prev and set v = _prev <- v
    member _.Next with get() = _next and set v = _next <- v

type DoublyLinkedList<'T when 'T : equality>() =
    let sentinel = DNode<'T>(Unchecked.defaultof<'T>)
    do
        sentinel.Prev <- sentinel
        sentinel.Next <- sentinel

    member _.AddLast(data: 'T) =
        let node = DNode<'T>(data)
        node.Prev <- sentinel.Prev
        node.Next <- sentinel
        sentinel.Prev.Next <- node
        sentinel.Prev <- node
```

番兵ノードを使うことで、先頭・末尾の特殊処理が不要になります。

---

## 3. 配列による連結リスト（カーソル版）

配列で連結リストを実装します。削除済みスロットを再利用します。

```fsharp
type ArrayLinkedList(capacity: int) =
    let ``null`` = -1
    let data  = Array.zeroCreate<int> capacity
    let next  = Array.create capacity ``null``
    let dnext = Array.create capacity ``null``  // 削除リスト

    let mutable head    = ``null``
    let mutable maxUsed = ``null``
    let mutable deleted = ``null``
```

バッククォートで囲む `` ``null`` `` は F# で予約語と同名の識別子を使う構文です。

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 35、スキップ: 0、合計: 35
```

## まとめ

| データ構造 | F# の実装手法 | 特徴 |
|-----------|-------------|------|
| 単方向リスト | `[<AllowNullLiteral>]` + `mutable` | シンプルな線形構造 |
| 双方向リスト | 番兵ノード + 双方向参照 | 挿入・削除が O(1) |
| 配列カーソル版 | 整数インデックスで Next を管理 | 削除スロットの再利用 |
