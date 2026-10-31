package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

class LinkedListsTest {
    @Test
    fun `singly linked list inserts at both ends and searches`() {
        val list = SinglyLinkedList<Int>()

        assertTrue(list.isEmpty())
        assertFalse(list.contains(1))

        list.addFirst(2)
        list.addFirst(1)
        list.addLast(3)

        assertEquals(3, list.size)
        assertFalse(list.isEmpty())
        assertEquals(listOf(1, 2, 3), list.toList())
        assertTrue(list.contains(2))
        assertFalse(list.contains(4))
    }

    @Test
    fun `singly linked list removes first last and first matching value`() {
        val list = SinglyLinkedList<Int>()
        assertNull(list.removeFirst())
        assertNull(list.removeLast())
        assertFalse(list.remove(1))

        list.addLast(1)
        assertEquals(1, list.removeFirst())
        assertTrue(list.isEmpty())

        list.addLast(1)
        list.addLast(2)
        list.addLast(2)
        list.addLast(3)

        assertTrue(list.remove(1))
        assertEquals(listOf(2, 2, 3), list.toList())
        assertTrue(list.remove(2))
        assertEquals(listOf(2, 3), list.toList())
        assertEquals(3, list.removeLast())
        assertEquals(2, list.removeLast())
        assertNull(list.removeLast())
        assertEquals(0, list.size)
        assertTrue(list.isEmpty())
    }

    @Test
    fun `doubly linked list inserts at both ends and traverses in both directions`() {
        val list = DoublyLinkedList<Int>()

        assertTrue(list.isEmpty())
        assertFalse(list.contains(1))

        list.addFirst(2)
        list.addFirst(1)
        list.addLast(3)

        assertEquals(3, list.size)
        assertFalse(list.isEmpty())
        assertEquals(listOf(1, 2, 3), list.toList())
        assertEquals(listOf(3, 2, 1), list.reversed())
        assertTrue(list.contains(2))
        assertFalse(list.contains(4))
    }

    @Test
    fun `doubly linked list removes first last and first matching value`() {
        val list = DoublyLinkedList<Int>()
        assertNull(list.removeFirst())
        assertNull(list.removeLast())
        assertFalse(list.remove(1))

        list.addLast(1)
        assertEquals(1, list.removeLast())
        assertTrue(list.isEmpty())

        list.addLast(1)
        list.addLast(2)
        list.addLast(2)
        list.addLast(3)

        assertTrue(list.remove(1))
        assertEquals(listOf(2, 2, 3), list.toList())
        assertEquals(listOf(3, 2, 2), list.reversed())
        assertTrue(list.remove(2))
        assertEquals(listOf(2, 3), list.toList())
        assertEquals(2, list.removeFirst())
        assertEquals(3, list.removeFirst())
        assertNull(list.removeFirst())
        assertEquals(0, list.size)
        assertTrue(list.isEmpty())
    }

    @Test
    fun `linked lists accept generic values`() {
        val singly = SinglyLinkedList<String>()
        val doubly = DoublyLinkedList<Int>()

        singly.addFirst("first")
        doubly.addFirst(1)
        singly.addLast("second")
        doubly.addLast(2)

        assertEquals(listOf("first", "second"), singly.toList())
        assertEquals(listOf(1, 2), doubly.toList())
    }
}
