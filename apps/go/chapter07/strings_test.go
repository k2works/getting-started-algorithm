package chapter07_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter07"
)

func TestBfMatch(t *testing.T) {
	got := chapter07.BfMatch("ABCXDEZCABACABAB", "ABAB")
	if got != 12 {
		t.Errorf("BfMatch(...) = %d; want 12", got)
	}
	got = chapter07.BfMatch("ABCXDEZCABACABAB", "XYZ")
	if got != -1 {
		t.Errorf("BfMatch(no match) = %d; want -1", got)
	}
}

func TestKmpMatch(t *testing.T) {
	got := chapter07.KmpMatch("ABCXDEZCABACABAB", "ABAB")
	if got != 12 {
		t.Errorf("KmpMatch(...) = %d; want 12", got)
	}
}

func TestBmMatch(t *testing.T) {
	got := chapter07.BmMatch("ABCXDEZCABACABAB", "ABAB")
	if got != 12 {
		t.Errorf("BmMatch(...) = %d; want 12", got)
	}
}
