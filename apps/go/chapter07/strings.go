// Package chapter07 第7章 文字列処理
package chapter07

// BfMatch ブルートフォース文字列探索
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

// KmpMatch KMP 法による文字列探索
func KmpMatch(text, pattern string) int {
	n, m := len(text), len(pattern)
	if m == 0 {
		return 0
	}
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

func buildKmpTable(pattern string) []int {
	m := len(pattern)
	table := make([]int, m)
	k := 0
	for i := 1; i < m; i++ {
		for k > 0 && pattern[k] != pattern[i] {
			k = table[k-1]
		}
		if pattern[k] == pattern[i] {
			k++
		}
		table[i] = k
	}
	return table
}

// BmMatch Boyer-Moore 法による文字列探索
func BmMatch(text, pattern string) int {
	n, m := len(text), len(pattern)
	if m == 0 {
		return 0
	}
	skip := make(map[byte]int)
	for i := 0; i < m-1; i++ {
		skip[pattern[i]] = m - i - 1
	}
	i := m - 1
	for i < n {
		j := m - 1
		k := i
		for j >= 0 && text[k] == pattern[j] {
			j--
			k--
		}
		if j < 0 {
			return k + 1
		}
		s, ok := skip[text[i]]
		if !ok {
			s = m
		}
		if s < 1 {
			s = 1
		}
		i += s
	}
	return -1
}

// CountChars 文字列中の各文字の出現回数を map で返す
func CountChars(s string) map[rune]int {
	result := make(map[rune]int)
	for _, c := range s {
		result[c]++
	}
	return result
}

// ReverseString 文字列を逆順にして返す
func ReverseString(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

// IsPalindrome 文字列が回文かどうかを判定する
func IsPalindrome(s string) bool {
	return s == ReverseString(s)
}
