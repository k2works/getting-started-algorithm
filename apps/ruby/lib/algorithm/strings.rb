# frozen_string_literal: true

# 第7章 文字列処理

module Algorithm
  # ブルートフォース文字列探索
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

  # KMP 法の失敗関数テーブルを構築
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

  # KMP（Knuth-Morris-Pratt）文字列探索
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
      if j == m
        return i - m + 1
      end
    end
    -1
  end

  # Boyer-Moore 文字列探索（Bad Character ルールのみ）
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

  # 文字列中の各文字の出現回数をハッシュで返す
  def self.count_chars(s)
    result = {}
    s.each_char do |c|
      result[c] = (result[c] || 0) + 1
    end
    result
  end

  # 文字列を逆順にして返す
  def self.reverse_string(s)
    s.reverse
  end

  # 文字列が回文かどうかを判定
  def self.palindrome?(s)
    s == s.reverse
  end
end
