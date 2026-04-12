<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\FixedStack;
use Algorithm\FixedQueue;
use PHPUnit\Framework\TestCase;

/**
 * 第4章 スタックとキュー
 */
class StackQueueTest extends TestCase
{
    // --- FixedStack ---

    public function testスタックプッシュとポップ(): void
    {
        $stack = new FixedStack(5);
        $stack->push(1);
        $stack->push(2);
        $stack->push(3);
        $this->assertSame(3, $stack->pop());
        $this->assertSame(2, $stack->pop());
    }

    public function testスタックpeek(): void
    {
        $stack = new FixedStack(5);
        $stack->push(1);
        $stack->push(2);
        $this->assertSame(2, $stack->peek());
        $this->assertSame(2, $stack->length());
    }

    public function test空のスタックからのポップは例外(): void
    {
        $stack = new FixedStack(5);
        $this->expectException(\UnderflowException::class);
        $stack->pop();
    }

    public function test満杯のスタックへのプッシュは例外(): void
    {
        $stack = new FixedStack(5);
        for ($i = 0; $i < 5; $i++) {
            $stack->push($i);
        }
        $this->expectException(\OverflowException::class);
        $stack->push(99);
    }

    public function testスタックfind(): void
    {
        $stack = new FixedStack(5);
        $stack->push(10);
        $stack->push(20);
        $stack->push(30);
        $this->assertSame(1, $stack->find(20));
        $this->assertSame(-1, $stack->find(99));
    }

    public function testスタックcount(): void
    {
        $stack = new FixedStack(5);
        $stack->push(1);
        $stack->push(2);
        $stack->push(1);
        $this->assertSame(2, $stack->count(1));
    }

    public function testスタックinclude(): void
    {
        $stack = new FixedStack(5);
        $stack->push(42);
        $this->assertTrue($stack->includes(42));
        $this->assertFalse($stack->includes(99));
    }

    public function testスタックclear(): void
    {
        $stack = new FixedStack(5);
        $stack->push(1);
        $stack->clear();
        $this->assertTrue($stack->isEmpty());
    }

    // --- FixedQueue ---

    public function testキューエンキューとデキュー(): void
    {
        $queue = new FixedQueue(5);
        $queue->enqueue(1);
        $queue->enqueue(2);
        $queue->enqueue(3);
        $this->assertSame(1, $queue->dequeue());
        $this->assertSame(2, $queue->dequeue());
    }

    public function testキューpeek(): void
    {
        $queue = new FixedQueue(5);
        $queue->enqueue(1);
        $queue->enqueue(2);
        $this->assertSame(1, $queue->peek());
        $this->assertSame(2, $queue->length());
    }

    public function test空のキューからのデキューは例外(): void
    {
        $queue = new FixedQueue(5);
        $this->expectException(\UnderflowException::class);
        $queue->dequeue();
    }

    public function test満杯のキューへのエンキューは例外(): void
    {
        $queue = new FixedQueue(5);
        for ($i = 0; $i < 5; $i++) {
            $queue->enqueue($i);
        }
        $this->expectException(\OverflowException::class);
        $queue->enqueue(99);
    }

    public function testキューリングバッファとして動作する(): void
    {
        $queue = new FixedQueue(5);
        for ($i = 0; $i < 3; $i++) {
            $queue->enqueue($i);
        }
        $queue->dequeue();
        $queue->dequeue();
        for ($i = 0; $i < 3; $i++) {
            $queue->enqueue($i + 10);
        }
        $this->assertSame(2, $queue->dequeue());
        $this->assertSame(10, $queue->dequeue());
    }

    public function testキューfind(): void
    {
        $queue = new FixedQueue(5);
        $queue->enqueue(10);
        $queue->enqueue(20);
        $queue->enqueue(30);
        $this->assertSame(1, $queue->find(20));
        $this->assertSame(-1, $queue->find(99));
    }

    public function testキューcount(): void
    {
        $queue = new FixedQueue(5);
        $queue->enqueue(1);
        $queue->enqueue(2);
        $queue->enqueue(1);
        $this->assertSame(2, $queue->count(1));
    }

    public function testキューclear(): void
    {
        $queue = new FixedQueue(5);
        $queue->enqueue(1);
        $queue->clear();
        $this->assertTrue($queue->isEmpty());
    }
}
