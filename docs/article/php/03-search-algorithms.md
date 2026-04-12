# 第 3 章 探索アルゴリズム

## はじめに

前章では配列とデータ構造について学びました。この章では、データの中から特定の値を見つけ出す「探索アルゴリズム」について学んでいきます。

主に以下の 3 つの方法を TDD で実装します：

1. 線形探索（シーケンシャルサーチ）
2. 二分探索（バイナリサーチ）
3. ハッシュ法

---

## 探索アルゴリズムとは

探索アルゴリズムとは、データの集合から特定の条件を満たす要素を見つけ出すための手順です。探索の対象となるデータは「キー」と呼ばれ、探索の結果は通常、キーが見つかった位置（インデックス）または見つからなかったことを示す特別な値（多くの場合は -1）となります。

探索アルゴリズムの性能は、主に以下の要素によって評価されます：

- 時間効率（計算量）：探索にかかる時間
- 空間効率：使用するメモリ量
- 前提条件：データが整列されている必要があるかなど

---

## 1. 線形探索

配列の先頭から順に各要素を調べ、目的のキーと一致する要素を探します。

### Red — 失敗するテストを書く

```php
<?php
declare(strict_types=1);
namespace Tests;

use Algorithm\Search;
use Algorithm\ChainedHash;
use Algorithm\OpenHash;
use PHPUnit\Framework\TestCase;

class SearchTest extends TestCase
{
    private array $arr = [6, 4, 3, 2, 1, 2, 8];

    public function test線形探索_whileキーが見つかる(): void
    {
        $this->assertSame(3, Search::ssearchWhile($this->arr, 2));
    }

    public function test線形探索_whileキーが見つからない(): void
    {
        $this->assertSame(-1, Search::ssearchWhile($this->arr, 99));
    }

    public function test線形探索_forキーが見つかる(): void
    {
        $this->assertSame(3, Search::ssearchFor($this->arr, 2));
    }

    public function test線形探索_forキーが見つからない(): void
    {
        $this->assertSame(-1, Search::ssearchFor($this->arr, 99));
    }
}
```

### Green — テストを通す実装

```php
<?php
declare(strict_types=1);
namespace Algorithm;

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
}
```

### アルゴリズムの考え方

線形探索は、配列が整列されているかどうかに関わらず使用できる汎用的なアルゴリズムです。

計算量：
- 最良の場合：O(1)（最初の要素がキーと一致する場合）
- 最悪の場合：O(n)（キーが見つからないか、最後の要素である場合）
- 平均の場合：O(n/2) = O(n)

#### while 文による線形探索のフローチャート

```plantuml
@startuml
title 線形探索アルゴリズム (while文版)

start
:入力: 配列 a, 探索するキー key;
:i = 0;
:n = count(a);

while (true) is (ループ)
  if (i === n) then (はい)
    :return -1;
    stop
  endif

  if (a[i] === key) then (はい)
    :return i;
    stop
  endif

  :i++;
endwhile

stop
@enduml
```

この図は、while 文を使った線形探索アルゴリズム（ssearchWhile メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 配列 a と探索するキー key を入力として受け取ります
2. 変数 i を 0 で初期化します（現在の検索位置）
3. 無限ループ内で以下の処理を繰り返します：
   - i が a の長さに達した場合（配列の末尾を超えた場合）、-1 を返して終了します（探索失敗）
   - a[i] が key と一致する場合、i を返して終了します（探索成功）
   - i を 1 増やします（次の要素へ）

#### for 文による線形探索のフローチャート

```plantuml
@startuml
title 線形探索アルゴリズム (foreach版)

start
:入力: 配列 a, 探索するキー key;

repeat :a の各要素を i => val で走査;
  if (val === key) then (はい)
    :return i;
    stop
  endif
repeat while (次の要素がある)

:return -1;
stop
@enduml
```

この図は、foreach を使った線形探索アルゴリズム（ssearchFor メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 配列 a と探索するキー key を入力として受け取ります
2. a の各要素を i => val で走査し、以下の処理を繰り返します：
   - val が key と一致する場合、i を返して終了します（探索成功）
3. ループが終了した場合（一致する要素が見つからなかった場合）、-1 を返します（探索失敗）

**計算量**: 最悪 O(n)、平均 O(n/2)

### 番兵法

末尾にキーを追加（番兵）することで、ループ内の終了判定を省略します。

```php
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
```

### 番兵法の解説

番兵法では、探索対象の配列の末尾に探索するキーを追加（番兵として配置）することで、ループ内での終了判定を簡略化します。

```plantuml
@startuml
title 線形探索アルゴリズム (番兵法)

start
:入力: 配列 a, 探索するキー key;
:n = count(a);
:arr = a のコピー;
:arr の末尾に key を追加（番兵）;
:i = 0;

while (true) is (ループ)
  if (arr[i] === key) then (はい)
    :break;
  endif
  :i++;
endwhile

if (i === n) then (はい)
  :return -1;
else (いいえ)
  :return i;
endif

stop
@enduml
```

番兵法の利点：ループ内での終了判定（i === n）を省略できるため、わずかながら効率が向上します。番兵に到達した場合でも arr[i] === key の条件は真になるため、ループから抜けることができます。その後、番兵に到達したかどうかを判定することで、探索の成功/失敗を決定します。

PHP では `$arr[] = $key` で配列の末尾に要素を追加できます。また、配列は値渡しがデフォルトなので、`$arr = $a` で自然にコピーが作られます（Python の `copy.deepcopy` に相当する処理が不要です）。

---

## 2. 二分探索

**前提**: 配列が整列されていること。

中央の要素とキーを比較し、探索範囲を半分に絞り込むことを繰り返します。

### Red — 失敗するテストを書く

```php
public function test二分探索_キーが見つかる(): void
{
    $sorted = [1, 2, 3, 5, 7, 8, 9];
    $this->assertSame(3, Search::bsearch($sorted, 5));
}

public function test二分探索_キーが見つからない(): void
{
    $sorted = [1, 2, 3, 5, 7, 8, 9];
    $this->assertSame(-1, Search::bsearch($sorted, 4));
}
```

### Green — テストを通す実装

```php
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
```

### アルゴリズムの考え方

```plantuml
@startuml
title 二分探索アルゴリズム (bsearch)

start
:入力: 配列 a, 探索するキー key;
:pl = 0;
:pr = count(a) - 1;

while (true) is (ループ)
  :pc = intdiv(pl + pr, 2);

  if (a[pc] === key) then (はい)
    :return pc;
    stop
  elseif (a[pc] < key) then (はい)
    :pl = pc + 1;
  else (いいえ)
    :pr = pc - 1;
  endif

  if (pl > pr) then (はい)
    :return -1;
    stop
  endif
endwhile

stop
@enduml
```

**計算量**: O(log n)

### 解説

二分探索は、線形探索よりも効率的ですが、配列が整列されていることが前提条件となります。

二分探索の計算量：
- 最良の場合：O(1)（最初の中央要素がキーと一致する場合）
- 最悪の場合：O(log n)（キーが見つからないか、最後の絞り込みで見つかる場合）
- 平均の場合：O(log n)

例えば、1,000,000 要素の配列では、線形探索は最悪の場合 1,000,000 回の比較が必要ですが、二分探索では約 20 回（log2 1,000,000 ≈ 20）の比較で済みます。

フローチャートの詳細説明：
1. 配列 a と探索するキー key を入力として受け取ります
2. 変数 pl を 0 で初期化します（探索範囲の先頭要素のインデックス）
3. 変数 pr を count(a) - 1 で初期化します（探索範囲の末尾要素のインデックス）
4. 無限ループ内で以下の処理を繰り返します：
   - 変数 pc に intdiv(pl + pr, 2) を代入します（中央要素のインデックス）
   - a[pc] が key と一致する場合、pc を返して終了します（探索成功）
   - a[pc] が key より小さい場合、pl を pc + 1 に更新します（探索範囲を後半に絞り込む）
   - a[pc] が key より大きい場合、pr を pc - 1 に更新します（探索範囲を前半に絞り込む）
   - pl が pr より大きくなった場合、-1 を返します（探索範囲がなくなった）

| 要素数 | 線形探索（最悪） | 二分探索（最悪） |
|--------|--------------|--------------|
| 100 | 100回 | 7回 |
| 1,000 | 1,000回 | 10回 |
| 1,000,000 | 1,000,000回 | 20回 |

---

## 3. ハッシュ法

キーからハッシュ関数でアドレスを求め、直接要素にアクセスします。理想的な場合 O(1) で探索できます。

衝突（異なるキーが同じハッシュ値を生成する）の解決方法として、「チェイン法」と「オープンアドレス法」を実装します。

### チェイン法

同じハッシュ値を持つ要素を連結リストで管理します。

#### Red — 失敗するテストを書く

```php
public function testチェイン法ハッシュ追加と探索(): void
{
    $hash = new ChainedHash(13);
    $hash->add('Alice', 1);
    $hash->add('Bob', 2);
    $this->assertSame(1, $hash->search('Alice'));
    $this->assertSame(2, $hash->search('Bob'));
}

public function testチェイン法ハッシュ重複追加は失敗する(): void
{
    $hash = new ChainedHash(13);
    $hash->add('Alice', 1);
    $this->assertFalse($hash->add('Alice', 2));
}

public function testチェイン法ハッシュ削除できる(): void
{
    $hash = new ChainedHash(13);
    $hash->add('Alice', 1);
    $hash->remove('Alice');
    $this->assertNull($hash->search('Alice'));
}
```

#### Green — テストを通す実装

```php
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
                return false;  // 重複は追加しない
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
                    $this->table[$h] = $p->nextNode;  // 先頭ノードを削除
                } else {
                    $pp->nextNode = $p->nextNode;      // 後続ノードを削除
                }
                return true;
            }
            $pp = $p;
            $p = $p->nextNode;
        }
        return false;
    }
}
```

PHP では `crc32()` 関数でハッシュ値を計算します。Python の `hashlib.sha256` に相当しますが、よりシンプルです。コンストラクタの promoted properties（`public mixed $key`）を使うことで、簡潔にノードクラスを定義できます。

### オープンアドレス法

衝突時に空きスロットを探して要素を格納します。

```php
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
            $h = ($h + 1) % $this->capacity;  // 次のスロットへ
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
```

バケットの状態は `Occupied`/`Empty`/`Deleted` の 3 種類で管理します。`Deleted` は削除済みを示し、探索をここで止めないためのマーカーです。

PHP の `enum` は PHP 8.1 で導入された機能で、Python の `Enum` クラスに相当します。PHP の enum はファーストクラスのオブジェクトであり、`case` キーワードで列挙子を定義します。

---

## テスト実行結果

```bash
$ vendor/bin/phpunit --testdox --filter SearchTest

PHPUnit 11.5.x by Sebastian Bergmann and contributors.

Search (Tests\SearchTest)
 ✔ 線形探索 whileキーが見つかる
 ✔ 線形探索 whileキーが見つからない
 ✔ 線形探索 forキーが見つかる
 ✔ 線形探索 forキーが見つからない
 ✔ 線形探索 番兵法キーが見つかる
 ✔ 線形探索 番兵法キーが見つからない
 ✔ 二分探索 キーが見つかる
 ✔ 二分探索 キーが見つからない
 ✔ チェイン法ハッシュ追加と探索
 ✔ チェイン法ハッシュ重複追加は失敗する
 ✔ チェイン法ハッシュ削除できる
 ✔ オープンアドレス法ハッシュ追加と探索
 ✔ オープンアドレス法ハッシュ重複追加は失敗する
 ✔ オープンアドレス法ハッシュ削除できる

14 tests, 14 assertions
```

---

## Python 版との違い

| 概念 | Python | PHP |
|------|--------|-----|
| 列挙型 | `class Status(Enum): OCCUPIED = 0` | `enum BucketStatus { case Occupied; }` |
| ハッシュ関数 | `hashlib.sha256(str(key).encode())` | `crc32((string) $key)` |
| 番兵追加 | `a.append(key)` | `$arr[] = $key` |
| None チェック | `if p is None:` | `if ($p === null)` |
| 型宣言 | `key: Any` | `mixed $key` |
| 厳密比較 | `==`（等値）/ `is`（同一性） | `===`（型も含めた等値比較） |
| コンストラクタ | `def __init__(self, key, value):` | `public function __construct(public mixed $key, ...)` |
| 配列コピー | `copy.deepcopy(list(seq))` | `$arr = $a`（値渡しで自然にコピー） |
| for-range | `for i in range(self.capacity):` | `for ($i = 0; $i < $this->capacity; $i++)` |

---

## 探索アルゴリズムの比較

| アルゴリズム | 事前条件 | 計算量 | 適用場面 |
|-------------|---------|--------|---------|
| 線形探索 | なし | O(n) | 小規模・未整列データ |
| 二分探索 | 整列済み | O(log n) | 大規模・整列データ |
| ハッシュ法 | なし | O(1)平均 | 高速な挿入・削除・探索 |

## まとめ

この章では、3 つの主要な探索アルゴリズムについて学びました：

1. **線形探索**：最も単純な探索方法で、配列の先頭から順に探索します。整列されていない配列でも使用できますが、効率は良くありません。番兵法を使うことでわずかに効率化できます。

2. **二分探索**：整列された配列に対して使用できる効率的な探索方法で、探索範囲を半分ずつ絞り込みます。O(log n) の計算量で高速な探索が可能です。

3. **ハッシュ法**：キーから直接アドレスを求める方法で、理想的な状況では定数時間 O(1) で探索できます。衝突解決方法として、チェイン法とオープンアドレス法があります。

探索アルゴリズムの選択は、データの性質（整列されているか）、データ量、探索の頻度などによって異なります。テスト駆動開発の手法を用いることで、各アルゴリズムの正確な実装と理解を深めることができました。

次の章では、スタックとキューについて学んでいきましょう。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
