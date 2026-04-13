#ifndef SORT_H
#define SORT_H

void bubble_sort(int *a, int n);
void selection_sort(int *a, int n);
void insertion_sort(int *a, int n);
void shell_sort(int *a, int n);
void quick_sort(int *a, int left, int right);
void merge_sort(int *a, int n);
void heap_sort(int *a, int n);
void counting_sort(int *a, int n, int max_val);

#endif /* SORT_H */
