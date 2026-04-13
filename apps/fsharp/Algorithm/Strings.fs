module Strings

open System
open System.Collections.Generic

/// ブルートフォース文字列探索
let bfMatch (txt: string) (pat: string) =
    let n = txt.Length
    let m = pat.Length
    if m = 0 then 0
    else
        let mutable result = -1
        let mutable i = 0
        while i <= n - m && result = -1 do
            let mutable j = 0
            while j < m && txt.[i + j] = pat.[j] do
                j <- j + 1
            if j = m then result <- i
            i <- i + 1
        result

/// KMP 文字列探索
let kmpMatch (txt: string) (pat: string) =
    let n = txt.Length
    let m = pat.Length
    if m = 0 then 0
    else
        // KMP テーブル構築
        let table = Array.zeroCreate m
        let mutable k = 0
        for i in 1..m-1 do
            while k > 0 && pat.[k] <> pat.[i] do
                k <- table.[k - 1]
            if pat.[k] = pat.[i] then k <- k + 1
            table.[i] <- k
        // 探索
        let mutable j = 0
        let mutable result = -1
        let mutable i = 0
        while i < n && result = -1 do
            while j > 0 && txt.[i] <> pat.[j] do
                j <- table.[j - 1]
            if txt.[i] = pat.[j] then j <- j + 1
            if j = m then result <- i - m + 1
            i <- i + 1
        result

/// BM 文字列探索（簡易版）
let bmMatch (txt: string) (pat: string) =
    let n = txt.Length
    let m = pat.Length
    if m = 0 then 0
    else
        let badChar = Dictionary<char, int>()
        for i in 0..m-1 do badChar.[pat.[i]] <- i
        let mutable s = 0
        let mutable result = -1
        while s <= n - m && result = -1 do
            let mutable j = m - 1
            while j >= 0 && pat.[j] = txt.[s + j] do
                j <- j - 1
            if j < 0 then result <- s
            else
                let bc = if badChar.ContainsKey(txt.[s + j]) then badChar.[txt.[s + j]] else -1
                let skip = max 1 (j - bc)
                s <- s + skip
        result

/// 文字の出現回数をカウントする
let countChars (s: string) =
    let result = Dictionary<char, int>()
    for c in s do
        let mutable count = 0
        result.TryGetValue(c, &count) |> ignore
        result.[c] <- count + 1
    result

/// 文字列を逆順にする
let reverseString (s: string) =
    let arr = s.ToCharArray()
    Array.Reverse(arr)
    new string(arr)

/// 回文判定
let isPalindrome (s: string) = s = reverseString s
