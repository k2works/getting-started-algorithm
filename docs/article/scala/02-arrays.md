# 第 2 章 配列

## はじめに

この章では配列操作、基数変換、素数列挙を Scala で実装します。Scala では `Array[T]` が Java の配列に相当し、`.max`、`.sum` 等のコレクションメソッドが使えます。

## 配列とは

配列は同じ型の要素を連続したメモリ領域に格納するデータ構造です。インデックスで O(1) アクセスが可能です。

| 操作 | 計算量 |
|------|--------|
| アクセス | O(1) |
| 探索 | O(n) |
| 挿入（末尾） | O(1) |
| 挿入（中間） | O(n) |

---

## 1. 最大値の検索

```scala
def maxOf(a: Array[Int]): Int = a.max
```

Scala では `a.max` で最大値が取得できます。

---

## 2. 配列の反転

```scala
def reverse(a: Array[Int]): Unit =
  val n = a.length
  for i <- 0 until n / 2 do
    val tmp = a(i)
    a(i) = a(n - i - 1)
    a(n - i - 1) = tmp
```

---

## 3. 基数変換

```scala
def cardConv(x: Int, r: Int): String =
  val dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  var n = x
  val sb = StringBuilder()
  while n > 0 do
    sb.append(dchar(n % r))
    n /= r
  sb.reverse.toString
```

---

## 4. 素数列挙（3 バージョン）

```scala
// 第1版：全数試し割り
def prime1(x: Int): Int = ...  // 除算回数: 78,022

// 第2版：既知の素数のみで割る
def prime2(x: Int): Int = ...  // 除算回数: 14,622

// 第3版：√n までの素数で割る
def prime3(x: Int): Int = ...  // 除算回数:  3,774
```

---

## テスト実行結果

```
Tests: succeeded 10, failed 0
```

## まとめ

| アルゴリズム | 計算量 | Scala の特徴 |
|-------------|--------|-------------|
| maxOf | O(n) | `.max` で簡潔 |
| reverse | O(n) | in-place |
| cardConv | O(log n) | `StringBuilder.reverse` |
| prime3 | O(n√n) | 除算回数が最小 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
