package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotSame

class SortingAlgorithmsTest {
    private val inPlaceSorts: List<Pair<String, (IntArray) -> Unit>> = listOf(
        "bubble" to SortingAlgorithms::bubbleSort,
        "selection" to SortingAlgorithms::selectionSort,
        "insertion" to SortingAlgorithms::insertionSort,
        "quick" to SortingAlgorithms::quickSort,
    )

    @Test
    fun `in place sorts order typical and boundary arrays`() {
        val cases = listOf(
            intArrayOf(6, 4, 3, 7, 1, 9, 8) to listOf(1, 3, 4, 6, 7, 8, 9),
            intArrayOf() to emptyList(),
            intArrayOf(42) to listOf(42),
            intArrayOf(1, 2, 3, 4) to listOf(1, 2, 3, 4),
            intArrayOf(4, 3, 2, 1) to listOf(1, 2, 3, 4),
            intArrayOf(3, 1, 2, 1, 3, 2) to listOf(1, 1, 2, 2, 3, 3),
            intArrayOf(Int.MAX_VALUE, 0, Int.MIN_VALUE) to
                listOf(Int.MIN_VALUE, 0, Int.MAX_VALUE),
            intArrayOf(5, 5, 5, 5) to listOf(5, 5, 5, 5),
        )

        for ((name, sort) in inPlaceSorts) {
            for ((input, expected) in cases) {
                val actual = input.copyOf()
                sort(actual)
                assertEquals(expected, actual.toList(), "$name sort")
            }
        }
    }

    @Test
    fun `quick sort handles a large sorted array`() {
        val values = IntArray(10_000) { it }

        SortingAlgorithms.quickSort(values)

        assertEquals((0 until 10_000).toList(), values.toList())
    }

    @Test
    fun `merge sort returns a sorted copy and preserves its input`() {
        val input = listOf(6, 4, 3, 7, 1, 9, 8)

        val sorted = SortingAlgorithms.mergeSort(input)

        assertEquals(listOf(1, 3, 4, 6, 7, 8, 9), sorted)
        assertEquals(listOf(6, 4, 3, 7, 1, 9, 8), input)
        assertNotSame(input, sorted)
    }

    @Test
    fun `merge sort handles boundaries duplicates and preserves equal item order`() {
        assertEquals(emptyList(), SortingAlgorithms.mergeSort(emptyList<Int>()))
        assertEquals(listOf(42), SortingAlgorithms.mergeSort(listOf(42)))
        assertEquals(listOf(1, 1, 2, 2, 3, 3), SortingAlgorithms.mergeSort(listOf(3, 1, 2, 1, 3, 2)))

        val items = listOf(
            SortItem(2, "first"),
            SortItem(1, "low"),
            SortItem(2, "second"),
            SortItem(2, "third"),
        )

        assertEquals(
            listOf("low", "first", "second", "third"),
            SortingAlgorithms.mergeSort(items).map { it.label },
        )
    }

    private data class SortItem(val key: Int, val label: String) : Comparable<SortItem> {
        override fun compareTo(other: SortItem): Int = key.compareTo(other.key)
    }
}
