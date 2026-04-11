/**
 * 第2章 配列
 */

/** シーケンスの要素の最大値を返す */
export function maxOf(a: number[]): number {
  let maximum = a[0];
  for (let i = 1; i < a.length; i++) {
    if (a[i] > maximum) maximum = a[i];
  }
  return maximum;
}

/** 配列の要素の並びを反転する（破壊的） */
export function reverseArray(a: number[]): void {
  const n = a.length;
  for (let i = 0; i < Math.floor(n / 2); i++) {
    const tmp = a[i];
    a[i] = a[n - i - 1];
    a[n - i - 1] = tmp;
  }
}

/** 整数値xをr進数に変換した文字列を返す */
export function cardConv(x: number, r: number): string {
  const dchar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  let d = '';
  while (x > 0) {
    d += dchar[x % r];
    x = Math.floor(x / r);
  }
  return d.split('').reverse().join('');
}

/** x以下の素数を列挙する（第1版）— 除算回数を返す */
export function prime1(x: number): number {
  let counter = 0;
  for (let n = 2; n <= x; n++) {
    for (let i = 2; i < n; i++) {
      counter++;
      if (n % i === 0) break;
    }
  }
  return counter;
}

/** x以下の素数を列挙する（第2版）— 除算回数を返す
 * 奇数のみを候補にし、すでに見つけた素数で割り切れるか確認する */
export function prime2(x: number): number {
  let counter = 0;
  let ptr = 0;
  const prime: number[] = new Array(500);

  prime[ptr++] = 2;

  outer: for (let n = 3; n <= x; n += 2) {
    for (let i = 1; i < ptr; i++) {
      counter++;
      if (n % prime[i] === 0) continue outer;
    }
    prime[ptr++] = n;
  }

  return counter;
}

/** x以下の素数を列挙する（第3版）— 除算回数を返す
 * 平方根以下の素数でのみ割り切れるか確認することで効率化する */
export function prime3(x: number): number {
  let counter = 0;
  let ptr = 0;
  const prime: number[] = new Array(500);

  prime[ptr++] = 2;
  prime[ptr++] = 3;

  outer: for (let n = 5; n <= 1000; n += 2) {
    let i = 1;
    while (prime[i] * prime[i] <= n) {
      counter += 2;
      if (n % prime[i] === 0) continue outer;
      i++;
    }
    prime[ptr++] = n;
    counter++;
  }

  return counter;
}
