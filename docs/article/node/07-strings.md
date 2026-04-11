# 第 7 章 文字列処理

## はじめに

この章では **文字列探索アルゴリズム** と基本的な文字列操作を学びます。テキスト中でパターンを効率的に探すアルゴリズムは、テキストエディタ、検索エンジン、ウイルス検出など幅広い場面で使われます。

---

## 1. ブルートフォース文字列探索

最も素直な実装。テキストの各位置でパターンを照合します。

### Red — 失敗するテストを書く

```typescript
test('見つかる', () => { expect(bfMatch('ABCXDEZCABACABAB', 'ABAB')).toBe(12); });
test('見つからない', () => { expect(bfMatch('ABCDE', 'XYZ')).toBe(-1); });
test('空パターン', () => { expect(bfMatch('ABCDE', '')).toBe(0); });
```

### Green — 最小限の実装

```typescript
export function bfMatch(text: string, pattern: string): number {
  const n = text.length;
  const m = pattern.length;
  if (m === 0) return 0;
  for (let i = 0; i <= n - m; i++) {
    let j = 0;
    while (j < m && text[i + j] === pattern[j]) j++;
    if (j === m) return i;
  }
  return -1;
}
```

計算量: **O(n × m)**。

---

## 2. KMP（Knuth-Morris-Pratt）法

失敗関数テーブルを使い、比較の重複を避けます。

```typescript
function buildKmpTable(pattern: string): number[] {
  const m = pattern.length;
  const table = new Array<number>(m).fill(0);
  let k = 0;
  for (let i = 1; i < m; i++) {
    while (k > 0 && pattern[k] !== pattern[i]) k = table[k - 1];
    if (pattern[k] === pattern[i]) k++;
    table[i] = k;
  }
  return table;
}

export function kmpMatch(text: string, pattern: string): number {
  const n = text.length;
  const m = pattern.length;
  if (m === 0) return 0;

  const table = buildKmpTable(pattern);
  let j = 0;
  for (let i = 0; i < n; i++) {
    while (j > 0 && text[i] !== pattern[j]) j = table[j - 1];
    if (text[i] === pattern[j]) j++;
    if (j === m) return i - m + 1;
  }
  return -1;
}
```

計算量: **O(n + m)**。

---

## 3. Boyer-Moore 法

パターンを右から左へ比較し、不一致時にスキップ量を最大化します。

```typescript
export function bmMatch(text: string, pattern: string): number {
  const n = text.length;
  const m = pattern.length;
  if (m === 0) return 0;

  const badChar = new Map<string, number>();
  for (let i = 0; i < m; i++) badChar.set(pattern[i], i);

  let s = 0;
  while (s <= n - m) {
    let j = m - 1;
    while (j >= 0 && pattern[j] === text[s + j]) j--;
    if (j < 0) return s;
    const skip = j - (badChar.get(text[s + j]) ?? -1);
    s += Math.max(1, skip);
  }
  return -1;
}
```

計算量: 平均 **O(n / m)**、最悪 O(n × m)。

TypeScript の `??` 演算子（Nullish Coalescing）で `Map.get()` のデフォルト値を -1 に設定しています（Python の `dict.get(key, -1)` と同等）。

---

## 4. 文字のカウント

```typescript
export function countChars(s: string): Record<string, number> {
  const result: Record<string, number> = {};
  for (const c of s) result[c] = (result[c] ?? 0) + 1;
  return result;
}
```

Python の `dict` に対応する TypeScript は `Record<string, number>` または `{ [key: string]: number }` です。

---

## 5. 文字列の逆順と回文判定

```typescript
export function reverseString(s: string): string {
  return s.split('').reverse().join('');
}

export function isPalindrome(s: string): boolean {
  return s === reverseString(s);
}
```

Python の `s[::-1]` は TypeScript に存在しないため、`split('').reverse().join('')` で代替します。

---

## テスト実行結果

```bash
$ npm test tests/strings.test.ts

Tests:  27 passed, 27 total
```

---

## まとめ

| アルゴリズム | 計算量（平均） | 特徴 |
|------------|--------------|------|
| ブルートフォース | O(n × m) | シンプル |
| KMP | O(n + m) | 失敗関数テーブルで重複を排除 |
| Boyer-Moore | O(n / m) | 大きな文字集合で高速 |

## Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| 文字列逆順 | `s[::-1]` | `s.split('').reverse().join('')` |
| 辞書デフォルト値 | `dict.get(key, -1)` | `map.get(key) ?? -1` |
| 辞書型 | `dict[str, int]` | `Record<string, number>` |
| for ループ | `for c in s:` | `for (const c of s)` |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
