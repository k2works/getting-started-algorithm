// Package chapter05 第5章 再帰アルゴリズム
package chapter05

// Factorial n の階乗を再帰的に計算する
func Factorial(n int) int {
	if n <= 0 {
		return 1
	}
	return n * Factorial(n-1)
}

// Gcd ユークリッドの互除法で最大公約数を求める
func Gcd(x, y int) int {
	if y == 0 {
		return x
	}
	return Gcd(y, x%y)
}

// RecursiveSum 1 から n までの和を再帰的に計算する
func RecursiveSum(n int) int {
	if n <= 0 {
		return 0
	}
	return n + RecursiveSum(n-1)
}

// Hanoi ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す
func Hanoi(n int, src, dst, via string) [][2]string {
	if n == 1 {
		return [][2]string{{src, dst}}
	}
	moves := Hanoi(n-1, src, via, dst)
	moves = append(moves, [2]string{src, dst})
	moves = append(moves, Hanoi(n-1, via, dst, src)...)
	return moves
}

// MazeSolve 迷路をバックトラッキングで解く
func MazeSolve(maze [][]int, row, col, goalRow, goalCol int, visited map[[2]int]bool) bool {
	if visited == nil {
		visited = make(map[[2]int]bool)
	}
	if row == goalRow && col == goalCol {
		return true
	}
	rows := len(maze)
	cols := len(maze[0])
	visited[[2]int{row, col}] = true

	dirs := [4][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	for _, d := range dirs {
		nr, nc := row+d[0], col+d[1]
		if nr >= 0 && nr < rows && nc >= 0 && nc < cols && maze[nr][nc] == 0 && !visited[[2]int{nr, nc}] {
			if MazeSolve(maze, nr, nc, goalRow, goalCol, visited) {
				return true
			}
		}
	}
	return false
}

// EightQueen 8 王妃問題（全組み合わせ列挙）
// 各列に 1 個の王妃を配置する組み合わせを全列挙する（行・対角線制約なし）
type EightQueen struct {
	Result [][]int
	pos    [8]int
}

func (q *EightQueen) put() {
	tmp := make([]int, 8)
	copy(tmp, q.pos[:])
	q.Result = append(q.Result, tmp)
}

func (q *EightQueen) Set(i int) {
	for j := 0; j < 8; j++ {
		q.pos[i] = j
		if i == 7 {
			q.put()
		} else {
			q.Set(i + 1)
		}
	}
}

// EightQueen2 8 王妃問題（行制約あり）
// 各行・各列に 1 個の王妃を配置する組み合わせを列挙する（対角線制約なし）
type EightQueen2 struct {
	Result [][]int
	pos    [8]int
	flag   [8]bool
}

func (q *EightQueen2) put() {
	tmp := make([]int, 8)
	copy(tmp, q.pos[:])
	q.Result = append(q.Result, tmp)
}

func (q *EightQueen2) Set(i int) {
	for j := 0; j < 8; j++ {
		if !q.flag[j] {
			q.pos[i] = j
			if i == 7 {
				q.put()
			} else {
				q.flag[j] = true
				q.Set(i + 1)
				q.flag[j] = false
			}
		}
	}
}

// EightQueen3 8 王妃問題（行・対角線制約あり）
// 各行・各列・各対角線に 1 個の王妃を配置する完全な 8 王妃問題。92 通りの解を求める。
type EightQueen3 struct {
	Result [][]int
	pos    [8]int
	flagA  [8]bool  // 各行のフラグ
	flagB  [15]bool // 右上がり対角線のフラグ
	flagC  [15]bool // 右下がり対角線のフラグ
}

func (q *EightQueen3) put() {
	tmp := make([]int, 8)
	copy(tmp, q.pos[:])
	q.Result = append(q.Result, tmp)
}

func (q *EightQueen3) Set(i int) {
	for j := 0; j < 8; j++ {
		if !q.flagA[j] && !q.flagB[i+j] && !q.flagC[i-j+7] {
			q.pos[i] = j
			if i == 7 {
				q.put()
			} else {
				q.flagA[j] = true
				q.flagB[i+j] = true
				q.flagC[i-j+7] = true
				q.Set(i + 1)
				q.flagA[j] = false
				q.flagB[i+j] = false
				q.flagC[i-j+7] = false
			}
		}
	}
}
