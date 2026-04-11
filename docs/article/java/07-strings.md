# 第 7 章 文字列処理

## はじめに

この章では文字列探索アルゴリズム（ブルートフォース、KMP、Boyer-Moore）と文字列ユーティリティを TDD で実装します。

---

## 1. ブルートフォース文字列探索

テキスト中でパターンが最初に現れる位置を返します。計算量 $O(nm)$。

```java
public static int bfMatch(String txt, String pat) {
    int n = txt.length(), m = pat.length();
    if (m == 0) return 0;
    for (int i = 0; i <= n - m; i++) {
        int j = 0;
        while (j < m && txt.charAt(i + j) == pat.charAt(j)) j++;
        if (j == m) return i;
    }
    return -1;
}
```

---

## 2. KMP 文字列探索

失敗関数テーブルを使い、比較の重複を避けます。計算量 $O(n + m)$。

---

## 3. Boyer-Moore 文字列探索

パターンを右から左へ比較し、不一致時のスキップ量を最大化します。平均計算量 $O(n/m)$。

---

## 4. 文字列ユーティリティ

- `countChars`: 各文字の出現回数を `Map<Character, Integer>` で返す
- `reverseString`: `StringBuilder.reverse()` で逆順
- `isPalindrome`: 逆順と比較して回文判定

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| 文字列逆順 | `s[::-1]` | `new StringBuilder(s).reverse().toString()` |
| 辞書 | `dict[str, int]` | `Map<Character, Integer>` |
| 文字アクセス | `s[i]` | `s.charAt(i)` |

---

## テスト実行結果

```
StringAlgorithmsTest > BfMatchTest > 見つかる() PASSED
StringAlgorithmsTest > KmpMatchTest > 見つかる() PASSED
StringAlgorithmsTest > BmMatchTest > 見つかる() PASSED
StringAlgorithmsTest > IsPalindromeTest > 回文() PASSED
```
