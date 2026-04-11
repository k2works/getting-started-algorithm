package algorithm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class LinkedListTest {

    @Nested
    class SinglyLinkedListTest {
        private SinglyLinkedList<Integer> lst;

        @BeforeEach
        void setUp() { lst = new SinglyLinkedList<>(); }

        @Test void 初期状態は空() { assertEquals(0, lst.size()); assertTrue(lst.isEmpty()); }
        @Test void addFirst() { lst.addFirst(1); assertEquals(1, lst.size()); }
        @Test void addLast() { lst.addLast(1); lst.addLast(2); assertEquals(2, lst.size()); }

        @Test void 探索_見つかる() {
            lst.addLast(10); lst.addLast(20); lst.addLast(30);
            assertTrue(lst.contains(20));
        }
        @Test void 探索_見つからない() {
            lst.addLast(10);
            assertFalse(lst.contains(99));
        }

        @Test void removeFirst() {
            lst.addLast(1); lst.addLast(2);
            lst.removeFirst();
            assertEquals(1, lst.size());
            assertFalse(lst.contains(1));
        }

        @Test void removeLast() {
            lst.addLast(1); lst.addLast(2);
            lst.removeLast();
            assertEquals(1, lst.size());
            assertFalse(lst.contains(2));
        }

        @Test void removeByValue() {
            lst.addLast(1); lst.addLast(2); lst.addLast(3);
            assertTrue(lst.remove(2));
            assertFalse(lst.contains(2));
            assertEquals(2, lst.size());
        }

        @Test void contains() {
            lst.addLast(42);
            assertTrue(lst.contains(42));
            assertFalse(lst.contains(0));
        }

        @Test void removeFirst_空で例外() {
            assertThrows(SinglyLinkedList.EmptyException.class, () -> lst.removeFirst());
        }

        @Test void removeLast_空で例外() {
            assertThrows(SinglyLinkedList.EmptyException.class, () -> lst.removeLast());
        }

        @Test void イテレーション() {
            lst.addLast(1); lst.addLast(2); lst.addLast(3);
            assertEquals(List.of(1, 2, 3), lst.toList());
        }

        @Test void clear() {
            lst.addLast(1); lst.addLast(2);
            lst.clear();
            assertTrue(lst.isEmpty());
        }

        @Test void removeLast_単一要素() {
            lst.addLast(1);
            lst.removeLast();
            assertTrue(lst.isEmpty());
        }

        @Test void remove_空リスト() {
            assertFalse(lst.remove(1));
        }

        @Test void remove_存在しない値() {
            lst.addLast(1); lst.addLast(2);
            assertFalse(lst.remove(99));
            assertEquals(2, lst.size());
        }
    }

    @Nested
    class DoublyLinkedListTest {
        private DoublyLinkedList<Integer> lst;

        @BeforeEach
        void setUp() { lst = new DoublyLinkedList<>(); }

        @Test void 初期状態は空() { assertEquals(0, lst.size()); assertTrue(lst.isEmpty()); }
        @Test void addFirst() { lst.addFirst(1); assertEquals(1, lst.size()); }
        @Test void addLast() { lst.addLast(1); lst.addLast(2); assertEquals(2, lst.size()); }

        @Test void contains() {
            lst.addLast(10); lst.addLast(20);
            assertTrue(lst.contains(20));
            assertFalse(lst.contains(99));
        }

        @Test void remove() {
            lst.addLast(1); lst.addLast(2); lst.addLast(3);
            assertTrue(lst.remove(2));
            assertFalse(lst.contains(2));
            assertEquals(2, lst.size());
        }

        @Test void イテレーション() {
            lst.addLast(1); lst.addLast(2); lst.addLast(3);
            assertEquals(List.of(1, 2, 3), lst.toList());
        }

        @Test void clear() {
            lst.addLast(1);
            lst.clear();
            assertTrue(lst.isEmpty());
        }

        @Test void remove_空リスト() {
            assertFalse(lst.remove(99));
        }
    }

    @Nested
    class ArrayLinkedListTest {
        @Test void 初期化() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            assertEquals(0, al.size());
        }

        @Test void addFirst() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addFirst(1); al.addFirst(2);
            assertEquals(2, al.size());
        }

        @Test void addFirst_順序() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addFirst(1); al.addFirst(2); al.addFirst(3);
            assertEquals(3, al.getHeadData());
        }

        @Test void addLast() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addLast(1); al.addLast(2);
            assertEquals(2, al.size());
        }

        @Test void addLast_順序() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addLast(1); al.addLast(2); al.addLast(3);
            assertEquals(1, al.getHeadData());
        }

        @Test void search_見つかる() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addLast(10); al.addLast(20); al.addLast(30);
            assertTrue(al.search(20) >= 0);
        }

        @Test void search_見つからない() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addLast(10);
            assertEquals(-1, al.search(99));
        }

        @Test void removeFirst() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addLast(1); al.addLast(2); al.addLast(3);
            al.removeFirst();
            assertEquals(2, al.size());
            assertEquals(-1, al.search(1));
        }

        @Test void removeFirst_空() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.removeFirst(); // 何もしない
            assertEquals(0, al.size());
        }

        @Test void 削除スロットの再利用() {
            ArrayLinkedList al = new ArrayLinkedList(100);
            al.addFirst(1); al.addFirst(2);
            al.removeFirst();
            al.addFirst(3);
            assertEquals(2, al.size());
        }

        @Test void 容量超過() {
            ArrayLinkedList al = new ArrayLinkedList(2);
            al.addFirst(1); al.addFirst(2);
            al.addFirst(3); // 容量超過で無視
            assertEquals(2, al.size());
        }
    }
}
