package algorithm;

import java.util.ArrayList;
import java.util.List;

/** 第5章 再帰アルゴリズム */
public class Recursion {

    /** 階乗を再帰的に計算 */
    public static int factorial(int n) {
        if (n <= 0) return 1;
        return n * factorial(n - 1);
    }

    /** ユークリッドの互除法で最大公約数を求める */
    public static int gcd(int x, int y) {
        if (y == 0) return x;
        return gcd(y, x % y);
    }

    /** 1 から n までの和を再帰的に計算 */
    public static int recursiveSum(int n) {
        if (n <= 0) return 0;
        return n + recursiveSum(n - 1);
    }

    /** ハノイの塔: 移動手順をリストで返す */
    public static List<String> hanoi(int n, String src, String dst, String via) {
        List<String> moves = new ArrayList<>();
        hanoiHelper(n, src, dst, via, moves);
        return moves;
    }

    private static void hanoiHelper(int n, String src, String dst, String via, List<String> moves) {
        if (n == 1) {
            moves.add(src + "->" + dst);
            return;
        }
        hanoiHelper(n - 1, src, via, dst, moves);
        moves.add(src + "->" + dst);
        hanoiHelper(n - 1, via, dst, src, moves);
    }

    /** 迷路をバックトラッキングで解く */
    public static boolean mazeSolve(int[][] maze, int row, int col, int goalRow, int goalCol) {
        boolean[][] visited = new boolean[maze.length][maze[0].length];
        return mazeSolveHelper(maze, row, col, goalRow, goalCol, visited);
    }

    private static boolean mazeSolveHelper(int[][] maze, int row, int col,
                                           int goalRow, int goalCol, boolean[][] visited) {
        if (row == goalRow && col == goalCol) return true;
        visited[row][col] = true;
        int[][] dirs = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
        for (int[] d : dirs) {
            int nr = row + d[0], nc = col + d[1];
            if (nr >= 0 && nr < maze.length && nc >= 0 && nc < maze[0].length
                    && maze[nr][nc] == 0 && !visited[nr][nc]) {
                if (mazeSolveHelper(maze, nr, nc, goalRow, goalCol, visited)) return true;
            }
        }
        return false;
    }

    // --- 8 王妃問題 ---

    /** 8 王妃問題（全組み合わせ、制約なし） -- カウントのみ（OOM 対策） */
    public static class EightQueen {
        private int count;
        private final int[] pos = new int[8];

        public void set(int i) {
            for (int j = 0; j < 8; j++) {
                pos[i] = j;
                if (i == 7) count++;
                else set(i + 1);
            }
        }

        public int getCount() { return count; }
    }

    /** 8 王妃問題（行制約あり） */
    public static class EightQueen2 {
        private final List<int[]> result = new ArrayList<>();
        private final int[] pos = new int[8];
        private final boolean[] flag = new boolean[8];

        public void set(int i) {
            for (int j = 0; j < 8; j++) {
                if (!flag[j]) {
                    pos[i] = j;
                    if (i == 7) {
                        result.add(pos.clone());
                    } else {
                        flag[j] = true;
                        set(i + 1);
                        flag[j] = false;
                    }
                }
            }
        }

        public List<int[]> getResult() { return result; }
    }

    /** 8 王妃問題（行・対角線制約あり、完全解） */
    public static class EightQueen3 {
        private final List<int[]> result = new ArrayList<>();
        private final int[] pos = new int[8];
        private final boolean[] flagA = new boolean[8];
        private final boolean[] flagB = new boolean[15];
        private final boolean[] flagC = new boolean[15];

        public void set(int i) {
            for (int j = 0; j < 8; j++) {
                if (!flagA[j] && !flagB[i + j] && !flagC[i - j + 7]) {
                    pos[i] = j;
                    if (i == 7) {
                        result.add(pos.clone());
                    } else {
                        flagA[j] = true;
                        flagB[i + j] = true;
                        flagC[i - j + 7] = true;
                        set(i + 1);
                        flagA[j] = false;
                        flagB[i + j] = false;
                        flagC[i - j + 7] = false;
                    }
                }
            }
        }

        public List<int[]> getResult() { return result; }
    }
}
