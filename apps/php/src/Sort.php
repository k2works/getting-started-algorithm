<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第6章 ソートアルゴリズム
 */
class Sort
{
    /** バブルソート */
    public static function bubbleSort(array &$a): void
    {
        $n = count($a);
        for ($i = 0; $i < $n - 1; $i++) {
            for ($j = $n - 1; $j > $i; $j--) {
                if ($a[$j - 1] > $a[$j]) {
                    [$a[$j - 1], $a[$j]] = [$a[$j], $a[$j - 1]];
                }
            }
        }
    }

    /** バブルソート（走査範囲限定版） */
    public static function bubbleSort3(array &$a): void
    {
        $n = count($a);
        $k = 0;
        while ($k < $n - 1) {
            $last = $n - 1;
            for ($j = $n - 1; $j > $k; $j--) {
                if ($a[$j - 1] > $a[$j]) {
                    [$a[$j - 1], $a[$j]] = [$a[$j], $a[$j - 1]];
                    $last = $j;
                }
            }
            $k = $last;
        }
    }

    /** シェーカーソート（双方向バブルソート） */
    public static function shakerSort(array &$a): void
    {
        $n     = count($a);
        $left  = 0;
        $right = $n - 1;
        $last  = $right;
        while ($left < $right) {
            for ($j = $right; $j > $left; $j--) {
                if ($a[$j - 1] > $a[$j]) {
                    [$a[$j - 1], $a[$j]] = [$a[$j], $a[$j - 1]];
                    $last = $j;
                }
            }
            $left = $last;
            for ($j = $left; $j < $right; $j++) {
                if ($a[$j] > $a[$j + 1]) {
                    [$a[$j], $a[$j + 1]] = [$a[$j + 1], $a[$j]];
                    $last = $j;
                }
            }
            $right = $last;
        }
    }

    /** 選択ソート */
    public static function selectionSort(array &$a): void
    {
        $n = count($a);
        for ($i = 0; $i < $n - 1; $i++) {
            $min = $i;
            for ($j = $i + 1; $j < $n; $j++) {
                if ($a[$j] < $a[$min]) {
                    $min = $j;
                }
            }
            if ($min !== $i) {
                [$a[$i], $a[$min]] = [$a[$min], $a[$i]];
            }
        }
    }

    /** 挿入ソート */
    public static function insertionSort(array &$a): void
    {
        $n = count($a);
        for ($i = 1; $i < $n; $i++) {
            $tmp = $a[$i];
            $j   = $i;
            while ($j > 0 && $a[$j - 1] > $tmp) {
                $a[$j] = $a[$j - 1];
                $j--;
            }
            $a[$j] = $tmp;
        }
    }

    /** 二分挿入ソート */
    public static function binaryInsertionSort(array &$a): void
    {
        $n = count($a);
        for ($i = 1; $i < $n; $i++) {
            $tmp  = $a[$i];
            $lo   = 0;
            $hi   = $i;
            while ($lo < $hi) {
                $mid = intdiv($lo + $hi, 2);
                if ($a[$mid] <= $tmp) {
                    $lo = $mid + 1;
                } else {
                    $hi = $mid;
                }
            }
            for ($j = $i; $j > $lo; $j--) {
                $a[$j] = $a[$j - 1];
            }
            $a[$lo] = $tmp;
        }
    }

    /** シェルソート */
    public static function shellSort(array &$a): void
    {
        $n = count($a);
        $h = 1;
        while ($h < intdiv($n, 9)) {
            $h = $h * 3 + 1;
        }
        while ($h > 0) {
            for ($i = $h; $i < $n; $i++) {
                $tmp = $a[$i];
                $j   = $i - $h;
                while ($j >= 0 && $a[$j] > $tmp) {
                    $a[$j + $h] = $a[$j];
                    $j -= $h;
                }
                $a[$j + $h] = $tmp;
            }
            $h = intdiv($h, 3);
        }
    }

    /** クイックソート（再帰） */
    public static function quickSort(array &$a, int $lo = 0, int $hi = -1): void
    {
        if ($hi === -1) {
            $hi = count($a) - 1;
        }
        if ($lo >= $hi) {
            return;
        }
        $pivot = $a[intdiv($lo + $hi, 2)];
        $i     = $lo;
        $j     = $hi;
        while ($i <= $j) {
            while ($a[$i] < $pivot) {
                $i++;
            }
            while ($a[$j] > $pivot) {
                $j--;
            }
            if ($i <= $j) {
                [$a[$i], $a[$j]] = [$a[$j], $a[$i]];
                $i++;
                $j--;
            }
        }
        self::quickSort($a, $lo, $j);
        self::quickSort($a, $i, $hi);
    }

    /** 非再帰クイックソート（明示的スタック） */
    public static function qsortStack(array &$a): void
    {
        $n     = count($a);
        $stack = [[0, $n - 1]];
        while (!empty($stack)) {
            [$lo, $hi] = array_pop($stack);
            if ($lo >= $hi) {
                continue;
            }
            $pivot = $a[intdiv($lo + $hi, 2)];
            $i     = $lo;
            $j     = $hi;
            while ($i <= $j) {
                while ($a[$i] < $pivot) {
                    $i++;
                }
                while ($a[$j] > $pivot) {
                    $j--;
                }
                if ($i <= $j) {
                    [$a[$i], $a[$j]] = [$a[$j], $a[$i]];
                    $i++;
                    $j--;
                }
            }
            if ($lo < $j) {
                $stack[] = [$lo, $j];
            }
            if ($i < $hi) {
                $stack[] = [$i, $hi];
            }
        }
    }

    /** マージソート（新配列を返す） */
    public static function mergeSort(array $a): array
    {
        $n = count($a);
        if ($n <= 1) {
            return $a;
        }
        $mid   = intdiv($n, 2);
        $left  = self::mergeSort(array_slice($a, 0, $mid));
        $right = self::mergeSort(array_slice($a, $mid));
        return self::merge($left, $right);
    }

    private static function merge(array $left, array $right): array
    {
        $result = [];
        $i = 0;
        $j = 0;
        while ($i < count($left) && $j < count($right)) {
            if ($left[$i] <= $right[$j]) {
                $result[] = $left[$i++];
            } else {
                $result[] = $right[$j++];
            }
        }
        while ($i < count($left)) {
            $result[] = $left[$i++];
        }
        while ($j < count($right)) {
            $result[] = $right[$j++];
        }
        return $result;
    }

    /** ソート済み配列2本をマージして $c に格納 */
    public static function mergeSortedArray(array $a, array $b, array &$c): void
    {
        $i = 0;
        $j = 0;
        $k = 0;
        $na = count($a);
        $nb = count($b);
        while ($i < $na && $j < $nb) {
            if ($a[$i] <= $b[$j]) {
                $c[$k++] = $a[$i++];
            } else {
                $c[$k++] = $b[$j++];
            }
        }
        while ($i < $na) {
            $c[$k++] = $a[$i++];
        }
        while ($j < $nb) {
            $c[$k++] = $b[$j++];
        }
    }

    /** ヒープソート */
    public static function heapSort(array &$a): void
    {
        $n = count($a);
        // ヒープ構築
        for ($i = intdiv($n, 2) - 1; $i >= 0; $i--) {
            self::downHeap($a, $i, $n);
        }
        // ソート
        for ($i = $n - 1; $i > 0; $i--) {
            [$a[0], $a[$i]] = [$a[$i], $a[0]];
            self::downHeap($a, 0, $i);
        }
    }

    private static function downHeap(array &$a, int $i, int $n): void
    {
        while (true) {
            $child = 2 * $i + 1; // 左の子
            if ($child >= $n) {
                break;
            }
            if ($child + 1 < $n && $a[$child] < $a[$child + 1]) {
                $child++;
            }
            if ($a[$i] >= $a[$child]) {
                break;
            }
            [$a[$i], $a[$child]] = [$a[$child], $a[$i]];
            $i = $child;
        }
    }

    /** 度数ソート（非負整数の配列を想定） */
    public static function countingSort(array $a): array
    {
        if (empty($a)) {
            return [];
        }
        $max  = max($a);
        $freq = array_fill(0, $max + 1, 0);
        foreach ($a as $v) {
            $freq[$v]++;
        }
        $result = [];
        foreach ($freq as $v => $cnt) {
            for ($i = 0; $i < $cnt; $i++) {
                $result[] = $v;
            }
        }
        return $result;
    }
}
