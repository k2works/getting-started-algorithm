<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第7章 文字列処理
 */
class Strings
{
    /** BF 法（ブルートフォース文字列探索） */
    public static function bfMatch(string $text, string $pattern): int
    {
        $pt = strlen($pattern);
        if ($pt === 0) {
            return 0;
        }
        $tt = strlen($text);
        $pi = 0;
        $ti = 0;
        while ($ti <= $tt - $pt) {
            $match = true;
            for ($k = 0; $k < $pt; $k++) {
                if ($text[$ti + $k] !== $pattern[$k]) {
                    $match = false;
                    break;
                }
            }
            if ($match) {
                return $ti;
            }
            $ti++;
        }
        return -1;
    }

    /** KMP 法（Knuth-Morris-Pratt 文字列探索） */
    public static function kmpMatch(string $text, string $pattern): int
    {
        $pt = strlen($pattern);
        if ($pt === 0) {
            return 0;
        }
        $tt   = strlen($text);
        $skip = self::kmpSkipTable($pattern);
        $ti   = 0;
        $pi   = 0;
        while ($ti < $tt && $pi < $pt) {
            if ($text[$ti] === $pattern[$pi]) {
                $ti++;
                $pi++;
            } elseif ($pi === 0) {
                $ti++;
            } else {
                $pi = $skip[$pi - 1];
            }
        }
        return $pi === $pt ? $ti - $pt : -1;
    }

    /** @return int[] */
    private static function kmpSkipTable(string $pattern): array
    {
        $m    = strlen($pattern);
        $skip = array_fill(0, $m, 0);
        $k    = 0;
        for ($i = 1; $i < $m; $i++) {
            while ($k > 0 && $pattern[$k] !== $pattern[$i]) {
                $k = $skip[$k - 1];
            }
            if ($pattern[$k] === $pattern[$i]) {
                $k++;
            }
            $skip[$i] = $k;
        }
        return $skip;
    }

    /** BM 法（Boyer-Moore 文字列探索） */
    public static function bmMatch(string $text, string $pattern): int
    {
        $pt = strlen($pattern);
        if ($pt === 0) {
            return 0;
        }
        $tt   = strlen($text);
        $skip = [];
        for ($i = 0; $i < $pt; $i++) {
            $skip[$pattern[$i]] = $pt - $i - 1;
        }
        $ti = $pt - 1;
        while ($ti < $tt) {
            $pi = $pt - 1;
            $k  = $ti;
            while ($pi >= 0 && $text[$k] === $pattern[$pi]) {
                $pi--;
                $k--;
            }
            if ($pi < 0) {
                return $k + 1;
            }
            $c    = $text[$k];
            $ti  += $skip[$c] ?? $pt;
        }
        return -1;
    }

    /** 文字の出現回数を返す */
    public static function countChars(string $s): array
    {
        $result = [];
        for ($i = 0; $i < strlen($s); $i++) {
            $c = $s[$i];
            if (!isset($result[$c])) {
                $result[$c] = 0;
            }
            $result[$c]++;
        }
        return $result;
    }

    /** 文字列を逆順にする */
    public static function reverseString(string $s): string
    {
        return strrev($s);
    }

    /** 回文判定 */
    public static function isPalindrome(string $s): bool
    {
        return $s === strrev($s);
    }
}
