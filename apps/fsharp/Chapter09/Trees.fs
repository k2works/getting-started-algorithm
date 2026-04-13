module Trees

// ─── 二分探索木 ────────────────────────────────────────────────

exception BSTEmptyException of string

[<AllowNullLiteral>]
type private BSTNode<'T>(key: 'T) =
    let mutable _key = key
    let mutable _left: BSTNode<'T> = null
    let mutable _right: BSTNode<'T> = null
    member _.Key with get() = _key and set v = _key <- v
    member _.Left with get() = _left and set v = _left <- v
    member _.Right with get() = _right and set v = _right <- v

type BinarySearchTree<'T when 'T : comparison>() =
    let mutable root: BSTNode<'T> = null
    let mutable size = 0

    member _.Size() = size
    member _.IsEmpty() = root = null

    member _.Contains(key: 'T) =
        let mutable ptr = root
        let mutable found = false
        while ptr <> null && not found do
            if key = ptr.Key then found <- true
            elif key < ptr.Key then ptr <- ptr.Left
            else ptr <- ptr.Right
        found

    member _.Insert(key: 'T) =
        if root = null then
            root <- BSTNode<'T>(key)
            size <- size + 1
        else
            let mutable ptr = root
            let mutable inserted = false
            while not inserted do
                if key = ptr.Key then
                    inserted <- true  // 重複は無視
                elif key < ptr.Key then
                    if ptr.Left = null then
                        ptr.Left <- BSTNode<'T>(key)
                        size <- size + 1
                        inserted <- true
                    else
                        ptr <- ptr.Left
                else
                    if ptr.Right = null then
                        ptr.Right <- BSTNode<'T>(key)
                        size <- size + 1
                        inserted <- true
                    else
                        ptr <- ptr.Right

    member this.Delete(key: 'T) =
        let mutable parent: BSTNode<'T> = null
        let mutable ptr = root
        let mutable isLeft = false
        let mutable found = false
        while ptr <> null && not found do
            if key = ptr.Key then found <- true
            else
                parent <- ptr
                if key < ptr.Key then
                    isLeft <- true
                    ptr <- ptr.Left
                else
                    isLeft <- false
                    ptr <- ptr.Right
        if ptr = null then ()
        else
            size <- size - 1
            let replace (n: BSTNode<'T>) =
                if parent = null then root <- n
                elif isLeft then parent.Left <- n
                else parent.Right <- n
            if ptr.Left = null && ptr.Right = null then
                replace null
            elif ptr.Right = null then
                replace ptr.Left
            elif ptr.Left = null then
                replace ptr.Right
            else
                // 中順後継（右部分木の最小値）を見つける
                let mutable succParent = ptr
                let mutable succ = ptr.Right
                while succ.Left <> null do
                    succParent <- succ
                    succ <- succ.Left
                ptr.Key <- succ.Key
                if succParent = ptr then succParent.Right <- succ.Right
                else succParent.Left <- succ.Right
                size <- size + 1

    member _.Min() =
        if root = null then raise (BSTEmptyException "木は空です")
        let mutable p = root
        while p.Left <> null do p <- p.Left
        p.Key

    member _.Max() =
        if root = null then raise (BSTEmptyException "木は空です")
        let mutable p = root
        while p.Right <> null do p <- p.Right
        p.Key

    member _.InOrder() =
        let result = System.Collections.Generic.List<'T>()
        let rec traverse (n: BSTNode<'T>) =
            if n <> null then
                traverse n.Left
                result.Add(n.Key)
                traverse n.Right
        traverse root
        result |> Seq.toList

    member _.PreOrder() =
        let result = System.Collections.Generic.List<'T>()
        let rec traverse (n: BSTNode<'T>) =
            if n <> null then
                result.Add(n.Key)
                traverse n.Left
                traverse n.Right
        traverse root
        result |> Seq.toList

    member _.PostOrder() =
        let result = System.Collections.Generic.List<'T>()
        let rec traverse (n: BSTNode<'T>) =
            if n <> null then
                traverse n.Left
                traverse n.Right
                result.Add(n.Key)
        traverse root
        result |> Seq.toList
