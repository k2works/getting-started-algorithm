package chapter01_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter01"
)

// --- Max3 ---

func TestMax3(t *testing.T) {
	tests := []struct {
		a, b, c  int
		expected int
	}{
		{3, 2, 1, 3},
		{3, 2, 2, 3},
		{3, 1, 2, 3},
		{3, 2, 3, 3},
		{2, 1, 3, 3},
		{3, 3, 2, 3},
		{3, 3, 3, 3},
		{2, 2, 3, 3},
		{2, 3, 1, 3},
		{2, 3, 2, 3},
		{1, 3, 2, 3},
		{2, 3, 3, 3},
		{1, 2, 3, 3},
	}
	for _, tt := range tests {
		got := chapter01.Max3(tt.a, tt.b, tt.c)
		if got != tt.expected {
			t.Errorf("Max3(%d,%d,%d) = %d; want %d", tt.a, tt.b, tt.c, got, tt.expected)
		}
	}
}

// --- Med3 ---

func TestMed3(t *testing.T) {
	tests := []struct {
		a, b, c  int
		expected int
	}{
		{3, 2, 1, 2},
		{3, 2, 2, 2},
		{3, 1, 2, 2},
		{3, 2, 3, 3},
		{2, 1, 3, 2},
		{3, 3, 2, 3},
		{3, 3, 3, 3},
		{2, 2, 3, 2},
		{2, 3, 1, 2},
		{2, 3, 2, 2},
		{1, 3, 2, 2},
		{2, 3, 3, 3},
		{1, 2, 3, 2},
	}
	for _, tt := range tests {
		got := chapter01.Med3(tt.a, tt.b, tt.c)
		if got != tt.expected {
			t.Errorf("Med3(%d,%d,%d) = %d; want %d", tt.a, tt.b, tt.c, got, tt.expected)
		}
	}
}

// --- JudgeSign ---

func TestJudgeSign(t *testing.T) {
	tests := []struct {
		n        int
		expected string
	}{
		{17, "その値は正です。"},
		{-5, "その値は負です。"},
		{0, "その値は0です。"},
	}
	for _, tt := range tests {
		got := chapter01.JudgeSign(tt.n)
		if got != tt.expected {
			t.Errorf("JudgeSign(%d) = %q; want %q", tt.n, got, tt.expected)
		}
	}
}

// --- Sum1ToN ---

func TestSum1ToNWhile(t *testing.T) {
	got := chapter01.Sum1ToNWhile(5)
	if got != 15 {
		t.Errorf("Sum1ToNWhile(5) = %d; want 15", got)
	}
}

func TestSum1ToNFor(t *testing.T) {
	got := chapter01.Sum1ToNFor(5)
	if got != 15 {
		t.Errorf("Sum1ToNFor(5) = %d; want 15", got)
	}
}

// --- Alternative ---

func TestAlternative1(t *testing.T) {
	tests := []struct {
		n        int
		expected string
	}{
		{12, "+-+-+-+-+-+-"},
		{5, "+-+-+"},
	}
	for _, tt := range tests {
		got := chapter01.Alternative1(tt.n)
		if got != tt.expected {
			t.Errorf("Alternative1(%d) = %q; want %q", tt.n, got, tt.expected)
		}
	}
}

func TestAlternative2(t *testing.T) {
	tests := []struct {
		n        int
		expected string
	}{
		{12, "+-+-+-+-+-+-"},
		{5, "+-+-+"},
	}
	for _, tt := range tests {
		got := chapter01.Alternative2(tt.n)
		if got != tt.expected {
			t.Errorf("Alternative2(%d) = %q; want %q", tt.n, got, tt.expected)
		}
	}
}

// --- Rectangle ---

func TestRectangle(t *testing.T) {
	got := chapter01.Rectangle(32)
	if got != "1x32 2x16 4x8 " {
		t.Errorf("Rectangle(32) = %q; want %q", got, "1x32 2x16 4x8 ")
	}
}

// --- MultiplicationTable ---

func TestMultiplicationTable(t *testing.T) {
	got := chapter01.MultiplicationTable()
	if len(got) == 0 {
		t.Error("MultiplicationTable() returned empty string")
	}
}

// --- TriangleLb ---

func TestTriangleLb(t *testing.T) {
	got := chapter01.TriangleLb(5)
	expected := "*\n**\n***\n****\n*****\n"
	if got != expected {
		t.Errorf("TriangleLb(5) = %q; want %q", got, expected)
	}
}
