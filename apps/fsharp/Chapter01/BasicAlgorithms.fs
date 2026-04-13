module BasicAlgorithms

open System.Text

/// 3つの整数値の最大値を返す
let max3 a b c =
    let mutable maximum = a
    if b > maximum then maximum <- b
    if c > maximum then maximum <- c
    maximum

/// 3つの整数値の中央値を返す
let med3 a b c =
    if a >= b then
        if b >= c then b
        elif a <= c then a
        else c
    elif a > c then a
    elif b > c then c
    else b

/// 整数値の符号を判定する
let judgeSign n =
    if n > 0 then "その値は正です。"
    elif n < 0 then "その値は負です。"
    else "その値は0です。"

/// while 相当で 1 から n までの総和を求める
let sum1ToNWhile n =
    let mutable total = 0
    let mutable i = 1
    while i <= n do
        total <- total + i
        i <- i + 1
    total

/// for 相当で 1 から n までの総和を求める
let sum1ToNFor n =
    let mutable total = 0
    for i in 1..n do
        total <- total + i
    total

/// 記号文字 '+' と '-' を交互に表示する（剰余判定方式）
let alternative1 n =
    let sb = StringBuilder()
    for i in 0..n-1 do
        sb.Append(if i % 2 <> 0 then '-' else '+') |> ignore
    sb.ToString()

/// 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）
let alternative2 n =
    let sb = StringBuilder()
    for _ in 1..n/2 do
        sb.Append("+-") |> ignore
    if n % 2 <> 0 then sb.Append('+') |> ignore
    sb.ToString()

/// 縦横が整数で面積が area の長方形の辺の長さを列挙する
let rectangle area =
    let sb = StringBuilder()
    let mutable i = 1
    while i * i <= area do
        if area % i = 0 then
            sb.Append(sprintf "%dx%d " i (area / i)) |> ignore
        i <- i + 1
    sb.ToString()

/// 九九の表を返す
let multiplicationTable () =
    let sb = StringBuilder()
    sb.AppendLine(String.replicate 27 "-") |> ignore
    for i in 1..9 do
        for j in 1..9 do
            sb.Append(sprintf "%3d" (i * j)) |> ignore
        sb.AppendLine() |> ignore
    sb.Append(String.replicate 27 "-") |> ignore
    sb.ToString()

/// 左下側が直角の二等辺三角形を返す
let triangleLb n =
    let sb = StringBuilder()
    for i in 0..n-1 do
        sb.AppendLine(String.replicate (i + 1) "*") |> ignore
    sb.ToString()
