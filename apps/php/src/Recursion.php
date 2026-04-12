<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第5章 再帰アルゴリズム
 */
class Recursion
{
    /** 階乗 */
    public static function factorial(int $n): int
    {
        if ($n <= 0) {
            return 1;
        }
        return $n * self::factorial($n - 1);
    }

    /** ユークリッドの互除法（最大公約数） */
    public static function gcd(int $a, int $b): int
    {
        if ($b === 0) {
            return $a;
        }
        return self::gcd($b, $a % $b);
    }

    /** 1〜n の再帰的な和 */
    public static function recursiveSum(int $n): int
    {
        if ($n <= 0) {
            return 0;
        }
        return $n + self::recursiveSum($n - 1);
    }

    /**
     * ハノイの塔 — 円盤の移動手順を返す
     * @return array<array{0: string, 1: string}>
     */
    public static function hanoi(int $n, string $from, string $to, string $via): array
    {
        $moves = [];
        if ($n === 1) {
            $moves[] = [$from, $to];
            return $moves;
        }
        $moves = array_merge($moves, self::hanoi($n - 1, $from, $via, $to));
        $moves[] = [$from, $to];
        $moves = array_merge($moves, self::hanoi($n - 1, $via, $to, $from));
        return $moves;
    }

    /** 迷路探索（DFS）— 0 = 通路、1 = 壁 */
    public static function mazeSolve(array $maze, int $sr, int $sc, int $gr, int $gc): bool
    {
        $rows    = count($maze);
        $cols    = count($maze[0]);
        $visited = array_fill(0, $rows, array_fill(0, $cols, false));
        return self::mazeDfs($maze, $sr, $sc, $gr, $gc, $visited, $rows, $cols);
    }

    private static function mazeDfs(
        array $maze,
        int $r,
        int $c,
        int $gr,
        int $gc,
        array &$visited,
        int $rows,
        int $cols
    ): bool {
        if ($r < 0 || $r >= $rows || $c < 0 || $c >= $cols) {
            return false;
        }
        if ($maze[$r][$c] === 1) {
            return false;
        }
        if ($r === $gr && $c === $gc) {
            return true;
        }
        if ($visited[$r][$c]) {
            return false;
        }
        $visited[$r][$c] = true;
        foreach ([[0, 1], [0, -1], [1, 0], [-1, 0]] as [$dr, $dc]) {
            if (self::mazeDfs($maze, $r + $dr, $c + $dc, $gr, $gc, $visited, $rows, $cols)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 真に再帰的な関数 recure(n)
     * recure(n-1) → print n → recure(n-2)
     */
    public static function recure(int $n, array $log): array
    {
        if ($n > 0) {
            $log = self::recure($n - 1, $log);
            $log[] = $n;
            $log = self::recure($n - 2, $log);
        }
        return $log;
    }

    /** recure の非再帰版（明示的スタックによるシミュレーション） */
    public static function recure2(int $n, array $log): array
    {
        $stack = [['type' => 'call', 'n' => $n]];
        while (!empty($stack)) {
            $item = array_pop($stack);
            if ($item['type'] === 'call') {
                $v = $item['n'];
                if ($v > 0) {
                    $stack[] = ['type' => 'call',  'n' => $v - 2];
                    $stack[] = ['type' => 'print', 'n' => $v];
                    $stack[] = ['type' => 'call',  'n' => $v - 1];
                }
            } else {
                $log[] = $item['n'];
            }
        }
        return $log;
    }
}

// ---- 8クイーン問題（全組み合わせ） ----

/** カウントのみ保持する Countable ラッパー */
final class QueenCountable implements \Countable
{
    public function __construct(private int $n) {}

    public function count(): int
    {
        return $this->n;
    }
}

class EightQueen
{
    /** @var int[] */
    protected array $pos   = [];
    protected int   $count = 0;

    public function __construct()
    {
        $this->pos = array_fill(0, 8, 0);
    }

    public function set(int $i): void
    {
        if ($i === 8) {
            $this->count++;
            return;
        }
        for ($j = 0; $j < 8; $j++) {
            $this->pos[$i] = $j;
            $this->set($i + 1);
        }
    }

    public function getResult(): \Countable
    {
        return new QueenCountable($this->count);
    }
}

// ---- 8クイーン問題（列制約あり） ----

class EightQueen2 extends EightQueen
{
    /** @var bool[] */
    private array $placed;

    public function __construct()
    {
        parent::__construct();
        $this->placed = array_fill(0, 8, false);
    }

    public function set(int $i): void
    {
        if ($i === 8) {
            $this->count++;
            return;
        }
        for ($j = 0; $j < 8; $j++) {
            if (!$this->placed[$j]) {
                $this->pos[$i]    = $j;
                $this->placed[$j] = true;
                $this->set($i + 1);
                $this->placed[$j] = false;
            }
        }
    }
}

// ---- 8クイーン問題（完全） ----

class EightQueen3 extends EightQueen
{
    /** @var bool[] */
    private array $colPlaced;
    /** @var bool[] */
    private array $diagPlaced1;
    /** @var bool[] */
    private array $diagPlaced2;

    public function __construct()
    {
        parent::__construct();
        $this->colPlaced   = array_fill(0, 8, false);
        $this->diagPlaced1 = array_fill(0, 15, false);
        $this->diagPlaced2 = array_fill(0, 15, false);
    }

    public function set(int $i): void
    {
        if ($i === 8) {
            $this->count++;
            return;
        }
        for ($j = 0; $j < 8; $j++) {
            if (
                !$this->colPlaced[$j]
                && !$this->diagPlaced1[$i + $j]
                && !$this->diagPlaced2[$i - $j + 7]
            ) {
                $this->pos[$i]                  = $j;
                $this->colPlaced[$j]            = true;
                $this->diagPlaced1[$i + $j]     = true;
                $this->diagPlaced2[$i - $j + 7] = true;
                $this->set($i + 1);
                $this->colPlaced[$j]            = false;
                $this->diagPlaced1[$i + $j]     = false;
                $this->diagPlaced2[$i - $j + 7] = false;
            }
        }
    }
}
