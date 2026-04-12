package algorithm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class StackQueueTest {

    @Nested
    class FixedStackTest {
        private FixedStack<Integer> stack;

        @BeforeEach
        void setUp() { stack = new FixedStack<>(64); }

        @Test
        void 初期状態は空() {
            assertTrue(stack.isEmpty());
            assertFalse(stack.isFull());
        }

        @Test
        void pushしてpeek() {
            stack.push(1);
            assertEquals(1, stack.peek());
        }

        @Test
        void pushしてpop() {
            stack.push(1);
            assertEquals(1, stack.pop());
        }

        @Test
        void 複数pushしてLIFO順にpop() {
            stack.push(1);
            stack.push(2);
            stack.push(3);
            assertEquals(3, stack.pop());
            assertEquals(2, stack.pop());
            assertEquals(1, stack.pop());
        }

        @Test
        void 満杯判定() {
            FixedStack<Integer> small = new FixedStack<>(3);
            small.push(1); small.push(2); small.push(3);
            assertTrue(small.isFull());
        }

        @Test
        void 空のpopで例外() {
            assertThrows(FixedStack.EmptyException.class, () -> stack.pop());
        }

        @Test
        void 満杯のpushで例外() {
            FixedStack<Integer> small = new FixedStack<>(2);
            small.push(1); small.push(2);
            assertThrows(FixedStack.FullException.class, () -> small.push(3));
        }

        @Test
        void 空のpeekで例外() {
            assertThrows(FixedStack.EmptyException.class, () -> stack.peek());
        }

        @Test
        void find() {
            stack.push(10); stack.push(20); stack.push(30);
            assertEquals(1, stack.find(20));
        }

        @Test
        void find_見つからない() {
            stack.push(10);
            assertEquals(-1, stack.find(99));
        }

        @Test
        void count() {
            stack.push(5); stack.push(5); stack.push(10);
            assertEquals(2, stack.count(5));
            assertEquals(1, stack.count(10));
            assertEquals(0, stack.count(99));
        }

        @Test
        void contains() {
            stack.push(42);
            assertTrue(stack.contains(42));
            assertFalse(stack.contains(0));
        }

        @Test
        void clear() {
            stack.push(1); stack.push(2);
            stack.clear();
            assertTrue(stack.isEmpty());
        }

        @Test
        void size() {
            stack.push(1); stack.push(2);
            assertEquals(2, stack.size());
        }

        @Test
        void capacity() {
            assertEquals(64, stack.getCapacity());
        }
    }

    @Nested
    class FixedQueueTest {
        private FixedQueue<Integer> queue;

        @BeforeEach
        void setUp() { queue = new FixedQueue<>(64); }

        @Test
        void 初期状態は空() {
            assertTrue(queue.isEmpty());
            assertFalse(queue.isFull());
        }

        @Test
        void enqueしてdeque() {
            queue.enque(1);
            assertEquals(1, queue.deque());
        }

        @Test
        void 複数enqueしてFIFO順にdeque() {
            queue.enque(1); queue.enque(2); queue.enque(3);
            assertEquals(1, queue.deque());
            assertEquals(2, queue.deque());
            assertEquals(3, queue.deque());
        }

        @Test
        void peek() {
            queue.enque(10); queue.enque(20);
            assertEquals(10, queue.peek());
        }

        @Test
        void 満杯判定() {
            FixedQueue<Integer> small = new FixedQueue<>(3);
            small.enque(1); small.enque(2); small.enque(3);
            assertTrue(small.isFull());
        }

        @Test
        void 空のdequeで例外() {
            assertThrows(FixedQueue.EmptyException.class, () -> queue.deque());
        }

        @Test
        void 満杯のenqueで例外() {
            FixedQueue<Integer> small = new FixedQueue<>(2);
            small.enque(1); small.enque(2);
            assertThrows(FixedQueue.FullException.class, () -> small.enque(3));
        }

        @Test
        void 空のpeekで例外() {
            assertThrows(FixedQueue.EmptyException.class, () -> queue.peek());
        }

        @Test
        void find() {
            queue.enque(10); queue.enque(20); queue.enque(30);
            assertEquals(0, queue.find(10));
        }

        @Test
        void find_見つからない() {
            queue.enque(10);
            assertEquals(-1, queue.find(99));
        }

        @Test
        void count() {
            queue.enque(5); queue.enque(5); queue.enque(10);
            assertEquals(2, queue.count(5));
        }

        @Test
        void contains() {
            queue.enque(42);
            assertTrue(queue.contains(42));
            assertFalse(queue.contains(0));
        }

        @Test
        void clear() {
            queue.enque(1); queue.enque(2);
            queue.clear();
            assertTrue(queue.isEmpty());
        }

        @Test
        void size() {
            queue.enque(1); queue.enque(2);
            assertEquals(2, queue.size());
        }

        @Test
        void capacity() {
            assertEquals(64, queue.getCapacity());
        }

        @Test
        void リングバッファの折り返し() {
            FixedQueue<Integer> small = new FixedQueue<>(3);
            small.enque(1); small.enque(2); small.enque(3);
            small.deque(); // 1 を取り出す
            small.enque(4); // 空き位置に追加
            assertEquals(2, small.deque());
            assertEquals(3, small.deque());
            assertEquals(4, small.deque());
        }
    }
}
