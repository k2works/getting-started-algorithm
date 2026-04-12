# 第 7 章 文字列処理

## はじめに

文字列探索は、テキストの中からパターン（キーワード）を検索する処理です。この章では、ブルートフォース法・KMP 法・Boyer-Moore 法の 3 種類の文字列探索アルゴリズムを TDD で実装します。

---

## 1. ブルートフォース法（総当たり）

テキスト中でパターンが最初に現れる位置を、総当たりで探す方法です。

### Red — テストを書く

```ruby
describe "Algorithm.bf_match" do
  let(:text)    { "ABCXDEZCABACABAB" }
  let(:pattern) { "ABAB" }

  it "パターンが見つかる" do
    expect(Algorithm.bf_match(text, pattern)).to eq(12)
  end

  it "パターンが見つからない" do
    expect(Algorithm.bf_match("AAAA", "BB")).to eq(-1)
  end

  it "空パターンは位置0を返す" do
    expect(Algorithm.bf_match("hello", "")).to eq(0)
  end
end
```

### Green — 実装

```ruby
def self.bf_match(text, pattern)
  n = text.length
  m = pattern.length
  return 0 if m == 0

  (0..n - m).each do |i|
    j = 0
    j += 1 while j < m && text[i + j] == pattern[j]
    return i if j == m
  end
  -1
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 文字列の長さ | `len(s)` | `s.length` |
| 文字アクセス | `text[i]` | `text[i]`（同様） |
| while 条件付き加算 | 同様 | `j += 1 while 条件` |

---

## 2. KMP 法（Knuth-Morris-Pratt）

失敗関数テーブルを使い、比較の重複を避ける効率的な探索法です。

### 失敗関数テーブルの構築

```ruby
def self._build_kmp_table(pattern)
  m = pattern.length
  table = Array.new(m, 0)
  k = 0
  (1...m).each do |i|
    while k > 0 && pattern[k] != pattern[i]
      k = table[k - 1]
    end
    k += 1 if pattern[k] == pattern[i]
    table[i] = k
  end
  table
end
private_class_method :_build_kmp_table
```

### Green — 実装

```ruby
def self.kmp_match(text, pattern)
  n = text.length
  m = pattern.length
  return 0 if m == 0

  table = _build_kmp_table(pattern)
  j = 0
  n.times do |i|
    while j > 0 && text[i] != pattern[j]
      j = table[j - 1]
    end
    j += 1 if text[i] == pattern[j]
    return i - m + 1 if j == m
  end
  -1
end
```

---

## 3. Boyer-Moore 法（Bad Character ルール）

パターンを右から左へ比較し、不一致時にスキップ量を最大化する方法です。

### Green — 実装

```ruby
def self.bm_match(text, pattern)
  n = text.length
  m = pattern.length
  return 0 if m == 0

  bad_char = {}
  pattern.chars.each_with_index { |c, i| bad_char[c] = i }

  s = 0
  while s <= n - m
    j = m - 1
    j -= 1 while j >= 0 && pattern[j] == text[s + j]
    return s if j < 0

    skip = j - bad_char.fetch(text[s + j], -1)
    s += [1, skip].max
  end
  -1
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 辞書 | `bad_char: dict[str, int] = {}` | `bad_char = {}` |
| デフォルト値付き取得 | `bad_char.get(key, -1)` | `bad_char.fetch(key, -1)` |
| 文字列を文字に分割 | `enumerate(pattern)` | `pattern.chars.each_with_index` |
| 最大値 | `max(1, skip)` | `[1, skip].max` |

---

## 4. 文字カウント

```ruby
def self.count_chars(s)
  result = {}
  s.each_char do |c|
    result[c] = (result[c] || 0) + 1
  end
  result
end
```

### テスト

```ruby
it "文字の出現回数を返す" do
  expect(Algorithm.count_chars("hello")).to eq({
    "h" => 1, "e" => 1, "l" => 2, "o" => 1
  })
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| デフォルト値 | `result.get(c, 0) + 1` | `(result[c] \|\| 0) + 1` |
| 文字イテレーション | `for c in s` | `s.each_char { \|c\| }` |

---

## 5. 文字列操作

```ruby
# 逆順
def self.reverse_string(s)
  s.reverse
end

# 回文判定
def self.palindrome?(s)
  s == s.reverse
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 逆順 | `s[::-1]` | `s.reverse` |
| 回文判定メソッド名 | `is_palindrome(s)` | `palindrome?(s)` |

Ruby では真偽値を返すメソッドには `?` を末尾につける慣習があります。

---

## まとめ

| 探索法 | 計算量（平均） | 計算量（最悪） | 特徴 |
|--------|--------------|--------------|------|
| ブルートフォース | O(n × m) | O(n × m) | シンプル |
| KMP | O(n + m) | O(n + m) | 前処理必要 |
| Boyer-Moore | O(n / m) | O(n × m) | 実用的に高速 |

### Ruby の特徴

- `s.length` で文字列長（Python の `len(s)` に相当）
- `s.reverse` で逆順文字列（Python の `s[::-1]` に相当）
- `s.each_char` で文字ごとのイテレーション
- `s.chars` で文字の配列に変換
- `hash.fetch(key, default)` でデフォルト値付き取得
- `[a, b].max` で 2 つの値の最大値
- `?` 末尾のメソッド名で真偽値返却を表す慣習
