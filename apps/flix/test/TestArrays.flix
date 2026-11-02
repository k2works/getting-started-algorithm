mod TestArrays {
    /// 最大値を走査して返す。
    @Test
    def maxOf_returns_largest_value(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 172 :: 153 :: 192 :: 140 :: 165 :: Nil);
            Assert.assertEq(expected = Some(192), Arrays.maxOf(values))
        }

    /// 空配列の最大値は存在しない。
    @Test
    def maxOf_empty_array(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = None, Arrays.maxOf(values))
        }

    /// 1 要素配列の最大値はその要素。
    @Test
    def maxOf_single_value(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 42 :: Nil);
            Assert.assertEq(expected = Some(42), Arrays.maxOf(values))
        }

    /// 負の値だけの配列でも最大値を求める。
    @Test
    def maxOf_negative_values(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, -8 :: -3 :: -12 :: Nil);
            Assert.assertEq(expected = Some(-3), Arrays.maxOf(values))
        }

    /// 配列の内容をその場で反転する。
    @Test
    def reverseArray_reverses_values_in_place(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 2 :: 5 :: 1 :: 3 :: 9 :: 6 :: 7 :: Nil);
            Arrays.reverseArray(values);
            Assert.assertEq(expected = 7 :: 6 :: 9 :: 3 :: 1 :: 5 :: 2 :: Nil, Array.toList(values))
        }

    /// 偶数個の要素を反転する。
    @Test
    def reverseArray_even_length(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: 4 :: Nil);
            Arrays.reverseArray(values);
            Assert.assertEq(expected = 4 :: 3 :: 2 :: 1 :: Nil, Array.toList(values))
        }

    /// 空配列の反転は空のまま。
    @Test
    def reverseArray_empty(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Arrays.reverseArray(values);
            Assert.assertEq(expected = Nil, Array.toList(values))
        }

    /// 1 要素配列はそのまま。
    @Test
    def reverseArray_single_value(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 42 :: Nil);
            Arrays.reverseArray(values);
            Assert.assertEq(expected = 42 :: Nil, Array.toList(values))
        }

    /// 2 進数へ変換する。
    @Test
    def cardConv_binary(): Unit \ Assert =
        Assert.assertEq(expected = Some("11101"), Arrays.cardConv(29, 2))

    /// 8 進数へ変換する。
    @Test
    def cardConv_octal(): Unit \ Assert =
        Assert.assertEq(expected = Some("35"), Arrays.cardConv(29, 8))

    /// 16 進数で 10 以上の桁に大文字を使う。
    @Test
    def cardConv_hexadecimal(): Unit \ Assert =
        Assert.assertEq(expected = Some("FF"), Arrays.cardConv(255, 16))

    /// 0 は基数にかかわらず "0" と表す。
    @Test
    def cardConv_zero(): Unit \ Assert =
        Assert.assertEq(expected = Some("0"), Arrays.cardConv(0, 2))

    /// 36 進数で 35 を Z と表す。
    @Test
    def cardConv_base_36(): Unit \ Assert =
        Assert.assertEq(expected = Some("Z"), Arrays.cardConv(35, 36))

    /// 対応範囲外の基数を拒否する。
    @Test
    def cardConv_invalid_base(): Unit \ Assert =
        Assert.assertEq(expected = None, Arrays.cardConv(10, 1))

    /// 負の入力を拒否する。
    @Test
    def cardConv_negative_value(): Unit \ Assert =
        Assert.assertEq(expected = None, Arrays.cardConv(-1, 10))

    /// 素朴な試し割りで 1000 以下の素数を列挙する。
    @Test
    def prime1_counts_divisions_to_1000(): Unit \ Assert =
        Assert.assertEq(expected = 78022, Arrays.prime1(1000))

    /// 2 未満の上限では試し割りを行わない。
    @Test
    def prime1_below_two(): Unit \ Assert =
        Assert.assertEq(expected = 0, Arrays.prime1(1))

    /// 奇数候補と既知の素数を使って 1000 以下の素数を列挙する。
    @Test
    def prime2_counts_divisions_to_1000(): Unit \ Assert =
        Assert.assertEq(expected = 14622, Arrays.prime2(1000))

    /// 2 以下では奇数候補の試し割りを行わない。
    @Test
    def prime2_at_two(): Unit \ Assert =
        Assert.assertEq(expected = 0, Arrays.prime2(2))

    /// 平方根以下の既知の素数だけで試し割りする。
    @Test
    def prime3_counts_divisions_to_1000(): Unit \ Assert =
        Assert.assertEq(expected = 1804, Arrays.prime3(1000))

    /// 5 未満では平方根を使った試し割りを行わない。
    @Test
    def prime3_below_five(): Unit \ Assert =
        Assert.assertEq(expected = 0, Arrays.prime3(4))
}
