<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第4章 スタックとキュー
 */

/** 固定長スタック */
class FixedStack
{
    private array $stk;
    private int $ptr = 0;

    public function __construct(private int $capacity)
    {
        $this->stk = array_fill(0, $capacity, null);
    }

    public function isEmpty(): bool
    {
        return $this->ptr === 0;
    }

    public function isFull(): bool
    {
        return $this->ptr === $this->capacity;
    }

    public function push(mixed $value): void
    {
        if ($this->isFull()) {
            throw new \OverflowException('Stack is full');
        }
        $this->stk[$this->ptr++] = $value;
    }

    public function pop(): mixed
    {
        if ($this->isEmpty()) {
            throw new \UnderflowException('Stack is empty');
        }
        return $this->stk[--$this->ptr];
    }

    public function peek(): mixed
    {
        if ($this->isEmpty()) {
            throw new \UnderflowException('Stack is empty');
        }
        return $this->stk[$this->ptr - 1];
    }

    public function length(): int
    {
        return $this->ptr;
    }

    /** スタックの上から数えたインデックスを返す（先頭 = 0）、見つからなければ -1 */
    public function find(mixed $value): int
    {
        for ($i = $this->ptr - 1; $i >= 0; $i--) {
            if ($this->stk[$i] === $value) {
                return $this->ptr - 1 - $i;
            }
        }
        return -1;
    }

    /** 値の出現回数 */
    public function count(mixed $value): int
    {
        $cnt = 0;
        for ($i = 0; $i < $this->ptr; $i++) {
            if ($this->stk[$i] === $value) {
                $cnt++;
            }
        }
        return $cnt;
    }

    public function includes(mixed $value): bool
    {
        return $this->find($value) !== -1;
    }

    public function clear(): void
    {
        $this->ptr = 0;
    }
}

/** 固定長キュー（リングバッファ実装） */
class FixedQueue
{
    private array $que;
    private int $front = 0;
    private int $rear  = 0;
    private int $num   = 0;

    public function __construct(private int $capacity)
    {
        $this->que = array_fill(0, $capacity, null);
    }

    public function isEmpty(): bool
    {
        return $this->num === 0;
    }

    public function isFull(): bool
    {
        return $this->num === $this->capacity;
    }

    public function enqueue(mixed $value): void
    {
        if ($this->isFull()) {
            throw new \OverflowException('Queue is full');
        }
        $this->que[$this->rear] = $value;
        $this->rear = ($this->rear + 1) % $this->capacity;
        $this->num++;
    }

    public function dequeue(): mixed
    {
        if ($this->isEmpty()) {
            throw new \UnderflowException('Queue is empty');
        }
        $value = $this->que[$this->front];
        $this->front = ($this->front + 1) % $this->capacity;
        $this->num--;
        return $value;
    }

    public function peek(): mixed
    {
        if ($this->isEmpty()) {
            throw new \UnderflowException('Queue is empty');
        }
        return $this->que[$this->front];
    }

    public function length(): int
    {
        return $this->num;
    }

    /** キューの先頭から数えたインデックスを返す（先頭 = 0）、見つからなければ -1 */
    public function find(mixed $value): int
    {
        for ($i = 0; $i < $this->num; $i++) {
            $idx = ($this->front + $i) % $this->capacity;
            if ($this->que[$idx] === $value) {
                return $i;
            }
        }
        return -1;
    }

    /** 値の出現回数 */
    public function count(mixed $value): int
    {
        $cnt = 0;
        for ($i = 0; $i < $this->num; $i++) {
            $idx = ($this->front + $i) % $this->capacity;
            if ($this->que[$idx] === $value) {
                $cnt++;
            }
        }
        return $cnt;
    }

    public function includes(mixed $value): bool
    {
        return $this->find($value) !== -1;
    }

    public function clear(): void
    {
        $this->front = 0;
        $this->rear  = 0;
        $this->num   = 0;
    }
}
