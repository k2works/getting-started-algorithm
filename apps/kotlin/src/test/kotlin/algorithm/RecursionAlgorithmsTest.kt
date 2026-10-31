package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class RecursionAlgorithmsTest {
    @Test
    fun `factorial implementations handle base and typical cases`() {
        assertEquals(1L, RecursionAlgorithms.factorial(0))
        assertEquals(1L, RecursionAlgorithms.factorial(1))
        assertEquals(120L, RecursionAlgorithms.factorial(5))
        assertEquals(3_628_800L, RecursionAlgorithms.factorial(10))
        assertEquals(2_432_902_008_176_640_000L, RecursionAlgorithms.factorial(20))

        assertEquals(120L, RecursionAlgorithms.factorialTailRecursive(5))
        assertEquals(120L, RecursionAlgorithms.factorialIterative(5))
        assertEquals(
            2_432_902_008_176_640_000L,
            RecursionAlgorithms.factorialTailRecursive(20),
        )
        assertEquals(2_432_902_008_176_640_000L, RecursionAlgorithms.factorialIterative(20))
    }

    @Test
    fun `factorial rejects values outside the Long result range`() {
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.factorial(-1) }
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.factorial(21) }
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.factorialTailRecursive(-1) }
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.factorialIterative(21) }
    }

    @Test
    fun `gcd implementations handle common divisors and zero`() {
        assertEquals(2, RecursionAlgorithms.gcd(22, 8))
        assertEquals(4, RecursionAlgorithms.gcd(12, 4))
        assertEquals(1, RecursionAlgorithms.gcd(7, 11))
        assertEquals(15, RecursionAlgorithms.gcd(15, 15))
        assertEquals(5, RecursionAlgorithms.gcd(0, 5))
        assertEquals(5, RecursionAlgorithms.gcd(5, 0))
        assertEquals(0, RecursionAlgorithms.gcd(0, 0))

        assertEquals(2, RecursionAlgorithms.gcdIterative(22, 8))
        assertEquals(0, RecursionAlgorithms.gcdIterative(0, 0))
    }

    @Test
    fun `gcd rejects negative values`() {
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.gcd(-1, 5) }
        assertFailsWith<IllegalArgumentException> { RecursionAlgorithms.gcdIterative(5, -1) }
    }

    @Test
    fun `hanoi returns expected moves and minimum move counts`() {
        assertEquals(emptyList(), RecursionAlgorithms.hanoi(0, "A", "C", "B"))
        assertEquals(listOf("A->C"), RecursionAlgorithms.hanoi(1, "A", "C", "B"))
        assertEquals(
            listOf("A->B", "A->C", "B->C"),
            RecursionAlgorithms.hanoi(2, "A", "C", "B"),
        )
        for (disks in 0..8) {
            assertEquals((1 shl disks) - 1, RecursionAlgorithms.hanoi(disks, "A", "C", "B").size)
        }
    }

    @Test
    fun `hanoi moves preserve disk order and reach destination`() {
        val moves = RecursionAlgorithms.hanoi(4, "A", "C", "B")
        val pegs = mutableMapOf(
            "A" to (4 downTo 1).toMutableList(),
            "B" to mutableListOf(),
            "C" to mutableListOf(),
        )

        for (move in moves) {
            val (source, destination) = move.split("->")
            val disk = pegs.getValue(source).removeLast()
            val destinationPeg = pegs.getValue(destination)
            if (destinationPeg.isNotEmpty()) {
                assertTrue(destinationPeg.last() > disk)
            }
            destinationPeg.add(disk)
        }

        assertEquals(listOf(4, 3, 2, 1), pegs.getValue("C"))
        assertEquals(emptyList(), pegs.getValue("A"))
        assertEquals(emptyList(), pegs.getValue("B"))
    }

    @Test
    fun `hanoi rejects negative disk count`() {
        assertFailsWith<IllegalArgumentException> {
            RecursionAlgorithms.hanoi(-1, "A", "C", "B")
        }
        assertFailsWith<IllegalArgumentException> {
            RecursionAlgorithms.hanoi(1, "A", "A", "B")
        }
    }

    @Test
    fun `multiple recursive calls return the same sequence as stack simulation`() {
        val expected = listOf(1, 2, 3, 1, 4, 1, 2)

        assertEquals(expected, RecursionAlgorithms.multipleRecursion(4))
        assertEquals(expected, RecursionAlgorithms.multipleRecursionPartiallyIterative(4))
        assertEquals(expected, RecursionAlgorithms.multipleRecursionIterative(4))
        assertEquals(emptyList(), RecursionAlgorithms.multipleRecursion(0))
        assertEquals(emptyList(), RecursionAlgorithms.multipleRecursionPartiallyIterative(-1))
        assertEquals(emptyList(), RecursionAlgorithms.multipleRecursionIterative(-1))
    }

    @Test
    fun `eight queens progressively restrict placements`() {
        assertEquals(16_777_216, RecursionAlgorithms.countUnrestrictedEightQueens())
        assertEquals(40_320, RecursionAlgorithms.eightQueensWithUniqueRows().size)

        val solutions = RecursionAlgorithms.solveEightQueens()
        assertEquals(92, solutions.size)
        assertTrue(solutions.all(::isValidEightQueenSolution))
    }

    @Test
    fun `maze solver finds a route and rejects a disconnected goal`() {
        val solvableMaze = arrayOf(
            intArrayOf(1, 1, 1, 1, 1),
            intArrayOf(1, 0, 0, 0, 1),
            intArrayOf(1, 0, 1, 0, 1),
            intArrayOf(1, 0, 0, 0, 1),
            intArrayOf(1, 1, 1, 1, 1),
        )
        val disconnectedMaze = arrayOf(
            intArrayOf(1, 1, 1, 1, 1),
            intArrayOf(1, 0, 1, 0, 1),
            intArrayOf(1, 1, 1, 1, 1),
            intArrayOf(1, 0, 0, 0, 1),
            intArrayOf(1, 1, 1, 1, 1),
        )

        assertTrue(RecursionAlgorithms.mazeSolve(solvableMaze, 1, 1, 3, 3))
        assertFalse(RecursionAlgorithms.mazeSolve(disconnectedMaze, 1, 1, 3, 1))
        assertTrue(RecursionAlgorithms.mazeSolve(solvableMaze, 1, 1, 1, 1))
        assertTrue(RecursionAlgorithms.mazeSolve(solvableMaze, 1, 1, 3, 3))
    }

    @Test
    fun `maze solver validates dimensions and endpoints`() {
        assertFailsWith<IllegalArgumentException> {
            RecursionAlgorithms.mazeSolve(emptyArray(), 0, 0, 0, 0)
        }
        assertFailsWith<IllegalArgumentException> {
            RecursionAlgorithms.mazeSolve(
                arrayOf(intArrayOf(0), intArrayOf(0, 0)),
                0,
                0,
                1,
                1,
            )
        }
        assertFailsWith<IllegalArgumentException> {
            RecursionAlgorithms.mazeSolve(arrayOf(intArrayOf(0)), -1, 0, 0, 0)
        }
        assertFalse(RecursionAlgorithms.mazeSolve(arrayOf(intArrayOf(1)), 0, 0, 0, 0))
    }

    private fun isValidEightQueenSolution(positions: IntArray): Boolean {
        if (positions.size != 8 || positions.toSet().size != 8) return false
        for (firstColumn in positions.indices) {
            for (secondColumn in firstColumn + 1 until positions.size) {
                if (kotlin.math.abs(positions[firstColumn] - positions[secondColumn]) ==
                    secondColumn - firstColumn
                ) {
                    return false
                }
            }
        }
        return true
    }
}
