<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\BinarySearchTree;
use PHPUnit\Framework\TestCase;

/**
 * 第9章 木構造
 */
class TreeTest extends TestCase
{
    private function buildBst(): BinarySearchTree
    {
        $bst = new BinarySearchTree();
        foreach ([5, 3, 7, 1, 4, 6, 8] as $k) {
            $bst->insert($k);
        }
        return $bst;
    }

    public function test挿入と探索(): void
    {
        $bst = $this->buildBst();
        $this->assertNotNull($bst->search(5));
        $this->assertSame(5, $bst->search(5)->key);
        $this->assertNull($bst->search(99));
    }

    public function testinclude(): void
    {
        $bst = $this->buildBst();
        $this->assertTrue($bst->includes(3));
        $this->assertFalse($bst->includes(99));
    }

    public function testlength(): void
    {
        $bst = $this->buildBst();
        $this->assertSame(7, $bst->length());
    }

    public function test重複挿入は無視される(): void
    {
        $bst = $this->buildBst();
        $bst->insert(5);
        $this->assertSame(7, $bst->length());
    }

    public function testminとmax(): void
    {
        $bst = $this->buildBst();
        $this->assertSame(1, $bst->min());
        $this->assertSame(8, $bst->max());
    }

    public function test中順探索昇順(): void
    {
        $bst = $this->buildBst();
        $this->assertSame([1, 3, 4, 5, 6, 7, 8], $bst->inorder());
    }

    public function test前順探索(): void
    {
        $bst = $this->buildBst();
        $this->assertSame([5, 3, 1, 4, 7, 6, 8], $bst->preorder());
    }

    public function test後順探索(): void
    {
        $bst = $this->buildBst();
        $this->assertSame([1, 4, 3, 6, 8, 7, 5], $bst->postorder());
    }

    public function test葉ノードの削除(): void
    {
        $bst = $this->buildBst();
        $bst->delete(1);
        $this->assertFalse($bst->includes(1));
        $this->assertSame([3, 4, 5, 6, 7, 8], $bst->inorder());
    }

    public function test子が1つのノードの削除(): void
    {
        $bst = $this->buildBst();
        $bst->delete(1);
        $bst->delete(3);
        $this->assertFalse($bst->includes(3));
        $this->assertSame([4, 5, 6, 7, 8], $bst->inorder());
    }

    public function test子が2つのノードの削除(): void
    {
        $bst = $this->buildBst();
        $bst->delete(7);
        $this->assertFalse($bst->includes(7));
        $this->assertSame([1, 3, 4, 5, 6, 8], $bst->inorder());
    }

    public function testルートノードの削除(): void
    {
        $bst = $this->buildBst();
        $bst->delete(5);
        $this->assertFalse($bst->includes(5));
        $this->assertSame([1, 3, 4, 6, 7, 8], $bst->inorder());
    }

    public function test空の木のminは例外(): void
    {
        $bst = new BinarySearchTree();
        $this->expectException(\UnderflowException::class);
        $bst->min();
    }
}
