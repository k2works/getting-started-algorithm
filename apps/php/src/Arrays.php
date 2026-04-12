<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第2章 配列
 */
class Arrays
{
    /** 配列の要素の最大値を返す */
    public static function maxOf(array $a): int
    {
        $maximum = $a[0];
        for ($i = 1; $i < count($a); $i++) {
            if ($a[$i] > $maximum) {
                $maximum = $a[$i];
            }
        }
        return $maximum;
    }

    /** 配列の要素の並びを反転する（参照渡しで破壊的） */
    public static function reverseArray(array &$a): void
    {
        $n = count($a);
        for ($i = 0; $i < intdiv($n, 2); $i++) {
            [$a[$i], $a[$n - $i - 1]] = [$a[$n - $i - 1], $a[$i]];
        }
    }

    /** 整数値xをr進数に変換した文字列を返す */
    public static function cardConv(int $x, int $r): string
    {
        $d = '';
        $dchar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        while ($x > 0) {
            $d .= $dchar[$x % $r];
            $x = intdiv($x, $r);
        }
        return strrev($d);
    }

    /** x以下の素数を列挙する（第1版）— 除算回数を返す */
    public static function prime1(int $x): int
    {
        $counter = 0;
        for ($n = 2; $n <= $x; $n++) {
            for ($i = 2; $i < $n; $i++) {
                $counter++;
                if ($n % $i === 0) {
                    break;
                }
            }
        }
        return $counter;
    }

    /** x以下の素数を列挙する（第2版）— 除算回数を返す */
    public static function prime2(int $x): int
    {
        $counter = 0;
        $ptr = 0;
        $prime = array_fill(0, 500, 0);

        $prime[$ptr++] = 2;

        for ($n = 3; $n <= $x; $n += 2) {
            $foundDivisor = false;
            for ($i = 1; $i < $ptr; $i++) {
                $counter++;
                if ($n % $prime[$i] === 0) {
                    $foundDivisor = true;
                    break;
                }
            }
            if (!$foundDivisor) {
                $prime[$ptr++] = $n;
            }
        }
        return $counter;
    }

    /** x以下の素数を列挙する（第3版）— 除算回数を返す */
    public static function prime3(int $x): int
    {
        $counter = 0;
        $ptr = 0;
        $prime = array_fill(0, 500, 0);

        $prime[$ptr++] = 2;
        $prime[$ptr++] = 3;

        for ($n = 5; $n <= 1000; $n += 2) {
            $i = 1;
            $foundDivisor = false;
            while ($prime[$i] * $prime[$i] <= $n) {
                $counter += 2;
                if ($n % $prime[$i] === 0) {
                    $foundDivisor = true;
                    break;
                }
                $i++;
            }
            if (!$foundDivisor) {
                $prime[$ptr++] = $n;
                $counter++;
            }
        }
        return $counter;
    }
}
