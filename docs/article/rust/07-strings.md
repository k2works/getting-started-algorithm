# 第 7 章 文字列処理

## はじめに

前章ではソートアルゴリズムを学びました。この章では、テキストデータを扱う「文字列処理」を TDD で実装します。

文字列探索は、テキストエディタの検索機能やウイルススキャン、DNA 配列解析など、あらゆるソフトウェアで使われる基本操作です。効率的な探索アルゴリズムを知ることは、実用的なプログラミングに直結します。

Rust では文字列は UTF-8 でエンコードされており、`&str`（文字列スライス）で受け取り、`chars()` で文字単位に処理します。Python の `-1`（見つからない）は `Option<usize>` の `None` で表現し、型安全な設計になります。

### 目次

1. [ブルートフォース法（BF 法）](#1-ブルートフォース法bf-法)
2. [KMP 法](#2-kmp-法)
3. [BM 法](#3-bm-法)
4. [文字数カウント](#4-文字数カウント)
5. [文字列逆順](#5-文字列逆順)
6. [回文判定](#6-回文判定)

---

## 1. ブルートフォース法（BF 法）

テキスト中でパターンを 1 文字ずつずらしながら照合する、最も単純な文字列探索アルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_bf_match_found() {
    assert_eq!(bf_match("ABCXDEZCABACABAB", "ABAB"), Some(12));
}

#[test]
fn test_bf_match_found_at_start() {
    assert_eq!(bf_match("ABCDE", "ABC"), Some(0));
}

#[test]
fn test_bf_match_not_found() {
    assert_eq!(bf_match("ABCDE", "XYZ"), None);
}

#[test]
fn test_bf_match_empty_pattern() {
    assert_eq!(bf_match("ABCDE", ""), Some(0));
}

#[test]
fn test_bf_match_pattern_longer_than_text() {
    assert_eq!(bf_match("AB", "ABCDE"), None);
}
```

### Green -- テストを通す実装

```rust
pub fn bf_match(text: &str, pattern: &str) -> Option<usize> {
    let text: Vec<char> = text.chars().collect();
    let pattern: Vec<char> = pattern.chars().collect();
    let n = text.len();
    let m = pattern.len();

    if m == 0 {
        return Some(0);
    }
    if m > n {
        return None;
    }

    for i in 0..=(n - m) {
        let mut j = 0;
        while j < m && text[i + j] == pattern[j] {
            j += 1;
        }
        if j == m {
            return Some(i);
        }
    }
    None
}
```

`chars().collect()` で `Vec<char>` に変換することで、UTF-8 マルチバイト文字にも対応した文字単位のインデックスアクセスが可能になります。Python の `-1` は Rust では `None` で表現し、`Option<usize>` の型シグネチャにより、呼び出し側で必ずマッチの成否をハンドリングすることを強制します。

---

## 2. KMP 法

KMP（Knuth-Morris-Pratt）法は、失敗関数テーブルを事前に構築し、不一致時のバックトラックを最小化する文字列探索アルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_kmp_match_found() {
    assert_eq!(kmp_match("ABCXDEZCABACABAB", "ABAB"), Some(12));
}

#[test]
fn test_kmp_match_found_at_start() {
    assert_eq!(kmp_match("ABCDE", "ABC"), Some(0));
}

#[test]
fn test_kmp_match_not_found() {
    assert_eq!(kmp_match("ABCDE", "XYZ"), None);
}

#[test]
fn test_kmp_match_repeated_pattern() {
    assert_eq!(kmp_match("AAABAAAB", "AAAB"), Some(0));
}
```

### Green -- テストを通す実装

#### 失敗関数テーブルの構築

```rust
fn build_kmp_table(pattern: &[char]) -> Vec<usize> {
    let m = pattern.len();
    let mut table = vec![0usize; m];
    let mut k = 0;

    for i in 1..m {
        while k > 0 && pattern[k] != pattern[i] {
            k = table[k - 1];
        }
        if pattern[k] == pattern[i] {
            k += 1;
        }
        table[i] = k;
    }
    table
}
```

失敗関数テーブルは、パターンの各位置で「接頭辞と接尾辞が一致する最大長」を記録します。これにより、不一致時にテキスト側のポインタを戻さずに次の比較位置を決定できます。

#### KMP 探索本体

```rust
pub fn kmp_match(text: &str, pattern: &str) -> Option<usize> {
    let text: Vec<char> = text.chars().collect();
    let pattern: Vec<char> = pattern.chars().collect();
    let n = text.len();
    let m = pattern.len();

    if m == 0 {
        return Some(0);
    }

    let table = build_kmp_table(&pattern);
    let mut j = 0;

    for i in 0..n {
        while j > 0 && text[i] != pattern[j] {
            j = table[j - 1];
        }
        if text[i] == pattern[j] {
            j += 1;
        }
        if j == m {
            return Some(i + 1 - m);
        }
    }
    None
}
```

マッチ位置の計算 `i + 1 - m` は、Rust の `usize`（符号なし整数）でのアンダーフローを防ぐために `i - m + 1` ではなく `i + 1 - m` と書いています。`j == m` の時点で `i >= m - 1` が保証されるため、`i + 1 >= m` は常に成立します。

---

## 3. BM 法

Boyer-Moore 法は、パターンを右から左へ比較し、Bad Character ルールで大きくスキップする高効率な探索アルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_bm_match_found() {
    assert_eq!(bm_match("ABCXDEZCABACABAB", "ABAB"), Some(12));
}

#[test]
fn test_bm_match_found_at_start() {
    assert_eq!(bm_match("ABCDE", "ABC"), Some(0));
}

#[test]
fn test_bm_match_not_found() {
    assert_eq!(bm_match("ABCDE", "XYZ"), None);
}
```

### Green -- テストを通す実装

```rust
pub fn bm_match(text: &str, pattern: &str) -> Option<usize> {
    let text: Vec<char> = text.chars().collect();
    let pattern: Vec<char> = pattern.chars().collect();
    let n = text.len();
    let m = pattern.len();

    if m == 0 {
        return Some(0);
    }
    if m > n {
        return None;
    }

    // Bad Character テーブル: 各文字のパターン内での最後の出現位置
    let mut bad_char: HashMap<char, isize> = HashMap::new();
    for (i, &c) in pattern.iter().enumerate() {
        bad_char.insert(c, i as isize);
    }

    let mut s: usize = 0;
    while s <= n - m {
        let mut j = m as isize - 1;
        while j >= 0 && pattern[j as usize] == text[s + j as usize] {
            j -= 1;
        }
        if j < 0 {
            return Some(s);
        } else {
            let bc = *bad_char.get(&text[s + j as usize]).unwrap_or(&-1);
            let skip = j - bc;
            s += std::cmp::max(1, skip) as usize;
        }
    }
    None
}
```

Bad Character テーブルは `HashMap<char, isize>` で構築します。パターンに含まれない文字は `unwrap_or(&-1)` で `-1` を返し、最大のスキップ量を得ます。`isize` を使うことで、負のインデックス計算を安全に行えます。

### 3 つの探索アルゴリズムの比較

| アルゴリズム | 前処理 | 平均計算量 | 最悪計算量 | 特徴 |
|------------|--------|-----------|-----------|------|
| BF 法 | なし | O(n * m) | O(n * m) | 最も単純 |
| KMP 法 | O(m) | O(n + m) | O(n + m) | テキスト側を戻さない |
| BM 法 | O(m + sigma) | O(n / m) | O(n * m) | 実用的に最速 |

---

## 4. 文字数カウント

文字列中の各文字の出現回数を `HashMap<char, usize>` で返します。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_count_chars() {
    let result = count_chars("hello world");
    assert_eq!(*result.get(&'l').unwrap(), 3);
    assert_eq!(*result.get(&'o').unwrap(), 2);
    assert_eq!(*result.get(&' ').unwrap(), 1);
}

#[test]
fn test_count_chars_empty() {
    let result = count_chars("");
    assert!(result.is_empty());
}
```

### Green -- テストを通す実装

```rust
pub fn count_chars(s: &str) -> HashMap<char, usize> {
    let mut result = HashMap::new();
    for c in s.chars() {
        *result.entry(c).or_insert(0) += 1;
    }
    result
}
```

`entry().or_insert(0)` は Python の `dict.get(c, 0)` に相当するイディオムです。キーが存在しなければ `0` を挿入し、その可変参照を返します。`*` で参照を解決してインクリメントします。

---

## 5. 文字列逆順

文字列を逆順にして新しい `String` を返します。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_reverse_string() {
    assert_eq!(reverse_string("hello"), "olleh");
}

#[test]
fn test_reverse_string_empty() {
    assert_eq!(reverse_string(""), "");
}

#[test]
fn test_reverse_string_single() {
    assert_eq!(reverse_string("a"), "a");
}
```

### Green -- テストを通す実装

```rust
pub fn reverse_string(s: &str) -> String {
    s.chars().rev().collect()
}
```

Python の `s[::-1]` に対応する Rust のイディオムです。`chars()` でイテレータを取得し、`rev()` で反転、`collect()` で `String` に収集します。所有権の移動はなく、新しい `String` が生成されます。

---

## 6. 回文判定

文字列が前から読んでも後ろから読んでも同じかどうかを判定します。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_is_palindrome() {
    assert!(is_palindrome("racecar"));
}

#[test]
fn test_is_not_palindrome() {
    assert!(!is_palindrome("hello"));
}

#[test]
fn test_is_palindrome_empty() {
    assert!(is_palindrome(""));
}

#[test]
fn test_is_palindrome_even() {
    assert!(is_palindrome("abba"));
}
```

### Green -- テストを通す実装

```rust
pub fn is_palindrome(s: &str) -> bool {
    let chars: Vec<char> = s.chars().collect();
    let n = chars.len();
    for i in 0..n / 2 {
        if chars[i] != chars[n - 1 - i] {
            return false;
        }
    }
    true
}
```

`reverse_string` を使って `s == reverse_string(s)` と書くこともできますが、ここでは前半と後半を比較する方法で実装しました。半分の比較で済むため、無駄なメモリ確保を避けられます。

---

## アルゴリズム比較

| アルゴリズム | 計算量 | 用途 |
|------------|--------|------|
| BF 法 | O(n * m) | 短いテキスト・パターン |
| KMP 法 | O(n + m) | 長いテキストの高速探索 |
| BM 法 | 平均 O(n / m) | 実用的な全文検索 |
| 文字数カウント | O(n) | 頻度分析、アナグラム判定 |
| 文字列逆順 | O(n) | 回文判定の前処理 |
| 回文判定 | O(n) | 文字列の対称性チェック |

---

## テスト実行結果

```bash
$ cargo test --manifest-path apps/rust/Cargo.toml -p chapter07
running 29 tests
test result: ok. 29 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

---

## まとめ

Rust での文字列処理の特徴:

- `&str` は UTF-8 バイト列への参照であり、文字単位のインデックスアクセスには `chars().collect::<Vec<char>>()` が必要
- Python の `-1`（見つからない）は `Option<usize>` の `None` で表現し、型レベルでエラーハンドリングを強制する
- `HashMap<char, usize>` は Python の `dict[str, int]` に対応し、`entry().or_insert()` で簡潔にカウント処理を記述できる
- `usize` は符号なしのため、`i - m + 1` のような式は `i + 1 - m` と書き順を変えてアンダーフローを防ぐ
- BM 法の Bad Character テーブルでは `HashMap<char, isize>` を使い、負のインデックスを安全に扱う

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
