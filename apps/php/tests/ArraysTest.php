<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\Arrays;
use PHPUnit\Framework\TestCase;

/**
 * 第2章 配列
 */
class ArraysTest extends TestCase
{
    public function test配列の最大値を返す(): void
    {
        $this->assertSame(192, Arrays::maxOf([172, 153, 192, 140, 165]));
    }

    public function test配列を逆順にする(): void
    {
        $a = [2, 5, 1, 3, 9, 6, 7];
        Arrays::reverseArray($a);
        $this->assertSame([7, 6, 9, 3, 1, 5, 2], $a);
    }

    public function test2進数変換(): void
    {
        $this->assertSame('11101', Arrays::cardConv(29, 2));
    }

    public function test16進数変換(): void
    {
        $this->assertSame('FF', Arrays::cardConv(255, 16));
    }

    public function test1000以下の素数の除算回数_第1版(): void
    {
        $this->assertSame(78022, Arrays::prime1(1000));
    }

    public function test1000以下の素数の除算回数_第2版(): void
    {
        $this->assertSame(14622, Arrays::prime2(1000));
    }

    public function test1000以下の素数の除算回数_第3版(): void
    {
        $this->assertSame(3774, Arrays::prime3(1000));
    }
}
