# 第 9 章 木構造

## はじめに

この章では二分探索木（BST）を F# で実装します。再帰的な走査（前順・中順・後順）も実装します。

---

## 1. 二分探索木

各ノードのキーが「左部分木のキーより大きく、右部分木のキーより小さい」性質を持つ木です。

### ノード型の定義

```fsharp
exception BSTEmptyException of string

[<AllowNullLiteral>]
type private BSTNode<'T>(key: 'T) =
    let mutable _key = key
    let mutable _left: BSTNode<'T> = null
    let mutable _right: BSTNode<'T> = null
    member _.Key with get() = _key and set v = _key <- v
    member _.Left with get() = _left and set v = _left <- v
    member _.Right with get() = _right and set v = _right <- v
```

### 挿入（Insert）

```fsharp
type BinarySearchTree<'T when 'T : comparison>() =
    let mutable root: BSTNode<'T> = null
    let mutable size = 0

    member _.Insert(key: 'T) =
        if root = null then
            root <- BSTNode<'T>(key); size <- size + 1
        else
            let mutable ptr = root
            let mutable inserted = false
            while not inserted do
                if key = ptr.Key then inserted <- true  // 重複は無視
                elif key < ptr.Key then
                    if ptr.Left = null then
                        ptr.Left <- BSTNode<'T>(key); size <- size + 1; inserted <- true
                    else ptr <- ptr.Left
                else
                    if ptr.Right = null then
                        ptr.Right <- BSTNode<'T>(key); size <- size + 1; inserted <- true
                    else ptr <- ptr.Right
```

`'T when 'T : comparison` は大小比較が可能な型制約です。

---

## 2. 走査（Traversal）

### 中順走査（In-Order）— 昇順出力

```fsharp
member _.InOrder() =
    let result = System.Collections.Generic.List<'T>()
    let rec traverse (n: BSTNode<'T>) =
        if n <> null then
            traverse n.Left
            result.Add(n.Key)   // 左 → 自分 → 右
            traverse n.Right
    traverse root
    result |> Seq.toList
```

中順走査の結果は常に昇順になります。

### 前順走査（Pre-Order）

```fsharp
    let rec traverse (n: BSTNode<'T>) =
        if n <> null then
            result.Add(n.Key)   // 自分 → 左 → 右
            traverse n.Left
            traverse n.Right
```

### 後順走査（Post-Order）

```fsharp
    let rec traverse (n: BSTNode<'T>) =
        if n <> null then
            traverse n.Left
            traverse n.Right
            result.Add(n.Key)   // 左 → 右 → 自分
```

---

## 3. 削除（Delete）

削除は 3 つのケースに分けて処理します：

1. **葉ノード**（子なし）: 単純に削除
2. **子が 1 つ**: 子を親に繋げる
3. **子が 2 つ**: 中順後継（右部分木の最小値）で置き換える

```fsharp
member this.Delete(key: 'T) =
    // キーを探索
    let mutable parent: BSTNode<'T> = null
    let mutable ptr = root
    let mutable isLeft = false
    // ... 探索ループ

    // 3 ケースで削除
    if ptr.Left = null && ptr.Right = null then replace null
    elif ptr.Right = null then replace ptr.Left
    elif ptr.Left = null then replace ptr.Right
    else
        // 中順後継で置き換え
        let mutable succParent = ptr
        let mutable succ = ptr.Right
        while succ.Left <> null do
            succParent <- succ; succ <- succ.Left
        ptr.Key <- succ.Key
        // 後継ノードを削除
```

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 23、スキップ: 0、合計: 23
```

## まとめ

| 操作 | 平均計算量 | 最悪計算量 |
|------|-----------|-----------|
| 探索 | O(log n) | O(n) |
| 挿入 | O(log n) | O(n) |
| 削除 | O(log n) | O(n) |
| 中順走査 | O(n) | O(n) |

最悪計算量が O(n) になるのは木が偏った場合（挿入がソート済みデータの場合）です。AVL 木や赤黒木で O(log n) を保証できます。
