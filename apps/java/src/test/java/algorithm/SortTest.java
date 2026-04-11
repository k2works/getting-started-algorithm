package algorithm;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.*;

class SortTest {

    private static final int[] UNSORTED = {6, 4, 3, 7, 1, 9, 8};
    private static final int[] SORTED = {1, 3, 4, 6, 7, 8, 9};

    @Nested
    class BubbleSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.bubbleSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.bubbleSort(a); assertArrayEquals(SORTED, a); }
        @Test void 単一要素() { int[] a = {42}; Sort.bubbleSort(a); assertArrayEquals(new int[]{42}, a); }
        @Test void 空配列() { int[] a = {}; Sort.bubbleSort(a); assertArrayEquals(new int[]{}, a); }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.bubbleSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
    }

    @Nested
    class SelectionSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.selectionSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.selectionSort(a); assertArrayEquals(SORTED, a); }
        @Test void 単一要素() { int[] a = {5}; Sort.selectionSort(a); assertArrayEquals(new int[]{5}, a); }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.selectionSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
    }

    @Nested
    class InsertionSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.insertionSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.insertionSort(a); assertArrayEquals(SORTED, a); }
        @Test void 単一要素() { int[] a = {7}; Sort.insertionSort(a); assertArrayEquals(new int[]{7}, a); }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.insertionSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
    }

    @Nested
    class ShellSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.shellSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.shellSort(a); assertArrayEquals(SORTED, a); }
        @Test void 大きな配列() {
            int[] a = new int[100];
            for (int i = 0; i < 100; i++) a[i] = i;
            shuffle(a);
            Sort.shellSort(a);
            int[] expected = new int[100];
            for (int i = 0; i < 100; i++) expected[i] = i;
            assertArrayEquals(expected, a);
        }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.shellSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
    }

    @Nested
    class QuickSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.quickSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.quickSort(a); assertArrayEquals(SORTED, a); }
        @Test void 単一要素() { int[] a = {1}; Sort.quickSort(a); assertArrayEquals(new int[]{1}, a); }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.quickSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
        @Test void 大きな配列() {
            int[] a = new int[200];
            for (int i = 0; i < 200; i++) a[i] = i;
            shuffle(a);
            Sort.quickSort(a);
            int[] expected = new int[200];
            for (int i = 0; i < 200; i++) expected[i] = i;
            assertArrayEquals(expected, a);
        }
    }

    @Nested
    class MergeSortTest {
        @Test void 基本() { assertArrayEquals(SORTED, Sort.mergeSort(UNSORTED.clone())); }
        @Test void 整列済み() { assertArrayEquals(SORTED, Sort.mergeSort(SORTED.clone())); }
        @Test void 単一要素() { assertArrayEquals(new int[]{5}, Sort.mergeSort(new int[]{5})); }
        @Test void 空配列() { assertArrayEquals(new int[]{}, Sort.mergeSort(new int[]{})); }
        @Test void 重複() { assertArrayEquals(new int[]{1,1,2,3,3}, Sort.mergeSort(new int[]{3,1,2,1,3})); }
    }

    @Nested
    class HeapSortTest {
        @Test void 基本() { int[] a = UNSORTED.clone(); Sort.heapSort(a); assertArrayEquals(SORTED, a); }
        @Test void 整列済み() { int[] a = SORTED.clone(); Sort.heapSort(a); assertArrayEquals(SORTED, a); }
        @Test void 単一要素() { int[] a = {42}; Sort.heapSort(a); assertArrayEquals(new int[]{42}, a); }
        @Test void 空配列() { int[] a = {}; Sort.heapSort(a); assertArrayEquals(new int[]{}, a); }
        @Test void 重複() { int[] a = {3,1,2,1,3}; Sort.heapSort(a); assertArrayEquals(new int[]{1,1,2,3,3}, a); }
    }

    @Nested
    class CountingSortTest {
        @Test void 基本() { assertArrayEquals(SORTED, Sort.countingSort(UNSORTED.clone())); }
        @Test void 整列済み() { assertArrayEquals(SORTED, Sort.countingSort(SORTED.clone())); }
        @Test void 単一要素() { assertArrayEquals(new int[]{5}, Sort.countingSort(new int[]{5})); }
        @Test void 空配列() { assertArrayEquals(new int[]{}, Sort.countingSort(new int[]{})); }
        @Test void 重複() { assertArrayEquals(new int[]{1,1,2,3,3}, Sort.countingSort(new int[]{3,1,2,1,3})); }
    }

    private static void shuffle(int[] a) {
        Random rng = new Random(42);
        for (int i = a.length - 1; i > 0; i--) {
            int j = rng.nextInt(i + 1);
            int tmp = a[i]; a[i] = a[j]; a[j] = tmp;
        }
    }
}
