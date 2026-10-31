package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class ArrayAlgorithmsTest {
    @Test
    fun `maxOf returns largest element`() {
        assertEquals(192, ArrayAlgorithms.maxOf(intArrayOf(172, 153, 192, 140, 165)))
        assertEquals(42, ArrayAlgorithms.maxOf(intArrayOf(42)))
        assertEquals(5, ArrayAlgorithms.maxOf(intArrayOf(5, 5, 5)))
        assertEquals(-1, ArrayAlgorithms.maxOf(intArrayOf(-9, -1, -4)))
        assertFailsWith<IllegalArgumentException> {
            ArrayAlgorithms.maxOf(intArrayOf())
        }
    }

    @Test
    fun `reverse changes array order in place`() {
        val odd = intArrayOf(2, 5, 1, 3, 9, 6, 7)
        ArrayAlgorithms.reverse(odd)
        assertEquals(listOf(7, 6, 9, 3, 1, 5, 2), odd.toList())

        val even = intArrayOf(1, 2, 3, 4)
        ArrayAlgorithms.reverse(even)
        assertEquals(listOf(4, 3, 2, 1), even.toList())

        val singleton = intArrayOf(42)
        ArrayAlgorithms.reverse(singleton)
        assertEquals(listOf(42), singleton.toList())

        val empty = intArrayOf()
        ArrayAlgorithms.reverse(empty)
        assertEquals(emptyList(), empty.toList())
    }

    @Test
    fun `cardConv converts nonnegative integers to bases from two through thirty six`() {
        assertEquals("11101", ArrayAlgorithms.cardConv(29, 2))
        assertEquals("35", ArrayAlgorithms.cardConv(29, 8))
        assertEquals("FF", ArrayAlgorithms.cardConv(255, 16))
        assertEquals("0", ArrayAlgorithms.cardConv(0, 2))
        assertEquals("Z", ArrayAlgorithms.cardConv(35, 36))
        assertEquals("ZIK0ZJ", ArrayAlgorithms.cardConv(Int.MAX_VALUE, 36))
    }

    @Test
    fun `cardConv rejects negative values and invalid bases`() {
        assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(-1, 10) }
        assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(10, 1) }
        assertFailsWith<IllegalArgumentException> { ArrayAlgorithms.cardConv(10, 37) }
    }

    @Test
    fun `prime versions report modulo operation counts`() {
        assertEquals(78_022L, ArrayAlgorithms.prime1(1_000))
        assertEquals(14_622L, ArrayAlgorithms.prime2(1_000))
        assertEquals(1_804L, ArrayAlgorithms.prime3(1_000))
        assertEquals(0L, ArrayAlgorithms.prime1(1))
        assertEquals(0L, ArrayAlgorithms.prime2(2))
        assertEquals(0L, ArrayAlgorithms.prime3(3))
    }
}
