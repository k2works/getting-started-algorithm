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
