package algorithm

object ArrayAlgorithms {
    private const val DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    fun maxOf(a: IntArray): Int {
        require(a.isNotEmpty()) { "配列は空にできません。" }

        var maximum = a[0]
        for (i in 1 until a.size) {
            if (a[i] > maximum) maximum = a[i]
        }
        return maximum
    }

    fun reverse(a: IntArray) {
        var left = 0
        var right = a.lastIndex
        while (left < right) {
            val temporary = a[left]
            a[left] = a[right]
            a[right] = temporary
            left++
            right--
        }
    }

    fun cardConv(x: Int, radix: Int): String {
        require(x >= 0) { "変換する値は 0 以上でなければなりません。" }
        require(radix in 2..DIGITS.length) { "基数は 2 から 36 の範囲で指定してください。" }
        if (x == 0) return "0"

        var value = x
        val result = StringBuilder()
        while (value > 0) {
            result.append(DIGITS[value % radix])
            value /= radix
        }
        return result.reverse().toString()
    }

    fun prime1(x: Int): Long {
        var divisions = 0L
        for (n in 2..x) {
            for (divisor in 2 until n) {
                divisions++
                if (n % divisor == 0) break
            }
        }
        return divisions
    }

    fun prime2(x: Int): Long {
        var divisions = 0L
        val primes = mutableListOf(2)
        for (n in 3..x step 2) {
            var isPrime = true
            for (i in 1 until primes.size) {
                divisions++
                if (n % primes[i] == 0) {
                    isPrime = false
                    break
                }
            }
            if (isPrime) primes.add(n)
        }
        return divisions
    }

    fun prime3(x: Int): Long {
        var divisions = 0L
        val primes = mutableListOf(2, 3)
        for (n in 5..x step 2) {
            var isPrime = true
            var i = 1
            while (i < primes.size && primes[i] <= n / primes[i]) {
                divisions++
                if (n % primes[i] == 0) {
                    isPrime = false
                    break
                }
                i++
            }
            if (isPrime) primes.add(n)
        }
        return divisions
    }
}
