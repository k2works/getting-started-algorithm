<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\LinkedList;
use Algorithm\DoublyLinkedList;
use Algorithm\ArrayLinkedList;
use PHPUnit\Framework\TestCase;

/**
 * 第8章 リスト
 */
class LinkedListTest extends TestCase
{
    // --- LinkedList ---

    public function test線形リスト先頭への挿入と探索(): void
    {
        $list = new LinkedList();
        $list->addFirst(1);
        $list->addFirst(2);
        $list->addFirst(3);
        $this->assertSame(3, $list->length());
        $this->assertNotNull($list->search(2));
    }

    public function test線形リスト末尾への挿入(): void
    {
        $list = new LinkedList();
        $list->addLast(1);
        $list->addLast(2);
        $list->addLast(3);
        $this->assertSame(3, $list->length());
    }

    public function test線形リスト先頭の削除(): void
    {
        $list = new LinkedList();
        $list->addFirst(1);
        $list->addFirst(2);
        $list->removeFirst();
        $this->assertSame(1, $list->length());
        $this->assertNull($list->search(2));
    }

    public function test線形リスト末尾の削除(): void
    {
        $list = new LinkedList();
        $list->addLast(1);
        $list->addLast(2);
        $list->removeLast();
        $this->assertSame(1, $list->length());
        $this->assertNull($list->search(2));
    }

    public function test線形リスト空リストからの削除は例外(): void
    {
        $list = new LinkedList();
        $this->expectException(\UnderflowException::class);
        $list->removeFirst();
    }

    public function test線形リストinclude(): void
    {
        $list = new LinkedList();
        $list->addFirst(42);
        $this->assertTrue($list->includes(42));
        $this->assertFalse($list->includes(99));
    }

    public function test線形リストclear(): void
    {
        $list = new LinkedList();
        $list->addFirst(1);
        $list->clear();
        $this->assertTrue($list->isEmpty());
    }

    public function test線形リストノード削除(): void
    {
        $list = new LinkedList();
        $list->addFirst(1);
        $list->addFirst(2);
        $node = $list->search(2);
        $list->remove($node);
        $this->assertFalse($list->includes(2));
    }

    // --- DoublyLinkedList ---

    public function test双方向リスト先頭への挿入と探索(): void
    {
        $list = new DoublyLinkedList();
        $list->addFirst(1);
        $list->addFirst(2);
        $list->addFirst(3);
        $this->assertSame(3, $list->length());
        $this->assertNotNull($list->search(2));
    }

    public function test双方向リスト末尾への挿入(): void
    {
        $list = new DoublyLinkedList();
        $list->addLast(1);
        $list->addLast(2);
        $list->addLast(3);
        $this->assertSame(3, $list->length());
    }

    public function test双方向リストノード削除(): void
    {
        $list = new DoublyLinkedList();
        $list->addFirst(1);
        $list->addFirst(2);
        $node = $list->search(2);
        $list->remove($node);
        $this->assertFalse($list->includes(2));
    }

    public function test双方向リストclear(): void
    {
        $list = new DoublyLinkedList();
        $list->addFirst(1);
        $list->clear();
        $this->assertTrue($list->isEmpty());
    }

    // --- ArrayLinkedList ---

    public function test配列リスト先頭への挿入と探索(): void
    {
        $list = new ArrayLinkedList(10);
        $list->addFirst(1);
        $list->addFirst(2);
        $list->addFirst(3);
        $this->assertSame(3, $list->length());
        $this->assertNotSame(ArrayLinkedList::NULL_INDEX, $list->search(2));
    }

    public function test配列リスト末尾への挿入(): void
    {
        $list = new ArrayLinkedList(10);
        $list->addLast(1);
        $list->addLast(2);
        $list->addLast(3);
        $this->assertSame(3, $list->length());
    }

    public function test配列リスト先頭の削除(): void
    {
        $list = new ArrayLinkedList(10);
        $list->addFirst(1);
        $list->addFirst(2);
        $list->removeFirst();
        $this->assertSame(1, $list->length());
        $this->assertSame(ArrayLinkedList::NULL_INDEX, $list->search(2));
    }
}
