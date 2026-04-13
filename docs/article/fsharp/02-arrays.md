# 第 2 章 配列

## はじめに

この章では F# の配列（`int[]`）を使ったアルゴリズムを TDD で実装します。F# の配列は .NET の `System.Array` と同一で、`[| ... |]` 構文で生成します。

## 配列とは

配列とは、同じ型のデータを連続して格納するためのデータ構造で、多くのアルゴリズムの基礎となります。

F# では配列に関連するデータ構造として主に以下の 2 つがあります：

- **配列**（`int[]`）: .NET の `System.Array` と同一。固定長で要素の変更が可能。`[| 1; 2; 3 |]` 構文で生成。インデックスアクセスは `a.[i]`。
- **リスト**（`int list`）: F# 固有の不変な単方向連結リスト。`[1; 2; 3]` 構文で生成。先頭への追加が O(1) だが、ランダムアクセスは O(n)。

配列はランダムアクセスが O(1) で高速、リストは不変性を活かした関数型プログラミングに適しています。

---

## 1. 配列の最大値

### Red — テストを書く

```fsharp
module MaxOfTests =
    [<Fact>]
    let ``基本``() = Assert.Equal(9, maxOf [|3;1;4;1;5;9;2|])
    [<Fact>]
    let ``単一要素``() = Assert.Equal(42, maxOf [|42|])
```

### Green — 実装

```fsharp
/// 配列の最大値を返す
let maxOf (a: int[]) =
    let mutable max = a.[0]
    for i in 1..a.Length-1 do
        if a.[i] > max then max <- a.[i]
    max
```

F# の配列インデックスアクセスは `a.[i]` です（`.` が必要）。

---

## 2. 配列の逆順

### Green — 実装

```fsharp
open System

/// 配列を逆順にする（in-place）
let reverseArray (a: int[]) =
    let n = a.Length
    for i in 0..n/2-1 do
        let tmp = a.[i]
        a.[i] <- a.[n-1-i]
        a.[n-1-i] <- tmp
```

---

## 3. 基数変換

10 進数を任意の基数（2〜36 進数）に変換します。

### Green — 実装

```fsharp
/// 非負整数 x を基数 r の文字列に変換する
let cardConv x r =
    let digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if x = 0 then "0"
    else
        let sb = System.Text.StringBuilder()
        let mutable n = x
        while n > 0 do
            sb.Append(digits.[n % r]) |> ignore
            n <- n / r
        new string(sb.ToString().ToCharArray() |> Array.rev)
```

---

## 4. 素数列挙

### 基本的な素数判定

```fsharp
/// n が素数かどうかを判定する（基本版）
let prime1 x =
    if x < 2 then false
    else
        let mutable i = 2
        let mutable isPrime = true
        while i < x && isPrime do
            if x % i = 0 then isPrime <- false
            i <- i + 1
        isPrime
```

### 改良版（√n まで試し割り）

```fsharp
/// n が素数かどうかを判定する（√n 版）
let prime2 x =
    if x < 2 then false
    elif x = 2 then true
    elif x % 2 = 0 then false
    else
        let mutable i = 3
        let mutable isPrime = true
        while i * i <= x && isPrime do
            if x % i = 0 then isPrime <- false
            i <- i + 2
        isPrime
```

### エラトステネスの篩

```fsharp
/// n 以下の素数一覧を返す（エラトステネスの篩）
let prime3 n =
    if n < 2 then [||]
    else
        let sieve = Array.create (n + 1) true
        sieve.[0] <- false
        sieve.[1] <- false
        let mutable i = 2
        while i * i <= n do
            if sieve.[i] then
                let mutable j = i * i
                while j <= n do
                    sieve.[j] <- false
                    j <- j + i
            i <- i + 1
        [| for k in 0..n do if sieve.[k] then yield k |]
```

F# のシーケンス式 `[| for k in ... do if ... then yield k |]` で配列をフィルタリングできます。

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 12、スキップ: 0、合計: 12
```

## まとめ

| アルゴリズム | 関数 | 計算量 | F# の特徴 |
|-------------|------|--------|-----------|
| 配列の最大値 | `maxOf` | O(n) | `a.[i]` のインデックスアクセス |
| 配列の逆順 | `reverseArray` | O(n) | in-place 操作と `mutable` |
| 基数変換 | `cardConv` | O(log x) | `StringBuilder` + `Array.rev` |
| 素数判定（基本） | `prime1` | O(n^2) | `while` ループと `mutable` フラグ |
| 素数判定（改良） | `prime2` | O(n sqrt(n)) | 試し割りの最適化 |
| 素数篩 | `prime3` | O(n sqrt(n) / log n) | シーケンス式 `[| for ... do |]` |

この章で学んだ内容：

1. F# の配列（`int[]`）とリスト（`int list`）の違い
2. 配列のインデックスアクセス（`a.[i]`）
3. 配列の走査と in-place 操作
4. 基数変換アルゴリズム
5. 素数列挙アルゴリズムとその改良

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
