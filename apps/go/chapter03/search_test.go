package chapter03_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter03"
)

func TestSsearchWhile(t *testing.T) {
	a := []int{6, 4, 3, 2, 1, 2, 8}
	got := chapter03.SsearchWhile(a, 2)
	if got != 3 {
		t.Errorf("SsearchWhile(..., 2) = %d; want 3", got)
	}
	got = chapter03.SsearchWhile(a, 99)
	if got != -1 {
		t.Errorf("SsearchWhile(..., 99) = %d; want -1", got)
	}
}

func TestSsearchFor(t *testing.T) {
	a := []int{6, 4, 3, 2, 1, 2, 8}
	got := chapter03.SsearchFor(a, 2)
	if got != 3 {
		t.Errorf("SsearchFor(..., 2) = %d; want 3", got)
	}
}

func TestBsearch(t *testing.T) {
	a := []int{1, 2, 3, 5, 7, 8, 9}
	got := chapter03.Bsearch(a, 5)
	if got != 3 {
		t.Errorf("Bsearch(..., 5) = %d; want 3", got)
	}
	got = chapter03.Bsearch(a, 99)
	if got != -1 {
		t.Errorf("Bsearch(..., 99) = %d; want -1", got)
	}
}

func TestHashTable(t *testing.T) {
	ht := chapter03.NewHashTable(10)
	ht.Add(1, "one")
	ht.Add(2, "two")
	ht.Add(3, "three")

	val, ok := ht.Search(2)
	if !ok || val != "two" {
		t.Errorf("HashTable.Search(2) = %v, %v; want two, true", val, ok)
	}

	_, ok = ht.Search(99)
	if ok {
		t.Error("HashTable.Search(99) should not be found")
	}

	ht.Remove(2)
	_, ok = ht.Search(2)
	if ok {
		t.Error("HashTable.Search(2) should not be found after Remove")
	}
}
