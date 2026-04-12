package chapter06_test

import (
	"reflect"
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter06"
)

var sortInput = []int{6, 4, 3, 7, 1, 9, 8}
var sortExpected = []int{1, 3, 4, 6, 7, 8, 9}

func copySlice(a []int) []int {
	b := make([]int, len(a))
	copy(b, a)
	return b
}

func TestBubbleSort(t *testing.T) {
	a := copySlice(sortInput)
	chapter06.BubbleSort(a)
	if !reflect.DeepEqual(a, sortExpected) {
		t.Errorf("BubbleSort = %v; want %v", a, sortExpected)
	}
}

func TestSelectionSort(t *testing.T) {
	a := copySlice(sortInput)
	chapter06.SelectionSort(a)
	if !reflect.DeepEqual(a, sortExpected) {
		t.Errorf("SelectionSort = %v; want %v", a, sortExpected)
	}
}

func TestInsertionSort(t *testing.T) {
	a := copySlice(sortInput)
	chapter06.InsertionSort(a)
	if !reflect.DeepEqual(a, sortExpected) {
		t.Errorf("InsertionSort = %v; want %v", a, sortExpected)
	}
}

func TestQuickSort(t *testing.T) {
	a := copySlice(sortInput)
	chapter06.QuickSort(a, 0, len(a)-1)
	if !reflect.DeepEqual(a, sortExpected) {
		t.Errorf("QuickSort = %v; want %v", a, sortExpected)
	}
}

func TestMergeSort(t *testing.T) {
	a := copySlice(sortInput)
	chapter06.MergeSort(a, 0, len(a)-1)
	if !reflect.DeepEqual(a, sortExpected) {
		t.Errorf("MergeSort = %v; want %v", a, sortExpected)
	}
}
