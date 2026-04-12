"""第6章 ソートアルゴリズム — テスト"""

from algorithm.sort import (
    bubble_sort,
    counting_sort,
    heap_sort,
    insertion_sort,
    merge_sort,
    quick_sort,
    selection_sort,
    shell_sort,
)

UNSORTED = [6, 4, 3, 7, 1, 9, 8]
SORTED = [1, 3, 4, 6, 7, 8, 9]


class TestBubbleSort:
    """バブルソート"""

    def test_bubble_sort(self):
        a = UNSORTED[:]
        bubble_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        bubble_sort(a)
        assert a == SORTED

    def test_single_element(self):
        a = [42]
        bubble_sort(a)
        assert a == [42]

    def test_empty(self):
        a = []
        bubble_sort(a)
        assert a == []

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        bubble_sort(a)
        assert a == [1, 1, 2, 3, 3]


class TestSelectionSort:
    """選択ソート"""

    def test_selection_sort(self):
        a = UNSORTED[:]
        selection_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        selection_sort(a)
        assert a == SORTED

    def test_single_element(self):
        a = [5]
        selection_sort(a)
        assert a == [5]

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        selection_sort(a)
        assert a == [1, 1, 2, 3, 3]


class TestInsertionSort:
    """挿入ソート"""

    def test_insertion_sort(self):
        a = UNSORTED[:]
        insertion_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        insertion_sort(a)
        assert a == SORTED

    def test_single_element(self):
        a = [7]
        insertion_sort(a)
        assert a == [7]

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        insertion_sort(a)
        assert a == [1, 1, 2, 3, 3]


class TestShellSort:
    """シェルソート"""

    def test_shell_sort(self):
        a = UNSORTED[:]
        shell_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        shell_sort(a)
        assert a == SORTED

    def test_large(self):
        import random
        a = list(range(100))
        random.shuffle(a)
        shell_sort(a)
        assert a == list(range(100))

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        shell_sort(a)
        assert a == [1, 1, 2, 3, 3]


class TestQuickSort:
    """クイックソート"""

    def test_quick_sort(self):
        a = UNSORTED[:]
        quick_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        quick_sort(a)
        assert a == SORTED

    def test_single_element(self):
        a = [1]
        quick_sort(a)
        assert a == [1]

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        quick_sort(a)
        assert a == [1, 1, 2, 3, 3]

    def test_large(self):
        import random
        a = list(range(200))
        random.shuffle(a)
        quick_sort(a)
        assert a == list(range(200))


class TestMergeSort:
    """マージソート"""

    def test_merge_sort(self):
        a = UNSORTED[:]
        result = merge_sort(a)
        assert result == SORTED

    def test_already_sorted(self):
        result = merge_sort(SORTED[:])
        assert result == SORTED

    def test_single_element(self):
        assert merge_sort([5]) == [5]

    def test_empty(self):
        assert merge_sort([]) == []

    def test_duplicates(self):
        result = merge_sort([3, 1, 2, 1, 3])
        assert result == [1, 1, 2, 3, 3]


class TestHeapSort:
    """ヒープソート"""

    def test_heap_sort(self):
        a = UNSORTED[:]
        heap_sort(a)
        assert a == SORTED

    def test_already_sorted(self):
        a = SORTED[:]
        heap_sort(a)
        assert a == SORTED

    def test_single_element(self):
        a = [42]
        heap_sort(a)
        assert a == [42]

    def test_empty(self):
        a = []
        heap_sort(a)
        assert a == []

    def test_duplicates(self):
        a = [3, 1, 2, 1, 3]
        heap_sort(a)
        assert a == [1, 1, 2, 3, 3]


class TestCountingSort:
    """度数ソート"""

    def test_counting_sort(self):
        result = counting_sort(UNSORTED[:])
        assert result == SORTED

    def test_already_sorted(self):
        result = counting_sort(SORTED[:])
        assert result == SORTED

    def test_single_element(self):
        assert counting_sort([5]) == [5]

    def test_empty(self):
        assert counting_sort([]) == []

    def test_duplicates(self):
        result = counting_sort([3, 1, 2, 1, 3])
        assert result == [1, 1, 2, 3, 3]
