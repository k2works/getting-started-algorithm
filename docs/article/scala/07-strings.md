# 第 7 章 文字列処理

## はじめに

この章では文字列探索（BF/KMP/BM）、文字数カウント、逆順、回文判定を Scala で実装します。Scala の `String` は Java の `String` と互換性があり、`.reverse`、`.groupBy` 等のメソッドが使えます。

## 文字列とは

文字列は文字の列です。Scala では `String` 型（Java String）を使用します。

| 操作 | 計算量 | 備考 |
|------|--------|------|
| 長さ取得 | O(1) | `.length` |
| 文字アクセス | O(1) | `s(i)` |
| 部分文字列 | O(k) | `s.substring` |
| 結合 | O(n+m) | `s + t` |

---

## 1. ブルートフォース探索（BF）

```scala
def bfMatch(txt: String, pat: String): Int =
  val n = txt.length; val m = pat.length
  if m == 0 then return 0
  for i <- 0 to n - m do
    var j = 0
    while j < m && txt(i + j) == pat(j) do j += 1
    if j == m then return i
  -1
```

---

## 2. KMP 探索

```scala
def kmpMatch(txt: String, pat: String): Int =
  val table = buildKmpTable(pat)
  var j = 0
  for i <- 0 until txt.length do
    while j > 0 && txt(i) != pat(j) do j = table(j - 1)
    if txt(i) == pat(j) then j += 1
    if j == pat.length then return i - pat.length + 1
  -1
```

---

## 3. Boyer-Moore 探索

```scala
def bmMatch(txt: String, pat: String): Int =
  val badChar = pat.zipWithIndex.toMap
  var s = 0
  while s <= txt.length - pat.length do
    var j = pat.length - 1
    while j >= 0 && pat(j) == txt(s + j) do j -= 1
    if j < 0 then return s
    val skip = j - badChar.getOrElse(txt(s + j), -1)
    s += math.max(1, skip)
  -1
```

---

## 4. 文字列操作ユーティリティ

```scala
def countChars(s: String): Map[Char, Int] =
  s.groupBy(identity).view.mapValues(_.length).toMap

def reverseString(s: String): String = s.reverse

def isPalindrome(s: String): Boolean = s == s.reverse
```

Scala の `.groupBy` と `.mapValues` で簡潔に文字カウントが実装できます。

---

## テスト実行結果

```
Tests: succeeded 13, failed 0
```

## まとめ

| アルゴリズム | 平均計算量 | 最悪計算量 | 特徴 |
|-------------|-----------|-----------|------|
| BF | O(n×m) | O(n×m) | シンプル |
| KMP | O(n+m) | O(n+m) | 前処理テーブル使用 |
| BM | O(n/m) | O(n×m) | 実用的に高速 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
