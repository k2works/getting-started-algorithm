package algorithm

object BasicAlgorithms {
    fun max3(a: Int, b: Int, c: Int): Int {
        var maximum = a
        if (b > maximum) maximum = b
        if (c > maximum) maximum = c
        return maximum
    }

    fun med3(a: Int, b: Int, c: Int): Int =
        when {
            a >= b && b >= c -> b
            a <= b && b <= c -> b
            b >= a && a >= c -> a
            b <= a && a <= c -> a
            c >= a && a >= b -> a
            else -> c
        }

    fun judgeSign(n: Int): String =
        when {
            n > 0 -> "その値は正です。"
            n < 0 -> "その値は負です。"
            else -> "その値は0です。"
        }

    fun sum1ToNWhile(n: Int): Long {
        var total = 0L
        var i = 1L
        while (i <= n.toLong()) {
            total += i
            i++
        }
        return total
    }

    fun sum1ToNFor(n: Int): Long {
        var total = 0L
        for (i in 1L..n.toLong()) {
            total += i
        }
        return total
    }

    fun alternative1(n: Int): String = buildString {
        repeat(n.coerceAtLeast(0)) { index ->
            append(if (index % 2 == 0) '+' else '-')
        }
    }

    fun alternative2(n: Int): String {
        val pairCount = n.coerceAtLeast(0) / 2
        return "+-".repeat(pairCount) + if (n > 0 && n % 2 != 0) "+" else ""
    }

    fun rectangle(area: Int): String {
        if (area <= 0) return ""

        return buildString {
            var side = 1
            while (side <= area / side) {
                if (area % side == 0) {
                    append(side).append('x').append(area / side).append(' ')
                }
                side++
            }
        }
    }

    fun multiplicationTable(): String = buildString {
        append("-".repeat(27)).append('\n')
        for (row in 1..9) {
            for (column in 1..9) {
                append((row * column).toString().padStart(3))
            }
            append('\n')
        }
        append("-".repeat(27))
    }

    fun triangle(n: Int): String = buildString {
        repeat(n.coerceAtLeast(0)) { index ->
            repeat(index + 1) { append('*') }
            append('\n')
        }
    }
}
