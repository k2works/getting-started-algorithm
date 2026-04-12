/**
 * 第5章 再帰アルゴリズム
 */

/** n の階乗を再帰的に計算 */
export function factorial(n: number): number {
  if (n <= 0) return 1;
  return n * factorial(n - 1);
}

/** ユークリッドの互除法で最大公約数を求める */
export function gcd(x: number, y: number): number {
  if (y === 0) return x;
  return gcd(y, x % y);
}

/** 1 から n までの和を再帰的に計算 */
export function recursiveSum(n: number): number {
  if (n <= 0) return 0;
  return n + recursiveSum(n - 1);
}

/** ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す */
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

/** 迷路をバックトラッキングで解く（0: 通路, 1: 壁） */
export function mazeSolve(
  maze: number[][],
  row: number,
  col: number,
  goalRow: number,
  goalCol: number,
  visited: Set<string> = new Set(),
): boolean {
  if (row === goalRow && col === goalCol) return true;

  const rows = maze.length;
  const cols = maze[0].length;
  visited.add(`${row},${col}`);

  for (const [dr, dc] of [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
    const nr = row + dr;
    const nc = col + dc;
    if (
      nr >= 0 && nr < rows &&
      nc >= 0 && nc < cols &&
      maze[nr][nc] === 0 &&
      !visited.has(`${nr},${nc}`)
    ) {
      if (mazeSolve(maze, nr, nc, goalRow, goalCol, visited)) return true;
    }
  }
  return false;
}

// ─── 8 王妃問題 ────────────────────────────────────────────

/** 8 王妃問題（全組み合わせ列挙） */
export class EightQueen {
  result: number[][] = [];
  private pos: number[];
  private n: number;

  constructor(n: number = 8) {
    this.n = n;
    this.pos = new Array(n).fill(0);
  }

  private put(): void {
    this.result.push([...this.pos]);
  }

  set(i: number): void {
    for (let j = 0; j < this.n; j++) {
      this.pos[i] = j;
      if (i === this.n - 1) this.put();
      else this.set(i + 1);
    }
  }
}

/** 8 王妃問題（行制約あり） */
export class EightQueen2 {
  result: number[][] = [];
  private pos: number[];
  private flag: boolean[];
  private n: number;

  constructor(n: number = 8) {
    this.n = n;
    this.pos = new Array(n).fill(0);
    this.flag = new Array(n).fill(false);
  }

  private put(): void {
    this.result.push([...this.pos]);
  }

  set(i: number): void {
    for (let j = 0; j < this.n; j++) {
      if (!this.flag[j]) {
        this.pos[i] = j;
        if (i === this.n - 1) {
          this.put();
        } else {
          this.flag[j] = true;
          this.set(i + 1);
          this.flag[j] = false;
        }
      }
    }
  }
}

/** 8 王妃問題（行・対角線制約あり）— 92 通りの解 */
export class EightQueen3 {
  result: number[][] = [];
  private pos: number[] = new Array(8).fill(0);
  private flagA: boolean[] = new Array(8).fill(false);
  private flagB: boolean[] = new Array(15).fill(false);
  private flagC: boolean[] = new Array(15).fill(false);

  private put(): void {
    this.result.push([...this.pos]);
  }

  set(i: number): void {
    for (let j = 0; j < 8; j++) {
      if (!this.flagA[j] && !this.flagB[i + j] && !this.flagC[i - j + 7]) {
        this.pos[i] = j;
        if (i === 7) {
          this.put();
        } else {
          this.flagA[j] = true;
          this.flagB[i + j] = true;
          this.flagC[i - j + 7] = true;
          this.set(i + 1);
          this.flagA[j] = false;
          this.flagB[i + j] = false;
          this.flagC[i - j + 7] = false;
        }
      }
    }
  }
}
