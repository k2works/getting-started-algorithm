package algorithm

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class StackQueueTest {
    @Test
    fun `fixed stack tracks state and follows LIFO order`() {
        val stack = FixedStack<Int>(3)
        assertTrue(stack.isEmpty())
        assertFalse(stack.isFull())
        assertEquals(0, stack.size)
        assertEquals(3, stack.capacity)

        stack.push(1)
        stack.push(2)
        stack.push(3)
        assertTrue(stack.isFull())
        assertEquals(3, stack.peek())
        assertEquals(3, stack.pop())
        assertEquals(2, stack.pop())
        assertEquals(1, stack.pop())
        assertTrue(stack.isEmpty())
    }

    @Test
    fun `fixed stack rejects overflow underflow and zero capacity`() {
        val stack = FixedStack<String>(1)
        assertFailsWith<IllegalStateException> { stack.pop() }
        assertFailsWith<IllegalStateException> { stack.peek() }
        stack.push("one")
        assertFailsWith<IllegalStateException> { stack.push("two") }
        assertFailsWith<IllegalArgumentException> { FixedStack<Int>(0) }
    }

    @Test
    fun `fixed stack find count contains and clear operate on stored elements`() {
        val stack = FixedStack<Int>(5)
        stack.push(10)
        stack.push(20)
        stack.push(10)
        assertEquals(1, stack.find(20))
        assertEquals(2, stack.find(10))
        assertEquals(-1, stack.find(99))
        assertEquals(2, stack.count(10))
        assertTrue(stack.contains(20))
        assertFalse(stack.contains(99))

        stack.clear()
        assertTrue(stack.isEmpty())
        assertEquals(0, stack.size)
        assertFalse(stack.isFull())
        assertFailsWith<IllegalStateException> { stack.peek() }
    }

    @Test
    fun `fixed queue tracks state and follows FIFO order`() {
        val queue = FixedQueue<Int>(3)
        assertTrue(queue.isEmpty())
        assertFalse(queue.isFull())
        assertEquals(0, queue.size)
        assertEquals(3, queue.capacity)

        queue.enque(1)
        queue.enque(2)
        queue.enque(3)
        assertTrue(queue.isFull())
        assertEquals(1, queue.peek())
        assertEquals(1, queue.deque())
        assertEquals(2, queue.deque())
        assertEquals(3, queue.deque())
        assertTrue(queue.isEmpty())
    }

    @Test
    fun `fixed queue rejects overflow underflow and zero capacity`() {
        val queue = FixedQueue<String>(1)
        assertFailsWith<IllegalStateException> { queue.deque() }
        assertFailsWith<IllegalStateException> { queue.peek() }
        queue.enque("one")
        assertFailsWith<IllegalStateException> { queue.enque("two") }
        assertFailsWith<IllegalArgumentException> { FixedQueue<Int>(0) }
    }

    @Test
    fun `fixed queue wraps around and can become full after wrap`() {
        val queue = FixedQueue<Int>(3)
        queue.enque(1)
        queue.enque(2)
        queue.enque(3)
        assertEquals(1, queue.deque())
        queue.enque(4)
        assertTrue(queue.isFull())
        assertEquals(2, queue.deque())
        assertEquals(3, queue.deque())
        assertEquals(4, queue.deque())
    }

    @Test
    fun `fixed queue find count contains and clear use logical order`() {
        val queue = FixedQueue<Int>(4)
        queue.enque(10)
        queue.enque(20)
        queue.enque(10)
        assertEquals(1, queue.find(20))
        assertEquals(0, queue.find(10))
        assertEquals(-1, queue.find(99))
        assertEquals(2, queue.count(10))
        assertTrue(queue.contains(20))
        assertFalse(queue.contains(99))

        assertEquals(10, queue.deque())
        assertEquals(0, queue.find(20))
        queue.clear()
        assertTrue(queue.isEmpty())
        assertEquals(0, queue.size)
        assertFalse(queue.isFull())
        assertFailsWith<IllegalStateException> { queue.peek() }
    }
}
