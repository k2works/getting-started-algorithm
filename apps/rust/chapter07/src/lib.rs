// chapter07: 文字列処理

use std::collections::HashMap;

/// ブルートフォース文字列探索（BF 法）
///
/// テキスト中でパターンが最初に現れる位置を返す。
/// 見つからない場合は `None` を返す。
///
/// 計算量: O(n * m)
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

/// KMP 法の失敗関数テーブルを構築する
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

/// KMP（Knuth-Morris-Pratt）文字列探索
///
/// 失敗関数テーブルを使い、比較の重複を避ける。
///
/// 計算量: O(n + m)
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

/// Boyer-Moore 文字列探索（Bad Character ルールのみ）
///
/// パターンを右から左へ比較し、不一致時にスキップ量を最大化する。
///
/// 計算量: 平均 O(n / m)、最悪 O(n * m)
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

    let mut s: usize = 0; // テキスト内のシフト量
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

/// 文字列中の各文字の出現回数を返す
///
/// ```
/// use chapter07::count_chars;
/// let result = count_chars("hello");
/// assert_eq!(*result.get(&'l').unwrap(), 2);
/// ```
pub fn count_chars(s: &str) -> HashMap<char, usize> {
    let mut result = HashMap::new();
    for c in s.chars() {
        *result.entry(c).or_insert(0) += 1;
    }
    result
}

/// 文字列を逆順にして返す
///
/// ```
/// use chapter07::reverse_string;
/// assert_eq!(reverse_string("hello"), "olleh");
/// ```
pub fn reverse_string(s: &str) -> String {
    s.chars().rev().collect()
}

/// 文字列が回文かどうかを判定する
///
/// ```
/// use chapter07::is_palindrome;
/// assert!(is_palindrome("racecar"));
/// assert!(!is_palindrome("hello"));
/// ```
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

#[cfg(test)]
mod tests {
    use super::*;

    // ── 1. ブルートフォース法（BF 法） ──────────────

    #[test]
    fn test_bf_match_found() {
        assert_eq!(bf_match("ABCXDEZCABACABAB", "ABAB"), Some(12));
    }

    #[test]
    fn test_bf_match_found_at_start() {
        assert_eq!(bf_match("ABCDE", "ABC"), Some(0));
    }

    #[test]
    fn test_bf_match_found_at_end() {
        assert_eq!(bf_match("ABCDE", "CDE"), Some(2));
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

    #[test]
    fn test_bf_match_single_char() {
        assert_eq!(bf_match("ABCDE", "C"), Some(2));
    }

    // ── 2. KMP 法 ─────────────────────────

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
    fn test_kmp_match_empty_pattern() {
        assert_eq!(kmp_match("ABCDE", ""), Some(0));
    }

    #[test]
    fn test_kmp_match_repeated_pattern() {
        assert_eq!(kmp_match("AAABAAAB", "AAAB"), Some(0));
    }

    // ── 3. BM 法 ──────────────────────────

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

    #[test]
    fn test_bm_match_empty_pattern() {
        assert_eq!(bm_match("ABCDE", ""), Some(0));
    }

    // ── 4. 文字数カウント ──────────────────────

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

    // ── 5. 文字列逆順 ────────────────────────

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

    #[test]
    fn test_reverse_string_palindrome_stays() {
        assert_eq!(reverse_string("racecar"), "racecar");
    }

    // ── 6. 回文判定 ──────────────────────────

    #[test]
    fn test_is_palindrome() {
        assert!(is_palindrome("racecar"));
    }

    #[test]
    fn test_is_not_palindrome() {
        assert!(!is_palindrome("hello"));
    }

    #[test]
    fn test_is_palindrome_single_char() {
        assert!(is_palindrome("a"));
    }

    #[test]
    fn test_is_palindrome_empty() {
        assert!(is_palindrome(""));
    }

    #[test]
    fn test_is_palindrome_even() {
        assert!(is_palindrome("abba"));
    }

    // ── 全アルゴリズムの一致テスト ──────────────────

    #[test]
    fn test_all_search_algorithms_agree() {
        let text = "ABCXDEZCABACABAB";
        let pattern = "ABAB";
        let expected = Some(12);
        assert_eq!(bf_match(text, pattern), expected);
        assert_eq!(kmp_match(text, pattern), expected);
        assert_eq!(bm_match(text, pattern), expected);
    }

    #[test]
    fn test_all_search_algorithms_not_found() {
        let text = "ABCDE";
        let pattern = "XYZ";
        assert_eq!(bf_match(text, pattern), None);
        assert_eq!(kmp_match(text, pattern), None);
        assert_eq!(bm_match(text, pattern), None);
    }
}
