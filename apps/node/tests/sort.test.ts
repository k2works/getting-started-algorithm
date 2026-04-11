/**
 * 第6章 ソートアルゴリズム — テスト
 */
import {
  bubbleSort,
  selectionSort,
  insertionSort,
  shellSort,
  quickSort,
  mergeSort,
  heapSort,
  countingSort,
} from '../src/algorithm/sort';

const UNSORTED = [6, 4, 3, 7, 1, 9, 8];
const SORTED = [1, 3, 4, 6, 7, 8, 9];

describe('バブルソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; bubbleSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; bubbleSort(a); expect(a).toEqual(SORTED); });
  test('1要素', () => { const a = [42]; bubbleSort(a); expect(a).toEqual([42]); });
  test('空配列', () => { const a: number[] = []; bubbleSort(a); expect(a).toEqual([]); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; bubbleSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
});

describe('選択ソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; selectionSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; selectionSort(a); expect(a).toEqual(SORTED); });
  test('1要素', () => { const a = [5]; selectionSort(a); expect(a).toEqual([5]); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; selectionSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
});

describe('挿入ソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; insertionSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; insertionSort(a); expect(a).toEqual(SORTED); });
  test('1要素', () => { const a = [7]; insertionSort(a); expect(a).toEqual([7]); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; insertionSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
});

describe('シェルソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; shellSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; shellSort(a); expect(a).toEqual(SORTED); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; shellSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
  test('100要素のランダム配列', () => {
    const a = Array.from({ length: 100 }, (_, i) => i).sort(() => Math.random() - 0.5);
    shellSort(a);
    expect(a).toEqual([...Array(100).keys()]);
  });
});

describe('クイックソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; quickSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; quickSort(a); expect(a).toEqual(SORTED); });
  test('1要素', () => { const a = [1]; quickSort(a); expect(a).toEqual([1]); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; quickSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
  test('200要素のランダム配列', () => {
    const a = Array.from({ length: 200 }, (_, i) => i).sort(() => Math.random() - 0.5);
    quickSort(a);
    expect(a).toEqual([...Array(200).keys()]);
  });
});

describe('マージソート', () => {
  test('ソート', () => { expect(mergeSort([...UNSORTED])).toEqual(SORTED); });
  test('整列済み', () => { expect(mergeSort([...SORTED])).toEqual(SORTED); });
  test('1要素', () => { expect(mergeSort([5])).toEqual([5]); });
  test('空配列', () => { expect(mergeSort([])).toEqual([]); });
  test('重複あり', () => { expect(mergeSort([3, 1, 2, 1, 3])).toEqual([1, 1, 2, 3, 3]); });
});

describe('ヒープソート', () => {
  test('ソート', () => { const a = [...UNSORTED]; heapSort(a); expect(a).toEqual(SORTED); });
  test('整列済み', () => { const a = [...SORTED]; heapSort(a); expect(a).toEqual(SORTED); });
  test('1要素', () => { const a = [42]; heapSort(a); expect(a).toEqual([42]); });
  test('空配列', () => { const a: number[] = []; heapSort(a); expect(a).toEqual([]); });
  test('重複あり', () => { const a = [3, 1, 2, 1, 3]; heapSort(a); expect(a).toEqual([1, 1, 2, 3, 3]); });
});

describe('度数ソート', () => {
  test('ソート', () => { expect(countingSort([...UNSORTED])).toEqual(SORTED); });
  test('整列済み', () => { expect(countingSort([...SORTED])).toEqual(SORTED); });
  test('1要素', () => { expect(countingSort([5])).toEqual([5]); });
  test('空配列', () => { expect(countingSort([])).toEqual([]); });
  test('重複あり', () => { expect(countingSort([3, 1, 2, 1, 3])).toEqual([1, 1, 2, 3, 3]); });
});
