mod BasicAlgorithms {
    ///
    /// 3 つの整数の最大値を返す。
    ///
    pub def max3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (a >= c) a else c
        else
            if (b >= c) b else c

    ///
    /// 3 つの整数の中央値を返す。
    ///
    pub def med3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (b >= c) b
            else if (a <= c) a
            else c
        else
            if (a > c) a
            else if (b > c) c
            else b

    ///
    /// 整数の符号を文字列で返す。
    ///
    pub def judgeSign(n: Int32): String =
        if (n > 0) "正"
        else if (n < 0) "負"
        else "0"

    ///
    /// 1 から n までの整数の総和を返す。n が 0 以下なら 0 を返す。
    ///
    pub def sum1ToN(n: Int32): Int32 =
        if (n <= 0) 0
        else List.range(1, n + 1) |> List.foldLeft((total, value) -> total + value, 0)

    ///
    /// 1 から 9 までの九九の表を行ごとのリストとして返す。
    ///
    pub def multiplicationTable(): List[List[Int32]] =
        List.range(1, 10)
            |> List.map(i ->
                List.range(1, 10)
                    |> List.map(j -> i * j)
            )
}
