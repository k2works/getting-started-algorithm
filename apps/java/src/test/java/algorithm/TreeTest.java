package algorithm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class TreeTest {

    @Nested
    class BinarySearchTreeTest {
        private BinarySearchTree<Integer> bst;

        @BeforeEach
        void setUp() { bst = new BinarySearchTree<>(); }

        @Test void 初期状態は空() { assertTrue(bst.isEmpty()); }

        @Test void insertしてcontains() {
            bst.insert(5);
            assertTrue(bst.contains(5));
        }

        @Test void 存在しないキー() { assertFalse(bst.contains(99)); }

        @Test void 複数insert() {
            for (int v : new int[]{5, 3, 7, 1, 4, 6, 8}) bst.insert(v);
            for (int v : new int[]{5, 3, 7, 1, 4, 6, 8}) assertTrue(bst.contains(v));
        }

        @Test void 中順探索は昇順() {
            for (int v : new int[]{5, 3, 7, 1, 4, 6, 8}) bst.insert(v);
            assertEquals(List.of(1, 3, 4, 5, 6, 7, 8), bst.inOrder());
        }

        @Test void 前順探索() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            assertEquals(List.of(5, 3, 7), bst.preOrder());
        }

        @Test void 後順探索() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            assertEquals(List.of(3, 7, 5), bst.postOrder());
        }

        @Test void min() {
            for (int v : new int[]{5, 3, 7, 1, 4}) bst.insert(v);
            assertEquals(1, bst.min());
        }

        @Test void max() {
            for (int v : new int[]{5, 3, 7, 1, 4}) bst.insert(v);
            assertEquals(7, bst.max());
        }

        @Test void min_空で例外() { assertThrows(BinarySearchTree.EmptyException.class, () -> bst.min()); }
        @Test void max_空で例外() { assertThrows(BinarySearchTree.EmptyException.class, () -> bst.max()); }

        @Test void 葉ノードの削除() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            bst.delete(3);
            assertFalse(bst.contains(3));
            assertTrue(bst.contains(5));
            assertTrue(bst.contains(7));
        }

        @Test void 子が1つのノードの削除() {
            for (int v : new int[]{5, 3, 7, 1}) bst.insert(v);
            bst.delete(3);
            assertFalse(bst.contains(3));
            assertTrue(bst.contains(1));
        }

        @Test void 子が2つのノードの削除() {
            for (int v : new int[]{5, 3, 7, 1, 4}) bst.insert(v);
            bst.delete(3);
            assertFalse(bst.contains(3));
            for (int v : new int[]{1, 4, 5, 7}) assertTrue(bst.contains(v));
        }

        @Test void 根ノードの削除() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            bst.delete(5);
            assertFalse(bst.contains(5));
            assertTrue(bst.contains(3));
            assertTrue(bst.contains(7));
            assertEquals(List.of(3, 7), bst.inOrder());
        }

        @Test void 存在しないキーの削除() {
            bst.insert(5);
            bst.delete(99);
            assertTrue(bst.contains(5));
        }

        @Test void size() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            assertEquals(3, bst.size());
        }

        @Test void contains() {
            bst.insert(42);
            assertTrue(bst.contains(42));
            assertFalse(bst.contains(0));
        }

        @Test void 根のみ削除で空() {
            bst.insert(5);
            bst.delete(5);
            assertTrue(bst.isEmpty());
        }

        @Test void 重複キー挿入は無視() {
            bst.insert(5); bst.insert(5);
            assertEquals(1, bst.size());
        }

        @Test void 右子のみのノード削除() {
            for (int v : new int[]{5, 3, 7, 8}) bst.insert(v);
            bst.delete(7);
            assertFalse(bst.contains(7));
            assertTrue(bst.contains(8));
        }

        @Test void 深い後継ノードの削除() {
            for (int v : new int[]{10, 5, 20, 15, 25, 12, 18}) bst.insert(v);
            bst.delete(10);
            assertFalse(bst.contains(10));
            assertEquals(List.of(5, 12, 15, 18, 20, 25), bst.inOrder());
        }

        @Test void 右子として親に繋がるノード削除() {
            for (int v : new int[]{5, 3, 7}) bst.insert(v);
            bst.delete(7);
            assertFalse(bst.contains(7));
            assertTrue(bst.contains(5));
        }
    }
}
