#include <stdlib.h>
#include <string.h>
#include "sort.h"

static void swap(int *a, int *b) { int t = *a; *a = *b; *b = t; }

void bubble_sort(int *a, int n) {
    for (int i = 0; i < n - 1; i++) {
        int swapped = 0;
        for (int j = n - 1; j > i; j--) {
            if (a[j - 1] > a[j]) { swap(&a[j-1], &a[j]); swapped = 1; }
        }
        if (!swapped) break;
    }
}

void selection_sort(int *a, int n) {
    for (int i = 0; i < n - 1; i++) {
        int min = i;
        for (int j = i + 1; j < n; j++) if (a[j] < a[min]) min = j;
        if (min != i) swap(&a[i], &a[min]);
    }
}

void insertion_sort(int *a, int n) {
    for (int i = 1; i < n; i++) {
        int key = a[i], j = i - 1;
        while (j >= 0 && a[j] > key) { a[j+1] = a[j]; j--; }
        a[j+1] = key;
    }
}

void shell_sort(int *a, int n) {
    int h = 1;
    while (h < n / 9) h = h * 3 + 1;
    for (; h > 0; h /= 3) {
        for (int i = h; i < n; i++) {
            int key = a[i], j = i - h;
            while (j >= 0 && a[j] > key) { a[j+h] = a[j]; j -= h; }
            a[j+h] = key;
        }
    }
}

void quick_sort(int *a, int left, int right) {
    if (left >= right) return;
    int pivot = a[(left + right) / 2];
    int i = left, j = right;
    while (i <= j) {
        while (a[i] < pivot) i++;
        while (a[j] > pivot) j--;
        if (i <= j) { swap(&a[i], &a[j]); i++; j--; }
    }
    quick_sort(a, left, j);
    quick_sort(a, i, right);
}

static void _merge(int *a, int left, int mid, int right) {
    int n1 = mid - left, n2 = right - mid;
    int *l = (int *)malloc((size_t)n1 * sizeof(int));
    int *r = (int *)malloc((size_t)n2 * sizeof(int));
    memcpy(l, a + left, (size_t)n1 * sizeof(int));
    memcpy(r, a + mid,  (size_t)n2 * sizeof(int));
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) a[k++] = (l[i] <= r[j]) ? l[i++] : r[j++];
    while (i < n1) a[k++] = l[i++];
    while (j < n2) a[k++] = r[j++];
    free(l); free(r);
}

static void _merge_sort(int *a, int left, int right) {
    if (right - left <= 1) return;
    int mid = (left + right) / 2;
    _merge_sort(a, left, mid);
    _merge_sort(a, mid, right);
    _merge(a, left, mid, right);
}

void merge_sort(int *a, int n) { _merge_sort(a, 0, n); }

static void _down_heap(int *a, int k, int n) {
    int tmp = a[k];
    while (2*k+1 < n) {
        int child = 2*k+1;
        if (child+1 < n && a[child+1] > a[child]) child++;
        if (tmp >= a[child]) break;
        a[k] = a[child]; k = child;
    }
    a[k] = tmp;
}

void heap_sort(int *a, int n) {
    for (int i = n/2 - 1; i >= 0; i--) _down_heap(a, i, n);
    for (int i = n - 1; i > 0; i--) { swap(&a[0], &a[i]); _down_heap(a, 0, i); }
}

void counting_sort(int *a, int n, int max_val) {
    int *cnt = (int *)calloc((size_t)max_val, sizeof(int));
    int *out = (int *)malloc((size_t)n * sizeof(int));
    for (int i = 0; i < n; i++) cnt[a[i]]++;
    for (int i = 1; i < max_val; i++) cnt[i] += cnt[i-1];
    for (int i = n - 1; i >= 0; i--) out[--cnt[a[i]]] = a[i];
    memcpy(a, out, (size_t)n * sizeof(int));
    free(cnt); free(out);
}
