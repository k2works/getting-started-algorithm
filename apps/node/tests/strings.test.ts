/**
 * 第7章 文字列処理 — テスト
 */
import {
  bfMatch,
  kmpMatch,
  bmMatch,
  countChars,
  reverseString,
  isPalindrome,
} from '../src/algorithm/strings';

describe('ブルートフォース文字列探索', () => {
  test('見つかる', () => { expect(bfMatch('ABCXDEZCABACABAB', 'ABAB')).toBe(12); });
  test('先頭で見つかる', () => { expect(bfMatch('ABCDE', 'ABC')).toBe(0); });
  test('末尾で見つかる', () => { expect(bfMatch('ABCDE', 'CDE')).toBe(2); });
  test('見つからない', () => { expect(bfMatch('ABCDE', 'XYZ')).toBe(-1); });
  test('空パターン', () => { expect(bfMatch('ABCDE', '')).toBe(0); });
  test('パターンがテキストより長い', () => { expect(bfMatch('AB', 'ABCDE')).toBe(-1); });
  test('1文字', () => { expect(bfMatch('ABCDE', 'C')).toBe(2); });
});

describe('KMP 文字列探索', () => {
  test('見つかる', () => { expect(kmpMatch('ABCXDEZCABACABAB', 'ABAB')).toBe(12); });
  test('先頭で見つかる', () => { expect(kmpMatch('ABCDE', 'ABC')).toBe(0); });
  test('見つからない', () => { expect(kmpMatch('ABCDE', 'XYZ')).toBe(-1); });
  test('空パターン', () => { expect(kmpMatch('ABCDE', '')).toBe(0); });
  test('繰り返しパターン', () => { expect(kmpMatch('AAABAAAB', 'AAAB')).toBe(0); });
});

describe('Boyer-Moore 文字列探索', () => {
  test('見つかる', () => { expect(bmMatch('ABCXDEZCABACABAB', 'ABAB')).toBe(12); });
  test('先頭で見つかる', () => { expect(bmMatch('ABCDE', 'ABC')).toBe(0); });
  test('見つからない', () => { expect(bmMatch('ABCDE', 'XYZ')).toBe(-1); });
  test('空パターン', () => { expect(bmMatch('ABCDE', '')).toBe(0); });
});

describe('文字のカウント', () => {
  test('文字カウント', () => {
    const result = countChars('hello world');
    expect(result['l']).toBe(3);
    expect(result['o']).toBe(2);
    expect(result[' ']).toBe(1);
  });
  test('空文字', () => { expect(countChars('')).toEqual({}); });
});

describe('文字列の逆順', () => {
  test('逆順', () => { expect(reverseString('hello')).toBe('olleh'); });
  test('空文字', () => { expect(reverseString('')).toBe(''); });
  test('1文字', () => { expect(reverseString('a')).toBe('a'); });
  test('回文はそのまま', () => { expect(reverseString('racecar')).toBe('racecar'); });
});

describe('回文判定', () => {
  test('回文', () => { expect(isPalindrome('racecar')).toBe(true); });
  test('回文でない', () => { expect(isPalindrome('hello')).toBe(false); });
  test('1文字', () => { expect(isPalindrome('a')).toBe(true); });
  test('空文字', () => { expect(isPalindrome('')).toBe(true); });
  test('偶数長の回文', () => { expect(isPalindrome('abba')).toBe(true); });
});
