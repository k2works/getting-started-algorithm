# 第 5 章 再帰とソートアルゴリズム比較

## はじめに

再帰は関数型言語の根幹をなす概念であり、ソートアルゴリズムは実装スタイルの違いが最も顕著に現れる題材です。本章では、再帰の表現力とソートの実装アプローチを 14 言語で比較します。

## 再帰の表現力比較

### 階乗（factorial）の実装

最もシンプルな再帰の例として、階乗の実装を比較します。

**命令型言語でもシンプル**:

```python
# Python
def factorial(n):
    if n <= 1: return 1
    return n * factorial(n - 1)
```

```java
// Java
static int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
```

**パターンマッチで直感的**:

```fsharp
// F#
let rec factorial = function
    | 0 | 1 -> 1
    | n -> n * factorial (n - 1)
```

```haskell
-- Haskell
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

```elixir
# Elixir
def factorial(0), do: 1
def factorial(n), do: n * factorial(n - 1)
```

```clojure
;; Clojure
(defn factorial [n]
  (if (<= n 1) 1
    (* n (factorial (dec n)))))
```

### 末尾再帰最適化（TCO）

末尾再帰最適化は、再帰をループと同等の効率で実行する仕組みです。

| 言語 | TCO サポート | 備考 |
|------|------------|------|
| Python | なし | 再帰深度制限あり（デフォルト 1000） |
| TypeScript | なし | V8 エンジンが未対応 |
| Java | なし | JVM が未対応 |
| C# | 限定的 | .NET JIT が一部最適化 |
| Ruby | 手動設定 | `RubyVM::InstructionSequence` で有効化可能 |
| PHP | なし | |
| Go | なし | ゴルーチンで代替 |
| C | コンパイラ依存 | GCC/Clang が `-O2` 以上で最適化 |
| **Rust** | **なし（保証なし）** | LLVM が最適化する場合あり |
| **F#** | **あり** | `rec` キーワードで明示 |
| **Scala** | **あり** | `@tailrec` アノテーションで検証 |
| **Clojure** | **`recur` で明示** | `recur` 特殊形式で末尾再帰 |
| **Elixir** | **あり** | BEAM VM がネイティブサポート |
| **Haskell** | **あり** | 遅延評価と組み合わせて最適化 |

### 末尾再帰の書き方比較

**Scala（@tailrec で検証）**:

```scala
@tailrec
def factorial(n: Int, acc: Int = 1): Int =
  if (n <= 1) acc
  else factorial(n - 1, n * acc)
```

**Clojure（recur で明示）**:

```clojure
(defn factorial [n]
  (loop [i n acc 1]
    (if (<= i 1) acc
      (recur (dec i) (* acc i)))))
```

**Elixir（アキュムレータパターン）**:

```elixir
def factorial(n), do: factorial(n, 1)
defp factorial(0, acc), do: acc
defp factorial(n, acc), do: factorial(n - 1, n * acc)
```

## ソートアルゴリズムの実装スタイル

### バブルソートの 14 言語比較

#### 破壊的ソート（in-place）

配列を直接変更するアプローチ:

**Python**:

```python
def bubble_sort(a):
    n = len(a)
    for i in range(n - 1):
        for j in range(n - 1, i, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
```

**Java**:

```java
static void bubbleSort(int[] a) {
    for (int i = 0; i < a.length - 1; i++)
        for (int j = a.length - 1; j > i; j--)
            if (a[j - 1] > a[j]) {
                int tmp = a[j - 1]; a[j - 1] = a[j]; a[j] = tmp;
            }
}
```

**Rust**:

```rust
pub fn bubble_sort(a: &mut Vec<i32>) {
    let n = a.len();
    for i in 0..n - 1 {
        for j in (i + 1..n).rev() {
            if a[j - 1] > a[j] { a.swap(j - 1, j); }
        }
    }
}
```

#### 非破壊的ソート（新しいリストを返す）

元のデータを変更せず、ソート済みの新しいリストを返すアプローチ:

**Haskell**:

```haskell
bubbleSort :: Ord a => [a] -> [a]
bubbleSort [] = []
bubbleSort xs = let (sorted, rest) = bubble xs
                in last sorted : bubbleSort (init sorted)
  where
    bubble [x] = ([x], [])
    bubble (x:y:xs)
      | x > y    = let (s, r) = bubble (x:xs) in (y:s, r)
      | otherwise = let (s, r) = bubble (y:xs) in (x:s, r)
```

**Clojure**:

```clojure
(defn bubble-sort [coll]
  (let [n (count coll)]
    (loop [a (vec coll) i 0]
      (if (>= i (dec n)) a
        (recur (reduce (fn [v j]
                 (if (> (v (dec j)) (v j))
                   (assoc v (dec j) (v j) j (v (dec j)))
                   v))
               a (range (dec n) i -1))
               (inc i))))))
```

### ソート実装スタイル分類

| スタイル | 言語 | 特徴 |
|---------|------|------|
| **破壊的（配列直接操作）** | Python, TS, Java, C#, Ruby, PHP, Go, C | 元の配列を変更。メモリ効率が良い |
| **破壊的（&mut）** | Rust | 可変参照を明示。安全性を保証 |
| **破壊的（IORef/mutable）** | F#, Haskell | IO 内で可変配列を操作 |
| **非破壊的（新リスト）** | Clojure, Elixir | 元のデータは不変。新しいリストを返す |

### クイックソートの比較

クイックソートは、言語のパラダイムの違いが最も顕著に現れるアルゴリズムです。

**Python（命令型）**:

```python
def quick_sort(a, left, right):
    pl, pr = left, right
    pivot = a[(left + right) // 2]
    while pl <= pr:
        while a[pl] < pivot: pl += 1
        while a[pr] > pivot: pr -= 1
        if pl <= pr:
            a[pl], a[pr] = a[pr], a[pl]
            pl += 1; pr -= 1
    if left < pr: quick_sort(a, left, pr)
    if pl < right: quick_sort(a, pl, right)
```

**Haskell（関数型 — リスト内包表記）**:

```haskell
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  quickSort [y | y <- xs, y <= x] ++ [x] ++ quickSort [y | y <- xs, y > x]
```

**Scala（関数型）**:

```scala
def quickSort(list: List[Int]): List[Int] = list match
  case Nil => Nil
  case pivot :: tail =>
    val (less, greater) = tail.partition(_ <= pivot)
    quickSort(less) ::: pivot :: quickSort(greater)
```

**Elixir（パターンマッチ + パイプ）**:

```elixir
def quick_sort([]), do: []
def quick_sort([pivot | rest]) do
  {less, greater} = Enum.split_with(rest, &(&1 <= pivot))
  quick_sort(less) ++ [pivot] ++ quick_sort(greater)
end
```

### クイックソートの表現力スペクトラム

```
命令型（長い）                                    関数型（短い）
 ←─────────────────────────────────────────────────→
 C    Java   Python   Rust   Scala   Elixir   Haskell
      Go     C#       F#     Clojure
```

Haskell のクイックソートは **3 行** で表現でき、アルゴリズムの本質（ピボット選択 → 分割 → 再帰）が直接コードに反映されています。

## ソートアルゴリズムの計算量

全言語で共通の計算量ですが、定数係数は言語の実行モデルにより異なります。

| アルゴリズム | 最良 | 平均 | 最悪 | 安定性 |
|------------|------|------|------|--------|
| バブルソート | O(n) | O(n^2) | O(n^2) | 安定 |
| 選択ソート | O(n^2) | O(n^2) | O(n^2) | 不安定 |
| 挿入ソート | O(n) | O(n^2) | O(n^2) | 安定 |
| シェルソート | O(n log n) | O(n^1.3) | O(n^2) | 不安定 |
| クイックソート | O(n log n) | O(n log n) | O(n^2) | 不安定 |
| マージソート | O(n log n) | O(n log n) | O(n log n) | 安定 |
| ヒープソート | O(n log n) | O(n log n) | O(n log n) | 不安定 |
| 度数ソート | O(n + k) | O(n + k) | O(n + k) | 安定 |

## まとめ

- **再帰**: 関数型言語はパターンマッチで直感的に書ける。命令型言語でも再帰は使えるが、TCO が保証されないことが多い
- **末尾再帰**: F#, Scala, Elixir, Haskell は TCO を保証。Clojure は `recur` で明示
- **ソートの破壊的/非破壊的**: OOP 言語は in-place ソートが基本。関数型言語は新しいリストを返す
- **クイックソート**: 関数型言語のリスト内包表記やパターンマッチにより、アルゴリズムの本質を最も簡潔に表現できる
- **言語選択の指針**: アルゴリズムの可読性を重視するなら関数型、パフォーマンスを重視するなら C/Rust/Go
