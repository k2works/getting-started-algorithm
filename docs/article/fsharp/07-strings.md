# 第 7 章 文字列処理

## はじめに

この章では文字列探索アルゴリズム（BF/KMP/BM）と基本的な文字列操作を F# で実装します。

---

## 1. ブルートフォース（BF）文字列探索

テキスト内でパターンを先頭から順に照合します。

```fsharp
/// ブルートフォース文字列探索
/// 見つかれば先頭インデックス、なければ -1
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
```

---

## 2. KMP アルゴリズム

失敗関数（失敗テーブル）を事前計算し、照合失敗時のスキップ量を最大化します。

```fsharp
/// KMP 文字列探索
let kmpMatch (txt: string) (pat: string) =
    let n = txt.Length
    let m = pat.Length
    if m = 0 then 0
    else
        // 失敗テーブル構築
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
```

---

## 3. BM アルゴリズム（簡易版）

パターンを右から左に照合し、悪文字規則でスキップします。

```fsharp
/// BM 文字列探索（悪文字規則のみ）
let bmMatch (txt: string) (pat: string) =
    let n = txt.Length
    let m = pat.Length
    if m = 0 then 0
    else
        let badChar = System.Collections.Generic.Dictionary<char, int>()
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
                s <- s + max 1 (j - bc)
        result
```

---

## 4. 文字列操作

### 文字の出現回数カウント

```fsharp
/// 各文字の出現回数を Dictionary で返す
let countChars (s: string) =
    let result = System.Collections.Generic.Dictionary<char, int>()
    for c in s do
        let mutable count = 0
        result.TryGetValue(c, &count) |> ignore
        result.[c] <- count + 1
    result
```

### 回文判定

```fsharp
/// 文字列を逆順にする
let reverseString (s: string) =
    let arr = s.ToCharArray()
    System.Array.Reverse(arr)
    new string(arr)

/// 回文かどうかを判定する
let isPalindrome (s: string) = s = reverseString s
```

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 27、スキップ: 0、合計: 27
```

## まとめ

| アルゴリズム | 時間計算量 | 特徴 |
|-------------|-----------|------|
| BF 探索 | O(n×m) | シンプルだが低速 |
| KMP 探索 | O(n+m) | 失敗テーブルで高速化 |
| BM 探索 | 平均 O(n/m) | 実用的に最速 |
