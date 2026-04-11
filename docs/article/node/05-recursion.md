# 第 5 章 再帰アルゴリズム

## はじめに

この章では「再帰」を学びます。再帰とは、関数が自分自身を呼び出すことで問題を解く手法です。複雑な問題を小さな部分問題に分割して解く際に非常に効果的です。

---

## 1. 基本的な再帰

### 階乗

```typescript
export function factorial(n: number): number {
  if (n <= 0) return 1;           // 基底ケース
  return n * factorial(n - 1);   // 再帰ケース
}
```

再帰の 2 要素: **基底ケース**（終了条件）と **再帰ケース**（自己呼び出し）。

### ユークリッドの互除法

```typescript
export function gcd(x: number, y: number): number {
  if (y === 0) return x;
  return gcd(y, x % y);
}
```

---

## 2. ハノイの塔

### Red — 失敗するテストを書く

```typescript
test('1 枚: A → C', () => {
  expect(hanoi(1, 'A', 'C', 'B')).toEqual([['A', 'C']]);
});

test('n 枚は 2^n - 1 回の移動', () => {
  for (let n = 1; n <= 6; n++) {
    expect(hanoi(n, 'A', 'C', 'B')).toHaveLength(2 ** n - 1);
  }
});
```

### Green — テストを通す最小限の実装

```typescript
export function hanoi(
  n: number,
  src: string,
  dst: string,
  via: string,
): [string, string][] {
  if (n === 1) return [[src, dst]];
  return [
    ...hanoi(n - 1, src, via, dst),
    [src, dst],
    ...hanoi(n - 1, via, dst, src),
  ];
}
```

スプレッド構文 `[...a, b, ...c]` で Python の `moves.extend()` + `moves.append()` を 1 行で表現します。

---

## 3. 8 王妃問題

### 3 バージョンの比較

| クラス | 制約 | 解の数 |
|--------|------|--------|
| `EightQueen` | なし | 8^8 = 16,777,216 |
| `EightQueen2` | 行の重複なし | 8! = 40,320 |
| `EightQueen3` | 行・対角線の重複なし | 92 |

### 重いテストの分離

```typescript
// 8^8 通りは非常に重いため skip
test.skip('8^8 通りの組み合わせ（低速）', () => {
  const eq = new EightQueen();
  eq.set(0);
  expect(eq.result).toHaveLength(8 ** 8);
});

// 完全解（92 通り）は十分高速
test('8 王妃問題の解は 92 通り', () => {
  const eq3 = new EightQueen3();
  eq3.set(0);
  expect(eq3.result).toHaveLength(92);
});
```

### Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| タプル返り値 | `list[tuple[str, str]]` | `[string, string][]` |
| リスト連結 | `moves.extend(...); moves.append(...)` | `[...a, b, ...c]` |
| set | `visited: set[tuple[int, int]]` | `Set<string>` + `\`${r},${c}\`` |

---

## テスト実行結果

```bash
$ npm test tests/recursion.test.ts

Tests:  2 skipped, 21 passed, 23 total
```

---

## まとめ

| アルゴリズム | 関数/クラス | 計算量 |
|-------------|------------|--------|
| 階乗 | `factorial` | O(n) |
| 最大公約数 | `gcd` | O(log min(x,y)) |
| 再帰的合計 | `recursiveSum` | O(n) |
| ハノイの塔 | `hanoi` | O(2^n) |
| 迷路探索 | `mazeSolve` | O(行数 × 列数) |
| 8 王妃（完全解）| `EightQueen3` | O(n!) |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
