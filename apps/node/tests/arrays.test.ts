/**
 * 第2章 配列 — テスト
 */
import {
  maxOf,
  reverseArray,
  cardConv,
  prime1,
  prime2,
  prime3,
} from '../src/algorithm/arrays';

describe('配列の要素の最大値', () => {
  test('5要素の配列', () => {
    expect(maxOf([172, 153, 192, 140, 165])).toBe(192);
  });

  test('1要素の配列', () => {
    expect(maxOf([42])).toBe(42);
  });

  test('すべて同じ値', () => {
    expect(maxOf([5, 5, 5])).toBe(5);
  });
});

describe('配列の要素の並びを反転', () => {
  test('7要素の配列', () => {
    const a = [2, 5, 1, 3, 9, 6, 7];
    reverseArray(a);
    expect(a).toEqual([7, 6, 9, 3, 1, 5, 2]);
  });

  test('偶数要素の配列', () => {
    const a = [1, 2, 3, 4];
    reverseArray(a);
    expect(a).toEqual([4, 3, 2, 1]);
  });

  test('1要素の配列', () => {
    const a = [42];
    reverseArray(a);
    expect(a).toEqual([42]);
  });
});

describe('基数変換', () => {
  test('2進数', () => {
    expect(cardConv(29, 2)).toBe('11101');
  });

  test('8進数', () => {
    expect(cardConv(29, 8)).toBe('35');
  });

  test('16進数', () => {
    expect(cardConv(255, 16)).toBe('FF');
  });
});

describe('素数の列挙', () => {
  test('第1版（1000以下）', () => {
    expect(prime1(1000)).toBe(78022);
  });

  test('第2版（1000以下）', () => {
    expect(prime2(1000)).toBe(14622);
  });

  test('第3版（1000以下）', () => {
    expect(prime3(1000)).toBe(3774);
  });
});
