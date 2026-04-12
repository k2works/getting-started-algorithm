package algorithm;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class RecursionTest {

    @Nested
    class FactorialTest {
        @Test void factorial_0() { assertEquals(1, Recursion.factorial(0)); }
        @Test void factorial_1() { assertEquals(1, Recursion.factorial(1)); }
        @Test void factorial_5() { assertEquals(120, Recursion.factorial(5)); }
        @Test void factorial_10() { assertEquals(3628800, Recursion.factorial(10)); }
    }

    @Nested
    class GcdTest {
        @Test void 基本() { assertEquals(2, Recursion.gcd(22, 8)); }
        @Test void 倍数() { assertEquals(4, Recursion.gcd(12, 4)); }
        @Test void 互いに素() { assertEquals(1, Recursion.gcd(7, 11)); }
        @Test void 同じ値() { assertEquals(15, Recursion.gcd(15, 15)); }
    }

    @Nested
    class RecursiveSumTest {
        @Test void sum_1() { assertEquals(1, Recursion.recursiveSum(1)); }
        @Test void sum_5() { assertEquals(15, Recursion.recursiveSum(5)); }
        @Test void sum_10() { assertEquals(55, Recursion.recursiveSum(10)); }
    }

    @Nested
    class HanoiTest {
        @Test
        void ハノイ1枚() {
            List<String> moves = Recursion.hanoi(1, "A", "C", "B");
            assertEquals(List.of("A->C"), moves);
        }

        @Test
        void ハノイ2枚() {
            List<String> moves = Recursion.hanoi(2, "A", "C", "B");
            assertEquals(List.of("A->B", "A->C", "B->C"), moves);
        }

        @Test
        void ハノイ3枚は7手() {
            List<String> moves = Recursion.hanoi(3, "A", "C", "B");
            assertEquals(7, moves.size());
        }

        @Test
        void ハノイn枚は2のn乗マイナス1手() {
            for (int n = 1; n <= 5; n++) {
                assertEquals((1 << n) - 1, Recursion.hanoi(n, "A", "C", "B").size());
            }
        }
    }

    @Nested
    class MazeSolveTest {
        @Test
        void 解ける迷路() {
            int[][] maze = {
                {1, 1, 1, 1, 1},
                {1, 0, 0, 0, 1},
                {1, 0, 1, 0, 1},
                {1, 0, 0, 0, 1},
                {1, 1, 1, 1, 1},
            };
            assertTrue(Recursion.mazeSolve(maze, 1, 1, 3, 3));
        }

        @Test
        void 解けない迷路() {
            int[][] maze = {
                {1, 1, 1, 1, 1},
                {1, 0, 1, 0, 1},
                {1, 1, 1, 1, 1},
                {1, 0, 0, 0, 1},
                {1, 1, 1, 1, 1},
            };
            assertFalse(Recursion.mazeSolve(maze, 1, 1, 3, 1));
        }
    }

    @Nested
    class EightQueenTest {
        @Test
        void 全組み合わせは8の8乗() {
            var eq = new Recursion.EightQueen();
            eq.set(0);
            assertEquals((int) Math.pow(8, 8), eq.getCount());
        }

        @Test
        void 行制約ありは40320通り() {
            var eq2 = new Recursion.EightQueen2();
            eq2.set(0);
            assertEquals(40320, eq2.getResult().size());
        }

        @Test
        void 完全解は92通り() {
            var eq3 = new Recursion.EightQueen3();
            eq3.set(0);
            assertEquals(92, eq3.getResult().size());
        }
    }
}
