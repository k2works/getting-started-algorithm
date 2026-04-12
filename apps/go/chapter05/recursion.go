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
