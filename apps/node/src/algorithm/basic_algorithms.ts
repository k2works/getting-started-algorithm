/**
 * 第1章 基本的なアルゴリズム
 */

/** 3つの整数値の最大値を返す */
export function max3(a: number, b: number, c: number): number {
  let maximum = a;
  if (b > maximum) maximum = b;
  if (c > maximum) maximum = c;
  return maximum;
}

/** 3つの整数値の中央値を返す */
export function med3(a: number, b: number, c: number): number {
  if (a >= b) {
    if (b >= c) return b;
    else if (a <= c) return a;
    else return c;
  } else if (a > c) {
    return a;
  } else if (b > c) {
    return c;
  } else {
    return b;
  }
}

/** 整数値の符号を判定する */
export function judgeSign(n: number): string {
  if (n > 0) return 'その値は正です。';
  else if (n < 0) return 'その値は負です。';
  else return 'その値は0です。';
}

/** while 文で 1 から n までの総和を求める */
export function sum1ToNWhile(n: number): number {
  let total = 0;
  let i = 1;
  while (i <= n) {
    total += i;
    i++;
  }
  return total;
}

/** for 文で 1 から n までの総和を求める */
export function sum1ToNFor(n: number): number {
  let total = 0;
  for (let i = 1; i <= n; i++) {
    total += i;
  }
  return total;
}

/** 記号文字 '+' と '-' を交互に表示する（剰余判定方式） */
export function alternative1(n: number): string {
  let result = '';
  for (let i = 0; i < n; i++) {
    result += i % 2 ? '-' : '+';
  }
  return result;
}

/** 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式） */
export function alternative2(n: number): string {
  let result = '+-'.repeat(Math.floor(n / 2));
  if (n % 2) result += '+';
  return result;
}

/** 縦横が整数で面積が area の長方形の辺の長さを列挙する */
export function rectangle(area: number): string {
  let result = '';
  for (let i = 1; i <= area; i++) {
    if (i * i > area) break;
    if (area % i) continue;
    result += `${i}x${area / i} `;
  }
  return result;
}

/** 九九の表を返す */
export function multiplicationTable(): string {
  let result = '-'.repeat(27) + '\n';
  for (let i = 1; i <= 9; i++) {
    for (let j = 1; j <= 9; j++) {
      result += String(i * j).padStart(3);
    }
    result += '\n';
  }
  result += '-'.repeat(27);
  return result;
}

/** 左下側が直角の二等辺三角形を返す */
export function triangleLb(n: number): string {
  let result = '';
  for (let i = 1; i <= n; i++) {
    result += '*'.repeat(i) + '\n';
  }
  return result;
}
