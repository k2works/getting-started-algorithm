# 第 8 章 リスト

## はじめに

Go ではポインタを使って連結リストを実装します。ガベージコレクションがあるためメモリ管理は自動です。

---

## 1. 線形リスト（単方向連結リスト）

```go
type node struct {
    data int
    next *node
}

type LinkedList struct {
    head *node
    no   int
}

func NewLinkedList() *LinkedList {
    return &LinkedList{}
}

func (l *LinkedList) AddFirst(data int) {
    l.head = &node{data: data, next: l.head}
    l.no++
}

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
```

---

## 2. 要素の探索

```go
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
```

---

## 3. 双方向連結リスト

```go
type dnode struct {
    data int
    prev *dnode
    next *dnode
}

type DoublyLinkedList struct {
    head *dnode
    tail *dnode
    no   int
}

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
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| ノード | `class _Node:` | `type node struct { ... }` |
| 参照 | オブジェクト参照（自動） | ポインタ `*node` |
| None チェック | `if ptr is None:` | `if ptr == nil {` |
| コンストラクタ | `_Node(data, next_node)` | `&node{data: data, next: ...}` |
| メモリ解放 | GC（自動） | GC（自動） |
