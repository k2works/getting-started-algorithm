# 第 9 章 木構造

## はじめに

木構造は階層的なデータを表現するデータ構造です。Go ではポインタを使って実装します。

---

## 1. 二分探索木（BST）

```go
type bstNode struct {
    key   int
    left  *bstNode
    right *bstNode
}

type BST struct {
    root *bstNode
    no   int
}

func (t *BST) Insert(key int) {
    if t.root == nil {
        t.root = &bstNode{key: key}
        t.no++
        return
    }
    ptr := t.root
    for {
        if key == ptr.key {
            return // 重複は無視
        } else if key < ptr.key {
            if ptr.left == nil {
                ptr.left = &bstNode{key: key}
                t.no++
                return
            }
            ptr = ptr.left
        } else {
            if ptr.right == nil {
                ptr.right = &bstNode{key: key}
                t.no++
                return
            }
            ptr = ptr.right
        }
    }
}

func (t *BST) Contains(key int) bool {
    ptr := t.root
    for ptr != nil {
        if key == ptr.key {
            return true
        } else if key < ptr.key {
            ptr = ptr.left
        } else {
            ptr = ptr.right
        }
    }
    return false
}
```

---

## 2. ヒープ（最小ヒープ）

```go
type MinHeap struct {
    data []int
}

func (h *MinHeap) Push(v int) {
    h.data = append(h.data, v)
    i := len(h.data) - 1
    for i > 0 {
        parent := (i - 1) / 2
        if h.data[parent] <= h.data[i] {
            break
        }
        h.data[parent], h.data[i] = h.data[i], h.data[parent]
        i = parent
    }
}

func (h *MinHeap) Pop() (int, error) {
    if len(h.data) == 0 {
        return 0, errors.New("heap is empty")
    }
    min := h.data[0]
    // 末尾を先頭に移動してヒープ化
    n := len(h.data) - 1
    h.data[0] = h.data[n]
    h.data = h.data[:n]
    // ヒープダウン
    i := 0
    for {
        left, right, smallest := 2*i+1, 2*i+2, i
        if left < n && h.data[left] < h.data[smallest] { smallest = left }
        if right < n && h.data[right] < h.data[smallest] { smallest = right }
        if smallest == i { break }
        h.data[i], h.data[smallest] = h.data[smallest], h.data[i]
        i = smallest
    }
    return min, nil
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| ノード | `class _BSTNode:` | `type bstNode struct { ... }` |
| None | `None` | `nil` |
| ヒープ | `heapq` モジュール | 手動実装 or `container/heap` |
| 削除（複数戻り値）| `def remove(key)` | `func (t *BST) Remove(key int)` |
