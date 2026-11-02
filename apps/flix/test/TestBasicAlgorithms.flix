mod TestBasicAlgorithms {
    /// 最大値が a の場合。
    @Test
    def max3_a_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 2, 1))

    /// 最大値が b の場合。
    @Test
    def max3_b_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(1, 3, 2))

    /// 最大値が c の場合。
    @Test
    def max3_c_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(1, 2, 3))

    /// 2 つの値が同じ最大値になる場合。
    @Test
    def max3_two_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 3, 1))

    /// すべての値が同じ場合。
    @Test
    def max3_all_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 3, 3))

    /// a > b > c の場合。
    @Test
    def med3_a_b_c(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 2, 1))

    /// a > b = c の場合。
    @Test
    def med3_b_equals_c(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 2, 2))

    /// a > c > b の場合。
    @Test
    def med3_a_c_b(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 1, 2))

    /// a = c > b の場合。
    @Test
    def med3_a_equals_c(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.med3(3, 2, 3))

    /// すべての値が同じ場合。
    @Test
    def med3_all_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.med3(3, 3, 3))

    /// 正の整数を判定する。
    @Test
    def judgeSign_positive(): Unit \ Assert =
        Assert.assertEq(expected = "正", BasicAlgorithms.judgeSign(17))

    /// 負の整数を判定する。
    @Test
    def judgeSign_negative(): Unit \ Assert =
        Assert.assertEq(expected = "負", BasicAlgorithms.judgeSign(-5))

    /// 0 を判定する。
    @Test
    def judgeSign_zero(): Unit \ Assert =
        Assert.assertEq(expected = "0", BasicAlgorithms.judgeSign(0))

    /// 1 から 5 までの総和。
    @Test
    def sum1ToN_five(): Unit \ Assert =
        Assert.assertEq(expected = 15, BasicAlgorithms.sum1ToN(5))

    /// 1 から 1 までの総和。
    @Test
    def sum1ToN_one(): Unit \ Assert =
        Assert.assertEq(expected = 1, BasicAlgorithms.sum1ToN(1))

    /// 0 以下の入力は空の範囲として 0 を返す。
    @Test
    def sum1ToN_zero(): Unit \ Assert =
        Assert.assertEq(expected = 0, BasicAlgorithms.sum1ToN(0))

    /// 九九の表は 9 行ある。
    @Test
    def multiplicationTable_has_nine_rows(): Unit \ Assert =
        Assert.assertEq(expected = 9, List.length(BasicAlgorithms.multiplicationTable()))

    /// 最初の行は 1 の段。
    @Test
    def multiplicationTable_first_row(): Unit \ Assert =
        Assert.assertEq(
            expected = Some(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: Nil),
            List.nth(0, BasicAlgorithms.multiplicationTable())
        )

    /// 最後の行は 9 の段。
    @Test
    def multiplicationTable_last_row(): Unit \ Assert =
        Assert.assertEq(
            expected = Some(9 :: 18 :: 27 :: 36 :: 45 :: 54 :: 63 :: 72 :: 81 :: Nil),
            List.nth(8, BasicAlgorithms.multiplicationTable())
        )
}
