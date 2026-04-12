// Package chapter08 第8章 リスト（連結リスト）
package chapter08

// --- 単方向連結リスト ---

type node struct {
	data int
	next *node
}

// LinkedList 単方向連結リスト
type LinkedList struct {
	head *node
	no   int
}

// NewLinkedList 新しい連結リストを生成する
func NewLinkedList() *LinkedList {
	return &LinkedList{}
}

// Len リストの要素数を返す
func (l *LinkedList) Len() int { return l.no }

// Contains リストにdataが含まれるかを確認する
func (l *LinkedList) Contains(data int) bool {
	ptr := l.head
	for ptr != nil {
		if ptr.data == data {
			return true
		}
		ptr = ptr.next
	}
	return false
}

// AddFirst 先頭にノードを挿入する
func (l *LinkedList) AddFirst(data int) {
	l.head = &node{data: data, next: l.head}
	l.no++
}

// AddLast 末尾にノードを挿入する
func (l *LinkedList) AddLast(data int) {
	n := &node{data: data}
	if l.head == nil {
		l.head = n
	} else {
		ptr := l.head
		for ptr.next != nil {
			ptr = ptr.next
		}
		ptr.next = n
	}
	l.no++
}

// RemoveFirst 先頭ノードを削除する
func (l *LinkedList) RemoveFirst() {
	if l.head != nil {
		l.head = l.head.next
		l.no--
	}
}

// RemoveLast 末尾ノードを削除する
func (l *LinkedList) RemoveLast() {
	if l.head == nil {
		return
	}
	if l.head.next == nil {
		l.head = nil
	} else {
		ptr := l.head
		for ptr.next != nil && ptr.next.next != nil {
			ptr = ptr.next
		}
		ptr.next = nil
	}
	l.no--
}

// --- 双方向連結リスト ---

type dnode struct {
	data int
	prev *dnode
	next *dnode
}

// DoublyLinkedList 双方向連結リスト
type DoublyLinkedList struct {
	head *dnode
	tail *dnode
	no   int
}

// NewDoublyLinkedList 新しい双方向連結リストを生成する
func NewDoublyLinkedList() *DoublyLinkedList {
	return &DoublyLinkedList{}
}

// Len リストの要素数を返す
func (l *DoublyLinkedList) Len() int { return l.no }

// Contains リストにdataが含まれるかを確認する
func (l *DoublyLinkedList) Contains(data int) bool {
	ptr := l.head
	for ptr != nil {
		if ptr.data == data {
			return true
		}
		ptr = ptr.next
	}
	return false
}

// AddFirst 先頭にノードを挿入する
func (l *DoublyLinkedList) AddFirst(data int) {
	n := &dnode{data: data, next: l.head}
	if l.head != nil {
		l.head.prev = n
	} else {
		l.tail = n
	}
	l.head = n
	l.no++
}

// AddLast 末尾にノードを挿入する
func (l *DoublyLinkedList) AddLast(data int) {
	n := &dnode{data: data, prev: l.tail}
	if l.tail != nil {
		l.tail.next = n
	} else {
		l.head = n
	}
	l.tail = n
	l.no++
}

// RemoveFirst 先頭ノードを削除する
func (l *DoublyLinkedList) RemoveFirst() {
	if l.head == nil {
		return
	}
	l.head = l.head.next
	if l.head != nil {
		l.head.prev = nil
	} else {
		l.tail = nil
	}
	l.no--
}
