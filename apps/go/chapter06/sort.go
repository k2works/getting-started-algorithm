// Package chapter06 第6章 ソートアルゴリズム
package chapter06

// BubbleSort バブルソート（in-place）
func BubbleSort(a []int) {
	n := len(a)
	for i := 0; i < n-1; i++ {
		swapped := false
		for j := n - 1; j > i; j-- {
			if a[j-1] > a[j] {
				a[j-1], a[j] = a[j], a[j-1]
				swapped = true
			}
		}
		if !swapped {
			break
		}
	}
}

// SelectionSort 選択ソート（in-place）
func SelectionSort(a []int) {
	n := len(a)
	for i := 0; i < n-1; i++ {
		minIdx := i
		for j := i + 1; j < n; j++ {
			if a[j] < a[minIdx] {
				minIdx = j
			}
		}
		if minIdx != i {
			a[i], a[minIdx] = a[minIdx], a[i]
		}
	}
}

// InsertionSort 挿入ソート（in-place）
func InsertionSort(a []int) {
	n := len(a)
	for i := 1; i < n; i++ {
		key := a[i]
		j := i - 1
		for j >= 0 && a[j] > key {
			a[j+1] = a[j]
			j--
		}
		a[j+1] = key
	}
}

// ShellSort シェルソート（in-place）
// Knuth 数列（1, 4, 13, 40, ...）を使用。
func ShellSort(a []int) {
	n := len(a)
	gap := 1
	for gap*3+1 < n {
		gap = gap*3 + 1
	}
	for gap > 0 {
		for i := gap; i < n; i++ {
			key := a[i]
			j := i - gap
			for j >= 0 && a[j] > key {
				a[j+gap] = a[j]
				j -= gap
			}
			a[j+gap] = key
		}
		gap /= 3
	}
}

// QuickSort クイックソート（in-place）
func QuickSort(a []int, left, right int) {
	if left >= right {
		return
	}
	pivot := a[(left+right)/2]
	i, j := left, right
	for i <= j {
		for a[i] < pivot {
			i++
		}
		for a[j] > pivot {
			j--
		}
		if i <= j {
			a[i], a[j] = a[j], a[i]
			i++
			j--
		}
	}
	QuickSort(a, left, j)
	QuickSort(a, i, right)
}

// MergeSort マージソート
func MergeSort(a []int, left, right int) {
	if left >= right {
		return
	}
	mid := (left + right) / 2
	MergeSort(a, left, mid)
	MergeSort(a, mid+1, right)
	merge(a, left, mid, right)
}

func merge(a []int, left, mid, right int) {
	tmp := make([]int, right-left+1)
	i, j, k := left, mid+1, 0
	for i <= mid && j <= right {
		if a[i] <= a[j] {
			tmp[k] = a[i]
			i++
		} else {
			tmp[k] = a[j]
			j++
		}
		k++
	}
	for i <= mid {
		tmp[k] = a[i]
		i++
		k++
	}
	for j <= right {
		tmp[k] = a[j]
		j++
		k++
	}
	copy(a[left:], tmp)
}

// HeapSort ヒープソート（in-place）
// 最大ヒープを構築してから最大値を末尾に移動することを繰り返す。
func HeapSort(a []int) {
	n := len(a)
	for i := (n-1)/2 - 1 + 1; i >= 0; i-- {
		downHeap(a, i, n-1)
	}
	for i := n - 1; i > 0; i-- {
		a[0], a[i] = a[i], a[0]
		downHeap(a, 0, i-1)
	}
}

func downHeap(a []int, left, right int) {
	temp := a[left]
	parent := left
	for parent < (right+1)/2 {
		cl := parent*2 + 1
		cr := cl + 1
		child := cl
		if cr <= right && a[cr] > a[cl] {
			child = cr
		}
		if temp >= a[child] {
			break
		}
		a[parent] = a[child]
		parent = child
	}
	a[parent] = temp
}

// CountingSort 度数ソート（計数ソート）— 新しいスライスを返す
// 非負整数のみ対応。計算量: O(n + k)（k は値の最大値）
func CountingSort(a []int) []int {
	if len(a) == 0 {
		return []int{}
	}
	maxVal := a[0]
	for _, v := range a {
		if v > maxVal {
			maxVal = v
		}
	}
	freq := make([]int, maxVal+1)
	for _, v := range a {
		freq[v]++
	}
	for i := 1; i < len(freq); i++ {
		freq[i] += freq[i-1]
	}
	result := make([]int, len(a))
	for i := len(a) - 1; i >= 0; i-- {
		freq[a[i]]--
		result[freq[a[i]]] = a[i]
	}
	return result
}
