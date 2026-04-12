namespace Algorithm;

/// <summary>第5章 再帰アルゴリズム</summary>
public static class Recursion
{
    public static int Factorial(int n) => n <= 0 ? 1 : n * Factorial(n - 1);

    public static int Gcd(int x, int y) => y == 0 ? x : Gcd(y, x % y);

    public static int RecursiveSum(int n) => n <= 0 ? 0 : n + RecursiveSum(n - 1);

    public static List<string> Hanoi(int n, string src, string dst, string via)
    {
        var moves = new List<string>();
        HanoiHelper(n, src, dst, via, moves);
        return moves;
    }

    private static void HanoiHelper(int n, string src, string dst, string via, List<string> moves)
    {
        if (n == 1) { moves.Add($"{src}->{dst}"); return; }
        HanoiHelper(n - 1, src, via, dst, moves);
        moves.Add($"{src}->{dst}");
        HanoiHelper(n - 1, via, dst, src, moves);
    }

    public static bool MazeSolve(int[][] maze, int row, int col, int goalRow, int goalCol)
    {
        bool[][] visited = new bool[maze.Length][];
        for (int i = 0; i < maze.Length; i++) visited[i] = new bool[maze[i].Length];
        return MazeSolveHelper(maze, row, col, goalRow, goalCol, visited);
    }

    private static bool MazeSolveHelper(int[][] maze, int row, int col, int goalRow, int goalCol, bool[][] visited)
    {
        if (row == goalRow && col == goalCol) return true;
        visited[row][col] = true;
        int[][] dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
        foreach (var d in dirs)
        {
            int nr = row + d[0], nc = col + d[1];
            if (nr >= 0 && nr < maze.Length && nc >= 0 && nc < maze[0].Length
                && maze[nr][nc] == 0 && !visited[nr][nc])
                if (MazeSolveHelper(maze, nr, nc, goalRow, goalCol, visited)) return true;
        }
        return false;
    }

    public class EightQueen
    {
        private int _count;
        private readonly int[] _pos = new int[8];
        public void Set(int i)
        {
            for (int j = 0; j < 8; j++) { _pos[i] = j; if (i == 7) _count++; else Set(i + 1); }
        }
        public int GetCount() => _count;
    }

    public class EightQueen2
    {
        private readonly List<int[]> _result = [];
        private readonly int[] _pos = new int[8];
        private readonly bool[] _flag = new bool[8];
        public void Set(int i)
        {
            for (int j = 0; j < 8; j++)
            {
                if (!_flag[j])
                {
                    _pos[i] = j;
                    if (i == 7) _result.Add((int[])_pos.Clone());
                    else { _flag[j] = true; Set(i + 1); _flag[j] = false; }
                }
            }
        }
        public List<int[]> GetResult() => _result;
    }

    public class EightQueen3
    {
        private readonly List<int[]> _result = [];
        private readonly int[] _pos = new int[8];
        private readonly bool[] _flagA = new bool[8];
        private readonly bool[] _flagB = new bool[15];
        private readonly bool[] _flagC = new bool[15];
        public void Set(int i)
        {
            for (int j = 0; j < 8; j++)
            {
                if (!_flagA[j] && !_flagB[i + j] && !_flagC[i - j + 7])
                {
                    _pos[i] = j;
                    if (i == 7) _result.Add((int[])_pos.Clone());
                    else
                    {
                        _flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = true;
                        Set(i + 1);
                        _flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = false;
                    }
                }
            }
        }
        public List<int[]> GetResult() => _result;
    }
}
