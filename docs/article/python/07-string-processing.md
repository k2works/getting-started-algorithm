# 第 7 章 文字列処理

## はじめに

前章ではソートアルゴリズムを学びました。この章では「文字列処理」について TDD で実装します。

主に以下を実装します：

1. ブルートフォース文字列探索
2. KMP 法（Knuth-Morris-Pratt）
3. Boyer-Moore 法
4. 文字カウント・逆順・回文判定

---

## 1. ブルートフォース文字列探索

テキストを左から順にパターンと比較する最もシンプルな方法です。

### Red — 失敗するテストを書く

```python
# tests/test_strings.py
class TestBfMatch:
    def test_found(self):
        assert bf_match("ABCXDEZCABACABAB", "ABAB") == 12

    def test_not_found(self):
        assert bf_match("ABCDE", "XYZ") == -1
```

### Green — テストを通す実装

```python
# src/algorithm/strings.py
def bf_match(text: str, pattern: str) -> int:
    """ブルートフォース文字列探索"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    for i in range(n - m + 1):
        j = 0
        while j < m and text[i + j] == pattern[j]:
            j += 1
        if j == m:
            return i
    return -1
```

**計算量**: O(n × m)

---

## 2. KMP 法

失敗関数テーブルを使い、不一致が発生した際にスキップ量を最適化します。

### Green — テストを通す実装

```python
def _build_kmp_table(pattern: str) -> list[int]:
    """失敗関数テーブルを構築"""
    m = len(pattern)
    table = [0] * m
    k = 0
    for i in range(1, m):
        while k > 0 and pattern[k] != pattern[i]:
            k = table[k - 1]
        if pattern[k] == pattern[i]:
            k += 1
        table[i] = k
    return table


def kmp_match(text: str, pattern: str) -> int:
    """KMP 文字列探索"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    table = _build_kmp_table(pattern)
    j = 0
    for i in range(n):
        while j > 0 and text[i] != pattern[j]:
            j = table[j - 1]
        if text[i] == pattern[j]:
            j += 1
        if j == m:
            return i - m + 1
    return -1
```

**計算量**: O(n + m)

---

## 3. Boyer-Moore 法

パターンを右から左へ比較し、不一致時のスキップ量を最大化します。

```python
def bm_match(text: str, pattern: str) -> int:
    """Boyer-Moore 文字列探索（Bad Character ルール）"""
    n, m = len(text), len(pattern)
    if m == 0:
        return 0
    bad_char: dict[str, int] = {}
    for i, c in enumerate(pattern):
        bad_char[c] = i
    s = 0
    while s <= n - m:
        j = m - 1
        while j >= 0 and pattern[j] == text[s + j]:
            j -= 1
        if j < 0:
            return s
        else:
            skip = j - bad_char.get(text[s + j], -1)
            s += max(1, skip)
    return -1
```

**計算量**: 平均 O(n / m)、最悪 O(n × m)

---

## 4. 文字カウント・逆順・回文判定

```python
def count_chars(s: str) -> dict[str, int]:
    """文字の出現回数をカウント"""
    result: dict[str, int] = {}
    for c in s:
        result[c] = result.get(c, 0) + 1
    return result


def reverse_string(s: str) -> str:
    """文字列を逆順にする"""
    return s[::-1]


def is_palindrome(s: str) -> bool:
    """回文判定"""
    return s == s[::-1]
```

---

## テスト実行結果

```bash
$ uv run pytest tests/test_strings.py -v

...（27 テスト全パス）...

Name                       Stmts   Miss  Cover
----------------------------------------------
src/algorithm/strings.py      65      0   100%
----------------------------------------------
27 passed in 0.17s
```

カバレッジ 100% 達成コロ助。

---

## 文字列探索アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| ブルートフォース | O(n × m) | シンプル、小規模に有効 |
| KMP 法 | O(n + m) | 最悪でも線形、前処理が必要 |
| Boyer-Moore 法 | O(n / m) 平均 | 大規模テキストで最速 |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
