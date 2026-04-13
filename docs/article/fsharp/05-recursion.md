# 第 5 章 再帰アルゴリズム

## はじめに

再帰は F# の得意とする表現です。`let rec` キーワードで再帰関数を定義します。

## 再帰アルゴリズムとは

再帰とは、**ある関数が自分自身を呼び出す**ことで問題を解く手法です。大きな問題を同じ構造の小さな問題に分解し、最終的に自明な基底ケースに到達したら戻り始めます。

再帰アルゴリズムは、一般的に以下の 2 つの部分から構成されます：

1. **基底部（base case）**: 再帰呼び出しを終了する条件
2. **再帰部（recursive case）**: 問題を小さくして自分自身を呼び出す部分

F# は関数型言語として再帰を自然にサポートしており、`let rec` キーワードで再帰関数を定義します。また、パターンマッチと組み合わせることで、再帰の基底部と再帰部を明確に表現できます。

---

## 1. 再帰の基本

### 階乗

```fsharp
/// n の階乗を再帰で求める
let rec factorial n =
    if n <= 1 then 1
    else n * factorial (n - 1)
```

F# では再帰関数に `let rec` が必要です。

### 最大公約数（ユークリッド互除法）

```fsharp
/// 最大公約数をユークリッド互除法で求める
let rec gcd x y =
    if y = 0 then x
    else gcd y (x % y)
```

`match` を使ったより F# らしい書き方：

```fsharp
let rec gcd x y =
    match y with
    | 0 -> x
    | _ -> gcd y (x % y)
```

---

## 2. 再帰の応用

### ハノイの塔

```fsharp
/// ハノイの塔の移動手順を文字列で返す
let hanoi n src dst via =
    let result = System.Collections.Generic.List<string>()
    let rec move n src dst via =
        if n > 0 then
            move (n-1) src via dst
            result.Add(sprintf "%d 番を %s から %s へ" n src dst)
            move (n-1) via dst src
    move n src dst via
    result |> Seq.toList
```

---

## 3. 8 クイーン問題

8×8 のチェス盤に 8 個のクイーンを互いに攻撃できない位置に配置する問題です。

```fsharp
type EightQueen() =
    let pos = Array.zeroCreate<int> 8
    let mutable count = 0

    let rec place col =
        if col = 8 then count <- count + 1
        else
            for row in 0..7 do
                let mutable ok = true
                for i in 0..col-1 do
                    if pos.[i] = row || abs (pos.[i] - row) = col - i then
                        ok <- false
                if ok then
                    pos.[col] <- row
                    place (col + 1)

    member _.Solve() = place 0; count
```

バックトラッキングで解を探索します。答えは 92 通りです。

---

## テスト実行結果

```
成功!   -失敗: 0、合格: 20、スキップ: 0、合計: 20
```

## 再帰アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| 階乗 | O(n) | 単純な線形再帰 |
| GCD（ユークリッド） | O(log min(x,y)) | 対数的収束 |
| ハノイの塔 | O(2^n) | 指数的成長 |
| 8 クイーン問題 | O(n!) | バックトラッキングによる枝刈り |
| 迷路探索 | O(行数 x 列数) | バックトラッキング |

## まとめ

この章では、再帰アルゴリズムを F# で実装しました：

| アルゴリズム | 関数 | 計算量 | F# の特徴 |
|-------------|------|--------|-----------|
| 階乗 | `factorial` | O(n) | `let rec` で再帰関数 |
| 最大公約数 | `gcd` | O(log min(x,y)) | パターンマッチと末尾再帰 |
| 迷路探索 | `mazeSolve` | O(行数 x 列数) | 再帰 + バックトラック |
| ハノイの塔 | `hanoi` | O(2^n) | 相互再帰的な移動 |
| 8 クイーン | `EightQueen` | O(n!) | バックトラッキングの実装 |

1. **再帰の基本**: 階乗やユークリッドの互除法などの基本的な再帰アルゴリズム
2. **再帰の応用**: ハノイの塔、8 クイーン問題、迷路探索
3. **F# の再帰サポート**: `let rec`、パターンマッチ、末尾再帰最適化

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
