<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第8章 リスト
 */

// ---- 線形リスト（単方向） ----

class Node
{
    public function __construct(
        public mixed $data,
        public ?Node $next = null,
    ) {}
}

class LinkedList
{
    private ?Node $head = null;
    private int   $size = 0;

    public function isEmpty(): bool
    {
        return $this->head === null;
    }

    public function length(): int
    {
        return $this->size;
    }

    public function addFirst(mixed $data): void
    {
        $this->head = new Node($data, $this->head);
        $this->size++;
    }

    public function addLast(mixed $data): void
    {
        $node = new Node($data);
        if ($this->head === null) {
            $this->head = $node;
        } else {
            $cur = $this->head;
            while ($cur->next !== null) {
                $cur = $cur->next;
            }
            $cur->next = $node;
        }
        $this->size++;
    }

    public function removeFirst(): void
    {
        if ($this->head === null) {
            throw new \UnderflowException('List is empty');
        }
        $this->head = $this->head->next;
        $this->size--;
    }

    public function removeLast(): void
    {
        if ($this->head === null) {
            throw new \UnderflowException('List is empty');
        }
        if ($this->head->next === null) {
            $this->head = null;
        } else {
            $cur = $this->head;
            while ($cur->next->next !== null) {
                $cur = $cur->next;
            }
            $cur->next = null;
        }
        $this->size--;
    }

    /** ノード $target を削除 */
    public function remove(Node $target): void
    {
        if ($this->head === null) {
            return;
        }
        if ($this->head === $target) {
            $this->head = $this->head->next;
            $this->size--;
            return;
        }
        $cur = $this->head;
        while ($cur->next !== null) {
            if ($cur->next === $target) {
                $cur->next = $cur->next->next;
                $this->size--;
                return;
            }
            $cur = $cur->next;
        }
    }

    public function search(mixed $data): ?Node
    {
        $cur = $this->head;
        while ($cur !== null) {
            if ($cur->data === $data) {
                return $cur;
            }
            $cur = $cur->next;
        }
        return null;
    }

    public function includes(mixed $data): bool
    {
        return $this->search($data) !== null;
    }

    public function clear(): void
    {
        $this->head = null;
        $this->size = 0;
    }
}

// ---- 双方向リスト ----

class DNode
{
    public function __construct(
        public mixed  $data,
        public ?DNode $prev = null,
        public ?DNode $next = null,
    ) {}
}

class DoublyLinkedList
{
    private ?DNode $head = null;
    private ?DNode $tail = null;
    private int    $size = 0;

    public function isEmpty(): bool
    {
        return $this->head === null;
    }

    public function length(): int
    {
        return $this->size;
    }

    public function addFirst(mixed $data): void
    {
        $node = new DNode($data, null, $this->head);
        if ($this->head !== null) {
            $this->head->prev = $node;
        } else {
            $this->tail = $node;
        }
        $this->head = $node;
        $this->size++;
    }

    public function addLast(mixed $data): void
    {
        $node = new DNode($data, $this->tail, null);
        if ($this->tail !== null) {
            $this->tail->next = $node;
        } else {
            $this->head = $node;
        }
        $this->tail = $node;
        $this->size++;
    }

    public function remove(DNode $target): void
    {
        if ($target->prev !== null) {
            $target->prev->next = $target->next;
        } else {
            $this->head = $target->next;
        }
        if ($target->next !== null) {
            $target->next->prev = $target->prev;
        } else {
            $this->tail = $target->prev;
        }
        $this->size--;
    }

    public function search(mixed $data): ?DNode
    {
        $cur = $this->head;
        while ($cur !== null) {
            if ($cur->data === $data) {
                return $cur;
            }
            $cur = $cur->next;
        }
        return null;
    }

    public function includes(mixed $data): bool
    {
        return $this->search($data) !== null;
    }

    public function clear(): void
    {
        $this->head = null;
        $this->tail = null;
        $this->size = 0;
    }
}

// ---- 配列によるリスト ----

class ArrayLinkedList
{
    public const NULL_INDEX = -1;

    private array $data;
    private array $next;
    private array $dnext; // フリーリスト用
    private int   $head;
    private int   $deleted;
    private int   $size;
    private int   $max;

    public function __construct(private int $capacity)
    {
        $this->data    = array_fill(0, $capacity, null);
        $this->next    = array_fill(0, $capacity, self::NULL_INDEX);
        $this->head    = self::NULL_INDEX;
        $this->deleted = self::NULL_INDEX;
        $this->size    = 0;
        $this->max     = 0;
    }

    private function alloc(): int
    {
        if ($this->deleted !== self::NULL_INDEX) {
            $idx           = $this->deleted;
            $this->deleted = $this->next[$idx];
            return $idx;
        }
        return $this->max++;
    }

    private function free(int $idx): void
    {
        $this->next[$idx] = $this->deleted;
        $this->deleted    = $idx;
    }

    public function isEmpty(): bool
    {
        return $this->size === 0;
    }

    public function length(): int
    {
        return $this->size;
    }

    public function addFirst(mixed $data): void
    {
        $idx              = $this->alloc();
        $this->data[$idx] = $data;
        $this->next[$idx] = $this->head;
        $this->head       = $idx;
        $this->size++;
    }

    public function addLast(mixed $data): void
    {
        $idx              = $this->alloc();
        $this->data[$idx] = $data;
        $this->next[$idx] = self::NULL_INDEX;
        if ($this->head === self::NULL_INDEX) {
            $this->head = $idx;
        } else {
            $cur = $this->head;
            while ($this->next[$cur] !== self::NULL_INDEX) {
                $cur = $this->next[$cur];
            }
            $this->next[$cur] = $idx;
        }
        $this->size++;
    }

    public function removeFirst(): void
    {
        if ($this->head === self::NULL_INDEX) {
            throw new \UnderflowException('List is empty');
        }
        $idx        = $this->head;
        $this->head = $this->next[$idx];
        $this->free($idx);
        $this->size--;
    }

    /** データを探してインデックスを返す（なければ NULL_INDEX） */
    public function search(mixed $data): int
    {
        $cur = $this->head;
        while ($cur !== self::NULL_INDEX) {
            if ($this->data[$cur] === $data) {
                return $cur;
            }
            $cur = $this->next[$cur];
        }
        return self::NULL_INDEX;
    }

    public function includes(mixed $data): bool
    {
        return $this->search($data) !== self::NULL_INDEX;
    }
}
