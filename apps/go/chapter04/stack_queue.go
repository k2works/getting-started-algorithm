// Package chapter04 第4章 スタックとキュー
package chapter04

import "errors"

var (
	errEmpty = errors.New("stack/queue is empty")
	errFull  = errors.New("stack is full")
)

// Stack 固定長スタック
type Stack struct {
	data     []int
	capacity int
	ptr      int
}

// NewStack 指定した容量のスタックを生成する
func NewStack(capacity int) *Stack {
	return &Stack{data: make([]int, capacity), capacity: capacity}
}

// Len スタックに積まれた要素数を返す
func (s *Stack) Len() int { return s.ptr }

// IsEmpty スタックが空かどうかを判定する
func (s *Stack) IsEmpty() bool { return s.ptr == 0 }

// IsFull スタックが満杯かどうかを判定する
func (s *Stack) IsFull() bool { return s.ptr == s.capacity }

// Push スタックに値をプッシュする
func (s *Stack) Push(v int) error {
	if s.IsFull() {
		return errFull
	}
	s.data[s.ptr] = v
	s.ptr++
	return nil
}

// Pop スタックからポップする
func (s *Stack) Pop() (int, error) {
	if s.IsEmpty() {
		return 0, errEmpty
	}
	s.ptr--
	return s.data[s.ptr], nil
}

// Peek スタックの先頭要素を参照する（取り出さない）
func (s *Stack) Peek() (int, error) {
	if s.IsEmpty() {
		return 0, errEmpty
	}
	return s.data[s.ptr-1], nil
}

// Contains スタック内に値が含まれるかを確認する
func (s *Stack) Contains(v int) bool {
	for i := 0; i < s.ptr; i++ {
		if s.data[i] == v {
			return true
		}
	}
	return false
}

// Find スタック内のvを探索してインデックスを返す（底からのインデックス、見つからなければ-1）
func (s *Stack) Find(v int) int {
	for i := s.ptr - 1; i >= 0; i-- {
		if s.data[i] == v {
			return i
		}
	}
	return -1
}

// Count スタック内のvの個数を返す
func (s *Stack) Count(v int) int {
	c := 0
	for i := 0; i < s.ptr; i++ {
		if s.data[i] == v {
			c++
		}
	}
	return c
}

// Clear スタックを空にする
func (s *Stack) Clear() { s.ptr = 0 }

// Queue 固定長キュー（リングバッファ）
type Queue struct {
	data     []int
	capacity int
	front    int
	rear     int
	num      int
}

// NewQueue 指定した容量のキューを生成する
func NewQueue(capacity int) *Queue {
	return &Queue{data: make([]int, capacity), capacity: capacity}
}

// Len キュー内の要素数を返す
func (q *Queue) Len() int { return q.num }

// IsEmpty キューが空かどうかを判定する
func (q *Queue) IsEmpty() bool { return q.num == 0 }

// IsFull キューが満杯かどうかを判定する
func (q *Queue) IsFull() bool { return q.num == q.capacity }

// Enqueue キューに値を追加する
func (q *Queue) Enqueue(v int) error {
	if q.IsFull() {
		return errFull
	}
	q.data[q.rear] = v
	q.rear = (q.rear + 1) % q.capacity
	q.num++
	return nil
}

// Dequeue キューから値を取り出す
func (q *Queue) Dequeue() (int, error) {
	if q.IsEmpty() {
		return 0, errEmpty
	}
	v := q.data[q.front]
	q.front = (q.front + 1) % q.capacity
	q.num--
	return v, nil
}

// Peek キューの先頭要素を参照する（取り出さない）
func (q *Queue) Peek() (int, error) {
	if q.IsEmpty() {
		return 0, errEmpty
	}
	return q.data[q.front], nil
}

// Find キュー内のvを探索して先頭からのインデックスを返す（見つからなければ-1）
func (q *Queue) Find(v int) int {
	for i := 0; i < q.num; i++ {
		idx := (i + q.front) % q.capacity
		if q.data[idx] == v {
			return i
		}
	}
	return -1
}

// Count キュー内のvの個数を返す
func (q *Queue) Count(v int) int {
	c := 0
	for i := 0; i < q.num; i++ {
		idx := (i + q.front) % q.capacity
		if q.data[idx] == v {
			c++
		}
	}
	return c
}

// Clear キューを空にする
func (q *Queue) Clear() { q.front, q.rear, q.num = 0, 0, 0 }
