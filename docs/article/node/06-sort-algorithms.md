# 第 6 章 ソートアルゴリズム

## はじめに

この章では代表的な **ソートアルゴリズム** を学びます。ソートとは、データを一定の順序（昇順・降順）に並べ替える操作です。アルゴリズムによって計算量・安定性・メモリ使用量が大きく異なります。

---

## 1. バブルソート

隣り合う要素を比較・交換しながら最大値を末尾へ「泡のように」浮かび上がらせます。

```typescript
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
    if (!swapped) break; // 交換なし → 整列済み
  }
}
```

TypeScript の **分割代入** `[a, b] = [b, a]` で一時変数不要なスワップを実現します。

---

## 2. 選択ソート

未ソート部分の最小値を選択し、先頭と交換します。

```typescript
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
```

---

## 3. 挿入ソート

手持ちのトランプを整列するように、未ソート部分から要素を取り出し適切な位置に挿入します。

```typescript
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
```

---

## 4. シェルソート（Knuth 数列）

挿入ソートを間隔 `gap` を縮めながら繰り返す高速化版。Knuth 数列 `(1, 4, 13, 40, ...)` で gap を生成します。

```typescript
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
```

---

## 5. クイックソート

ピボットで分割を繰り返す分割統治法。平均 O(n log n)。

```typescript
export function quickSort(a: number[], left = 0, right = a.length - 1): void {
  if (left >= right) return;

  const pivot = a[Math.floor((left + right) / 2)];
  let i = left, j = right;

  while (i <= j) {
    while (a[i] < pivot) i++;
    while (a[j] > pivot) j--;
    if (i <= j) { [a[i], a[j]] = [a[j], a[i]]; i++; j--; }
  }
  quickSort(a, left, j);
  quickSort(a, i, right);
}
```

---

## 6. マージソート

分割して再帰的にソートし、マージして戻します。安定ソート、O(n log n)。

```typescript
export function mergeSort(a: number[]): number[] {
  if (a.length <= 1) return [...a];
  const mid = Math.floor(a.length / 2);
  const left = mergeSort(a.slice(0, mid));
  const right = mergeSort(a.slice(mid));
  return merge(left, right);
}

function merge(left: number[], right: number[]): number[] {
  const result: number[] = [];
  let i = 0, j = 0;
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) result.push(left[i++]);
    else result.push(right[j++]);
  }
  return [...result, ...left.slice(i), ...right.slice(j)];
}
```

---

## 7. ヒープソート

最大ヒープを構築し、根（最大値）を末尾と交換しながらソートします。

```typescript
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
```

---

## 8. 度数ソート（計数ソート）

値の出現頻度を数えて直接配置します。O(n + k)（k: 値の範囲）。

```typescript
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
```

---

## テスト実行結果

```bash
$ npm test tests/sort.test.ts

Tests:  37 passed, 37 total
```

---

## アルゴリズム比較

| アルゴリズム | 平均計算量 | 最悪計算量 | 安定性 | in-place |
|------------|-----------|-----------|--------|----------|
| バブルソート | O(n²) | O(n²) | ✓ | ✓ |
| 選択ソート | O(n²) | O(n²) | ✗ | ✓ |
| 挿入ソート | O(n²) | O(n²) | ✓ | ✓ |
| シェルソート | O(n log² n) | O(n²) | ✗ | ✓ |
| クイックソート | O(n log n) | O(n²) | ✗ | ✓ |
| マージソート | O(n log n) | O(n log n) | ✓ | ✗ |
| ヒープソート | O(n log n) | O(n log n) | ✗ | ✓ |
| 度数ソート | O(n + k) | O(n + k) | ✓ | ✗ |

## Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| スワップ | `a[i], a[j] = a[j], a[i]` | `[a[i], a[j]] = [a[j], a[i]]` |
| スライス結合 | `left + right[j:]` | `[...result, ...right.slice(j)]` |
| 整数除算 | `gap // 3` | `Math.floor(gap / 3)` |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
