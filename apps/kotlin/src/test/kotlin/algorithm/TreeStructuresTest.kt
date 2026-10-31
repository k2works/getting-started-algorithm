package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

class TreeStructuresTest {
    @Test
    fun `binary search tree inserts searches and traverses in all orders`() {
        val tree = BinarySearchTree<Int, String>()

        assertTrue(tree.isEmpty())
        assertNull(tree.search(5))
        assertNull(tree.minKey())
        assertNull(tree.maxKey())
        assertEquals(emptyList(), tree.inorder())
        assertEquals(emptyList(), tree.preorder())
        assertEquals(emptyList(), tree.postorder())

        for (key in listOf(5, 3, 7, 1, 4, 6, 8)) {
            assertTrue(tree.add(key, "value-$key"))
        }

        assertFalse(tree.isEmpty())
        assertEquals(7, tree.size)
        assertEquals("value-6", tree.search(6))
        assertNull(tree.search(9))
        assertEquals(1, tree.minKey())
        assertEquals(8, tree.maxKey())
        assertEquals(
            listOf(1, 3, 4, 5, 6, 7, 8).map { it to "value-$it" },
            tree.inorder(),
        )
        assertEquals(
            listOf(5, 3, 1, 4, 7, 6, 8).map { it to "value-$it" },
            tree.preorder(),
        )
        assertEquals(
            listOf(1, 4, 3, 6, 8, 7, 5).map { it to "value-$it" },
            tree.postorder(),
        )
    }

    @Test
    fun `binary search tree rejects duplicate keys without replacing values`() {
        val tree = BinarySearchTree<Int, String>()

        assertTrue(tree.add(5, "original"))
        assertFalse(tree.add(5, "replacement"))

        assertEquals(1, tree.size)
        assertEquals("original", tree.search(5))
    }

    @Test
    fun `binary search tree deletes leaves nodes with one child and nodes with two children`() {
        val tree = BinarySearchTree<Int, String>()
        for (key in listOf(50, 30, 70, 20, 40, 60, 80, 65)) {
            tree.add(key, "value-$key")
        }

        assertTrue(tree.remove(20))
        assertTrue(tree.remove(60))
        assertTrue(tree.remove(50))
        assertFalse(tree.remove(999))

        assertEquals(5, tree.size)
        assertEquals(listOf(30, 40, 65, 70, 80), tree.inorder().map { it.first })
        assertEquals("value-65", tree.search(65))
        assertNull(tree.search(50))
        assertEquals(30, tree.minKey())
        assertEquals(80, tree.maxKey())
    }

    @Test
    fun `binary search tree removes root and becomes empty`() {
        val tree = BinarySearchTree<Int, Int>()
        tree.add(2, 20)
        tree.add(1, 10)
        tree.add(3, 30)

        assertTrue(tree.remove(2))
        assertEquals(listOf(1, 3), tree.inorder().map { it.first })
        assertTrue(tree.remove(1))
        assertTrue(tree.remove(3))

        assertTrue(tree.isEmpty())
        assertEquals(0, tree.size)
        assertNull(tree.minKey())
        assertNull(tree.maxKey())
        assertFalse(tree.remove(3))
    }

    @Test
    fun `binary search tree compares keys independently from stored values`() {
        val tree = BinarySearchTree<String, Int>()

        tree.add("pear", 3)
        tree.add("apple", 1)
        tree.add("orange", 2)

        assertEquals(listOf("apple", "orange", "pear"), tree.inorder().map { it.first })
        assertEquals(listOf(1, 2, 3), tree.inorder().map { it.second })
    }

    @Test
    fun `min heap maintains order across insertion and removal`() {
        val heap = MinHeap<Int>()

        assertTrue(heap.isEmpty())
        assertNull(heap.peek())
        assertNull(heap.removeMin())

        for (value in listOf(3, 1, 4, 1, 5, 2)) {
            heap.add(value)
        }

        assertEquals(6, heap.size)
        assertEquals(1, heap.peek())
        assertEquals(listOf(1, 1, 2, 3, 4, 5), List(6) { heap.removeMin() })
        assertTrue(heap.isEmpty())
        assertNull(heap.removeMin())
    }

    @Test
    fun `min heap handles a single item and remains reusable`() {
        val heap = MinHeap<String>()

        heap.add("only")
        assertEquals("only", heap.removeMin())
        assertNull(heap.peek())
        heap.add("again")
        assertEquals("again", heap.removeMin())
    }
}
