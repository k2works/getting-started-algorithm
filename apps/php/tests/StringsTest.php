<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\Strings;
use PHPUnit\Framework\TestCase;

/**
 * 第7章 文字列処理
 */
class StringsTest extends TestCase
{
    private string $text    = 'ABCXDEZCABACABAB';
    private string $pattern = 'ABAB';

    public function testBF法パターンが見つかる(): void
    {
        $this->assertSame(12, Strings::bfMatch($this->text, $this->pattern));
    }

    public function testBF法パターンが見つからない(): void
    {
        $this->assertSame(-1, Strings::bfMatch('AAAA', 'BB'));
    }

    public function testBF法空パターンは位置0を返す(): void
    {
        $this->assertSame(0, Strings::bfMatch('hello', ''));
    }

    public function testKMP法パターンが見つかる(): void
    {
        $this->assertSame(12, Strings::kmpMatch($this->text, $this->pattern));
    }

    public function testKMP法パターンが見つからない(): void
    {
        $this->assertSame(-1, Strings::kmpMatch('AAAA', 'BB'));
    }

    public function testKMP法空パターンは位置0を返す(): void
    {
        $this->assertSame(0, Strings::kmpMatch('hello', ''));
    }

    public function testBM法パターンが見つかる(): void
    {
        $this->assertSame(12, Strings::bmMatch($this->text, $this->pattern));
    }

    public function testBM法パターンが見つからない(): void
    {
        $this->assertSame(-1, Strings::bmMatch('AAAA', 'BB'));
    }

    public function testBM法空パターンは位置0を返す(): void
    {
        $this->assertSame(0, Strings::bmMatch('hello', ''));
    }

    public function test文字の出現回数を返す(): void
    {
        $this->assertSame(['h' => 1, 'e' => 1, 'l' => 2, 'o' => 1], Strings::countChars('hello'));
    }

    public function test文字列を逆順にする(): void
    {
        $this->assertSame('olleh', Strings::reverseString('hello'));
    }

    public function test回文を判定する真(): void
    {
        $this->assertTrue(Strings::isPalindrome('racecar'));
    }

    public function test回文を判定する偽(): void
    {
        $this->assertFalse(Strings::isPalindrome('hello'));
    }
}
