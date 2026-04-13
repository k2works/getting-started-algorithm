# 第 7 章 文字列処理

## はじめに

C での文字列処理は `<string.h>` の関数群を使います。文字列は `\0` で終わる `char` 配列であり、ポインタ演算で効率的に処理できます。

---

## 1. 文字列照合アルゴリズム

テキストの中からパターンを探す操作です。

### BF 法（Brute Force）

単純な全探索です。

```c
int bf_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    for (int i = 0; i <= n - m; i++) {
        int j = 0;
        while (j < m && text[i+j] == pattern[j]) j++;
        if (j == m) return i;
    }
    return -1;
}
```

### KMP 法（Knuth-Morris-Pratt）

失敗関数（failure table）を使って、ミスマッチ時のバックトラックを最小化します。

```c
int kmp_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    int *table = (int *)calloc((size_t)m, sizeof(int));
    /* 失敗関数の構築 */
    int k = 0;
    for (int i = 1; i < m; i++) {
        while (k > 0 && pattern[k] != pattern[i]) k = table[k-1];
        if (pattern[k] == pattern[i]) k++;
        table[i] = k;
    }
    /* 検索 */
    k = 0;
    int result = -1;
    for (int i = 0; i < n; i++) {
        while (k > 0 && text[i] != pattern[k]) k = table[k-1];
        if (text[i] == pattern[k]) k++;
        if (k == m) { result = i - m + 1; break; }
    }
    free(table);
    return result;
}
```

### BM 法（Boyer-Moore）— Bad Character ルール

パターンの末尾から比較し、不一致文字に基づいてスキップ量を計算します。

```c
int bm_match(const char *text, const char *pattern) {
    int n = (int)strlen(text), m = (int)strlen(pattern);
    if (m == 0) return 0;
    int bad[256];
    for (int i = 0; i < 256; i++) bad[i] = -1;
    for (int i = 0; i < m; i++) bad[(unsigned char)pattern[i]] = i;
    int s = 0;
    while (s <= n - m) {
        int j = m - 1;
        while (j >= 0 && pattern[j] == text[s+j]) j--;
        if (j < 0) return s;
        int skip = j - bad[(unsigned char)text[s+j]];
        s += (skip < 1) ? 1 : skip;
    }
    return -1;
}
```

BM 法は実用的に最速の照合アルゴリズムの一つです。テキストを右から左に比較し、不一致時に大きくスキップします。

| アルゴリズム | 平均計算量 | 前処理 |
|------------|----------|--------|
| BF 法 | O(nm) | なし |
| KMP 法 | O(n+m) | 失敗関数 O(m) |
| BM 法 | O(n/m) 程度 | 悪文字テーブル O(m+σ) |

---

## 2. 文字のカウント

```c
typedef struct { char c; int count; } CharCount;

int count_chars(const char *s, CharCount *cc, int max_chars) {
    int n = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        char c = s[i];
        int found = 0;
        for (int j = 0; j < n; j++) {
            if (cc[j].c == c) { cc[j].count++; found = 1; break; }
        }
        if (!found && n < max_chars) { cc[n].c = c; cc[n].count = 1; n++; }
    }
    return n;
}
```

テスト：

```c
void test_count_chars(void) {
    CharCount cc[26];
    int n = count_chars("hello", cc, 26);
    /* 'l' が 2 回出現することを確認 */
    int found = 0;
    for (int i = 0; i < n; i++) {
        if (cc[i].c == 'l') { ASSERT_EQ_INT(2, cc[i].count); found = 1; }
    }
    ASSERT_TRUE(found);
}
```

---

## 3. 文字列の逆順と回文判定

```c
void reverse_string(const char *s, char *buf, size_t bufsz) {
    int len = (int)strlen(s);
    int j = 0;
    for (int i = len - 1; i >= 0 && (size_t)j < bufsz - 1; i--)
        buf[j++] = s[i];
    buf[j] = '\0';
}

int is_palindrome(const char *s) {
    int len = (int)strlen(s);
    for (int i = 0; i < len / 2; i++)
        if (s[i] != s[len - i - 1]) return 0;
    return 1;
}
```

テスト：

```c
void test_reverse_string(void) {
    char buf[16];
    reverse_string("hello", buf, sizeof(buf));
    ASSERT_EQ_STR("olleh", buf);
}

void test_is_palindrome(void) {
    ASSERT_TRUE(is_palindrome("racecar"));
    ASSERT_FALSE(is_palindrome("hello"));
}
```

---

## テスト実行結果

```bash
$ make test-chapter07/strings
=== Testing chapter07/strings ===
11 tests run: 11 passed, 0 failed
```

---

## まとめ

C での文字列処理のポイント：

- 文字列は `'\0'` 終端の `char` 配列
- `strlen` でバイト数を取得（O(n)）
- バッファ渡しパターン（`char *buf, size_t bufsz`）でオーバーフローを防ぐ
- `(unsigned char)` キャストで ASCII テーブルのインデックスをマイナスにしない

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
