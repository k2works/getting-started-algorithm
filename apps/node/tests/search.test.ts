/**
 * 第3章 探索アルゴリズム — テスト
 */
import {
  ssearchWhile,
  ssearchFor,
  ssearchSentinel,
  bsearch,
  ChainedHash,
  OpenHash,
} from '../src/algorithm/search';

describe('線形探索', () => {
  test('整数配列から要素を検索', () => {
    expect(ssearchWhile([6, 4, 3, 2, 1, 2, 8], 2)).toBe(3);
  });

  test('浮動小数点配列から要素を検索', () => {
    expect(ssearchWhile([12.7, 3.14, 6.4, 7.2], 6.4)).toBe(2);
  });

  test('文字列配列から要素を検索', () => {
    expect(ssearchWhile(['DTS', 'AAC', 'FLAC'], 'DTS')).toBe(0);
  });

  test('見つからない場合は -1 を返す', () => {
    expect(ssearchWhile([1, 2, 3], 99)).toBe(-1);
  });

  test('for 文版: 整数配列', () => {
    expect(ssearchFor([6, 4, 3, 2, 1, 2, 8], 2)).toBe(3);
  });

  test('for 文版: 見つからない場合', () => {
    expect(ssearchFor([1, 2, 3], 99)).toBe(-1);
  });
});

describe('線形探索 — 番兵法', () => {
  test('見つかる場合', () => {
    expect(ssearchSentinel([6, 4, 3, 2, 1, 2, 8], 2)).toBe(3);
  });

  test('見つからない場合', () => {
    expect(ssearchSentinel([1, 2, 3], 99)).toBe(-1);
  });
});

describe('二分探索', () => {
  test('中間要素を検索', () => {
    expect(bsearch([1, 2, 3, 5, 7, 8, 9], 5)).toBe(3);
  });

  test('先頭要素を検索', () => {
    expect(bsearch([1, 2, 3, 5, 7, 8, 9], 1)).toBe(0);
  });

  test('末尾要素を検索', () => {
    expect(bsearch([1, 2, 3, 5, 7, 8, 9], 9)).toBe(6);
  });

  test('見つからない場合は -1 を返す', () => {
    expect(bsearch([1, 2, 3, 5, 7, 8, 9], 4)).toBe(-1);
  });
});

describe('チェイン法ハッシュ', () => {
  let h: ChainedHash<number, string>;

  beforeEach(() => {
    h = new ChainedHash(13);
    h.add(1, '赤尾');
    h.add(5, '武田');
    h.add(10, '小野');
    h.add(12, '鈴木');
    h.add(14, '神崎');
  });

  test('検索: キーが見つかる', () => {
    expect(h.search(1)).toBe('赤尾');
    expect(h.search(14)).toBe('神崎');
  });

  test('検索: キーが見つからない', () => {
    expect(h.search(100)).toBeNull();
  });

  test('追加', () => {
    h.add(100, '山田');
    expect(h.search(100)).toBe('山田');
  });

  test('重複キーは追加できない', () => {
    expect(h.add(1, '重複')).toBe(false);
  });

  test('削除: 先頭ノード', () => {
    h.add(100, '山田');
    h.remove(100);
    expect(h.search(100)).toBeNull();
  });

  test('削除: 衝突ノード（1%13=1, 14%13=1）', () => {
    h.remove(1);
    h.remove(14);
    expect(h.search(1)).toBeNull();
    expect(h.search(14)).toBeNull();
  });

  test('削除: 存在しないキー', () => {
    expect(h.remove(999)).toBe(false);
  });
});

describe('オープンアドレス法ハッシュ', () => {
  let h: OpenHash<number, string>;

  beforeEach(() => {
    h = new OpenHash(13);
    h.add(1, '赤尾');
    h.add(5, '武田');
    h.add(10, '小野');
    h.add(12, '鈴木');
    h.add(14, '神崎');
  });

  test('検索: キーが見つかる', () => {
    expect(h.search(1)).toBe('赤尾');
  });

  test('検索: キーが見つからない', () => {
    expect(h.search(999)).toBeNull();
  });

  test('追加', () => {
    h.add(100, '山田');
    expect(h.search(100)).toBe('山田');
  });

  test('重複キーは追加できない', () => {
    expect(h.add(1, '重複')).toBe(false);
  });

  test('削除', () => {
    h.add(100, '山田');
    h.remove(100);
    expect(h.search(100)).toBeNull();
  });

  test('削除: 存在しないキー', () => {
    expect(h.remove(999)).toBe(false);
  });

  test('テーブルが満杯の場合は追加できない', () => {
    const small = new OpenHash<number, string>(3);
    small.add(0, 'a');
    small.add(1, 'b');
    small.add(2, 'c');
    expect(small.add(99, 'd')).toBe(false);
  });

  test('全スロット OCCUPIED で対象なし', () => {
    const small = new OpenHash<number, string>(3);
    small.add(0, 'a');
    small.add(1, 'b');
    small.add(2, 'c');
    expect(small.remove(99)).toBe(false);
  });
});
