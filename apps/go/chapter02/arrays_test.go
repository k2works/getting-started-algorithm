package chapter02_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter02"
)

func TestMaxOf(t *testing.T) {
	got := chapter02.MaxOf([]int{172, 153, 192, 140, 165})
	if got != 192 {
		t.Errorf("MaxOf(...) = %d; want 192", got)
	}
}

func TestReverseArray(t *testing.T) {
	a := []int{2, 5, 1, 3, 9, 6, 7}
	chapter02.ReverseArray(a)
	expected := []int{7, 6, 9, 3, 1, 5, 2}
	for i, v := range a {
		if v != expected[i] {
			t.Errorf("ReverseArray index %d = %d; want %d", i, v, expected[i])
		}
	}
}

func TestCardConv(t *testing.T) {
	tests := []struct {
		x, r     int
		expected string
	}{
		{29, 2, "11101"},
		{255, 16, "FF"},
	}
	for _, tt := range tests {
		got := chapter02.CardConv(tt.x, tt.r)
		if got != tt.expected {
			t.Errorf("CardConv(%d,%d) = %q; want %q", tt.x, tt.r, got, tt.expected)
		}
	}
}

func TestPrime1(t *testing.T) {
	got := chapter02.Prime1(1000)
	if got != 78022 {
		t.Errorf("Prime1(1000) = %d; want 78022", got)
	}
}

func TestPrime2(t *testing.T) {
	got := chapter02.Prime2(1000)
	if got != 14622 {
		t.Errorf("Prime2(1000) = %d; want 14622", got)
	}
}

func TestPrime3(t *testing.T) {
	got := chapter02.Prime3(1000)
	if got != 3774 {
		t.Errorf("Prime3(1000) = %d; want 3774", got)
	}
}
