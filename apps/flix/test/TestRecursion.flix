mod TestRecursion {
    /// 0 の階乗は 1。
    @Test
    def factorial_zero(): Unit \ Assert =
        Assert.assertEq(expected = Some(1), Recursion.factorial(0))

    /// 階乗を再帰で計算する。
    @Test
    def factorial_five(): Unit \ Assert =
        Assert.assertEq(expected = Some(120), Recursion.factorial(5))

    /// Int32 で表現できる最大の階乗を計算する。
    @Test
    def factorial_max_int32_input(): Unit \ Assert =
        Assert.assertEq(expected = Some(479001600), Recursion.factorial(12))

    /// 負数と Int32 の範囲を超える階乗は拒否する。
    @Test
    def factorial_rejects_out_of_range_input(): Unit \ Assert =
        Assert.assertEq(expected = None, Recursion.factorial(-1));
        Assert.assertEq(expected = None, Recursion.factorial(13))

    /// 反復版は再帰版と同じ値を返す。
    @Test
    def factorial_iterative_matches_recursive(): Unit \ Assert =
        Assert.assertEq(expected = Some(720), Recursion.factorialIterative(6))

    /// 反復版も 0 の階乗を扱う。
    @Test
    def factorial_iterative_zero(): Unit \ Assert =
        Assert.assertEq(expected = Some(1), Recursion.factorialIterative(0))

    /// GCD はユークリッドの互除法で求められる。
    @Test
    def gcd_basic(): Unit \ Assert =
        Assert.assertEq(expected = Some(2), Recursion.gcd(22, 8))

    /// 互いに素な数の最大公約数は 1。
    @Test
    def gcd_coprime(): Unit \ Assert =
        Assert.assertEq(expected = Some(1), Recursion.gcd(7, 11))

    /// どちらか一方が 0 の場合も最大公約数を求める。
    @Test
    def gcd_zero_operand(): Unit \ Assert =
        Assert.assertEq(expected = Some(8), Recursion.gcd(0, 8));
        Assert.assertEq(expected = Some(8), Recursion.gcd(8, 0))

    /// 2 つの 0 の最大公約数を 0 と定義する。
    @Test
    def gcd_both_zero(): Unit \ Assert =
        Assert.assertEq(expected = Some(0), Recursion.gcd(0, 0))

    /// GCD は負数を入力として受け付けない。
    @Test
    def gcd_rejects_negative_input(): Unit \ Assert =
        Assert.assertEq(expected = None, Recursion.gcd(-22, 8));
        Assert.assertEq(expected = None, Recursion.gcd(22, -8))

    /// 1 枚の円盤は 1 回で移動できる。
    @Test
    def hanoi_one_disk(): Unit \ Assert =
        Assert.assertEq(expected = ("A", "C") :: Nil, Recursion.hanoi(1, "A", "C", "B"))

    /// 3 枚の円盤を移動する正しい手順を返す。
    @Test
    def hanoi_three_disks(): Unit \ Assert =
        Assert.assertEq(
            expected =
                ("A", "C") ::
                ("A", "B") ::
                ("C", "B") ::
                ("A", "C") ::
                ("B", "A") ::
                ("B", "C") ::
                ("A", "C") ::
                Nil,
            Recursion.hanoi(3, "A", "C", "B")
        )

    /// 円盤 n 枚の移動回数は 2^n - 1。
    @Test
    def hanoi_move_count(): Unit \ Assert =
        Assert.assertEq(expected = 1, List.length(Recursion.hanoi(1, "A", "C", "B")));
        Assert.assertEq(expected = 3, List.length(Recursion.hanoi(2, "A", "C", "B")));
        Assert.assertEq(expected = 7, List.length(Recursion.hanoi(3, "A", "C", "B")));
        Assert.assertEq(expected = 31, List.length(Recursion.hanoi(5, "A", "C", "B")))

    /// 0 枚または負の枚数では移動は不要。
    @Test
    def hanoi_non_positive_disks(): Unit \ Assert =
        Assert.assertEq(expected = Nil, Recursion.hanoi(0, "A", "C", "B"));
        Assert.assertEq(expected = Nil, Recursion.hanoi(-1, "A", "C", "B"))

    /// 複数回再帰の呼び出し順序を結果で確認する。
    @Test
    def recure_records_recursive_calls_in_order(): Unit \ Assert =
        Assert.assertEq(
            expected = 1 :: 2 :: 3 :: 1 :: 4 :: 1 :: 2 :: Nil,
            Recursion.recure(4)
        )

    /// 末尾再帰形と明示的な作業スタックは再帰版と同じ結果になる。
    @Test
    def recure_iterative_forms_match_recursive(): Unit \ Assert =
        let expected = 1 :: 2 :: 3 :: 1 :: 4 :: 1 :: 2 :: Nil;
        Assert.assertEq(expected = expected, Recursion.recureTailLoop(4));
        Assert.assertEq(expected = expected, Recursion.recureWithStack(4))

    /// 4 列のすべての配置と行が重複しない配置を数える。
    @Test
    def queens_counts_each_constraint_stage(): Unit \ Assert =
        Assert.assertEq(expected = 256, Recursion.queenPlacementCount(4));
        Assert.assertEq(expected = 24, Recursion.queenRowPermutationCount(4))

    /// バックトラッキングは 4 王妃と 8 王妃の解をすべて列挙する。
    @Test
    def queens_find_all_solutions(): Unit \ Assert =
        Assert.assertEq(expected = 2, List.length(Recursion.queensSolutions(4)));
        Assert.assertEq(expected = 92, List.length(Recursion.queensSolutions(8)))

    /// 4 王妃問題の 2 つの配置を列ごとの行番号で返す。
    @Test
    def queens_return_valid_four_queen_boards(): Unit \ Assert =
        Assert.assertEq(
            expected =
                (1 :: 3 :: 0 :: 2 :: Nil) ::
                (2 :: 0 :: 3 :: 1 :: Nil) ::
                Nil,
            Recursion.queensSolutions(4)
        )

    /// 迷路探索は通路がつながっている場合にゴールへ到達する。
    @Test
    def mazeSolve_finds_path(): Unit \ Assert =
        let maze =
            (1 :: 1 :: 1 :: 1 :: 1 :: Nil) ::
            (1 :: 0 :: 0 :: 0 :: 1 :: Nil) ::
            (1 :: 0 :: 1 :: 0 :: 1 :: Nil) ::
            (1 :: 0 :: 0 :: 0 :: 1 :: Nil) ::
            (1 :: 1 :: 1 :: 1 :: 1 :: Nil) ::
            Nil;
        Assert.assertTrue(Recursion.mazeSolve(maze, 1, 1, 3, 3))

    /// 迷路探索は壁で分断されたゴールへ到達しない。
    @Test
    def mazeSolve_rejects_blocked_goal(): Unit \ Assert =
        let maze =
            (1 :: 1 :: 1 :: Nil) ::
            (1 :: 0 :: 1 :: Nil) ::
            (1 :: 1 :: 1 :: Nil) ::
            Nil;
        Assert.assertFalse(Recursion.mazeSolve(maze, 1, 1, 1, 2))
}
