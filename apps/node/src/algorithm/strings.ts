/**
 * 第7章 文字列処理
 */

/** ブルートフォース文字列探索 — O(n * m) */
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

/** KMP 法の失敗関数テーブルを構築 */
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

/** KMP（Knuth-Morris-Pratt）文字列探索 — O(n + m) */
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

/** Boyer-Moore 文字列探索（Bad Character ルール） — 平均 O(n / m) */
export function bmMatch(text: string, pattern: string): number {
  const n = text.length;
  const m = pattern.length;
  if (m === 0) return 0;

  // Bad Character テーブル: 各文字のパターン内の最後の出現位置
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

/** 文字列中の各文字の出現回数を返す */
export function countChars(s: string): Record<string, number> {
  const result: Record<string, number> = {};
  for (const c of s) result[c] = (result[c] ?? 0) + 1;
  return result;
}

/** 文字列を逆順にして返す */
export function reverseString(s: string): string {
  return s.split('').reverse().join('');
}

/** 文字列が回文かどうかを判定 */
export function isPalindrome(s: string): boolean {
  return s === reverseString(s);
}
