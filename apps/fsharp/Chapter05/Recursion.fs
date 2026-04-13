module Recursion

/// 階乗
let rec factorial n =
    if n <= 0 then 1 else n * factorial (n - 1)

/// ユークリッドの互除法
let rec gcd x y =
    if y = 0 then x else gcd y (x % y)

/// 再帰による総和
let rec recursiveSum n =
    if n <= 0 then 0 else n + recursiveSum (n - 1)

/// ハノイの塔（手順リストを返す）
let hanoi n src dst via =
    let moves = System.Collections.Generic.List<string>()
    let rec helper n src dst via =
        if n = 1 then moves.Add(sprintf "%s->%s" src dst)
        else
            helper (n-1) src via dst
            moves.Add(sprintf "%s->%s" src dst)
            helper (n-1) via dst src
    helper n src dst via
    moves |> Seq.toList

/// 迷路探索
let mazeSolve (maze: int[][]) startRow startCol goalRow goalCol =
    let rows = maze.Length
    let cols = maze.[0].Length
    let visited = Array.init rows (fun _ -> Array.create cols false)
    let rec helper row col =
        if row = goalRow && col = goalCol then true
        else
            visited.[row].[col] <- true
            let dirs = [|(-1, 0); (1, 0); (0, -1); (0, 1)|]
            dirs |> Array.exists (fun (dr, dc) ->
                let nr = row + dr
                let nc = col + dc
                nr >= 0 && nr < rows && nc >= 0 && nc < cols
                && maze.[nr].[nc] = 0 && not visited.[nr].[nc]
                && helper nr nc)
    helper startRow startCol

/// 8クイーン（全組み合わせ）
type EightQueen() =
    let mutable count = 0
    let pos = Array.zeroCreate<int> 8

    member this.Set(i) =
        for j in 0..7 do
            pos.[i] <- j
            if i = 7 then count <- count + 1
            else this.Set(i + 1)

    member _.GetCount() = count

/// 8クイーン（行制約あり）
type EightQueen2() =
    let result = System.Collections.Generic.List<int[]>()
    let pos = Array.zeroCreate<int> 8
    let flag = Array.create 8 false

    member this.Set(i) =
        for j in 0..7 do
            if not flag.[j] then
                pos.[i] <- j
                if i = 7 then result.Add(Array.copy pos)
                else
                    flag.[j] <- true
                    this.Set(i + 1)
                    flag.[j] <- false

    member _.GetResult() = result |> Seq.toList

/// 8クイーン（完全解）
type EightQueen3() =
    let result = System.Collections.Generic.List<int[]>()
    let pos = Array.zeroCreate<int> 8
    let flagA = Array.create 8 false
    let flagB = Array.create 15 false
    let flagC = Array.create 15 false

    member this.Set(i) =
        for j in 0..7 do
            if not flagA.[j] && not flagB.[i+j] && not flagC.[i-j+7] then
                pos.[i] <- j
                if i = 7 then result.Add(Array.copy pos)
                else
                    flagA.[j] <- true
                    flagB.[i+j] <- true
                    flagC.[i-j+7] <- true
                    this.Set(i + 1)
                    flagA.[j] <- false
                    flagB.[i+j] <- false
                    flagC.[i-j+7] <- false

    member _.GetResult() = result |> Seq.toList
