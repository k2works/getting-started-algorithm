/**
 * 第1章 基本的なアルゴリズム — テスト
 */
import {
  max3,
  med3,
  judgeSign,
  sum1ToNWhile,
  sum1ToNFor,
  alternative1,
  alternative2,
  rectangle,
  multiplicationTable,
  triangleLb,
} from '../src/algorithm/basic_algorithms';

describe('3値の最大値', () => {
  test.each([
    [3, 2, 1, 3], // a > b > c
    [3, 2, 2, 3], // a > b = c
    [3, 1, 2, 3], // a > c > b
    [3, 2, 3, 3], // a = c > b
    [2, 1, 3, 3], // c > a > b
    [3, 3, 2, 3], // a = b > c
    [3, 3, 3, 3], // a = b = c
    [2, 2, 3, 3], // c > a = b
    [2, 3, 1, 3], // b > a > c
    [2, 3, 2, 3], // b > a = c
    [1, 3, 2, 3], // b > c > a
    [2, 3, 3, 3], // b = c > a
    [1, 2, 3, 3], // c > b > a
  ])('max3(%i, %i, %i) === %i', (a, b, c, expected) => {
    expect(max3(a, b, c)).toBe(expected);
  });
});

describe('3値の中央値', () => {
  test.each([
    [3, 2, 1, 2], // a > b > c
    [3, 2, 2, 2], // a > b = c
    [3, 1, 2, 2], // a > c > b
    [3, 2, 3, 3], // a = c > b
    [2, 1, 3, 2], // c > a > b
    [3, 3, 2, 3], // a = b > c
    [3, 3, 3, 3], // a = b = c
    [2, 2, 3, 2], // c > a = b
    [2, 3, 1, 2], // b > a > c
    [2, 3, 2, 2], // b > a = c
    [1, 3, 2, 2], // b > c > a
    [2, 3, 3, 3], // b = c > a
    [1, 2, 3, 2], // c > b > a
  ])('med3(%i, %i, %i) === %i', (a, b, c, expected) => {
    expect(med3(a, b, c)).toBe(expected);
  });
});

describe('条件判定と分岐', () => {
  test('正の数', () => {
    expect(judgeSign(17)).toBe('その値は正です。');
  });

  test('負の数', () => {
    expect(judgeSign(-5)).toBe('その値は負です。');
  });

  test('ゼロ', () => {
    expect(judgeSign(0)).toBe('その値は0です。');
  });
});

describe('繰り返し処理 — 1からnまでの総和', () => {
  test('while 文で 1 から 5 までの総和', () => {
    expect(sum1ToNWhile(5)).toBe(15);
  });

  test('for 文で 1 から 5 までの総和', () => {
    expect(sum1ToNFor(5)).toBe(15);
  });
});

describe('繰り返し処理 — 記号文字の交互表示', () => {
  test('剰余判定方式で 12 文字', () => {
    expect(alternative1(12)).toBe('+-+-+-+-+-+-');
  });

  test('パターン繰り返し方式で 12 文字', () => {
    expect(alternative2(12)).toBe('+-+-+-+-+-+-');
  });

  test('奇数の場合', () => {
    expect(alternative1(5)).toBe('+-+-+');
    expect(alternative2(5)).toBe('+-+-+');
  });
});

describe('繰り返し処理 — 長方形の辺の長さを列挙', () => {
  test('面積 32 の長方形', () => {
    expect(rectangle(32)).toBe('1x32 2x16 4x8 ');
  });
});

describe('多重ループ — 九九の表', () => {
  test('九九の表', () => {
    const expected =
      '---------------------------\n' +
      '  1  2  3  4  5  6  7  8  9\n' +
      '  2  4  6  8 10 12 14 16 18\n' +
      '  3  6  9 12 15 18 21 24 27\n' +
      '  4  8 12 16 20 24 28 32 36\n' +
      '  5 10 15 20 25 30 35 40 45\n' +
      '  6 12 18 24 30 36 42 48 54\n' +
      '  7 14 21 28 35 42 49 56 63\n' +
      '  8 16 24 32 40 48 56 64 72\n' +
      '  9 18 27 36 45 54 63 72 81\n' +
      '---------------------------';
    expect(multiplicationTable()).toBe(expected);
  });
});

describe('多重ループ — 直角三角形の表示', () => {
  test('5行の左下三角形', () => {
    expect(triangleLb(5)).toBe('*\n**\n***\n****\n*****\n');
  });
});
