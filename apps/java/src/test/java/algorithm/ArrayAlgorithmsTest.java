package algorithm;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ArrayAlgorithmsTest {

    @Nested
    class MaxOfTest {
        @Test
        void 複数要素の最大値() {
            assertEquals(192, ArrayAlgorithms.maxOf(new int[]{172, 153, 192, 140, 165}));
        }

        @Test
        void 単一要素() {
            assertEquals(42, ArrayAlgorithms.maxOf(new int[]{42}));
        }

        @Test
        void 全て同じ値() {
            assertEquals(5, ArrayAlgorithms.maxOf(new int[]{5, 5, 5}));
        }
    }

    @Nested
    class ReverseArrayTest {
        @Test
        void 奇数長の配列を反転() {
            int[] a = {2, 5, 1, 3, 9, 6, 7};
            ArrayAlgorithms.reverse(a);
            assertArrayEquals(new int[]{7, 6, 9, 3, 1, 5, 2}, a);
        }

        @Test
        void 偶数長の配列を反転() {
            int[] a = {1, 2, 3, 4};
            ArrayAlgorithms.reverse(a);
            assertArrayEquals(new int[]{4, 3, 2, 1}, a);
        }

        @Test
        void 単一要素() {
            int[] a = {42};
            ArrayAlgorithms.reverse(a);
            assertArrayEquals(new int[]{42}, a);
        }
    }

    @Nested
    class CardConvTest {
        @Test
        void 二進数変換() {
            assertEquals("11101", ArrayAlgorithms.cardConv(29, 2));
        }

        @Test
        void 八進数変換() {
            assertEquals("35", ArrayAlgorithms.cardConv(29, 8));
        }

        @Test
        void 十六進数変換() {
            assertEquals("FF", ArrayAlgorithms.cardConv(255, 16));
        }
    }

    @Nested
    class PrimeTest {
        @Test
        void 素数列挙第1版の除算回数() {
            assertEquals(78022, ArrayAlgorithms.prime1(1000));
        }

        @Test
        void 素数列挙第2版の除算回数() {
            assertEquals(14622, ArrayAlgorithms.prime2(1000));
        }

        @Test
        void 素数列挙第3版の除算回数() {
            assertEquals(3774, ArrayAlgorithms.prime3(1000));
        }
    }
}
