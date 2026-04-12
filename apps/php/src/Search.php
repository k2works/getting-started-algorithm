<?php

declare(strict_types=1);

namespace Algorithm;

/**
 * 第3章 探索アルゴリズム
 */
class Search
{
    /** 配列 $a から $key と等価な要素を線形探索（while 文） */
    public static function ssearchWhile(array $a, mixed $key): int
    {
        $i = 0;
        $n = count($a);
        while (true) {
            if ($i === $n) {
                return -1;
            }
            if ($a[$i] === $key) {
                return $i;
            }
            $i++;
        }
    }

    /** 配列 $a から $key と等価な要素を線形探索（for 文） */
    public static function ssearchFor(array $a, mixed $key): int
    {
        foreach ($a as $i => $val) {
            if ($val === $key) {
                return $i;
            }
        }
        return -1;
    }

    /** 配列 $a から $key と一致する要素を線形探索（番兵法） */
    public static function ssearchSentinel(array $a, mixed $key): int
    {
        $n = count($a);
        $arr = $a;
        $arr[] = $key; // 番兵を追加
        $i = 0;
        while ($arr[$i] !== $key) {
            $i++;
        }
        return $i === $n ? -1 : $i;
    }

    /** 配列 $a から $key と一致する要素を二分探索（昇順配列前提） */
    public static function bsearch(array $a, mixed $key): int
    {
        $pl = 0;
        $pr = count($a) - 1;
        while (true) {
            $pc = intdiv($pl + $pr, 2);
            if ($a[$pc] === $key) {
                return $pc;
            } elseif ($a[$pc] < $key) {
                $pl = $pc + 1;
            } else {
                $pr = $pc - 1;
            }
            if ($pl > $pr) {
                return -1;
            }
        }
    }
}

// ---- チェイン法ハッシュ ----

class ChainNode
{
    public function __construct(
        public mixed $key,
        public mixed $value,
        public ?ChainNode $nextNode = null,
    ) {}
}

class ChainedHash
{
    private array $table;

    public function __construct(private int $capacity)
    {
        $this->table = array_fill(0, $capacity, null);
    }

    private function hashValue(mixed $key): int
    {
        if (is_int($key)) {
            return $key % $this->capacity;
        }
        return abs(crc32((string) $key)) % $this->capacity;
    }

    public function search(mixed $key): mixed
    {
        $h = $this->hashValue($key);
        $p = $this->table[$h];
        while ($p !== null) {
            if ($p->key === $key) {
                return $p->value;
            }
            $p = $p->nextNode;
        }
        return null;
    }

    public function add(mixed $key, mixed $value): bool
    {
        $h = $this->hashValue($key);
        $p = $this->table[$h];
        while ($p !== null) {
            if ($p->key === $key) {
                return false;
            }
            $p = $p->nextNode;
        }
        $this->table[$h] = new ChainNode($key, $value, $this->table[$h]);
        return true;
    }

    public function remove(mixed $key): bool
    {
        $h = $this->hashValue($key);
        $p = $this->table[$h];
        $pp = null;
        while ($p !== null) {
            if ($p->key === $key) {
                if ($pp === null) {
                    $this->table[$h] = $p->nextNode;
                } else {
                    $pp->nextNode = $p->nextNode;
                }
                return true;
            }
            $pp = $p;
            $p = $p->nextNode;
        }
        return false;
    }
}

// ---- オープンアドレス法ハッシュ ----

enum BucketStatus
{
    case Occupied;
    case Empty;
    case Deleted;
}

class Bucket
{
    public function __construct(
        public mixed $key = null,
        public mixed $value = null,
        public BucketStatus $stat = BucketStatus::Empty,
    ) {}
}

class OpenHash
{
    /** @var Bucket[] */
    private array $table;

    public function __construct(private int $capacity)
    {
        $this->table = [];
        for ($i = 0; $i < $capacity; $i++) {
            $this->table[$i] = new Bucket();
        }
    }

    private function hashValue(mixed $key): int
    {
        if (is_int($key)) {
            return $key % $this->capacity;
        }
        return abs(crc32((string) $key)) % $this->capacity;
    }

    public function search(mixed $key): mixed
    {
        $h = $this->hashValue($key);
        for ($i = 0; $i < $this->capacity; $i++) {
            $p = $this->table[$h];
            if ($p->stat === BucketStatus::Empty) {
                return null;
            }
            if ($p->stat === BucketStatus::Occupied && $p->key === $key) {
                return $p->value;
            }
            $h = ($h + 1) % $this->capacity;
        }
        return null;
    }

    public function add(mixed $key, mixed $value): bool
    {
        if ($this->search($key) !== null) {
            return false;
        }
        $h = $this->hashValue($key);
        for ($i = 0; $i < $this->capacity; $i++) {
            $p = $this->table[$h];
            if ($p->stat === BucketStatus::Empty || $p->stat === BucketStatus::Deleted) {
                $this->table[$h] = new Bucket($key, $value, BucketStatus::Occupied);
                return true;
            }
            $h = ($h + 1) % $this->capacity;
        }
        return false;
    }

    public function remove(mixed $key): bool
    {
        $h = $this->hashValue($key);
        for ($i = 0; $i < $this->capacity; $i++) {
            $p = $this->table[$h];
            if ($p->stat === BucketStatus::Empty) {
                return false;
            }
            if ($p->stat === BucketStatus::Occupied && $p->key === $key) {
                $p->stat = BucketStatus::Deleted;
                return true;
            }
            $h = ($h + 1) % $this->capacity;
        }
        return false;
    }
}
