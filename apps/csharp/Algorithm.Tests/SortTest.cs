using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第6章 ソートアルゴリズム テスト</summary>
public class SortTest
{
    private static readonly int[] Unsorted = [6, 4, 3, 7, 1, 9, 8];
    private static readonly int[] Sorted = [1, 3, 4, 6, 7, 8, 9];

    private static int[] Shuffle(int[] a)
    {
        var r = new Random(42);
        var b = (int[])a.Clone();
        for (int i = b.Length - 1; i > 0; i--) { int j = r.Next(i + 1); (b[i], b[j]) = (b[j], b[i]); }
        return b;
    }

    public class BubbleSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.BubbleSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.BubbleSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 単一要素() { int[] a = [42]; Sort.BubbleSort(a); Assert.Equal([42], a); }
        [Fact] public void 空配列() { int[] a = []; Sort.BubbleSort(a); Assert.Equal([], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.BubbleSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class BubbleSort2Test
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.BubbleSort2(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.BubbleSort2(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.BubbleSort2(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class ShakerSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.ShakerSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.ShakerSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.ShakerSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class SelectionSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.SelectionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.SelectionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 単一要素() { int[] a = [5]; Sort.SelectionSort(a); Assert.Equal([5], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.SelectionSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class InsertionSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.InsertionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.InsertionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 単一要素() { int[] a = [7]; Sort.InsertionSort(a); Assert.Equal([7], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.InsertionSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class BinaryInsertionSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.BinaryInsertionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.BinaryInsertionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.BinaryInsertionSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class ShellSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.ShellSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.ShellSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact]
        public void 大きな配列()
        {
            int[] a = Enumerable.Range(0, 100).ToArray();
            int[] shuffled = new SortTest().ShuffleArr(a);
            Sort.ShellSort(shuffled);
            Assert.Equal(a, shuffled);
        }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.ShellSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class QuickSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.QuickSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.QuickSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 単一要素() { int[] a = [1]; Sort.QuickSort(a); Assert.Equal([1], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.QuickSort(a); Assert.Equal([1,1,2,3,3], a); }
        [Fact]
        public void 大きな配列()
        {
            int[] a = Enumerable.Range(0, 200).ToArray();
            int[] shuffled = new SortTest().ShuffleArr(a);
            Sort.QuickSort(shuffled);
            Assert.Equal(a, shuffled);
        }
    }

    public class QuickSortNonRecursiveTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.QuickSortNonRecursive(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.QuickSortNonRecursive(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.QuickSortNonRecursive(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class MergeSortedArraysTest
    {
        [Fact] public void 基本() => Assert.Equal([1,2,3,4,5,6], Sort.MergeSortedArrays([1,3,5],[2,4,6]));
        [Fact] public void 一方が空() => Assert.Equal([1,2,3], Sort.MergeSortedArrays([],[1,2,3]));
        [Fact] public void 重複あり() => Assert.Equal([1,2,2,3,4], Sort.MergeSortedArrays([1,2,4],[2,3]));
    }

    public class MergeSortTest
    {
        [Fact] public void 基本() => Assert.Equal([1,3,4,6,7,8,9], Sort.MergeSort([6,4,3,7,1,9,8]));
        [Fact] public void 整列済み() => Assert.Equal([1,3,4,6,7,8,9], Sort.MergeSort([1,3,4,6,7,8,9]));
        [Fact] public void 単一要素() => Assert.Equal([5], Sort.MergeSort([5]));
        [Fact] public void 空配列() => Assert.Equal([], Sort.MergeSort([]));
        [Fact] public void 重複() => Assert.Equal([1,1,2,3,3], Sort.MergeSort([3,1,2,1,3]));
    }

    public class HeapSortTest
    {
        [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.HeapSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.HeapSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
        [Fact] public void 単一要素() { int[] a = [42]; Sort.HeapSort(a); Assert.Equal([42], a); }
        [Fact] public void 空配列() { int[] a = []; Sort.HeapSort(a); Assert.Equal([], a); }
        [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.HeapSort(a); Assert.Equal([1,1,2,3,3], a); }
    }

    public class CountingSortTest
    {
        [Fact] public void 基本() => Assert.Equal([1,3,4,6,7,8,9], Sort.CountingSort([6,4,3,7,1,9,8]));
        [Fact] public void 整列済み() => Assert.Equal([1,3,4,6,7,8,9], Sort.CountingSort([1,3,4,6,7,8,9]));
        [Fact] public void 単一要素() => Assert.Equal([5], Sort.CountingSort([5]));
        [Fact] public void 空配列() => Assert.Equal([], Sort.CountingSort([]));
        [Fact] public void 重複() => Assert.Equal([1,1,2,3,3], Sort.CountingSort([3,1,2,1,3]));
    }

    private int[] ShuffleArr(int[] a)
    {
        var r = new Random(42);
        var b = (int[])a.Clone();
        for (int i = b.Length - 1; i > 0; i--) { int j = r.Next(i + 1); (b[i], b[j]) = (b[j], b[i]); }
        return b;
    }
}
