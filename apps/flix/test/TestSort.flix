mod TestSort {
    /// バブルソートは配列を昇順にする。
    @Test
    def bubbleSort_sorts_values(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil);
            Sort.bubbleSort(values);
            Assert.assertEq(expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil, Array.toList(values))
        }

    /// バブルソートは空・単一・重複値を扱う。
    @Test
    def bubbleSort_handles_boundaries(): Unit \ Assert =
        region rc {
            let empty = Array.repeat(rc, 0, 0);
            let single = List.toArray(rc, 42 :: Nil);
            let reverse = List.toArray(rc, 4 :: 3 :: 2 :: 1 :: Nil);
            let duplicates = List.toArray(rc, 3 :: 1 :: 3 :: 2 :: 1 :: Nil);
            Sort.bubbleSort(empty);
            Sort.bubbleSort(single);
            Sort.bubbleSort(reverse);
            Sort.bubbleSort(duplicates);
            Assert.assertEq(expected = Nil, Array.toList(empty));
            Assert.assertEq(expected = 42 :: Nil, Array.toList(single));
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Array.toList(reverse));
            Assert.assertEq(expected = 1 :: 1 :: 2 :: 3 :: 3 :: Nil, Array.toList(duplicates))
        }

    /// 選択ソートは昇順にし、すでに整列済みの入力も扱う。
    @Test
    def selectionSort_sorts_values(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil);
            let sorted = List.toArray(rc, 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil);
            Sort.selectionSort(values);
            Sort.selectionSort(sorted);
            Assert.assertEq(expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil, Array.toList(values));
            Assert.assertEq(expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil, Array.toList(sorted))
        }

    /// 選択ソートは逆順と重複値を扱う。
    @Test
    def selectionSort_handles_reverse_and_duplicates(): Unit \ Assert =
        region rc {
            let reverse = List.toArray(rc, 5 :: 4 :: 3 :: 2 :: 1 :: Nil);
            let duplicates = List.toArray(rc, 2 :: 1 :: 2 :: 1 :: Nil);
            Sort.selectionSort(reverse);
            Sort.selectionSort(duplicates);
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: 5 :: Nil, Array.toList(reverse));
            Assert.assertEq(expected = 1 :: 1 :: 2 :: 2 :: Nil, Array.toList(duplicates))
        }

    /// 挿入ソートは昇順にする。
    @Test
    def insertionSort_sorts_values(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil);
            Sort.insertionSort(values);
            Assert.assertEq(expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil, Array.toList(values))
        }

    /// 挿入ソートは整列済み・逆順・重複値を扱う。
    @Test
    def insertionSort_handles_boundaries(): Unit \ Assert =
        region rc {
            let sorted = List.toArray(rc, 1 :: 2 :: 3 :: 4 :: Nil);
            let reverse = List.toArray(rc, 4 :: 3 :: 2 :: 1 :: Nil);
            let duplicates = List.toArray(rc, 2 :: 1 :: 2 :: 1 :: Nil);
            Sort.insertionSort(sorted);
            Sort.insertionSort(reverse);
            Sort.insertionSort(duplicates);
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Array.toList(sorted));
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Array.toList(reverse));
            Assert.assertEq(expected = 1 :: 1 :: 2 :: 2 :: Nil, Array.toList(duplicates))
        }

    /// クイックソートは分割後の各範囲を昇順にする。
    @Test
    def quickSort_sorts_values(): Unit \ Assert =
        let values = 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil;
        Assert.assertEq(
            expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil,
            Sort.quickSort(values)
        );
        Assert.assertEq(expected = 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil, values)

    /// クイックソートは空・単一・全要素同値を扱う。
    @Test
    def quickSort_handles_boundaries(): Unit \ Assert =
        Assert.assertEq(expected = Nil, Sort.quickSort(Nil));
        Assert.assertEq(expected = 5 :: Nil, Sort.quickSort(5 :: Nil));
        Assert.assertEq(expected = 2 :: 2 :: 2 :: 2 :: Nil, Sort.quickSort(2 :: 2 :: 2 :: 2 :: Nil));
        Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Sort.quickSort(4 :: 3 :: 2 :: 1 :: Nil));
        Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Sort.quickSort(1 :: 2 :: 3 :: 4 :: Nil))

    /// マージソートは配列を昇順にする。
    @Test
    def mergeSort_sorts_values(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 5 :: 8 :: 4 :: 2 :: 6 :: 1 :: 3 :: 9 :: 7 :: Nil);
            Sort.mergeSort(values);
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: Nil, Array.toList(values))
        }

    /// マージソートは空・単一・重複値を扱う。
    @Test
    def mergeSort_handles_boundaries(): Unit \ Assert =
        region rc {
            let empty = Array.repeat(rc, 0, 0);
            let single = List.toArray(rc, 42 :: Nil);
            let reverse = List.toArray(rc, 4 :: 3 :: 2 :: 1 :: Nil);
            let sorted = List.toArray(rc, 1 :: 2 :: 3 :: 4 :: Nil);
            let duplicates = List.toArray(rc, 3 :: 1 :: 3 :: 2 :: 1 :: Nil);
            Sort.mergeSort(empty);
            Sort.mergeSort(single);
            Sort.mergeSort(reverse);
            Sort.mergeSort(sorted);
            Sort.mergeSort(duplicates);
            Assert.assertEq(expected = Nil, Array.toList(empty));
            Assert.assertEq(expected = 42 :: Nil, Array.toList(single));
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Array.toList(reverse));
            Assert.assertEq(expected = 1 :: 2 :: 3 :: 4 :: Nil, Array.toList(sorted));
            Assert.assertEq(expected = 1 :: 1 :: 2 :: 3 :: 3 :: Nil, Array.toList(duplicates))
        }
}
