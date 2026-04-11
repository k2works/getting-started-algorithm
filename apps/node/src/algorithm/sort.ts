/**
 * 第6章 ソートアルゴリズム
 */

/** バブルソート（in-place） */
export function bubbleSort(a: number[]): void {
  const n = a.length;
  for (let i = 0; i < n - 1; i++) {
    let swapped = false;
    for (let j = n - 1; j > i; j--) {
      if (a[j - 1] > a[j]) {
        [a[j - 1], a[j]] = [a[j], a[j - 1]];
        swapped = true;
      }
    }
    if (!swapped) break;
  }
}

/** 選択ソート（in-place） */
export function selectionSort(a: number[]): void {
  const n = a.length;
  for (let i = 0; i < n - 1; i++) {
    let minIdx = i;
    for (let j = i + 1; j < n; j++) {
      if (a[j] < a[minIdx]) minIdx = j;
    }
    if (minIdx !== i) [a[i], a[minIdx]] = [a[minIdx], a[i]];
  }
}

/** 挿入ソート（in-place） */
export function insertionSort(a: number[]): void {
  const n = a.length;
  for (let i = 1; i < n; i++) {
    const key = a[i];
    let j = i - 1;
    while (j >= 0 && a[j] > key) {
      a[j + 1] = a[j];
      j--;
    }
    a[j + 1] = key;
  }
}

/** シェルソート（in-place）— Knuth 数列 */
export function shellSort(a: number[]): void {
  const n = a.length;
  let gap = 1;
  while (gap * 3 + 1 < n) gap = gap * 3 + 1;

  while (gap > 0) {
    for (let i = gap; i < n; i++) {
      const key = a[i];
      let j = i - gap;
      while (j >= 0 && a[j] > key) {
        a[j + gap] = a[j];
        j -= gap;
      }
      a[j + gap] = key;
    }
    gap = Math.floor(gap / 3);
  }
}

/** クイックソート（in-place） */
export function quickSort(a: number[], left: number = 0, right: number = a.length - 1): void {
  if (left >= right) return;

  const pivot = a[Math.floor((left + right) / 2)];
  let i = left;
  let j = right;

  while (i <= j) {
    while (a[i] < pivot) i++;
    while (a[j] > pivot) j--;
    if (i <= j) {
      [a[i], a[j]] = [a[j], a[i]];
      i++;
      j--;
    }
  }
  quickSort(a, left, j);
  quickSort(a, i, right);
}

/** マージソート（新しい配列を返す） */
export function mergeSort(a: number[]): number[] {
  if (a.length <= 1) return [...a];

  const mid = Math.floor(a.length / 2);
  const left = mergeSort(a.slice(0, mid));
  const right = mergeSort(a.slice(mid));

  return merge(left, right);
}

function merge(left: number[], right: number[]): number[] {
  const result: number[] = [];
  let i = 0;
  let j = 0;
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) result.push(left[i++]);
    else result.push(right[j++]);
  }
  return [...result, ...left.slice(i), ...right.slice(j)];
}

/** ヒープソート（in-place） */
export function heapSort(a: number[]): void {
  const n = a.length;

  function downHeap(left: number, right: number): void {
    const temp = a[left];
    let parent = left;
    while (parent < Math.floor((right + 1) / 2)) {
      const cl = parent * 2 + 1;
      const cr = cl + 1;
      const child = cr <= right && a[cr] > a[cl] ? cr : cl;
      if (temp >= a[child]) break;
      a[parent] = a[child];
      parent = child;
    }
    a[parent] = temp;
  }

  for (let i = Math.floor((n - 1) / 2); i >= 0; i--) downHeap(i, n - 1);
  for (let i = n - 1; i > 0; i--) {
    [a[0], a[i]] = [a[i], a[0]];
    downHeap(0, i - 1);
  }
}

/** 度数ソート（計数ソート）— 新しい配列を返す */
export function countingSort(a: number[]): number[] {
  if (a.length === 0) return [];
  const maxVal = Math.max(...a);
  const freq = new Array(maxVal + 1).fill(0);
  for (const x of a) freq[x]++;
  for (let i = 1; i < freq.length; i++) freq[i] += freq[i - 1];
  const result = new Array(a.length).fill(0);
  for (let i = a.length - 1; i >= 0; i--) {
    freq[a[i]]--;
    result[freq[a[i]]] = a[i];
  }
  return result;
}
