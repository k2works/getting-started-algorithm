<?php

declare(strict_types=1);

namespace Tests;

use Algorithm\Sort;
use PHPUnit\Framework\TestCase;

/**
 * 第6章 ソートアルゴリズム
 */
class SortTest extends TestCase
{
    private array $unsorted = [6, 4, 3, 7, 1, 9, 8];
    private array $sorted   = [1, 3, 4, 6, 7, 8, 9];

    public function testバブルソート(): void
    {
        $a = $this->unsorted;
        Sort::bubbleSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function test選択ソート(): void
    {
        $a = $this->unsorted;
        Sort::selectionSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function test挿入ソート(): void
    {
        $a = $this->unsorted;
        Sort::insertionSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function testシェルソート(): void
    {
        $a = $this->unsorted;
        Sort::shellSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function testクイックソート(): void
    {
        $a = $this->unsorted;
        Sort::quickSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function testマージソート(): void
    {
        $this->assertSame($this->sorted, Sort::mergeSort($this->unsorted));
    }

    public function testヒープソート(): void
    {
        $a = $this->unsorted;
        Sort::heapSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function test度数ソート(): void
    {
        $this->assertSame($this->sorted, Sort::countingSort($this->unsorted));
    }

    public function test度数ソート空配列(): void
    {
        $this->assertSame([], Sort::countingSort([]));
    }

    public function testバブルソート走査範囲限定(): void
    {
        $a = $this->unsorted;
        Sort::bubbleSort3($a);
        $this->assertSame($this->sorted, $a);
    }

    public function testシェーカーソート(): void
    {
        $a = $this->unsorted;
        Sort::shakerSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function test二分挿入ソート(): void
    {
        $a = $this->unsorted;
        Sort::binaryInsertionSort($a);
        $this->assertSame($this->sorted, $a);
    }

    public function test非再帰的クイックソート(): void
    {
        $a = $this->unsorted;
        Sort::qsortStack($a);
        $this->assertSame($this->sorted, $a);
    }

    public function testソート済み配列のマージ(): void
    {
        $a = [1, 3, 5, 7];
        $b = [2, 4, 6, 8];
        $c = array_fill(0, 8, 0);
        Sort::mergeSortedArray($a, $b, $c);
        $this->assertSame([1, 2, 3, 4, 5, 6, 7, 8], $c);
    }
}
