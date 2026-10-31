package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class SearchAlgorithmsTest {
    @Test
    fun `linear search variants return the first matching index`() {
        val values = intArrayOf(6, 4, 3, 2, 1, 2, 8)
        assertEquals(3, SearchAlgorithms.linearSearchWhile(values, 2))
        assertEquals(3, SearchAlgorithms.linearSearchFor(values, 2))
        assertEquals(3, SearchAlgorithms.linearSearchSentinel(values, 2))

        assertEquals(0, SearchAlgorithms.linearSearchFor(intArrayOf(2, 2), 2))
    }

    @Test
    fun `linear search variants handle missing values and empty arrays`() {
        val empty = intArrayOf()
        val values = intArrayOf(1, 2, 3)

        assertEquals(-1, SearchAlgorithms.linearSearchWhile(empty, 1))
        assertEquals(-1, SearchAlgorithms.linearSearchFor(empty, 1))
        assertEquals(-1, SearchAlgorithms.linearSearchSentinel(empty, 1))
        assertEquals(-1, SearchAlgorithms.linearSearchWhile(values, 99))
        assertEquals(-1, SearchAlgorithms.linearSearchFor(values, 99))
        assertEquals(-1, SearchAlgorithms.linearSearchSentinel(values, 99))
    }

    @Test
    fun `binary search handles sorted values and boundaries`() {
        val values = intArrayOf(1, 2, 3, 5, 7, 8, 9)

        assertEquals(3, SearchAlgorithms.binarySearch(values, 5))
        assertEquals(0, SearchAlgorithms.binarySearch(values, 1))
        assertEquals(6, SearchAlgorithms.binarySearch(values, 9))
        assertEquals(-1, SearchAlgorithms.binarySearch(values, 4))
        assertEquals(-1, SearchAlgorithms.binarySearch(intArrayOf(), 1))
        assertEquals(0, SearchAlgorithms.binarySearch(intArrayOf(Int.MIN_VALUE), Int.MIN_VALUE))
        assertEquals(1, SearchAlgorithms.binarySearch(intArrayOf(Int.MIN_VALUE, Int.MAX_VALUE), Int.MAX_VALUE))
    }

    @Test
    fun `chained hash resolves collisions and removes head middle and tail nodes`() {
        val hash = SearchAlgorithms.ChainedHash(13)
        assertTrue(hash.add(1, "赤尾"))
        assertTrue(hash.add(14, "神崎"))
        assertTrue(hash.add(27, "武田"))

        assertEquals("赤尾", hash.search(1))
        assertEquals("神崎", hash.search(14))
        assertEquals("武田", hash.search(27))
        assertEquals(null, hash.search(100))
        assertFalse(hash.add(14, "重複"))

        assertTrue(hash.remove(14))
        assertEquals("武田", hash.search(27))
        assertEquals("赤尾", hash.search(1))
        assertTrue(hash.remove(27))
        assertTrue(hash.remove(1))
        assertFalse(hash.remove(1))
        assertEquals(null, hash.search(1))
        assertEquals(null, hash.search(14))
        assertEquals(null, hash.search(27))
    }

    @Test
    fun `chained hash supports negative keys and rejects invalid capacity`() {
        val hash = SearchAlgorithms.ChainedHash(7)
        assertTrue(hash.add(Int.MIN_VALUE, "最小"))
        assertEquals("最小", hash.search(Int.MIN_VALUE))
        assertTrue(hash.remove(Int.MIN_VALUE))
        assertFailsWith<IllegalArgumentException> {
            SearchAlgorithms.ChainedHash(0)
        }
    }

    @Test
    fun `open hash preserves collision chains after deletion and reuses tombstones`() {
        val hash = SearchAlgorithms.OpenHash(5)
        assertTrue(hash.add(1, "赤尾"))
        assertTrue(hash.add(6, "神崎"))
        assertTrue(hash.add(11, "武田"))

        assertTrue(hash.remove(6))
        assertEquals("赤尾", hash.search(1))
        assertEquals("武田", hash.search(11))
        assertEquals(null, hash.search(6))
        assertFalse(hash.add(11, "重複"))

        assertTrue(hash.add(16, "小野"))
        assertEquals("小野", hash.search(16))
        assertTrue(hash.remove(1))
        assertTrue(hash.remove(11))
        assertTrue(hash.remove(16))
        assertFalse(hash.remove(99))
    }

    @Test
    fun `open hash wraps around and reports full capacity`() {
        val hash = SearchAlgorithms.OpenHash(3)
        assertTrue(hash.add(2, "a"))
        assertTrue(hash.add(5, "b"))
        assertTrue(hash.add(8, "c"))
        assertFalse(hash.add(11, "d"))
        assertEquals("a", hash.search(2))
        assertEquals("b", hash.search(5))
        assertEquals("c", hash.search(8))
        assertEquals(null, hash.search(11))
        assertFalse(hash.remove(11))

        assertTrue(hash.remove(5))
        assertTrue(hash.add(11, "d"))
        assertEquals("d", hash.search(11))
    }
}
