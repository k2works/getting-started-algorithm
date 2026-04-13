module SearchAlgorithms

/// 線形探索（while 相当）
let linearSearchWhile (a: int[]) key =
    let mutable i = 0
    let mutable result = -1
    while i < a.Length && result = -1 do
        if a.[i] = key then result <- i
        else i <- i + 1
    result

/// 線形探索（for 相当）
let linearSearchFor (a: int[]) key =
    let mutable result = -1
    for i in 0..a.Length-1 do
        if a.[i] = key && result = -1 then result <- i
    result

/// 線形探索（番兵法）
let linearSearchSentinel (a: int[]) key =
    let b = Array.append a [|key|]
    let mutable i = 0
    while b.[i] <> key do
        i <- i + 1
    if i = a.Length then -1 else i

/// 二分探索
let binarySearch (a: int[]) key =
    let mutable pl = 0
    let mutable pr = a.Length - 1
    let mutable result = -1
    while pl <= pr && result = -1 do
        let pc = (pl + pr) / 2
        if a.[pc] = key then result <- pc
        elif a.[pc] < key then pl <- pc + 1
        else pr <- pc - 1
    result

/// チェイン法ハッシュテーブル
type private ChainNode(key: int, value: string, next: ChainNode option) =
    member _.Key = key
    member _.Value = value
    member _.Next = next

type ChainedHash(capacity: int) =
    let table: ChainNode option array = Array.create capacity None

    let hashValue key = key % capacity

    member _.Search(key: int) : string option =
        let mutable p = table.[hashValue key]
        let mutable result = None
        while p.IsSome && result.IsNone do
            let node = p.Value
            if node.Key = key then result <- Some node.Value
            else p <- node.Next
        result

    member this.Add(key: int, value: string) : bool =
        if this.Search(key).IsSome then false
        else
            let h = hashValue key
            table.[h] <- Some(ChainNode(key, value, table.[h]))
            true

    member _.Remove(key: int) : bool =
        let h = hashValue key
        let mutable p = table.[h]
        let mutable pp: ChainNode option = None
        let mutable removed = false
        while p.IsSome && not removed do
            let node = p.Value
            if node.Key = key then
                match pp with
                | None -> table.[h] <- node.Next
                | Some prev -> table.[h] <- Some(ChainNode(prev.Key, prev.Value, node.Next))
                removed <- true
            else
                pp <- p
                p <- node.Next
        removed

/// オープンアドレス法ハッシュテーブル
type private BucketStatus = Occupied | Empty | Deleted

type private Bucket() =
    member val Key = 0 with get, set
    member val Value = "" with get, set
    member val Stat = Empty with get, set

type OpenHash(capacity: int) =
    let table = Array.init capacity (fun _ -> Bucket())

    let hashValue key = key % capacity

    member _.Search(key: int) : string option =
        let mutable h = hashValue key
        let mutable result = None
        let mutable i = 0
        while i < capacity && result.IsNone do
            let p = table.[h]
            if p.Stat = Empty then i <- capacity
            elif p.Stat = Occupied && p.Key = key then result <- Some p.Value
            else
                h <- (h + 1) % capacity
                i <- i + 1
        result

    member this.Add(key: int, value: string) : bool =
        if this.Search(key).IsSome then false
        else
            let mutable h = hashValue key
            let mutable added = false
            let mutable i = 0
            while i < capacity && not added do
                let p = table.[h]
                if p.Stat = Empty || p.Stat = Deleted then
                    p.Key <- key
                    p.Value <- value
                    p.Stat <- Occupied
                    added <- true
                else
                    h <- (h + 1) % capacity
                    i <- i + 1
            added

    member _.Remove(key: int) : bool =
        let mutable h = hashValue key
        let mutable removed = false
        let mutable i = 0
        while i < capacity && not removed do
            let p = table.[h]
            if p.Stat = Empty then i <- capacity
            elif p.Stat = Occupied && p.Key = key then
                p.Stat <- Deleted
                removed <- true
            else
                h <- (h + 1) % capacity
                i <- i + 1
        removed
