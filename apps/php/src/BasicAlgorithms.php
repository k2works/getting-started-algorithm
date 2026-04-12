<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第1章 基本的なアルゴリズム
 */
class BasicAlgorithms
{
    /** 3つの整数値の最大値を返す */
    public static function max3(int $a, int $b, int $c): int
    {
        $maximum = $a;
        if ($b > $maximum) {
            $maximum = $b;
        }
        if ($c > $maximum) {
            $maximum = $c;
        }
        return $maximum;
    }

    /** 3つの整数値の中央値を返す */
    public static function med3(int $a, int $b, int $c): int
    {
        if ($a >= $b) {
            if ($b >= $c) {
                return $b;
            } elseif ($a <= $c) {
                return $a;
            } else {
                return $c;
            }
        } elseif ($a > $c) {
            return $a;
        } elseif ($b > $c) {
            return $c;
        } else {
            return $b;
        }
    }

    /** 整数値の符号を判定する */
    public static function judgeSign(int $n): string
    {
        if ($n > 0) {
            return 'その値は正です。';
        } elseif ($n < 0) {
            return 'その値は負です。';
        } else {
            return 'その値は0です。';
        }
    }

    /** while ループで 1 から n までの総和を求める */
    public static function sum1ToNWhile(int $n): int
    {
        $total = 0;
        $i = 1;
        while ($i <= $n) {
            $total += $i;
            $i++;
        }
        return $total;
    }

    /** for ループで 1 から n までの総和を求める */
    public static function sum1ToNFor(int $n): int
    {
        $total = 0;
        for ($i = 1; $i <= $n; $i++) {
            $total += $i;
        }
        return $total;
    }

    /** 記号文字 '+' と '-' を交互に表示する（剰余判定方式） */
    public static function alternative1(int $n): string
    {
        $result = '';
        for ($i = 0; $i < $n; $i++) {
            $result .= ($i % 2 === 0) ? '+' : '-';
        }
        return $result;
    }

    /** 記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式） */
    public static function alternative2(int $n): string
    {
        $result = str_repeat('+-', intdiv($n, 2));
        if ($n % 2 !== 0) {
            $result .= '+';
        }
        return $result;
    }

    /** 縦横が整数で面積が area の長方形の辺の長さを列挙する */
    public static function rectangle(int $area): string
    {
        $result = '';
        for ($i = 1; $i * $i <= $area; $i++) {
            if ($area % $i === 0) {
                $result .= "{$i}x" . ($area / $i) . ' ';
            }
        }
        return $result;
    }

    /** 九九の表を返す */
    public static function multiplicationTable(): string
    {
        $result = str_repeat('-', 27) . "\n";
        for ($i = 1; $i <= 9; $i++) {
            for ($j = 1; $j <= 9; $j++) {
                $result .= sprintf('%3d', $i * $j);
            }
            $result .= "\n";
        }
        $result .= str_repeat('-', 27);
        return $result;
    }

    /** 左下側が直角の二等辺三角形を返す */
    public static function triangleLb(int $n): string
    {
        $result = '';
        for ($i = 1; $i <= $n; $i++) {
            $result .= str_repeat('*', $i) . "\n";
        }
        return $result;
    }
}
