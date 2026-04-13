module Arrays

open System
open System.Text

/// 配列の最大値を返す
let maxOf (a: int[]) =
    let mutable maximum = a.[0]
    for i in 1..a.Length-1 do
        if a.[i] > maximum then maximum <- a.[i]
    maximum

/// 配列を逆順にする（破壊的）
let reverseArray (a: int[]) =
    let n = a.Length
    for i in 0..n/2-1 do
        let tmp = a.[i]
        a.[i] <- a.[n - i - 1]
        a.[n - i - 1] <- tmp

/// 基数変換（x を r 進数の文字列に変換）
let cardConv x r =
    let dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let sb = StringBuilder()
    let mutable v = x
    while v > 0 do
        sb.Append(dchar.[v % r]) |> ignore
        v <- v / r
    let arr = sb.ToString().ToCharArray()
    Array.Reverse(arr)
    new string(arr)

/// 素数列挙第1版（2〜x の除算回数を返す）
let prime1 x =
    let mutable counter = 0
    for n in 2..x do
        let mutable i = 2
        while i < n do
            counter <- counter + 1
            if n % i = 0 then i <- n
            else i <- i + 1
    counter

/// 素数列挙第2版（既知の素数を利用）
let prime2 x =
    let mutable counter = 0
    let mutable ptr = 0
    let prime = Array.zeroCreate<int> 500
    prime.[ptr] <- 2
    ptr <- ptr + 1
    let mutable n = 3
    while n <= x do
        let mutable i = 1
        let mutable found = false
        while i < ptr && not found do
            counter <- counter + 1
            if n % prime.[i] = 0 then found <- true
            else i <- i + 1
        if not found then
            prime.[ptr] <- n
            ptr <- ptr + 1
        n <- n + 2
    counter

/// 素数列挙第3版（平方根まで割り算）
let prime3 x =
    let mutable counter = 0
    let mutable ptr = 0
    let prime = Array.zeroCreate<int> 500
    prime.[ptr] <- 2; ptr <- ptr + 1
    prime.[ptr] <- 3; ptr <- ptr + 1
    let mutable n = 5
    while n <= x do
        let mutable isPrime = true
        let mutable i = 1
        while prime.[i] * prime.[i] <= n && isPrime do
            counter <- counter + 2
            if n % prime.[i] = 0 then isPrime <- false
            else i <- i + 1
        if isPrime then
            prime.[ptr] <- n
            ptr <- ptr + 1
            counter <- counter + 1
        n <- n + 2
    counter
