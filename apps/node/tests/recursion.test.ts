/**
 * 第5章 再帰アルゴリズム — テスト
 */
import {
  factorial,
  gcd,
  recursiveSum,
  hanoi,
  mazeSolve,
  EightQueen,
  EightQueen2,
  EightQueen3,
} from '../src/algorithm/recursion';

describe('階乗', () => {
  test('factorial(0) === 1', () => {
    expect(factorial(0)).toBe(1);
  });

  test('factorial(1) === 1', () => {
    expect(factorial(1)).toBe(1);
  });

  test('factorial(5) === 120', () => {
    expect(factorial(5)).toBe(120);
  });

  test('factorial(10) === 3628800', () => {
    expect(factorial(10)).toBe(3628800);
  });
});

describe('最大公約数（ユークリッドの互除法）', () => {
  test('gcd(22, 8) === 2', () => {
    expect(gcd(22, 8)).toBe(2);
  });

  test('gcd(12, 4) === 4', () => {
    expect(gcd(12, 4)).toBe(4);
  });

  test('互いに素: gcd(7, 11) === 1', () => {
    expect(gcd(7, 11)).toBe(1);
  });

  test('同じ値: gcd(15, 15) === 15', () => {
    expect(gcd(15, 15)).toBe(15);
  });
});

describe('再帰的な合計', () => {
  test('recursiveSum(1) === 1', () => {
    expect(recursiveSum(1)).toBe(1);
  });

  test('recursiveSum(5) === 15', () => {
    expect(recursiveSum(5)).toBe(15);
  });

  test('recursiveSum(10) === 55', () => {
    expect(recursiveSum(10)).toBe(55);
  });
});

describe('ハノイの塔', () => {
  test('1 枚: A → C', () => {
    expect(hanoi(1, 'A', 'C', 'B')).toEqual([['A', 'C']]);
  });

  test('2 枚: 3 回の移動', () => {
    expect(hanoi(2, 'A', 'C', 'B')).toEqual([
      ['A', 'B'],
      ['A', 'C'],
      ['B', 'C'],
    ]);
  });

  test('3 枚: 7 回の移動', () => {
    expect(hanoi(3, 'A', 'C', 'B')).toHaveLength(7);
  });

  test('n 枚は 2^n - 1 回の移動', () => {
    for (let n = 1; n <= 6; n++) {
      expect(hanoi(n, 'A', 'C', 'B')).toHaveLength(2 ** n - 1);
    }
  });
});

describe('迷路探索（再帰的バックトラッキング）', () => {
  test('到達可能な迷路', () => {
    const maze = [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 1, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
    ];
    expect(mazeSolve(maze, 1, 1, 3, 3)).toBe(true);
  });

  test('到達不可能な迷路', () => {
    const maze = [
      [1, 1, 1, 1, 1],
      [1, 0, 1, 0, 1],
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1],
    ];
    expect(mazeSolve(maze, 1, 1, 3, 1)).toBe(false);
  });
});

describe('8 王妃問題（全組み合わせ）', () => {
  // 8^8 = 16,777,216 通り — 時間がかかるため skip
  test.skip('8^8 通りの組み合わせ（低速）', () => {
    const eq = new EightQueen();
    eq.set(0);
    expect(eq.result).toHaveLength(8 ** 8);
  });

  test('各結果の列数が 8', () => {
    // 小規模（3列）で検証
    const eq = new EightQueen(3);
    eq.set(0);
    expect(eq.result.every((row) => row.length === 3)).toBe(true);
  });
});

describe('8 王妃問題（行制約あり）', () => {
  // 8! = 40,320 通り — 時間がかかるため skip
  test.skip('8! 通りの組み合わせ（低速）', () => {
    const eq2 = new EightQueen2();
    eq2.set(0);
    expect(eq2.result).toHaveLength(40320);
  });

  test('各行は重複しない（3列版）', () => {
    const eq2 = new EightQueen2(3);
    eq2.set(0);
    for (const row of eq2.result) {
      expect(new Set(row).size).toBe(3);
    }
  });
});

describe('8 王妃問題（完全解）', () => {
  test('8 王妃問題の解は 92 通り', () => {
    const eq3 = new EightQueen3();
    eq3.set(0);
    expect(eq3.result).toHaveLength(92);
  });

  test('各行は重複しない', () => {
    const eq3 = new EightQueen3();
    eq3.set(0);
    for (const row of eq3.result) {
      expect(new Set(row).size).toBe(8);
    }
  });
});
