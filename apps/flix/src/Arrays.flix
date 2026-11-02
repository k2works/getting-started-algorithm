mod Arrays {
    ///
    /// Returns the largest value in the array, or None if it is empty.
    ///
    pub def maxOf(values: Array[Int32, r]): Option[Int32] \ r =
        let length = Array.length(values);
        def loop(i, maximum) =
            if (i >= length)
                maximum
            else {
                let value = Array.get(i, values);
                loop(i + 1, if (value > maximum) value else maximum)
            };
        if (length == 0) {
            None
        } else {
            Some(loop(1, Array.get(0, values)))
        }

    ///
    /// Reverses the array in place.
    ///
    pub def reverseArray(values: Array[a, r]): Unit \ r =
        let last = Array.length(values) - 1;
        def loop(left, right) =
            if (left >= right) {
                ()
            } else {
                let leftValue = Array.get(left, values);
                let rightValue = Array.get(right, values);
                Array.put(rightValue, left, values);
                Array.put(leftValue, right, values);
                loop(left + 1, right - 1)
            };
        loop(0, last)

    ///
    /// Converts a non-negative integer to a base from 2 through 36.
    ///
    pub def cardConv(value: Int32, base: Int32): Option[String] =
        def digits(n, acc) =
            if (n == 0)
                acc
            else
                digits(n / base, (n `Int32.remainder` base) :: acc);

        if (value < 0 or base < 2 or base > 36) {
            None
        } else if (value == 0) {
            Some("0")
        } else {
            Some(digitsToString(digits(value, Nil)))
        }

    ///
    /// Converts the most-significant-first digits to their character representation.
    ///
    def digitsToString(digits: List[Int32]): String = region rc {
        let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        let digitArray = List.toArray(rc, digits);
        String.init(i -> String.get(Array.get(i, digitArray), alphabet), List.length(digits))
    }

    ///
    /// Returns the number of trial divisions used by the straightforward algorithm.
    ///
    pub def prime1(limit: Int32): Int32 =
        def divisions(n, divisor, count) =
            if (divisor >= n)
                count
            else if (n `Int32.remainder` divisor == 0)
                count + 1
            else
                divisions(n, divisor + 1, count + 1);

        def candidates(n, count) =
            if (n > limit)
                count
            else
                candidates(n + 1, count + divisions(n, 2, 0));

        if (limit < 2) {
            0
        } else {
            candidates(2, 0)
        }

    ///
    /// Returns the number of trial divisions using odd candidates and known primes.
    ///
    pub def prime2(limit: Int32): Int32 =
        if (limit < 3) {
            0
        } else {
            region rc {
                let primes = Array.empty(rc, (limit / 2) + 1);
                Array.put(2, 0, primes);

                def findDivisor(n, i, primeCount, count) =
                    if (i >= primeCount)
                        (false, count)
                    else if (n `Int32.remainder` Array.get(i, primes) == 0)
                        (true, count + 1)
                    else
                        findDivisor(n, i + 1, primeCount, count + 1);

                def candidates(n, primeCount, count) =
                    if (n > limit) {
                        count
                    } else {
                        let (isComposite, checks) = findDivisor(n, 1, primeCount, 0);
                        if (isComposite) {
                            candidates(n + 2, primeCount, count + checks)
                        } else {
                            Array.put(n, primeCount, primes);
                            candidates(n + 2, primeCount + 1, count + checks)
                        }
                    };

                candidates(3, 1, 0)
            }
        }

    ///
    /// Returns the number of modulo operations using primes up to the square root.
    ///
    pub def prime3(limit: Int32): Int32 =
        if (limit < 5) {
            0
        } else {
            region rc {
                let primes = Array.empty(rc, (limit / 2) + 1);
                Array.put(2, 0, primes);
                Array.put(3, 1, primes);

                def findDivisor(n, i, primeCount, score) =
                    if (i >= primeCount)
                        (false, score)
                    else if (Array.get(i, primes) * Array.get(i, primes) > n)
                        (false, score)
                    else if (n `Int32.remainder` Array.get(i, primes) == 0)
                        (true, score + 1)
                    else
                        findDivisor(n, i + 1, primeCount, score + 1);

                def candidates(n, primeCount, score) =
                    if (n > limit) {
                        score
                    } else {
                        let (isComposite, checks) = findDivisor(n, 1, primeCount, 0);
                        if (isComposite) {
                            candidates(n + 2, primeCount, score + checks)
                        } else {
                            Array.put(n, primeCount, primes);
                            candidates(n + 2, primeCount + 1, score + checks)
                        }
                    };

                candidates(5, 2, 0)
            }
        }
}
