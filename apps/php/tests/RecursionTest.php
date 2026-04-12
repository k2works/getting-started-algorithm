<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\Recursion;
use Algorithm\EightQueen;
use Algorithm\EightQueen2;
use Algorithm\EightQueen3;
use PHPUnit\Framework\TestCase;

/**
 * 第5章 再帰アルゴリズム
 */
class RecursionTest extends TestCase
{
    public function test5の階乗(): void
    {
        $this->assertSame(120, Recursion::factorial(5));
    }

    public function test0の階乗(): void
    {
        $this->assertSame(1, Recursion::factorial(0));
    }

    public function test22と8の最大公約数(): void
    {
        $this->assertSame(2, Recursion::gcd(22, 8));
    }

    public function test48と18の最大公約数(): void
    {
        $this->assertSame(6, Recursion::gcd(48, 18));
    }

    public function test1から5までの再帰的な和(): void
    {
        $this->assertSame(15, Recursion::recursiveSum(5));
    }

    public function test円盤1枚のハノイ(): void
    {
        $moves = Recursion::hanoi(1, 'A', 'C', 'B');
        $this->assertSame([['A', 'C']], $moves);
    }

    public function test円盤3枚のハノイの手順数(): void
    {
        $moves = Recursion::hanoi(3, 'A', 'C', 'B');
        $this->assertCount(7, $moves);
    }

    public function test解あり迷路(): void
    {
        $maze = [[1, 1, 1], [1, 0, 1], [1, 1, 1]];
        $this->assertTrue(Recursion::mazeSolve($maze, 1, 1, 1, 1));
    }

    public function testスタートゴールが同じは常に解あり(): void
    {
        $maze = [[0, 0], [0, 0]];
        $this->assertTrue(Recursion::mazeSolve($maze, 0, 0, 0, 0));
    }

    public function test8クイーン全組み合わせは8の8乗(): void
    {
        $q = new EightQueen();
        $q->set(0);
        $this->assertCount(8 ** 8, $q->getResult());
    }

    public function test8クイーン行制約ありは8の階乗(): void
    {
        $q = new EightQueen2();
        $q->set(0);
        $this->assertCount(40320, $q->getResult());
    }

    public function test8クイーン完全は92通り(): void
    {
        $q = new EightQueen3();
        $q->set(0);
        $this->assertCount(92, $q->getResult());
    }

    public function test真に再帰的な関数_recure4(): void
    {
        $this->assertSame([1, 2, 3, 1, 4, 1, 2], Recursion::recure(4, []));
    }

    public function test再帰的な関数_n0は空(): void
    {
        $this->assertSame([], Recursion::recure(0, []));
    }

    public function test末尾再帰除去版_recure2_4(): void
    {
        $this->assertSame([1, 2, 3, 1, 4, 1, 2], Recursion::recure2(4, []));
    }
}
