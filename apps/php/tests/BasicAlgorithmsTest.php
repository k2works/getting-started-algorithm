<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\BasicAlgorithms;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\DataProvider;

/**
 * 第1章 基本的なアルゴリズム
 */
class BasicAlgorithmsTest extends TestCase
{
    // --- max3 ---

    public static function max3Provider(): array
    {
        return [
            [3, 2, 1, 3],
            [3, 2, 2, 3],
            [3, 1, 2, 3],
            [3, 2, 3, 3],
            [2, 1, 3, 3],
            [3, 3, 2, 3],
            [3, 3, 3, 3],
            [2, 2, 3, 3],
            [2, 3, 1, 3],
            [2, 3, 2, 3],
            [1, 3, 2, 3],
            [2, 3, 3, 3],
            [1, 2, 3, 3],
        ];
    }

    #[DataProvider('max3Provider')]
    public function test3値の最大値を返す(int $a, int $b, int $c, int $expected): void
    {
        $this->assertSame($expected, BasicAlgorithms::max3($a, $b, $c));
    }

    // --- med3 ---

    public static function med3Provider(): array
    {
        return [
            [3, 2, 1, 2],
            [3, 2, 2, 2],
            [3, 1, 2, 2],
            [3, 2, 3, 3],
            [2, 1, 3, 2],
            [3, 3, 2, 3],
            [3, 3, 3, 3],
            [2, 2, 3, 2],
            [2, 3, 1, 2],
            [2, 3, 2, 2],
            [1, 3, 2, 2],
            [2, 3, 3, 3],
            [1, 2, 3, 2],
        ];
    }

    #[DataProvider('med3Provider')]
    public function test3値の中央値を返す(int $a, int $b, int $c, int $expected): void
    {
        $this->assertSame($expected, BasicAlgorithms::med3($a, $b, $c));
    }

    // --- judgeSign ---

    public function test正の値の符号判定(): void
    {
        $this->assertSame('その値は正です。', BasicAlgorithms::judgeSign(17));
    }

    public function test負の値の符号判定(): void
    {
        $this->assertSame('その値は負です。', BasicAlgorithms::judgeSign(-5));
    }

    public function testゼロの符号判定(): void
    {
        $this->assertSame('その値は0です。', BasicAlgorithms::judgeSign(0));
    }

    // --- 繰り返し処理 ---

    public function testWhileループで1からnまでの総和(): void
    {
        $this->assertSame(15, BasicAlgorithms::sum1ToNWhile(5));
    }

    public function testForループで1からnまでの総和(): void
    {
        $this->assertSame(15, BasicAlgorithms::sum1ToNFor(5));
    }

    // --- 記号文字の交互表示 ---

    public function test剰余判定方式で偶数個(): void
    {
        $this->assertSame('+-+-+-+-+-+-', BasicAlgorithms::alternative1(12));
    }

    public function testパターン繰り返し方式で偶数個(): void
    {
        $this->assertSame('+-+-+-+-+-+-', BasicAlgorithms::alternative2(12));
    }

    public function test剰余判定方式で奇数個(): void
    {
        $this->assertSame('+-+-+', BasicAlgorithms::alternative1(5));
    }

    public function testパターン繰り返し方式で奇数個(): void
    {
        $this->assertSame('+-+-+', BasicAlgorithms::alternative2(5));
    }

    // --- rectangle ---

    public function test面積32の長方形の辺の組み合わせ(): void
    {
        $this->assertSame('1x32 2x16 4x8 ', BasicAlgorithms::rectangle(32));
    }

    // --- multiplicationTable ---

    public function test九九の表(): void
    {
        $expected = implode("\n", [
            '---------------------------',
            '  1  2  3  4  5  6  7  8  9',
            '  2  4  6  8 10 12 14 16 18',
            '  3  6  9 12 15 18 21 24 27',
            '  4  8 12 16 20 24 28 32 36',
            '  5 10 15 20 25 30 35 40 45',
            '  6 12 18 24 30 36 42 48 54',
            '  7 14 21 28 35 42 49 56 63',
            '  8 16 24 32 40 48 56 64 72',
            '  9 18 27 36 45 54 63 72 81',
            '---------------------------',
        ]);
        $this->assertSame($expected, BasicAlgorithms::multiplicationTable());
    }

    // --- triangleLb ---

    public function test左下直角の二等辺三角形(): void
    {
        $this->assertSame("*\n**\n***\n****\n*****\n", BasicAlgorithms::triangleLb(5));
    }
}
