module LinkedLists

// ─── 単方向連結リスト ───────────────────────────────────────────

exception SinglyListEmptyException of string

[<AllowNullLiteral>]
type private SNode<'T>(data: 'T, next: SNode<'T>) =
    let mutable _next = next
    member _.Data = data
    member _.Next with get() = _next and set v = _next <- v

type SinglyLinkedList<'T when 'T : equality>() =
    let mutable head: SNode<'T> = null
    let mutable size = 0

    member _.Size() = size
    member _.IsEmpty() = head = null

    member _.Contains(data: 'T) =
        let mutable ptr = head
        let mutable found = false
        while ptr <> null && not found do
            if ptr.Data = data then found <- true
            else ptr <- ptr.Next
        found

    member _.AddFirst(data: 'T) =
        head <- SNode<'T>(data, head)
        size <- size + 1

    member _.AddLast(data: 'T) =
        if head = null then
            head <- SNode<'T>(data, null)
        else
            let mutable ptr = head
            while ptr.Next <> null do
                ptr <- ptr.Next
            ptr.Next <- SNode<'T>(data, null)
        size <- size + 1

    member _.RemoveFirst() =
        if head = null then raise (SinglyListEmptyException "リストは空です")
        head <- head.Next
        size <- size - 1

    member _.RemoveLast() =
        if head = null then raise (SinglyListEmptyException "リストは空です")
        if head.Next = null then
            head <- null
        else
            let mutable ptr = head
            while ptr.Next.Next <> null do
                ptr <- ptr.Next
            ptr.Next <- null
        size <- size - 1

    member _.Remove(data: 'T) =
        if head = null then false
        elif head.Data = data then
            head <- head.Next
            size <- size - 1
            true
        else
            let mutable ptr = head
            let mutable found = false
            while ptr.Next <> null && not found do
                if ptr.Next.Data = data then
                    ptr.Next <- ptr.Next.Next
                    size <- size - 1
                    found <- true
                else
                    ptr <- ptr.Next
            found

    member _.Clear() =
        head <- null
        size <- 0

    member _.ToList() =
        let result = System.Collections.Generic.List<'T>()
        let mutable ptr = head
        while ptr <> null do
            result.Add(ptr.Data)
            ptr <- ptr.Next
        result |> Seq.toList

// ─── 双方向連結リスト ───────────────────────────────────────────

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

    let mutable size = 0

    member _.Size() = size
    member _.IsEmpty() = size = 0

    member _.Contains(data: 'T) =
        let mutable ptr = sentinel.Next
        let mutable found = false
        while ptr <> sentinel && not found do
            if ptr.Data = data then found <- true
            else ptr <- ptr.Next
        found

    member _.AddFirst(data: 'T) =
        let node = DNode<'T>(data)
        node.Prev <- sentinel
        node.Next <- sentinel.Next
        sentinel.Next.Prev <- node
        sentinel.Next <- node
        size <- size + 1

    member _.AddLast(data: 'T) =
        let node = DNode<'T>(data)
        node.Prev <- sentinel.Prev
        node.Next <- sentinel
        sentinel.Prev.Next <- node
        sentinel.Prev <- node
        size <- size + 1

    member _.Remove(data: 'T) =
        if size = 0 then false
        else
            let mutable ptr = sentinel.Next
            let mutable found = false
            while ptr <> sentinel && not found do
                if ptr.Data = data then
                    ptr.Prev.Next <- ptr.Next
                    ptr.Next.Prev <- ptr.Prev
                    size <- size - 1
                    found <- true
                else
                    ptr <- ptr.Next
            found

    member _.Clear() =
        sentinel.Prev <- sentinel
        sentinel.Next <- sentinel
        size <- 0

    member _.ToList() =
        let result = System.Collections.Generic.List<'T>()
        let mutable ptr = sentinel.Next
        while ptr <> sentinel do
            result.Add(ptr.Data)
            ptr <- ptr.Next
        result |> Seq.toList

// ─── 配列による連結リスト ─────────────────────────────────────

type ArrayLinkedList(capacity: int) =
    let ``null`` = -1

    let data  = Array.zeroCreate<int> capacity
    let next  = Array.create capacity ``null``
    let dnext = Array.create capacity ``null``

    let mutable head    = ``null``
    let mutable maxUsed = ``null``
    let mutable deleted = ``null``
    let mutable size    = 0

    let getInsertIndex () =
        if deleted = ``null`` then
            if maxUsed + 1 < capacity then
                maxUsed <- maxUsed + 1
                maxUsed
            else ``null``
        else
            let rec' = deleted
            deleted <- dnext.[rec']
            rec'

    member _.Size() = size

    member _.GetHeadData() =
        if head = ``null`` then raise (System.IndexOutOfRangeException "empty")
        data.[head]

    member _.AddFirst(value: int) =
        let ptr = head
        let rec' = getInsertIndex ()
        if rec' <> ``null`` then
            head <- rec'
            data.[head] <- value
            next.[head] <- ptr
            dnext.[head] <- ``null``
            size <- size + 1

    member this.AddLast(value: int) =
        if head = ``null`` then this.AddFirst(value)
        else
            let mutable ptr = head
            while next.[ptr] <> ``null`` do
                ptr <- next.[ptr]
            let rec' = getInsertIndex ()
            if rec' <> ``null`` then
                next.[ptr] <- rec'
                data.[rec'] <- value
                next.[rec'] <- ``null``
                dnext.[rec'] <- ``null``
                size <- size + 1

    member _.Search(value: int) =
        let mutable ptr = head
        let mutable result = ``null``
        while ptr <> ``null`` && result = ``null`` do
            if data.[ptr] = value then result <- ptr
            else ptr <- next.[ptr]
        result

    member _.RemoveFirst() =
        if head <> ``null`` then
            let ptr = head
            head <- next.[ptr]
            dnext.[ptr] <- deleted
            deleted <- ptr
            size <- size - 1
