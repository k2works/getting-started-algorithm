// Package chapter02 第2章 配列
package chapter02

// MaxOf スライスの要素の最大値を返す
func MaxOf(a []int) int {
	maximum := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] > maximum {
			maximum = a[i]
		}
	}
	return maximum
}

// ReverseArray スライスの要素の並びを反転する
func ReverseArray(a []int) {
	n := len(a)
	for i := 0; i < n/2; i++ {
		a[i], a[n-i-1] = a[n-i-1], a[i]
	}
}

// CardConv 整数値xをr進数に変換した数値を表す文字列を返す
func CardConv(x, r int) string {
	dchar := "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	digits := []byte{}
	for x > 0 {
		digits = append(digits, dchar[x%r])
		x /= r
	}
	// reverse
	for i, j := 0, len(digits)-1; i < j; i, j = i+1, j-1 {
		digits[i], digits[j] = digits[j], digits[i]
	}
	return string(digits)
}

// Prime1 x以下の素数を列挙する（第1版）— 除算回数を返す
func Prime1(x int) int {
	counter := 0
	for n := 2; n <= x; n++ {
		for i := 2; i < n; i++ {
			counter++
			if n%i == 0 {
				break
			}
		}
	}
	return counter
}

// Prime2 x以下の素数を列挙する（第2版）— 除算回数を返す
func Prime2(x int) int {
	counter := 0
	prime := make([]int, 500)
	ptr := 0
	prime[ptr] = 2
	ptr++

	for n := 3; n <= x; n += 2 {
		divided := false
		for i := 1; i < ptr; i++ {
			counter++
			if n%prime[i] == 0 {
				divided = true
				break
			}
		}
		if !divided {
			prime[ptr] = n
			ptr++
		}
	}
	return counter
}

// Prime3 x以下の素数を列挙する（第3版）— 除算回数を返す
// 平方根以下の素数でのみ割り切れるか確認することで効率化する。
func Prime3(x int) int {
	counter := 0
	prime := make([]int, 500)
	ptr := 0
	prime[ptr] = 2
	ptr++
	prime[ptr] = 3
	ptr++

	for n := 5; n <= 1000; n += 2 {
		i := 1
		found := false
		for prime[i]*prime[i] <= n {
			counter += 2
			if n%prime[i] == 0 {
				found = true
				break
			}
			i++
		}
		if !found {
			prime[ptr] = n
			ptr++
			counter++
		}
	}
	return counter
}
