# 第 3 章 探索アルゴリズム

## はじめに

この章では、線形探索・二分探索・ハッシュ法の 3 つの探索アルゴリズムを F# で実装します。ハッシュ法では F# のクラス型（`type`）を使ったオブジェクト指向スタイルも学びます。

## 探索アルゴリズムとは

探索アルゴリズムとは、データの集合から特定の条件を満たす要素を見つけ出すための手順です。探索の対象となるデータは「キー」と呼ばれ、探索の結果は通常、キーが見つかった位置（インデックス）または見つからなかったことを示す特別な値（多くの場合は -1）となります。

探索アルゴリズムの性能は、主に以下の要素によって評価されます：

- **時間効率**（計算量）：探索にかかる時間
- **空間効率**：使用するメモリ量
- **前提条件**：データが整列されている必要があるかなど

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

## 探索アルゴリズムの比較

| アルゴリズム | 前提条件 | 計算量（平均） | 計算量（最悪） | 適用場面 |
|-------------|---------|-------------|-------------|---------|
| 線形探索 | なし | O(n) | O(n) | 小規模・未整列データ |
| 二分探索 | ソート済み配列 | O(log n) | O(log n) | 大規模・整列データ |
| ハッシュ法（チェーン） | なし | O(1) | O(n) | 高速な挿入・削除・探索 |
| ハッシュ法（オープン） | なし | O(1) | O(n) | 高速な挿入・削除・探索 |

## まとめ

この章では、3 つの主要な探索アルゴリズムを F# で実装しました：

1. **線形探索**：最も単純な探索方法で、配列の先頭から順に探索します。番兵法を使うことでわずかに効率化できます。
2. **二分探索**：ソート済み配列に対して使用できる効率的な探索方法で、探索範囲を半分ずつ絞り込みます。
3. **ハッシュ法**：キーからハッシュ値でアドレスを求める方法で、理想的な状況では O(1) で探索できます。F# の `option<T>` 型を使って NULL 安全な API を提供しています。

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
