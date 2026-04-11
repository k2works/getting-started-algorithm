package algorithm;

import java.util.Arrays;

/** 第6章 ソートアルゴリズム */
public class Sort {

    /** バブルソート（in-place） */
    public static void bubbleSort(int[] a) {
        int n = a.length;
        for (int i = 0; i < n - 1; i++) {
            boolean swapped = false;
            for (int j = n - 1; j > i; j--) {
                if (a[j - 1] > a[j]) {
                    int tmp = a[j - 1]; a[j - 1] = a[j]; a[j] = tmp;
                    swapped = true;
                }
            }
            if (!swapped) break;
        }
    }

    /** 選択ソート（in-place） */
    public static void selectionSort(int[] a) {
        int n = a.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (a[j] < a[minIdx]) minIdx = j;
            }
            if (minIdx != i) {
                int tmp = a[i]; a[i] = a[minIdx]; a[minIdx] = tmp;
            }
        }
    }

    /** 挿入ソート（in-place） */
    public static void insertionSort(int[] a) {
        int n = a.length;
        for (int i = 1; i < n; i++) {
            int key = a[i];
            int j = i - 1;
            while (j >= 0 && a[j] > key) {
                a[j + 1] = a[j];
                j--;
            }
            a[j + 1] = key;
        }
    }

    /** シェルソート（in-place、Knuth 数列） */
    public static void shellSort(int[] a) {
        int n = a.length;
        int gap = 1;
        while (gap * 3 + 1 < n) gap = gap * 3 + 1;
        while (gap > 0) {
            for (int i = gap; i < n; i++) {
                int key = a[i];
                int j = i - gap;
                while (j >= 0 && a[j] > key) {
                    a[j + gap] = a[j];
                    j -= gap;
                }
                a[j + gap] = key;
            }
            gap /= 3;
        }
    }

    /** クイックソート（in-place） */
    public static void quickSort(int[] a, int left, int right) {
        if (left >= right) return;
        int pivot = a[(left + right) / 2];
        int i = left, j = right;
        while (i <= j) {
            while (a[i] < pivot) i++;
            while (a[j] > pivot) j--;
            if (i <= j) {
                int tmp = a[i]; a[i] = a[j]; a[j] = tmp;
                i++; j--;
            }
        }
        quickSort(a, left, j);
        quickSort(a, i, right);
    }

    /** クイックソート（引数省略版） */
    public static void quickSort(int[] a) {
        if (a.length > 1) quickSort(a, 0, a.length - 1);
    }

    /** マージソート（新しい配列を返す） */
    public static int[] mergeSort(int[] a) {
        if (a.length <= 1) return Arrays.copyOf(a, a.length);
        int mid = a.length / 2;
        int[] left = mergeSort(Arrays.copyOfRange(a, 0, mid));
        int[] right = mergeSort(Arrays.copyOfRange(a, mid, a.length));
        return merge(left, right);
    }

    private static int[] merge(int[] left, int[] right) {
        int[] result = new int[left.length + right.length];
        int i = 0, j = 0, k = 0;
        while (i < left.length && j < right.length) {
            if (left[i] <= right[j]) result[k++] = left[i++];
            else result[k++] = right[j++];
        }
        while (i < left.length) result[k++] = left[i++];
        while (j < right.length) result[k++] = right[j++];
        return result;
    }

    /** ヒープソート（in-place） */
    public static void heapSort(int[] a) {
        int n = a.length;
        if (n <= 1) return;
        // 最大ヒープ構築
        for (int i = (n - 1) / 2; i >= 0; i--) {
            downHeap(a, i, n - 1);
        }
        // ヒープの最大要素と末尾を交換
        for (int i = n - 1; i > 0; i--) {
            int tmp = a[0]; a[0] = a[i]; a[i] = tmp;
            downHeap(a, 0, i - 1);
        }
    }

    private static void downHeap(int[] a, int left, int right) {
        int temp = a[left];
        int parent = left;
        while (parent < (right + 1) / 2) {
            int cl = parent * 2 + 1;
            int cr = cl + 1;
            int child = (cr <= right && a[cr] > a[cl]) ? cr : cl;
            if (temp >= a[child]) break;
            a[parent] = a[child];
            parent = child;
        }
        a[parent] = temp;
    }

    /** 度数ソート（計数ソート）-- 新しい配列を返す */
    public static int[] countingSort(int[] a) {
        if (a.length == 0) return new int[0];
        int maxVal = a[0];
        for (int x : a) if (x > maxVal) maxVal = x;
        int[] freq = new int[maxVal + 1];
        for (int x : a) freq[x]++;
        for (int i = 1; i < freq.length; i++) freq[i] += freq[i - 1];
        int[] result = new int[a.length];
        for (int i = a.length - 1; i >= 0; i--) {
            freq[a[i]]--;
            result[freq[a[i]]] = a[i];
        }
        return result;
    }
}
