package chapter04_test

import (
	"testing"

	"github.com/k2works/getting-started-algorithm/go/chapter04"
)

func TestStack(t *testing.T) {
	s := chapter04.NewStack(5)

	if !s.IsEmpty() {
		t.Error("new stack should be empty")
	}

	s.Push(1)
	s.Push(2)
	s.Push(3)

	val, err := s.Peek()
	if err != nil || val != 3 {
		t.Errorf("Peek() = %v, %v; want 3, nil", val, err)
	}

	val, err = s.Pop()
	if err != nil || val != 3 {
		t.Errorf("Pop() = %v, %v; want 3, nil", val, err)
	}

	if s.Len() != 2 {
		t.Errorf("Len() = %d; want 2", s.Len())
	}

	if !s.Contains(2) {
		t.Error("Contains(2) should be true")
	}
}

func TestStackEmpty(t *testing.T) {
	s := chapter04.NewStack(3)
	_, err := s.Pop()
	if err == nil {
		t.Error("Pop on empty stack should return error")
	}
}

func TestStackFull(t *testing.T) {
	s := chapter04.NewStack(2)
	s.Push(1)
	s.Push(2)
	err := s.Push(3)
	if err == nil {
		t.Error("Push on full stack should return error")
	}
}

func TestQueue(t *testing.T) {
	q := chapter04.NewQueue(5)

	if !q.IsEmpty() {
		t.Error("new queue should be empty")
	}

	q.Enqueue(1)
	q.Enqueue(2)
	q.Enqueue(3)

	val, err := q.Dequeue()
	if err != nil || val != 1 {
		t.Errorf("Dequeue() = %v, %v; want 1, nil", val, err)
	}

	if q.Len() != 2 {
		t.Errorf("Len() = %d; want 2", q.Len())
	}
}

func TestQueueEmpty(t *testing.T) {
	q := chapter04.NewQueue(3)
	_, err := q.Dequeue()
	if err == nil {
		t.Error("Dequeue on empty queue should return error")
	}
}

func TestStackFindCountClear(t *testing.T) {
	s := chapter04.NewStack(5)
	s.Push(1)
	s.Push(2)
	s.Push(1)

	if s.Find(2) == -1 {
		t.Error("Find(2) should find 2")
	}
	if s.Find(99) != -1 {
		t.Error("Find(99) should return -1")
	}
	if s.Count(1) != 2 {
		t.Errorf("Count(1) = %d; want 2", s.Count(1))
	}
	s.Clear()
	if s.Len() != 0 {
		t.Errorf("after Clear Len() = %d; want 0", s.Len())
	}
}

func TestQueuePeekFindCountClear(t *testing.T) {
	q := chapter04.NewQueue(5)
	q.Enqueue(1)
	q.Enqueue(2)
	q.Enqueue(1)

	val, err := q.Peek()
	if err != nil || val != 1 {
		t.Errorf("Peek() = %v, %v; want 1, nil", val, err)
	}
	if q.Find(2) != 1 {
		t.Errorf("Find(2) = %d; want 1", q.Find(2))
	}
	if q.Find(99) != -1 {
		t.Error("Find(99) should return -1")
	}
	if q.Count(1) != 2 {
		t.Errorf("Count(1) = %d; want 2", q.Count(1))
	}
	q.Clear()
	if q.Len() != 0 {
		t.Errorf("after Clear Len() = %d; want 0", q.Len())
	}
}
