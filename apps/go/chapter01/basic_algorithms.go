// Package chapter01 第1章 基本的なアルゴリズム
package chapter01

import (
	"fmt"
	"strings"
)

// Max3 3つの整数値の最大値を返す
func Max3(a, b, c int) int {
	maximum := a
	if b > maximum {
		maximum = b
	}
	if c > maximum {
		maximum = c
	}
	return maximum
}

// Med3 3つの整数値の中央値を返す
func Med3(a, b, c int) int {
	if a >= b {
		if b >= c {
			return b
		} else if a <= c {
			return a
		} else {
			return c
		}
	} else if a > c {
		return a
	} else if b > c {
		return c
	} else {
		return b
	}
}

// JudgeSign 整数値の符号を判定する
func JudgeSign(n int) string {
	if n > 0 {
		return "その値は正です。"
	} else if n < 0 {
		return "その値は負です。"
	} else {
		return "その値は0です。"
	}
}

// Sum1ToNWhile while ループで 1 から n までの総和を求める
func Sum1ToNWhile(n int) int {
	total := 0
	i := 1
	for i <= n {
		total += i
		i++
	}
	return total
}

// Sum1ToNFor for ループで 1 から n までの総和を求める
func Sum1ToNFor(n int) int {
	total := 0
	for i := 1; i <= n; i++ {
		total += i
	}
	return total
}

// Alternative1 記号文字 '+' と '-' を交互に表示する（剰余判定方式）
func Alternative1(n int) string {
	var result strings.Builder
	for i := 0; i < n; i++ {
		if i%2 == 0 {
			result.WriteByte('+')
		} else {
			result.WriteByte('-')
		}
	}
	return result.String()
}

// Alternative2 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）
func Alternative2(n int) string {
	result := strings.Repeat("+-", n/2)
	if n%2 != 0 {
		result += "+"
	}
	return result
}

// Rectangle 縦横が整数で面積が area の長方形の辺の長さを列挙する
func Rectangle(area int) string {
	var result strings.Builder
	for i := 1; i*i <= area; i++ {
		if area%i == 0 {
			result.WriteString(fmt.Sprintf("%dx%d ", i, area/i))
		}
	}
	return result.String()
}

// MultiplicationTable 九九の表を返す
func MultiplicationTable() string {
	var result strings.Builder
	result.WriteString(strings.Repeat("-", 27) + "\n")
	for i := 1; i <= 9; i++ {
		for j := 1; j <= 9; j++ {
			result.WriteString(fmt.Sprintf("%3d", i*j))
		}
		result.WriteByte('\n')
	}
	result.WriteString(strings.Repeat("-", 27))
	return result.String()
}

// TriangleLb 左下側が直角の二等辺三角形を返す
func TriangleLb(n int) string {
	var result strings.Builder
	for i := 1; i <= n; i++ {
		result.WriteString(strings.Repeat("*", i) + "\n")
	}
	return result.String()
}
