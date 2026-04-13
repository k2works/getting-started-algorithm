module SortAlgorithms

open System.Collections.Generic

/// バブルソート
let bubbleSort (a: int[]) =
    let n = a.Length
    let mutable i = 0
    while i < n - 1 do
        let mutable swapped = false
        let mutable j = n - 1
        while j > i do
            if a.[j-1] > a.[j] then
                let tmp = a.[j-1]
                a.[j-1] <- a.[j]
                a.[j] <- tmp
                swapped <- true
            j <- j - 1
        if not swapped then i <- n
        else i <- i + 1

/// バブルソート第2版
let bubbleSort2 (a: int[]) =
    let n = a.Length
    let mutable k = 0
    while k < n - 1 do
        let mutable last = n - 1
        let mutable j = n - 1
        while j > k do
            if a.[j-1] > a.[j] then
                let tmp = a.[j-1]
                a.[j-1] <- a.[j]
                a.[j] <- tmp
                last <- j
            j <- j - 1
        k <- last

/// シェーカーソート
let shakerSort (a: int[]) =
    let mutable left = 0
    let mutable right = a.Length - 1
    let mutable last = right
    while left < right do
        let mutable j = right
        while j > left do
            if a.[j-1] > a.[j] then
                let tmp = a.[j-1]
                a.[j-1] <- a.[j]
                a.[j] <- tmp
                last <- j
            j <- j - 1
        left <- last
        let mutable k = left
        while k < right do
            if a.[k] > a.[k+1] then
                let tmp = a.[k]
                a.[k] <- a.[k+1]
                a.[k+1] <- tmp
                last <- k
            k <- k + 1
        right <- last

/// 選択ソート
let selectionSort (a: int[]) =
    let n = a.Length
    for i in 0..n-2 do
        let mutable minIdx = i
        for j in i+1..n-1 do
            if a.[j] < a.[minIdx] then minIdx <- j
        if minIdx <> i then
            let tmp = a.[i]
            a.[i] <- a.[minIdx]
            a.[minIdx] <- tmp

/// 挿入ソート
let insertionSort (a: int[]) =
    let n = a.Length
    for i in 1..n-1 do
        let key = a.[i]
        let mutable j = i - 1
        while j >= 0 && a.[j] > key do
            a.[j+1] <- a.[j]
            j <- j - 1
        a.[j+1] <- key

/// 二分挿入ソート
let binaryInsertionSort (a: int[]) =
    let n = a.Length
    for i in 1..n-1 do
        let key = a.[i]
        let mutable pl = 0
        let mutable pr = i - 1
        let mutable pc = 0
        while pl <= pr do
            pc <- (pl + pr) / 2
            if a.[pc] = key then pl <- pr + 1
            elif a.[pc] < key then pl <- pc + 1
            else pr <- pc - 1
        let insertPos = if pl > pr && a.[pc] <= key then pc + 1 else pl
        let mutable j = i - 1
        while j >= insertPos do
            a.[j+1] <- a.[j]
            j <- j - 1
        a.[insertPos] <- key

/// シェルソート
let shellSort (a: int[]) =
    let n = a.Length
    let mutable h = 1
    while h < n / 9 do
        h <- h * 3 + 1
    while h > 0 do
        for i in h..n-1 do
            let tmp = a.[i]
            let mutable j = i - h
            while j >= 0 && a.[j] > tmp do
                a.[j+h] <- a.[j]
                j <- j - h
            a.[j+h] <- tmp
        h <- h / 3

/// クイックソート（再帰）
let quickSort (a: int[]) =
    let rec sort left right =
        if left < right then
            let pivot = a.[(left + right) / 2]
            let mutable i = left
            let mutable j = right
            while i <= j do
                while a.[i] < pivot do i <- i + 1
                while a.[j] > pivot do j <- j - 1
                if i <= j then
                    let tmp = a.[i]
                    a.[i] <- a.[j]
                    a.[j] <- tmp
                    i <- i + 1
                    j <- j - 1
            sort left j
            sort i right
    if a.Length > 1 then sort 0 (a.Length - 1)

/// クイックソート（非再帰）
let quickSortNonRecursive (a: int[]) =
    if a.Length > 1 then
        let stack = Stack<int * int>()
        stack.Push((0, a.Length - 1))
        while stack.Count > 0 do
            let (left, right) = stack.Pop()
            if left < right then
                let pivot = a.[(left + right) / 2]
                let mutable i = left
                let mutable j = right
                while i <= j do
                    while a.[i] < pivot do i <- i + 1
                    while a.[j] > pivot do j <- j - 1
                    if i <= j then
                        let tmp = a.[i]
                        a.[i] <- a.[j]
                        a.[j] <- tmp
                        i <- i + 1
                        j <- j - 1
                if left < j then stack.Push((left, j))
                if i < right then stack.Push((i, right))

/// ソート済み配列のマージ
let mergeSortedArrays (a: int[]) (b: int[]) =
    let result = Array.zeroCreate (a.Length + b.Length)
    let mutable i = 0
    let mutable j = 0
    let mutable k = 0
    while i < a.Length && j < b.Length do
        if a.[i] <= b.[j] then
            result.[k] <- a.[i]
            i <- i + 1
        else
            result.[k] <- b.[j]
            j <- j + 1
        k <- k + 1
    while i < a.Length do
        result.[k] <- a.[i]
        i <- i + 1
        k <- k + 1
    while j < b.Length do
        result.[k] <- b.[j]
        j <- j + 1
        k <- k + 1
    result

/// マージソート
let rec mergeSort (a: int[]) =
    if a.Length <= 1 then Array.copy a
    else
        let mid = a.Length / 2
        let left = mergeSort a.[..mid-1]
        let right = mergeSort a.[mid..]
        mergeSortedArrays left right

/// ヒープソート
let private downHeap (a: int[]) left right =
    let temp = a.[left]
    let mutable parent = left
    let mutable cont = true
    while cont && parent < (right + 1) / 2 do
        let cl = parent * 2 + 1
        let cr = cl + 1
        let child = if cr <= right && a.[cr] > a.[cl] then cr else cl
        if temp >= a.[child] then cont <- false
        else
            a.[parent] <- a.[child]
            parent <- child
    a.[parent] <- temp

let heapSort (a: int[]) =
    let n = a.Length
    if n > 1 then
        for i in (n - 1) / 2 .. -1 .. 0 do
            downHeap a i (n - 1)
        for i in n-1 .. -1 .. 1 do
            let tmp = a.[0]
            a.[0] <- a.[i]
            a.[i] <- tmp
            downHeap a 0 (i - 1)

/// 度数ソート
let countingSort (a: int[]) =
    if a.Length = 0 then [||]
    else
        let maxVal = Array.max a
        let freq = Array.zeroCreate (maxVal + 1)
        for x in a do freq.[x] <- freq.[x] + 1
        for i in 1..freq.Length-1 do freq.[i] <- freq.[i] + freq.[i-1]
        let result = Array.zeroCreate a.Length
        for i in a.Length-1 .. -1 .. 0 do
            freq.[a.[i]] <- freq.[a.[i]] - 1
            result.[freq.[a.[i]]] <- a.[i]
        result
