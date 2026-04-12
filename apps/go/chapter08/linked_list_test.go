package chapter08_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter08"
)

func TestLinkedList(t *testing.T) {
	ll := chapter08.NewLinkedList()

	if ll.Len() != 0 {
		t.Errorf("new list Len() = %d; want 0", ll.Len())
	}

	ll.AddFirst(1)
	ll.AddFirst(2)
	ll.AddLast(3)

	// 2 -> 1 -> 3
	if ll.Len() != 3 {
		t.Errorf("Len() = %d; want 3", ll.Len())
	}

	if !ll.Contains(1) {
		t.Error("Contains(1) should be true")
	}
	if ll.Contains(99) {
		t.Error("Contains(99) should be false")
	}

	ll.RemoveFirst()
	if ll.Len() != 2 {
		t.Errorf("after RemoveFirst Len() = %d; want 2", ll.Len())
	}

	ll.RemoveLast()
	if ll.Len() != 1 {
		t.Errorf("after RemoveLast Len() = %d; want 1", ll.Len())
	}
}

func TestDoublyLinkedList(t *testing.T) {
	dll := chapter08.NewDoublyLinkedList()

	dll.AddFirst(1)
	dll.AddFirst(2)
	dll.AddLast(3)

	if dll.Len() != 3 {
		t.Errorf("DoublyLinkedList Len() = %d; want 3", dll.Len())
	}

	if !dll.Contains(3) {
		t.Error("DoublyLinkedList Contains(3) should be true")
	}

	dll.RemoveFirst()
	if dll.Len() != 2 {
		t.Errorf("after RemoveFirst Len() = %d; want 2", dll.Len())
	}
}
