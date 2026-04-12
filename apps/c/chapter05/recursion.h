#ifndef RECURSION_H
#define RECURSION_H

int factorial(int n);
int gcd(int x, int y);
int recursive_sum(int n);

typedef struct { char from; char to; } HanoiMove;
int hanoi(int n, char src, char dst, char via, HanoiMove *moves);

int maze_solve(const int *maze, int rows, int cols,
               int row, int col, int goal_row, int goal_col);

int eight_queen(void);
int eight_queen2(void);
int eight_queen3(void);

#endif /* RECURSION_H */
