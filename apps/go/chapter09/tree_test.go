package chapter09_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter09"
)

func TestBST(t *testing.T) {
	bst := chapter09.NewBST()

	if bst.Len() != 0 {
		t.Errorf("new BST Len() = %d; want 0", bst.Len())
	}

	bst.Insert(5)
	bst.Insert(3)
	bst.Insert(7)
	bst.Insert(1)

	if bst.Len() != 4 {
		t.Errorf("BST Len() = %d; want 4", bst.Len())
	}

	if !bst.Contains(3) {
		t.Error("BST Contains(3) should be true")
	}
	if bst.Contains(99) {
		t.Error("BST Contains(99) should be false")
	}

	bst.Remove(3)
	if bst.Contains(3) {
		t.Error("BST Contains(3) should be false after Remove")
	}
	if bst.Len() != 3 {
		t.Errorf("BST Len() after Remove = %d; want 3", bst.Len())
	}
}

func TestHeap(t *testing.T) {
	h := chapter09.NewMinHeap()

	h.Push(5)
	h.Push(3)
	h.Push(7)
	h.Push(1)

	val, err := h.Pop()
	if err != nil || val != 1 {
		t.Errorf("MinHeap Pop() = %v, %v; want 1, nil", val, err)
	}

	val, err = h.Pop()
	if err != nil || val != 3 {
		t.Errorf("MinHeap Pop() = %v, %v; want 3, nil", val, err)
	}
}

func TestHeapEmpty(t *testing.T) {
	h := chapter09.NewMinHeap()
	_, err := h.Pop()
	if err == nil {
		t.Error("Pop on empty heap should return error")
	}
}

func TestBSTTraversal(t *testing.T) {
	bst := chapter09.NewBST()
	for _, v := range []int{5, 3, 7, 1, 4} {
		bst.Insert(v)
	}

	inorder := bst.Inorder()
	expected := []int{1, 3, 4, 5, 7}
	for i, v := range expected {
		if inorder[i] != v {
			t.Errorf("Inorder[%d] = %d; want %d", i, inorder[i], v)
		}
	}

	min, err := bst.Min()
	if err != nil || min != 1 {
		t.Errorf("Min() = %v, %v; want 1, nil", min, err)
	}

	max, err := bst.Max()
	if err != nil || max != 7 {
		t.Errorf("Max() = %v, %v; want 7, nil", max, err)
	}

	preorder := bst.Preorder()
	if preorder[0] != 5 {
		t.Errorf("Preorder[0] = %d; want 5 (root)", preorder[0])
	}

	postorder := bst.Postorder()
	if postorder[len(postorder)-1] != 5 {
		t.Errorf("Postorder last = %d; want 5 (root)", postorder[len(postorder)-1])
	}
}
