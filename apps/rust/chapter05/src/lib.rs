// chapter05: 再帰アルゴリズム

/// n の階乗を再帰的に計算する
///
/// # Examples
/// ```
/// assert_eq!(chapter05::factorial(5), 120);
/// ```
pub fn factorial(n: u64) -> u64 {
    if n == 0 {
        return 1;
    }
    n * factorial(n - 1)
}

/// ユークリッドの互除法で最大公約数を求める
///
/// # Examples
/// ```
/// assert_eq!(chapter05::gcd(22, 8), 2);
/// ```
pub fn gcd(x: u64, y: u64) -> u64 {
    if y == 0 {
        return x;
    }
    gcd(y, x % y)
}

/// 1 から n までの和を再帰的に計算する
///
/// # Examples
/// ```
/// assert_eq!(chapter05::recur(5), 15);
/// ```
pub fn recur(n: u64) -> u64 {
    if n == 0 {
        return 0;
    }
    n + recur(n - 1)
}

/// ハノイの塔: n 枚の円盤を from から to へ via を経由して移動する手順を返す
///
/// # Examples
/// ```
/// let moves = chapter05::hanoi(1, 'A', 'C', 'B');
/// assert_eq!(moves, vec!["A -> C".to_string()]);
/// ```
pub fn hanoi(n: u32, from: char, to: char, via: char) -> Vec<String> {
    if n == 0 {
        return vec![];
    }
    if n == 1 {
        return vec![format!("{} -> {}", from, to)];
    }
    let mut moves = Vec::new();
    moves.extend(hanoi(n - 1, from, via, to));
    moves.push(format!("{} -> {}", from, to));
    moves.extend(hanoi(n - 1, via, to, from));
    moves
}

/// 迷路探索（再帰的バックトラッキング）
///
/// maze の各セル: 0 = 通路, 1 = 壁
/// 解が見つかった場合は経路を返す
pub fn maze_solve(
    maze: &Vec<Vec<u8>>,
    start: (usize, usize),
    goal: (usize, usize),
) -> Option<Vec<(usize, usize)>> {
    let rows = maze.len();
    let cols = maze[0].len();
    let mut visited = vec![vec![false; cols]; rows];
    let mut path = Vec::new();
    if maze_solve_rec(maze, start, goal, &mut visited, &mut path) {
        Some(path)
    } else {
        None
    }
}

fn maze_solve_rec(
    maze: &Vec<Vec<u8>>,
    pos: (usize, usize),
    goal: (usize, usize),
    visited: &mut Vec<Vec<bool>>,
    path: &mut Vec<(usize, usize)>,
) -> bool {
    let (row, col) = pos;
    if pos == goal {
        path.push(pos);
        return true;
    }

    let rows = maze.len();
    let cols = maze[0].len();
    visited[row][col] = true;
    path.push(pos);

    let directions: [(isize, isize); 4] = [(-1, 0), (1, 0), (0, -1), (0, 1)];
    for (dr, dc) in &directions {
        let nr = row as isize + dr;
        let nc = col as isize + dc;
        if nr >= 0 && nr < rows as isize && nc >= 0 && nc < cols as isize {
            let nr = nr as usize;
            let nc = nc as usize;
            if maze[nr][nc] == 0 && !visited[nr][nc] {
                if maze_solve_rec(maze, (nr, nc), goal, visited, path) {
                    return true;
                }
            }
        }
    }

    path.pop();
    false
}

/// 8 王妃問題（基本版: 全組み合わせ列挙、制約なし）
///
/// 各列に王妃を 0-7 行のいずれかに配置する全組み合わせを返す。
/// 結果は 8^8 = 16,777,216 通り。
pub fn eight_queen() -> Vec<[usize; 8]> {
    let mut result = Vec::new();
    let mut pos = [0usize; 8];
    eight_queen_set(&mut pos, 0, &mut result);
    result
}

fn eight_queen_set(pos: &mut [usize; 8], col: usize, result: &mut Vec<[usize; 8]>) {
    for j in 0..8 {
        pos[col] = j;
        if col == 7 {
            result.push(*pos);
        } else {
            eight_queen_set(pos, col + 1, result);
        }
    }
}

/// 8 王妃問題（最適化版 1: 行の重複排除）
///
/// 各行・各列に 1 個の王妃を配置する組み合わせを返す。
/// 結果は 8! = 40,320 通り。
pub fn eight_queen2() -> Vec<[usize; 8]> {
    let mut result = Vec::new();
    let mut pos = [0usize; 8];
    let mut flag_row = [false; 8];
    eight_queen2_set(&mut pos, 0, &mut flag_row, &mut result);
    result
}

fn eight_queen2_set(
    pos: &mut [usize; 8],
    col: usize,
    flag_row: &mut [bool; 8],
    result: &mut Vec<[usize; 8]>,
) {
    for j in 0..8 {
        if !flag_row[j] {
            pos[col] = j;
            if col == 7 {
                result.push(*pos);
            } else {
                flag_row[j] = true;
                eight_queen2_set(pos, col + 1, flag_row, result);
                flag_row[j] = false;
            }
        }
    }
}

/// 8 王妃問題（最適化版 2: 行・対角線の重複排除）
///
/// 行、列、対角線すべての制約を適用した完全な 8 王妃問題の解を返す。
/// 結果は 92 通り。
pub fn eight_queen3() -> Vec<[usize; 8]> {
    let mut result = Vec::new();
    let mut pos = [0usize; 8];
    let mut flag_a = [false; 8]; // 行フラグ
    let mut flag_b = [false; 15]; // 右上がり対角線フラグ
    let mut flag_c = [false; 15]; // 右下がり対角線フラグ
    eight_queen3_set(&mut pos, 0, &mut flag_a, &mut flag_b, &mut flag_c, &mut result);
    result
}

fn eight_queen3_set(
    pos: &mut [usize; 8],
    col: usize,
    flag_a: &mut [bool; 8],
    flag_b: &mut [bool; 15],
    flag_c: &mut [bool; 15],
    result: &mut Vec<[usize; 8]>,
) {
    for j in 0..8 {
        if !flag_a[j] && !flag_b[col + j] && !flag_c[col + 7 - j] {
            pos[col] = j;
            if col == 7 {
                result.push(*pos);
            } else {
                flag_a[j] = true;
                flag_b[col + j] = true;
                flag_c[col + 7 - j] = true;
                eight_queen3_set(pos, col + 1, flag_a, flag_b, flag_c, result);
                flag_a[j] = false;
                flag_b[col + j] = false;
                flag_c[col + 7 - j] = false;
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    // ===== 階乗 =====

    #[test]
    fn test_factorial_0() {
        assert_eq!(factorial(0), 1);
    }

    #[test]
    fn test_factorial_1() {
        assert_eq!(factorial(1), 1);
    }

    #[test]
    fn test_factorial_5() {
        assert_eq!(factorial(5), 120);
    }

    #[test]
    fn test_factorial_10() {
        assert_eq!(factorial(10), 3628800);
    }

    // ===== 最大公約数 =====

    #[test]
    fn test_gcd_basic() {
        assert_eq!(gcd(22, 8), 2);
    }

    #[test]
    fn test_gcd_one_multiple() {
        assert_eq!(gcd(12, 4), 4);
    }

    #[test]
    fn test_gcd_coprime() {
        assert_eq!(gcd(7, 11), 1);
    }

    #[test]
    fn test_gcd_same() {
        assert_eq!(gcd(15, 15), 15);
    }

    // ===== 再帰的な和 =====

    #[test]
    fn test_recur_1() {
        assert_eq!(recur(1), 1);
    }

    #[test]
    fn test_recur_5() {
        assert_eq!(recur(5), 15);
    }

    #[test]
    fn test_recur_10() {
        assert_eq!(recur(10), 55);
    }

    // ===== ハノイの塔 =====

    #[test]
    fn test_hanoi_1() {
        let moves = hanoi(1, 'A', 'C', 'B');
        assert_eq!(moves, vec!["A -> C"]);
    }

    #[test]
    fn test_hanoi_2() {
        let moves = hanoi(2, 'A', 'C', 'B');
        assert_eq!(moves, vec!["A -> B", "A -> C", "B -> C"]);
    }

    #[test]
    fn test_hanoi_3_count() {
        let moves = hanoi(3, 'A', 'C', 'B');
        assert_eq!(moves.len(), 7); // 2^3 - 1
    }

    #[test]
    fn test_hanoi_move_count() {
        for n in 1..=5 {
            let moves = hanoi(n, 'A', 'C', 'B');
            assert_eq!(moves.len(), (1 << n) - 1); // 2^n - 1
        }
    }

    // ===== 迷路探索 =====

    #[test]
    fn test_maze_solvable() {
        let maze = vec![
            vec![1, 1, 1, 1, 1],
            vec![1, 0, 0, 0, 1],
            vec![1, 0, 1, 0, 1],
            vec![1, 0, 0, 0, 1],
            vec![1, 1, 1, 1, 1],
        ];
        let result = maze_solve(&maze, (1, 1), (3, 3));
        assert!(result.is_some());
        let path = result.unwrap();
        assert_eq!(*path.first().unwrap(), (1, 1));
        assert_eq!(*path.last().unwrap(), (3, 3));
    }

    #[test]
    fn test_maze_unsolvable() {
        let maze = vec![
            vec![1, 1, 1, 1, 1],
            vec![1, 0, 1, 0, 1],
            vec![1, 1, 1, 1, 1],
            vec![1, 0, 0, 0, 1],
            vec![1, 1, 1, 1, 1],
        ];
        let result = maze_solve(&maze, (1, 1), (3, 1));
        assert!(result.is_none());
    }

    // ===== 8 王妃問題（基本） =====

    #[test]
    fn test_eight_queen_count() {
        let result = eight_queen();
        // 8^8 = 16,777,216 通り
        assert_eq!(result.len(), 16_777_216);
    }

    #[test]
    fn test_eight_queen_column_count() {
        let result = eight_queen();
        // 各結果の列数が 8
        assert!(result.iter().all(|row| row.len() == 8));
    }

    // ===== 8 王妃問題（行制約） =====

    #[test]
    fn test_eight_queen2_count() {
        let result = eight_queen2();
        // 8! = 40,320 通り
        assert_eq!(result.len(), 40_320);
    }

    #[test]
    fn test_eight_queen2_no_row_dup() {
        let result = eight_queen2();
        for row in &result {
            let mut seen = [false; 8];
            for &val in row {
                assert!(!seen[val], "行の重複が検出されました");
                seen[val] = true;
            }
        }
    }

    // ===== 8 王妃問題（完全解） =====

    #[test]
    fn test_eight_queen3_count() {
        let result = eight_queen3();
        // 8 王妃問題の解は 92 通り
        assert_eq!(result.len(), 92);
    }

    #[test]
    fn test_eight_queen3_no_row_dup() {
        let result = eight_queen3();
        for row in &result {
            let mut seen = [false; 8];
            for &val in row {
                assert!(!seen[val], "行の重複が検出されました");
                seen[val] = true;
            }
        }
    }
}
