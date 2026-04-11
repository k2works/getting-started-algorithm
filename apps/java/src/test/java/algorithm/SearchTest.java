package algorithm;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SearchTest {

    @Nested
    class LinearSearchTest {
        @Test
        void while文で探索_見つかる() {
            assertEquals(3, Search.linearSearchWhile(new int[]{6, 4, 3, 2, 1, 2, 8}, 2));
        }

        @Test
        void while文で探索_見つからない() {
            assertEquals(-1, Search.linearSearchWhile(new int[]{1, 2, 3}, 99));
        }

        @Test
        void for文で探索_見つかる() {
            assertEquals(3, Search.linearSearchFor(new int[]{6, 4, 3, 2, 1, 2, 8}, 2));
        }

        @Test
        void for文で探索_見つからない() {
            assertEquals(-1, Search.linearSearchFor(new int[]{1, 2, 3}, 99));
        }

        @Test
        void 番兵法で探索_見つかる() {
            assertEquals(3, Search.linearSearchSentinel(new int[]{6, 4, 3, 2, 1, 2, 8}, 2));
        }

        @Test
        void 番兵法で探索_見つからない() {
            assertEquals(-1, Search.linearSearchSentinel(new int[]{1, 2, 3}, 99));
        }
    }

    @Nested
    class BinarySearchTest {
        @Test
        void 中央の要素を探索() {
            assertEquals(3, Search.binarySearch(new int[]{1, 2, 3, 5, 7, 8, 9}, 5));
        }

        @Test
        void 先頭の要素を探索() {
            assertEquals(0, Search.binarySearch(new int[]{1, 2, 3, 5, 7, 8, 9}, 1));
        }

        @Test
        void 末尾の要素を探索() {
            assertEquals(6, Search.binarySearch(new int[]{1, 2, 3, 5, 7, 8, 9}, 9));
        }

        @Test
        void 見つからない() {
            assertEquals(-1, Search.binarySearch(new int[]{1, 2, 3, 5, 7, 8, 9}, 4));
        }
    }

    @Nested
    class ChainedHashTest {
        private Search.ChainedHash h;

        @BeforeEach
        void setUp() {
            h = new Search.ChainedHash(13);
            h.add(1, "赤尾");
            h.add(5, "武田");
            h.add(10, "小野");
            h.add(12, "鈴木");
            h.add(14, "神崎");
        }

        @Test
        void 探索_見つかる() {
            assertEquals("赤尾", h.search(1));
            assertEquals("神崎", h.search(14));
        }

        @Test
        void 探索_見つからない() {
            assertNull(h.search(100));
        }

        @Test
        void 追加して探索() {
            h.add(100, "山田");
            assertEquals("山田", h.search(100));
        }

        @Test
        void 重複キーは追加できない() {
            assertFalse(h.add(1, "重複"));
        }

        @Test
        void 削除() {
            h.add(100, "山田");
            assertTrue(h.remove(100));
            assertNull(h.search(100));
        }

        @Test
        void 衝突したノードの削除() {
            assertTrue(h.remove(1));
            assertTrue(h.remove(14));
            assertNull(h.search(1));
            assertNull(h.search(14));
        }

        @Test
        void 存在しないキーの削除() {
            assertFalse(h.remove(999));
        }
    }

    @Nested
    class OpenHashTest {
        private Search.OpenHash h;

        @BeforeEach
        void setUp() {
            h = new Search.OpenHash(13);
            h.add(1, "赤尾");
            h.add(5, "武田");
            h.add(10, "小野");
            h.add(12, "鈴木");
            h.add(14, "神崎");
        }

        @Test
        void 探索_見つかる() {
            assertEquals("赤尾", h.search(1));
        }

        @Test
        void 探索_見つからない() {
            assertNull(h.search(999));
        }

        @Test
        void 追加して探索() {
            h.add(100, "山田");
            assertEquals("山田", h.search(100));
        }

        @Test
        void 重複キーは追加できない() {
            assertFalse(h.add(1, "重複"));
        }

        @Test
        void 削除() {
            h.add(100, "山田");
            assertTrue(h.remove(100));
            assertNull(h.search(100));
        }

        @Test
        void 存在しないキーの削除() {
            assertFalse(h.remove(999));
        }

        @Test
        void テーブル満杯時の追加() {
            Search.OpenHash small = new Search.OpenHash(3);
            small.add(0, "a");
            small.add(1, "b");
            small.add(2, "c");
            assertFalse(small.add(99, "d"));
        }

        @Test
        void テーブル満杯時の存在しないキー削除() {
            Search.OpenHash small = new Search.OpenHash(3);
            small.add(0, "a");
            small.add(1, "b");
            small.add(2, "c");
            assertFalse(small.remove(99));
        }
    }
}
