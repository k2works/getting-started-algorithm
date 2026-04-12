// Package chapter09 第9章 木構造
package chapter09

import "errors"

// --- 二分探索木 ---

type bstNode struct {
	key   int
	left  *bstNode
	right *bstNode
}

// BST 二分探索木
type BST struct {
	root *bstNode
	no   int
}

// NewBST 新しい二分探索木を生成する
func NewBST() *BST { return &BST{} }

// Len ノード数を返す
func (t *BST) Len() int { return t.no }

// Contains キーが存在するかを確認する
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

// Insert キーを挿入する（重複は無視）
func (t *BST) Insert(key int) {
	if t.root == nil {
		t.root = &bstNode{key: key}
		t.no++
		return
	}
	ptr := t.root
	for {
		if key == ptr.key {
			return
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

// Remove キーを削除する
func (t *BST) Remove(key int) {
	t.root = removeNode(t.root, key, &t.no)
}

// Min 最小キーを返す
func (t *BST) Min() (int, error) {
	if t.root == nil {
		return 0, errors.New("BST is empty")
	}
	ptr := t.root
	for ptr.left != nil {
		ptr = ptr.left
	}
	return ptr.key, nil
}

// Max 最大キーを返す
func (t *BST) Max() (int, error) {
	if t.root == nil {
		return 0, errors.New("BST is empty")
	}
	ptr := t.root
	for ptr.right != nil {
		ptr = ptr.right
	}
	return ptr.key, nil
}

// Inorder 中順探索（昇順）でキーのスライスを返す
func (t *BST) Inorder() []int {
	result := []int{}
	inorderTraversal(t.root, &result)
	return result
}

func inorderTraversal(n *bstNode, result *[]int) {
	if n == nil {
		return
	}
	inorderTraversal(n.left, result)
	*result = append(*result, n.key)
	inorderTraversal(n.right, result)
}

// Preorder 前順探索でキーのスライスを返す
func (t *BST) Preorder() []int {
	result := []int{}
	preorderTraversal(t.root, &result)
	return result
}

func preorderTraversal(n *bstNode, result *[]int) {
	if n == nil {
		return
	}
	*result = append(*result, n.key)
	preorderTraversal(n.left, result)
	preorderTraversal(n.right, result)
}

// Postorder 後順探索でキーのスライスを返す
func (t *BST) Postorder() []int {
	result := []int{}
	postorderTraversal(t.root, &result)
	return result
}

func postorderTraversal(n *bstNode, result *[]int) {
	if n == nil {
		return
	}
	postorderTraversal(n.left, result)
	postorderTraversal(n.right, result)
	*result = append(*result, n.key)
}

func removeNode(n *bstNode, key int, count *int) *bstNode {
	if n == nil {
		return nil
	}
	if key < n.key {
		n.left = removeNode(n.left, key, count)
	} else if key > n.key {
		n.right = removeNode(n.right, key, count)
	} else {
		*count--
		if n.left == nil {
			return n.right
		}
		if n.right == nil {
			return n.left
		}
		// 右部分木の最小ノードと交換
		min := n.right
		for min.left != nil {
			min = min.left
		}
		n.key = min.key
		*count++
		n.right = removeNode(n.right, min.key, count)
	}
	return n
}

// --- 最小ヒープ ---

// MinHeap 最小ヒープ
type MinHeap struct {
	data []int
}

// NewMinHeap 新しい最小ヒープを生成する
func NewMinHeap() *MinHeap { return &MinHeap{} }

// Push 値をヒープに追加する
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

// Pop 最小値を取り出す
func (h *MinHeap) Pop() (int, error) {
	if len(h.data) == 0 {
		return 0, errors.New("heap is empty")
	}
	min := h.data[0]
	n := len(h.data) - 1
	h.data[0] = h.data[n]
	h.data = h.data[:n]
	i := 0
	for {
		left, right := 2*i+1, 2*i+2
		smallest := i
		if left < n && h.data[left] < h.data[smallest] {
			smallest = left
		}
		if right < n && h.data[right] < h.data[smallest] {
			smallest = right
		}
		if smallest == i {
			break
		}
		h.data[i], h.data[smallest] = h.data[smallest], h.data[i]
		i = smallest
	}
	return min, nil
}
