#include <string.h>
#include "recursion.h"

int factorial(int n) {
    if (n <= 0) return 1;
    return n * factorial(n - 1);
}

int gcd(int x, int y) {
    if (y == 0) return x;
    return gcd(y, x % y);
}

int recursive_sum(int n) {
    if (n <= 0) return 0;
    return n + recursive_sum(n - 1);
}

int hanoi(int n, char src, char dst, char via, HanoiMove *moves) {
    if (n == 1) {
        moves[0].from = src;
        moves[0].to   = dst;
        return 1;
    }
    int k = hanoi(n - 1, src, via, dst, moves);
    moves[k].from = src;
    moves[k].to   = dst;
    k++;
    k += hanoi(n - 1, via, dst, src, moves + k);
    return k;
}

/* maze_solve uses a visited array on the stack (max 10x10) */
#define MAX_MAZE 10
static int _visited[MAX_MAZE][MAX_MAZE];

static int _maze_solve(const int *maze, int rows, int cols,
                       int row, int col, int gr, int gc) {
    if (row == gr && col == gc) return 1;
    _visited[row][col] = 1;
    int dr[] = {-1, 1, 0, 0};
    int dc[] = {0, 0, -1, 1};
    for (int d = 0; d < 4; d++) {
        int nr = row + dr[d], nc = col + dc[d];
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols
            && maze[nr * cols + nc] == 0 && !_visited[nr][nc]) {
            if (_maze_solve(maze, rows, cols, nr, nc, gr, gc)) return 1;
        }
    }
    return 0;
}

int maze_solve(const int *maze, int rows, int cols,
               int row, int col, int goal_row, int goal_col) {
    memset(_visited, 0, sizeof(_visited));
    return _maze_solve(maze, rows, cols, row, col, goal_row, goal_col);
}

/* Eight queens - version 1: all 8^8 combinations */
static int _eq1_count;
static int _eq1_pos[8];

static void _eq1_set(int i) {
    for (int j = 0; j < 8; j++) {
        _eq1_pos[i] = j;
        if (i == 7) _eq1_count++;
        else _eq1_set(i + 1);
    }
}

int eight_queen(void) {
    _eq1_count = 0;
    _eq1_set(0);
    return _eq1_count;
}

/* Eight queens - version 2: row constraint (8! solutions) */
static int _eq2_count;
static int _eq2_pos[8];
static int _eq2_flag[8];

static void _eq2_set(int i) {
    for (int j = 0; j < 8; j++) {
        if (!_eq2_flag[j]) {
            _eq2_pos[i] = j;
            if (i == 7) _eq2_count++;
            else {
                _eq2_flag[j] = 1;
                _eq2_set(i + 1);
                _eq2_flag[j] = 0;
            }
        }
    }
}

int eight_queen2(void) {
    _eq2_count = 0;
    memset(_eq2_flag, 0, sizeof(_eq2_flag));
    _eq2_set(0);
    return _eq2_count;
}

/* Eight queens - version 3: row + diagonal constraints (92 solutions) */
static int _eq3_count;
static int _eq3_pos[8];
static int _eq3_fa[8];
static int _eq3_fb[15];
static int _eq3_fc[15];

static void _eq3_set(int i) {
    for (int j = 0; j < 8; j++) {
        if (!_eq3_fa[j] && !_eq3_fb[i+j] && !_eq3_fc[i-j+7]) {
            _eq3_pos[i] = j;
            if (i == 7) _eq3_count++;
            else {
                _eq3_fa[j] = _eq3_fb[i+j] = _eq3_fc[i-j+7] = 1;
                _eq3_set(i + 1);
                _eq3_fa[j] = _eq3_fb[i+j] = _eq3_fc[i-j+7] = 0;
            }
        }
    }
}

int eight_queen3(void) {
    _eq3_count = 0;
    memset(_eq3_fa, 0, sizeof(_eq3_fa));
    memset(_eq3_fb, 0, sizeof(_eq3_fb));
    memset(_eq3_fc, 0, sizeof(_eq3_fc));
    _eq3_set(0);
    return _eq3_count;
}
