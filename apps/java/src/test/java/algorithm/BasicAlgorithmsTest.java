package algorithm;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BasicAlgorithmsTest {

    @Nested
    class Max3Test {
        @Test
        void 各パターンで最大値を返す() {
            int[][] cases = {
                {3, 2, 1, 3}, {3, 2, 2, 3}, {3, 1, 2, 3},
                {3, 2, 3, 3}, {2, 1, 3, 3}, {3, 3, 2, 3},
                {3, 3, 3, 3}, {2, 2, 3, 3}, {2, 3, 1, 3},
                {2, 3, 2, 3}, {1, 3, 2, 3}, {2, 3, 3, 3},
                {1, 2, 3, 3},
            };
            for (int[] c : cases) {
                assertEquals(c[3], BasicAlgorithms.max3(c[0], c[1], c[2]),
                    String.format("max3(%d, %d, %d) should be %d", c[0], c[1], c[2], c[3]));
            }
        }
    }

    @Nested
    class Med3Test {
        @Test
        void 各パターンで中央値を返す() {
            int[][] cases = {
                {3, 2, 1, 2}, {3, 2, 2, 2}, {3, 1, 2, 2},
                {3, 2, 3, 3}, {2, 1, 3, 2}, {3, 3, 2, 3},
                {3, 3, 3, 3}, {2, 2, 3, 2}, {2, 3, 1, 2},
                {2, 3, 2, 2}, {1, 3, 2, 2}, {2, 3, 3, 3},
                {1, 2, 3, 2},
            };
            for (int[] c : cases) {
                assertEquals(c[3], BasicAlgorithms.med3(c[0], c[1], c[2]),
                    String.format("med3(%d, %d, %d) should be %d", c[0], c[1], c[2], c[3]));
            }
        }
    }

    @Nested
    class JudgeSignTest {
        @Test
        void 正の値() {
            assertEquals("その値は正です。", BasicAlgorithms.judgeSign(17));
        }

        @Test
        void 負の値() {
            assertEquals("その値は負です。", BasicAlgorithms.judgeSign(-5));
        }

        @Test
        void ゼロ() {
            assertEquals("その値は0です。", BasicAlgorithms.judgeSign(0));
        }
    }

    @Nested
    class Sum1ToNTest {
        @Test
        void while文で総和() {
            assertEquals(15, BasicAlgorithms.sum1ToNWhile(5));
        }

        @Test
        void for文で総和() {
            assertEquals(15, BasicAlgorithms.sum1ToNFor(5));
        }
    }

    @Nested
    class AlternativeTest {
        @Test
        void 剰余判定方式で12文字() {
            assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative1(12));
        }

        @Test
        void パターン繰り返し方式で12文字() {
            assertEquals("+-+-+-+-+-+-", BasicAlgorithms.alternative2(12));
        }

        @Test
        void 奇数文字() {
            assertEquals("+-+-+", BasicAlgorithms.alternative1(5));
            assertEquals("+-+-+", BasicAlgorithms.alternative2(5));
        }
    }

    @Nested
    class RectangleTest {
        @Test
        void 面積32の長方形() {
            assertEquals("1x32 2x16 4x8 ", BasicAlgorithms.rectangle(32));
        }
    }

    @Nested
    class MultiplicationTableTest {
        @Test
        void 九九の表() {
            String expected =
                "---------------------------\n" +
                "  1  2  3  4  5  6  7  8  9\n" +
                "  2  4  6  8 10 12 14 16 18\n" +
                "  3  6  9 12 15 18 21 24 27\n" +
                "  4  8 12 16 20 24 28 32 36\n" +
                "  5 10 15 20 25 30 35 40 45\n" +
                "  6 12 18 24 30 36 42 48 54\n" +
                "  7 14 21 28 35 42 49 56 63\n" +
                "  8 16 24 32 40 48 56 64 72\n" +
                "  9 18 27 36 45 54 63 72 81\n" +
                "---------------------------";
            assertEquals(expected, BasicAlgorithms.multiplicationTable());
        }
    }

    @Nested
    class TriangleLbTest {
        @Test
        void 直角三角形() {
            String expected = "*\n**\n***\n****\n*****\n";
            assertEquals(expected, BasicAlgorithms.triangleLb(5));
        }
    }
}
