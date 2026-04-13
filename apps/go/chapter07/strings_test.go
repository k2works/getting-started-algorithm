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

func TestCountChars(t *testing.T) {
	got := chapter07.CountChars("hello")
	expected := map[rune]int{'h': 1, 'e': 1, 'l': 2, 'o': 1}
	for k, v := range expected {
		if got[k] != v {
			t.Errorf("CountChars('hello')[%c] = %d; want %d", k, got[k], v)
		}
	}
}

func TestReverseString(t *testing.T) {
	got := chapter07.ReverseString("hello")
	if got != "olleh" {
		t.Errorf("ReverseString('hello') = %q; want 'olleh'", got)
	}
}

func TestIsPalindrome(t *testing.T) {
	if !chapter07.IsPalindrome("racecar") {
		t.Error("IsPalindrome('racecar') should be true")
	}
	if chapter07.IsPalindrome("hello") {
		t.Error("IsPalindrome('hello') should be false")
	}
}
