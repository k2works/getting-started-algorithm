# 第 8 章 リスト

## はじめに

この章では 3 種類の連結リストを F# で実装します。F# の型システムの制約（ネスト型・例外はモジュールレベル）に対応した実装を学びます。

## 連結リストとは

連結リストとは、各要素（ノード）がデータと次の要素へのポインタ（参照）を持つデータ構造です。配列と異なり、メモリ上で連続している必要がありません。

**配列との違い：**

| 操作 | 配列 | 連結リスト |
|------|------|-----------|
| ランダムアクセス | O(1) | O(n) |
| 先頭への挿入 | O(n) | O(1) |
| 末尾への挿入 | O(1)（動的配列）| O(n)（単方向）/ O(1)（双方向） |
| 途中への挿入 | O(n) | O(1)（位置が既知の場合） |
| 削除 | O(n) | O(1)（位置が既知の場合） |
| メモリ | 連続領域が必要 | 動的に確保可能 |

連結リストは、頻繁な挿入・削除が必要な場合に適しています。一方、ランダムアクセスが多い場合は配列が有利です。

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

| データ構造 | 挿入（先頭） | 挿入（末尾） | 削除 | 検索 | F# の実装手法 |
|-----------|------------|------------|------|------|-------------|
| 単方向リスト | O(1) | O(n) | O(n) | O(n) | `[<AllowNullLiteral>]` + `mutable` |
| 双方向リスト | O(1) | O(1) | O(1) | O(n) | 番兵ノード + 双方向参照 |
| 配列カーソル版 | O(1) | O(n) | O(1) | O(n) | 整数インデックスで Next を管理 |

この章では、3 種類の連結リストを F# で実装しました：

1. **単方向連結リスト** -- 各ノードが次のノードへのポインタを持つシンプルな構造
2. **双方向連結リスト** -- 番兵ノードにより境界処理を簡略化し、先頭・末尾への挿入削除が O(1)
3. **配列カーソル版** -- ポインタの代わりに配列インデックスを使い、削除済みスロットを再利用

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
