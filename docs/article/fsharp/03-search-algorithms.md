# 第 3 章 探索アルゴリズム

## はじめに

この章では、線形探索・二分探索・ハッシュ法の 3 つの探索アルゴリズムを F# で実装します。ハッシュ法では F# のクラス型（`type`）を使ったオブジェクト指向スタイルも学びます。

---

## 1. 線形探索

配列を先頭から順に走査して目的の値を探します。

### Green — 実装

```fsharp
/// while 版線形探索（見つかればインデックス、なければ -1）
let linearSearchWhile (a: int[]) key =
    let mutable i = 0
    while i < a.Length && a.[i] <> key do
        i <- i + 1
    if i = a.Length then -1 else i

/// for 版線形探索
let linearSearchFor (a: int[]) key =
    let mutable result = -1
    for i in 0..a.Length-1 do
        if a.[i] = key && result = -1 then result <- i
    result
```

### 番兵法による線形探索

配列末尾に番兵（目的値のコピー）を追加することで、境界チェックを省略できます。

```fsharp
/// 番兵法による線形探索
let linearSearchSentinel (a: int[]) key =
    let n = a.Length
    let b = Array.append a [| key |]  // 番兵を追加
    let mutable i = 0
    while b.[i] <> key do i <- i + 1
    if i = n then -1 else i
```

---

## 2. 二分探索

ソート済み配列の中央値と比較しながら探索範囲を半分に絞ります。

```fsharp
/// 二分探索（見つかればインデックス、なければ -1）
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
```

二分探索は O(log n) で、線形探索の O(n) より効率的です。ただし、**配列がソート済みであること**が前提です。

---

## 3. ハッシュ法

キーをハッシュ関数でインデックスに変換し、高速な探索を実現します。

### チェーン法

衝突したキーを連結リストで管理します。F# では `string option` を使って NULL 安全な API を提供します。

```fsharp
type ChainedHash(capacity: int) =
    // ... 実装詳細は apps/fsharp/Chapter03/SearchAlgorithms.fs 参照

    /// キーを探索する（見つかれば Some value、なければ None）
    member _.Search(key) : string option = ...

    /// キーを追加する（成功すれば true）
    member this.Add(key, value) : bool = ...

    /// キーを削除する（成功すれば true）
    member _.Remove(key) : bool = ...
```

`option<T>` 型の使い方：

```fsharp
let hash = ChainedHash(5)
hash.Add("Alice", "alice@example.com") |> ignore

match hash.Search("Alice") with
| Some email -> printfn "Found: %s" email
| None -> printfn "Not found"
```

### オープンアドレス法

衝突時に別のバケットを探索します。

```fsharp
type OpenHash(capacity: int) =
    // ... 実装詳細は apps/fsharp/Chapter03/SearchAlgorithms.fs 参照
```

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 25、スキップ: 0、合計: 25
```

## まとめ

| アルゴリズム | 時間計算量 | 前提条件 |
|-------------|-----------|---------|
| 線形探索 | O(n) | なし |
| 二分探索 | O(log n) | ソート済み配列 |
| ハッシュ法（チェーン） | 平均 O(1) | なし |
| ハッシュ法（オープン） | 平均 O(1) | なし |
