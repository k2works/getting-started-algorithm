namespace Algorithm;

/// <summary>第6章 ソートアルゴリズム</summary>
public static class Sort
{
    public static void BubbleSort(int[] a)
    {
        int n = a.Length;
        for (int i = 0; i < n - 1; i++)
        {
            bool swapped = false;
            for (int j = n - 1; j > i; j--)
                if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); swapped = true; }
            if (!swapped) break;
        }
    }

    /// <summary>バブルソート第2版：走査範囲の限定</summary>
    public static void BubbleSort2(int[] a)
    {
        int n = a.Length, k = 0;
        while (k < n - 1)
        {
            int last = n - 1;
            for (int j = n - 1; j > k; j--)
                if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); last = j; }
            k = last;
        }
    }

    /// <summary>シェーカーソート（双方向バブルソート）</summary>
    public static void ShakerSort(int[] a)
    {
        int left = 0, right = a.Length - 1, last = right;
        while (left < right)
        {
            for (int j = right; j > left; j--)
                if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); last = j; }
            left = last;
            for (int j = left; j < right; j++)
                if (a[j] > a[j + 1]) { (a[j], a[j + 1]) = (a[j + 1], a[j]); last = j; }
            right = last;
        }
    }

    public static void SelectionSort(int[] a)
    {
        int n = a.Length;
        for (int i = 0; i < n - 1; i++)
        {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) if (a[j] < a[minIdx]) minIdx = j;
            if (minIdx != i) (a[i], a[minIdx]) = (a[minIdx], a[i]);
        }
    }

    public static void InsertionSort(int[] a)
    {
        int n = a.Length;
        for (int i = 1; i < n; i++)
        {
            int key = a[i], j = i - 1;
            while (j >= 0 && a[j] > key) { a[j + 1] = a[j]; j--; }
            a[j + 1] = key;
        }
    }

    /// <summary>二分挿入ソート</summary>
    public static void BinaryInsertionSort(int[] a)
    {
        int n = a.Length;
        for (int i = 1; i < n; i++)
        {
            int key = a[i], pl = 0, pr = i - 1, pc = 0;
            while (pl <= pr)
            {
                pc = (pl + pr) / 2;
                if (a[pc] == key) break;
                else if (a[pc] < key) pl = pc + 1;
                else pr = pc - 1;
            }
            int pd = (pl <= pr) ? pc + 1 : pr + 1;
            for (int j = i; j > pd; j--) a[j] = a[j - 1];
            a[pd] = key;
        }
    }

    public static void ShellSort(int[] a)
    {
        int n = a.Length, gap = 1;
        while (gap * 3 + 1 < n) gap = gap * 3 + 1;
        while (gap > 0)
        {
            for (int i = gap; i < n; i++)
            {
                int key = a[i], j = i - gap;
                while (j >= 0 && a[j] > key) { a[j + gap] = a[j]; j -= gap; }
                a[j + gap] = key;
            }
            gap /= 3;
        }
    }

    public static void QuickSort(int[] a, int left, int right)
    {
        if (left >= right) return;
        int pivot = a[(left + right) / 2], i = left, j = right;
        while (i <= j)
        {
            while (a[i] < pivot) i++;
            while (a[j] > pivot) j--;
            if (i <= j) { (a[i], a[j]) = (a[j], a[i]); i++; j--; }
        }
        QuickSort(a, left, j);
        QuickSort(a, i, right);
    }

    public static void QuickSort(int[] a) { if (a.Length > 1) QuickSort(a, 0, a.Length - 1); }

    /// <summary>非再帰的クイックソート</summary>
    public static void QuickSortNonRecursive(int[] a)
    {
        if (a.Length <= 1) return;
        var stack = new Stack<(int, int)>();
        stack.Push((0, a.Length - 1));
        while (stack.Count > 0)
        {
            var (left, right) = stack.Pop();
            if (left >= right) continue;
            int pivot = a[(left + right) / 2], i = left, j = right;
            while (i <= j)
            {
                while (a[i] < pivot) i++;
                while (a[j] > pivot) j--;
                if (i <= j) { (a[i], a[j]) = (a[j], a[i]); i++; j--; }
            }
            if (left < j) stack.Push((left, j));
            if (i < right) stack.Push((i, right));
        }
    }

    /// <summary>ソート済み配列のマージ</summary>
    public static int[] MergeSortedArrays(int[] a, int[] b)
    {
        int[] result = new int[a.Length + b.Length];
        int i = 0, j = 0, k = 0;
        while (i < a.Length && j < b.Length)
            result[k++] = a[i] <= b[j] ? a[i++] : b[j++];
        while (i < a.Length) result[k++] = a[i++];
        while (j < b.Length) result[k++] = b[j++];
        return result;
    }

    public static int[] MergeSort(int[] a)
    {
        if (a.Length <= 1) return (int[])a.Clone();
        int mid = a.Length / 2;
        int[] left = MergeSort(a[..mid]);
        int[] right = MergeSort(a[mid..]);
        return Merge(left, right);
    }

    private static int[] Merge(int[] left, int[] right)
    {
        int[] result = new int[left.Length + right.Length];
        int i = 0, j = 0, k = 0;
        while (i < left.Length && j < right.Length)
            result[k++] = left[i] <= right[j] ? left[i++] : right[j++];
        while (i < left.Length) result[k++] = left[i++];
        while (j < right.Length) result[k++] = right[j++];
        return result;
    }

    public static void HeapSort(int[] a)
    {
        int n = a.Length;
        if (n <= 1) return;
        for (int i = (n - 1) / 2; i >= 0; i--) DownHeap(a, i, n - 1);
        for (int i = n - 1; i > 0; i--) { (a[0], a[i]) = (a[i], a[0]); DownHeap(a, 0, i - 1); }
    }

    private static void DownHeap(int[] a, int left, int right)
    {
        int temp = a[left], parent = left;
        while (parent < (right + 1) / 2)
        {
            int cl = parent * 2 + 1, cr = cl + 1;
            int child = (cr <= right && a[cr] > a[cl]) ? cr : cl;
            if (temp >= a[child]) break;
            a[parent] = a[child]; parent = child;
        }
        a[parent] = temp;
    }

    public static int[] CountingSort(int[] a)
    {
        if (a.Length == 0) return [];
        int maxVal = a[0];
        foreach (int x in a) if (x > maxVal) maxVal = x;
        int[] freq = new int[maxVal + 1];
        foreach (int x in a) freq[x]++;
        for (int i = 1; i < freq.Length; i++) freq[i] += freq[i - 1];
        int[] result = new int[a.Length];
        for (int i = a.Length - 1; i >= 0; i--) { freq[a[i]]--; result[freq[a[i]]] = a[i]; }
        return result;
    }
}
