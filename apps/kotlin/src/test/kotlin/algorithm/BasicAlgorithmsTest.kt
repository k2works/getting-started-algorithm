package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals

class BasicAlgorithmsTest {
    @Test
    fun `max3 returns the maximum for every ordering and ties`() {
        val cases = listOf(
            listOf(3, 2, 1, 3), listOf(3, 2, 2, 3), listOf(3, 1, 2, 3),
            listOf(3, 2, 3, 3), listOf(2, 1, 3, 3), listOf(3, 3, 2, 3),
            listOf(3, 3, 3, 3), listOf(2, 2, 3, 3), listOf(2, 3, 1, 3),
            listOf(2, 3, 2, 3), listOf(1, 3, 2, 3), listOf(2, 3, 3, 3),
            listOf(1, 2, 3, 3),
        )

        cases.forEach { (a, b, c, expected) ->
            assertEquals(expected, BasicAlgorithms.max3(a, b, c))
        }
        assertEquals(Int.MAX_VALUE, BasicAlgorithms.max3(Int.MIN_VALUE, 0, Int.MAX_VALUE))
    }

    @Test
    fun `med3 returns the median for every ordering and ties`() {
        val cases = listOf(
            listOf(3, 2, 1, 2), listOf(3, 2, 2, 2), listOf(3, 1, 2, 2),
            listOf(3, 2, 3, 3), listOf(2, 1, 3, 2), listOf(3, 3, 2, 3),
            listOf(3, 3, 3, 3), listOf(2, 2, 3, 2), listOf(2, 3, 1, 2),
            listOf(2, 3, 2, 2), listOf(1, 3, 2, 2), listOf(2, 3, 3, 3),
            listOf(1, 2, 3, 2),
        )

        cases.forEach { (a, b, c, expected) ->
            assertEquals(expected, BasicAlgorithms.med3(a, b, c))
        }
        assertEquals(0, BasicAlgorithms.med3(Int.MIN_VALUE, 0, Int.MAX_VALUE))
    }

    @Test
    fun `judgeSign classifies positive negative and zero`() {
        assertEquals("その値は正です。", BasicAlgorithms.judgeSign(17))
        assertEquals("その値は負です。", BasicAlgorithms.judgeSign(-5))
        assertEquals("その値は0です。", BasicAlgorithms.judgeSign(0))
    }

    @Test
    fun `sum functions calculate the inclusive range and handle nonpositive input`() {
        assertEquals(15L, BasicAlgorithms.sum1ToNWhile(5))
        assertEquals(15L, BasicAlgorithms.sum1ToNFor(5))
        assertEquals(0L, BasicAlgorithms.sum1ToNWhile(0))
        assertEquals(0L, BasicAlgorithms.sum1ToNFor(0))
        assertEquals(0L, BasicAlgorithms.sum1ToNWhile(-3))
        assertEquals(0L, BasicAlgorithms.sum1ToNFor(-3))
    }

    @Test
    fun `alternative functions create alternating signs`() {
        assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative1(12))
        assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative2(12))
        assertEquals("+-+-+", BasicAlgorithms.alternative1(5))
        assertEquals("+-+-+", BasicAlgorithms.alternative2(5))
        assertEquals("", BasicAlgorithms.alternative1(0))
        assertEquals("", BasicAlgorithms.alternative2(-2))
    }

    @Test
    fun `rectangle lists unique factor pairs up to the square root`() {
        assertEquals("1x32 2x16 4x8 ", BasicAlgorithms.rectangle(32))
        assertEquals("1x36 2x18 3x12 4x9 6x6 ", BasicAlgorithms.rectangle(36))
        assertEquals("1x1 ", BasicAlgorithms.rectangle(1))
        assertEquals("", BasicAlgorithms.rectangle(0))
        assertEquals("", BasicAlgorithms.rectangle(-8))
    }

    @Test
    fun `multiplicationTable formats all products`() {
        val expected = listOf(
            "---------------------------",
            "  1  2  3  4  5  6  7  8  9",
            "  2  4  6  8 10 12 14 16 18",
            "  3  6  9 12 15 18 21 24 27",
            "  4  8 12 16 20 24 28 32 36",
            "  5 10 15 20 25 30 35 40 45",
            "  6 12 18 24 30 36 42 48 54",
            "  7 14 21 28 35 42 49 56 63",
            "  8 16 24 32 40 48 56 64 72",
            "  9 18 27 36 45 54 63 72 81",
            "---------------------------",
        ).joinToString("\n")

        assertEquals(expected, BasicAlgorithms.multiplicationTable())
    }

    @Test
    fun `triangle returns rows with a trailing newline`() {
        assertEquals("*\n**\n***\n****\n*****\n", BasicAlgorithms.triangle(5))
        assertEquals("", BasicAlgorithms.triangle(0))
        assertEquals("", BasicAlgorithms.triangle(-1))
    }
}
