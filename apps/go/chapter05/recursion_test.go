package chapter05_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter05"
)

func TestFactorial(t *testing.T) {
	got := chapter05.Factorial(5)
	if got != 120 {
		t.Errorf("Factorial(5) = %d; want 120", got)
	}
}

func TestGcd(t *testing.T) {
	got := chapter05.Gcd(22, 8)
	if got != 2 {
		t.Errorf("Gcd(22,8) = %d; want 2", got)
	}
}

func TestRecursiveSum(t *testing.T) {
	got := chapter05.RecursiveSum(5)
	if got != 15 {
		t.Errorf("RecursiveSum(5) = %d; want 15", got)
	}
}

func TestHanoi(t *testing.T) {
	moves := chapter05.Hanoi(1, "A", "C", "B")
	if len(moves) != 1 || moves[0][0] != "A" || moves[0][1] != "C" {
		t.Errorf("Hanoi(1,A,C,B) = %v; want [[A C]]", moves)
	}

	moves3 := chapter05.Hanoi(3, "A", "C", "B")
	if len(moves3) != 7 {
		t.Errorf("Hanoi(3,...) len = %d; want 7", len(moves3))
	}
}

func TestMazeSolve(t *testing.T) {
	maze := [][]int{
		{1, 1, 1},
		{1, 0, 1},
		{1, 1, 1},
	}
	got := chapter05.MazeSolve(maze, 1, 1, 1, 1, nil)
	if !got {
		t.Error("MazeSolve should return true for start==goal")
	}
}

func TestEightQueen(t *testing.T) {
	q := &chapter05.EightQueen{}
	q.Set(0)
	// 全組み合わせ: 8^8 = 16777216
	if len(q.Result) != 16777216 {
		t.Errorf("EightQueen len(Result) = %d; want 16777216", len(q.Result))
	}
}

func TestEightQueen2(t *testing.T) {
	q := &chapter05.EightQueen2{}
	q.Set(0)
	// 行制約のみ: 8! = 40320
	if len(q.Result) != 40320 {
		t.Errorf("EightQueen2 len(Result) = %d; want 40320", len(q.Result))
	}
}

func TestEightQueen3(t *testing.T) {
	q := &chapter05.EightQueen3{}
	q.Set(0)
	// 完全な8王妃問題: 92通り
	if len(q.Result) != 92 {
		t.Errorf("EightQueen3 len(Result) = %d; want 92", len(q.Result))
	}
}
