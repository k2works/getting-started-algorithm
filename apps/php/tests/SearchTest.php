<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\Search;
use Algorithm\ChainedHash;
use Algorithm\OpenHash;
use PHPUnit\Framework\TestCase;

/**
 * 第3章 探索アルゴリズム
 */
class SearchTest extends TestCase
{
    private array $arr = [6, 4, 3, 2, 1, 2, 8];

    // --- 線形探索 ---

    public function test線形探索_whileキーが見つかる(): void
    {
        $this->assertSame(3, Search::ssearchWhile($this->arr, 2));
    }

    public function test線形探索_whileキーが見つからない(): void
    {
        $this->assertSame(-1, Search::ssearchWhile($this->arr, 99));
    }

    public function test線形探索_forキーが見つかる(): void
    {
        $this->assertSame(3, Search::ssearchFor($this->arr, 2));
    }

    public function test線形探索_forキーが見つからない(): void
    {
        $this->assertSame(-1, Search::ssearchFor($this->arr, 99));
    }

    public function test線形探索_番兵法キーが見つかる(): void
    {
        $this->assertSame(3, Search::ssearchSentinel($this->arr, 2));
    }

    public function test線形探索_番兵法キーが見つからない(): void
    {
        $this->assertSame(-1, Search::ssearchSentinel($this->arr, 99));
    }

    // --- 二分探索 ---

    public function test二分探索_キーが見つかる(): void
    {
        $sorted = [1, 2, 3, 5, 7, 8, 9];
        $this->assertSame(3, Search::bsearch($sorted, 5));
    }

    public function test二分探索_キーが見つからない(): void
    {
        $sorted = [1, 2, 3, 5, 7, 8, 9];
        $this->assertSame(-1, Search::bsearch($sorted, 4));
    }

    // --- ChainedHash ---

    public function testチェイン法ハッシュ追加と探索(): void
    {
        $hash = new ChainedHash(13);
        $hash->add('Alice', 1);
        $hash->add('Bob', 2);
        $this->assertSame(1, $hash->search('Alice'));
        $this->assertSame(2, $hash->search('Bob'));
    }

    public function testチェイン法ハッシュ重複追加は失敗する(): void
    {
        $hash = new ChainedHash(13);
        $hash->add('Alice', 1);
        $this->assertFalse($hash->add('Alice', 2));
    }

    public function testチェイン法ハッシュ削除できる(): void
    {
        $hash = new ChainedHash(13);
        $hash->add('Alice', 1);
        $hash->remove('Alice');
        $this->assertNull($hash->search('Alice'));
    }

    // --- OpenHash ---

    public function testオープンアドレス法ハッシュ追加と探索(): void
    {
        $hash = new OpenHash(13);
        $hash->add('Alice', 1);
        $hash->add('Bob', 2);
        $this->assertSame(1, $hash->search('Alice'));
        $this->assertSame(2, $hash->search('Bob'));
    }

    public function testオープンアドレス法ハッシュ重複追加は失敗する(): void
    {
        $hash = new OpenHash(13);
        $hash->add('Alice', 1);
        $this->assertFalse($hash->add('Alice', 2));
    }

    public function testオープンアドレス法ハッシュ削除できる(): void
    {
        $hash = new OpenHash(13);
        $hash->add('Alice', 1);
        $hash->remove('Alice');
        $this->assertNull($hash->search('Alice'));
    }
}
