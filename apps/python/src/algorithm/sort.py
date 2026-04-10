"""第6章 ソートアルゴリズム"""


def bubble_sort(a: list) -> None:
    """バブルソート（in-place）

    隣接する要素を比較・交換し、最大値を末尾へ浮き上がらせる。
    最適化: 交換が発生しなければ終了。

    計算量: O(n^2) 最悪, O(n) 最良（整列済み）

    >>> a = [6, 4, 3, 7, 1, 9, 8]
    >>> bubble_sort(a)
    >>> a
    [1, 3, 4, 6, 7, 8, 9]
    """
    n = len(a)
    for i in range(n - 1):
        swapped = False
        for j in range(n - 1, i, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                swapped = True
        if not swapped:
            break


def selection_sort(a: list) -> None:
    """選択ソート（in-place）

    未整列部分の最小値を探し、先頭と交換する。

    計算量: O(n^2)

    >>> a = [6, 4, 3, 7, 1, 9, 8]
    >>> selection_sort(a)
    >>> a
    [1, 3, 4, 6, 7, 8, 9]
    """
    n = len(a)
    for i in range(n - 1):
        min_idx = i
        for j in range(i + 1, n):
            if a[j] < a[min_idx]:
                min_idx = j
        if min_idx != i:
            a[i], a[min_idx] = a[min_idx], a[i]


def insertion_sort(a: list) -> None:
    """挿入ソート（in-place）

    未整列部分の先頭要素を、整列済み部分の適切な位置に挿入する。

    計算量: O(n^2) 最悪, O(n) 最良（整列済み）

    >>> a = [6, 4, 3, 7, 1, 9, 8]
    >>> insertion_sort(a)
    >>> a
    [1, 3, 4, 6, 7, 8, 9]
    """
    n = len(a)
    for i in range(1, n):
        key = a[i]
        j = i - 1
        while j >= 0 and a[j] > key:
            a[j + 1] = a[j]
            j -= 1
        a[j + 1] = key


def shell_sort(a: list) -> None:
    """シェルソート（in-place）

    挿入ソートの改良。間隔（gap）を縮小しながら複数回の挿入ソートを行う。
    Knuth 数列（1, 4, 13, 40, ...）を使用。

    計算量: O(n^(3/2)) ～ O(n log^2 n)

    >>> a = [6, 4, 3, 7, 1, 9, 8]
    >>> shell_sort(a)
    >>> a
    [1, 3, 4, 6, 7, 8, 9]
    """
    n = len(a)
    # Knuth 数列で最大 gap を決定
    gap = 1
    while gap * 3 + 1 < n:
        gap = gap * 3 + 1

    while gap > 0:
        for i in range(gap, n):
            key = a[i]
            j = i - gap
            while j >= 0 and a[j] > key:
                a[j + gap] = a[j]
                j -= gap
            a[j + gap] = key
        gap //= 3


def quick_sort(a: list, left: int = 0, right: int | None = None) -> None:
    """クイックソート（in-place）

    ピボットを基準に配列を分割し、再帰的にソートする。

    計算量: O(n log n) 平均, O(n^2) 最悪

    >>> a = [6, 4, 3, 7, 1, 9, 8]
    >>> quick_sort(a)
    >>> a
    [1, 3, 4, 6, 7, 8, 9]
    """
    if right is None:
        right = len(a) - 1

    if left >= right:
        return

    pivot = a[(left + right) // 2]
    i, j = left, right

    while i <= j:
        while a[i] < pivot:
            i += 1
        while a[j] > pivot:
            j -= 1
        if i <= j:
            a[i], a[j] = a[j], a[i]
            i += 1
            j -= 1

    quick_sort(a, left, j)
    quick_sort(a, i, right)


def merge_sort(a: list) -> list:
    """マージソート（新しいリストを返す）

    配列を半分に分割し、再帰的にソートして結合する。

    計算量: O(n log n)

    >>> merge_sort([6, 4, 3, 7, 1, 9, 8])
    [1, 3, 4, 6, 7, 8, 9]
    """
    if len(a) <= 1:
        return a[:]

    mid = len(a) // 2
    left = merge_sort(a[:mid])
    right = merge_sort(a[mid:])

    return _merge(left, right)


def _merge(left: list, right: list) -> list:
    """2 つの整列済みリストをマージ"""
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
