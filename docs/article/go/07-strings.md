# 第 7 章 文字列処理

## はじめに

Go の文字列は UTF-8 バイト列として扱われます。`strings` パッケージに多くのユーティリティが用意されています。

---

## 1. 文字列の基本

Go の文字列はイミュータブルなバイト列です。

```go
s := "ABCXDEZCABACABAB"
// 文字列の長さ（バイト数）
n := len(s)
// i 番目のバイト
b := s[i]
```

---

## 2. 文字列の探索

### ブルートフォース法（O(n×m)）

```go
func BfMatch(text, pattern string) int {
    n, m := len(text), len(pattern)
    if m == 0 {
        return 0
    }
    for i := 0; i <= n-m; i++ {
        j := 0
        for j < m && text[i+j] == pattern[j] {
            j++
        }
        if j == m {
            return i
        }
    }
    return -1
}
```

---

## 3. 文字列の照合

### KMP 法（O(n+m)）

失敗関数テーブルを事前構築し、比較の重複を避けます。

```go
func KmpMatch(text, pattern string) int {
    n, m := len(text), len(pattern)
    table := buildKmpTable(pattern)
    j := 0
    for i := 0; i < n; i++ {
        for j > 0 && text[i] != pattern[j] {
            j = table[j-1]
        }
        if text[i] == pattern[j] {
            j++
        }
        if j == m {
            return i - m + 1
        }
    }
    return -1
}
```

### Boyer-Moore 法

末尾から比較し、スキップテーブルで飛び越します。

```go
func BmMatch(text, pattern string) int {
    n, m := len(text), len(pattern)
    skip := make(map[byte]int)
    for i := 0; i < m-1; i++ {
        skip[pattern[i]] = m - i - 1
    }
    i := m - 1
    for i < n {
        j := m - 1
        k := i
        for j >= 0 && text[k] == pattern[j] {
            j--; k--
        }
        if j < 0 {
            return k + 1
        }
        s, ok := skip[text[i]]
        if !ok { s = m }
        i += s
    }
    return -1
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| 文字列長 | `len(s)` | `len(s)` |
| 文字アクセス | `s[i]`（str） | `s[i]`（byte） |
| 文字列検索 | `s.find(p)` | `strings.Index(s, p)` |
| 標準 str モジュール | `str.find()` | `strings.Contains()` 等 |
