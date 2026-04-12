# 第 5 章 再帰アルゴリズム

## はじめに

再帰は関数が自分自身を呼び出す技法です。C では関数ポインタや再帰呼び出しを利用して、問題を小さな部分問題に分解します。

---

## 1. 階乗と最大公約数

### Red — 失敗するテストを書く

```c
void test_factorial(void) {
    ASSERT_EQ_INT(120, factorial(5));
    ASSERT_EQ_INT(1,   factorial(0));
}

void test_gcd(void) {
    ASSERT_EQ_INT(6, gcd(12, 18));
    ASSERT_EQ_INT(1, gcd(7,  13));
}
```

### Green — 実装

```c
int factorial(int n) {
    return (n <= 1) ? 1 : n * factorial(n - 1);
}

int gcd(int a, int b) {
    return (b == 0) ? a : gcd(b, a % b);
}
```

ユークリッド互除法：`gcd(a, b) = gcd(b, a % b)`（b = 0 のとき a が答え）

---

## 2. ハノイの塔

`n` 枚のディスクを柱 A から柱 C へ（柱 B を補助として）移動する手順を求めます。

### Red — 失敗するテストを書く

```c
void test_hanoi(void) {
    HanoiMove moves[10];
    int n = hanoi(3, 'A', 'B', 'C', moves, 10);
    ASSERT_EQ_INT(7, n);  /* 2^3 - 1 = 7 手 */
    ASSERT_EQ_INT('A', moves[0].from);
    ASSERT_EQ_INT('C', moves[0].to);
}
```

### Green — 実装

```c
typedef struct { char from; char to; } HanoiMove;

int hanoi(int n, char from, char via, char to,
          HanoiMove *moves, int max_moves) {
    if (n == 0) return 0;
    int k = hanoi(n - 1, from, to, via, moves, max_moves);
    if (k < max_moves) { moves[k].from = from; moves[k].to = to; k++; }
    return k + hanoi(n - 1, via, from, to, moves + k, max_moves - k);
}
```

再帰の構造：
1. `n-1` 枚を `from → via`（`to` を補助）
2. 1 枚を `from → to`
3. `n-1` 枚を `via → to`（`from` を補助）

---

## 3. 迷路探索

バックトラッキングで迷路の出口を探します。

### Red — 失敗するテストを書く

```c
void test_maze_solve(void) {
    int maze[5][5] = {
        {1,1,1,1,1},
        {1,0,0,0,1},
        {1,0,1,0,1},
        {1,0,0,2,1},  /* 2 = ゴール */
        {1,1,1,1,1}
    };
    ASSERT_TRUE(maze_solve((int *)maze, 5, 5, 1, 1));
}
```

### Green — 実装

```c
int maze_solve(int *maze, int rows, int cols, int r, int c) {
    if (maze[r * cols + c] == 2) return 1;  /* ゴール */
    if (maze[r * cols + c] != 0) return 0;  /* 壁 or 訪問済み */
    maze[r * cols + c] = -1;                /* 訪問済みマーク */
    int dr[] = {-1, 1, 0, 0};
    int dc[] = {0, 0, -1, 1};
    for (int i = 0; i < 4; i++) {
        if (maze_solve(maze, rows, cols, r + dr[i], c + dc[i]))
            return 1;
    }
    maze[r * cols + c] = 0;  /* バックトラック */
    return 0;
}
```

---

## 4. 8 王妃問題

8 × 8 のチェスボードに 8 個のクイーンを互いに攻撃しないように配置します。

### Red — 失敗するテストを書く

```c
void test_eight_queen(void) {
    ASSERT_EQ_INT(16777216, eight_queen());   /* 8^8（全列挙） */
    ASSERT_EQ_INT(40320,    eight_queen2());  /* 8!（行制約） */
    ASSERT_EQ_INT(92,       eight_queen3());  /* 行+対角制約 */
}
```

### Green — 段階的実装

```c
/* 方法1: 各行に1つ（8^8 通り試す） */
static int count1;
static void place1(int queens[], int row) {
    if (row == 8) { count1++; return; }
    for (int col = 0; col < 8; col++) {
        queens[row] = col;
        place1(queens, row + 1);
    }
}

/* 方法3: 行制約 + 対角制約（92 通り） */
static int flag_a[8], flag_b[15], flag_c[15];
static int count3;
static void place3(int queens[], int row) {
    if (row == 8) { count3++; return; }
    for (int col = 0; col < 8; col++) {
        if (!flag_a[col] && !flag_b[row+col] && !flag_c[row-col+7]) {
            queens[row] = col;
            flag_a[col] = flag_b[row+col] = flag_c[row-col+7] = 1;
            place3(queens, row + 1);
            flag_a[col] = flag_b[row+col] = flag_c[row-col+7] = 0;
        }
    }
}
```

| 方法 | 試行数 | 制約 |
|------|--------|------|
| eight_queen | 16,777,216 | なし |
| eight_queen2 | 40,320 | 同じ行に置かない |
| eight_queen3 | 92 | 行・対角線も制約 |

---

## テスト実行結果

```bash
$ make test-chapter05/recursion
=== Testing chapter05/recursion ===
14 tests run: 14 passed, 0 failed
```

---

## まとめ

| 問題 | 再帰の特徴 |
|------|-----------|
| 階乗・GCD | 末尾再帰（シンプル） |
| ハノイの塔 | 分岐再帰（2 回呼び出し） |
| 迷路探索 | バックトラッキング（訪問マーク + 取消し） |
| 8 王妃問題 | 枝刈り付きバックトラッキング |

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
