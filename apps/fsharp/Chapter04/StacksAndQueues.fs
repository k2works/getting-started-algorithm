module StacksAndQueues

exception StackEmptyException of string
exception StackFullException of string
exception QueueEmptyException of string
exception QueueFullException of string

/// 固定長スタック
type FixedStack<'T when 'T : equality>(capacity: int) =
    let stk = Array.zeroCreate<obj> capacity
    let mutable ptr = 0

    member _.IsEmpty() = ptr <= 0
    member _.IsFull() = ptr >= capacity
    member _.Size() = ptr
    member _.GetCapacity() = capacity

    member _.Push(value: 'T) =
        if ptr >= capacity then raise (StackFullException "スタックは満杯です")
        stk.[ptr] <- box value
        ptr <- ptr + 1

    member _.Pop() : 'T =
        if ptr <= 0 then raise (StackEmptyException "スタックは空です")
        ptr <- ptr - 1
        unbox stk.[ptr]

    member _.Peek() : 'T =
        if ptr <= 0 then raise (StackEmptyException "スタックは空です")
        unbox stk.[ptr - 1]

    member _.Find(value: 'T) =
        let mutable result = -1
        let mutable i = ptr - 1
        while i >= 0 && result = -1 do
            if unbox<'T> stk.[i] = value then result <- i
            i <- i - 1
        result

    member this.Contains(value: 'T) = this.Find(value) <> -1

    member _.Count(value: 'T) =
        let mutable c = 0
        for i in 0..ptr-1 do
            if unbox<'T> stk.[i] = value then c <- c + 1
        c

    member _.Clear() = ptr <- 0

/// 固定長キュー（リングバッファ）
type FixedQueue<'T when 'T : equality>(capacity: int) =
    let que = Array.zeroCreate<obj> capacity
    let mutable front = 0
    let mutable rear = 0
    let mutable num = 0

    member _.IsEmpty() = num <= 0
    member _.IsFull() = num >= capacity
    member _.Size() = num
    member _.GetCapacity() = capacity

    member _.Enque(value: 'T) =
        if num >= capacity then raise (QueueFullException "キューは満杯です")
        que.[rear] <- box value
        rear <- (rear + 1) % capacity
        num <- num + 1

    member _.Deque() : 'T =
        if num <= 0 then raise (QueueEmptyException "キューは空です")
        let value = unbox<'T> que.[front]
        front <- (front + 1) % capacity
        num <- num - 1
        value

    member _.Peek() : 'T =
        if num <= 0 then raise (QueueEmptyException "キューは空です")
        unbox<'T> que.[front]

    member _.Find(value: 'T) =
        let mutable result = -1
        for i in 0..num-1 do
            let idx = (i + front) % capacity
            if unbox<'T> que.[idx] = value && result = -1 then result <- i
        result

    member this.Contains(value: 'T) = this.Find(value) <> -1

    member _.Count(value: 'T) =
        let mutable c = 0
        for i in 0..num-1 do
            let idx = (i + front) % capacity
            if unbox<'T> que.[idx] = value then c <- c + 1
        c

    member _.Clear() =
        front <- 0; rear <- 0; num <- 0
