# 第 7 章 文字列処理

## はじめに

前章ではソートアルゴリズムを学びました。この章では、プログラミングにおいて非常に重要な「文字列処理」について TDD で実装します。

文字列処理は、テキストデータの操作や解析に欠かせない技術です。特に、テキスト検索、パターンマッチング、データ抽出などの処理は、多くのアプリケーションで必要とされます。

この章では、まず PHP における基本的な文字列操作について学び、その後、テスト駆動開発の手法を用いて、効率的な文字列検索アルゴリズムを実装していきます。

### 目次

1. [PHP の文字列基本操作](#php-の文字列基本操作)
2. [ブルートフォース文字列探索（力まかせ法）](#1-ブルートフォース文字列探索)
3. [KMP 法](#2-kmp-法)
4. [Boyer-Moore 法](#3-boyer-moore-法)
5. [文字カウント・逆順・回文判定](#4-文字カウント逆順回文判定)

---

## PHP の文字列基本操作

PHP では、文字列はバイト列として扱われます。シングルクォートまたはダブルクォートで囲んで生成し、豊富な組み込み関数で操作できます。

### 文字列の生成と基本操作

```php
// 文字列の生成
$s1 = "Hello";
$s2 = 'World';
$s3 = <<<EOT
This is a
multiline string
EOT;

// 文字列の連結
$s = $s1 . " " . $s2;  // "Hello World"

// 文字列の繰り返し
$s = str_repeat($s1, 3);  // "HelloHelloHello"

// 文字列の長さ
$length = strlen($s1);  // 5

// 文字へのアクセス
$firstChar = $s1[0];   // "H"
$lastChar  = $s1[-1];  // "o"

// 部分文字列
$substring = substr($s1, 1, 3);  // "ell"
```

### 文字列の関数

PHP には多くの便利な文字列関数が用意されています：

```php
$s = "Hello, World!";

// 検索
$pos = strpos($s, "World");   // 7
$pos = strpos($s, "Python");  // false（見つからない場合）

// 置換
$newS = str_replace("World", "PHP", $s);  // "Hello, PHP!"

// 分割
$parts = explode(", ", $s);  // ["Hello", "World!"]

// 結合
$joined = implode(", ", ["Hello", "World"]);  // "Hello, World"

// 大文字・小文字変換
$upper = strtoupper($s);  // "HELLO, WORLD!"
$lower = strtolower($s);  // "hello, world!"

// 先頭・末尾の処理
$stripped = trim("  Hello  ");               // "Hello"
$starts   = str_starts_with($s, "Hello");    // true（PHP 8.0+）
$ends     = str_ends_with($s, "World!");     // true（PHP 8.0+）
```

### 文字列のフォーマット

PHP では、文字列のフォーマットにいくつかの方法があります：

```php
// sprintf
$name = "Alice";
$age  = 30;
$s = sprintf("Name: %s, Age: %d", $name, $age);  // "Name: Alice, Age: 30"

// ダブルクォート内の変数展開
$s = "Name: {$name}, Age: {$age}";  // "Name: Alice, Age: 30"

// ヒアドキュメント
$s = <<<EOT
Name: {$name}, Age: {$age}
EOT;
```

これらの基本的な文字列操作を理解した上で、より高度な文字列検索アルゴリズムを見ていきましょう。

---

## 1. ブルートフォース文字列探索

テキストを左から順にパターンと比較する最もシンプルな方法です。

### Red -- 失敗するテストを書く

```php
// tests/StringsTest.php
class StringsTest extends TestCase
{
    private string $text    = 'ABCXDEZCABACABAB';
    private string $pattern = 'ABAB';

    public function testBF法パターンが見つかる(): void
    {
        $this->assertSame(12, Strings::bfMatch($this->text, $this->pattern));
    }

    public function testBF法パターンが見つからない(): void
    {
        $this->assertSame(-1, Strings::bfMatch('AAAA', 'BB'));
    }

    public function testBF法空パターンは位置0を返す(): void
    {
        $this->assertSame(0, Strings::bfMatch('hello', ''));
    }
}
```

### Green -- テストを通す実装

```php
// src/Strings.php
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
}
```

### 解説

力まかせ法（ブルートフォース法）のアルゴリズムは以下の通りです：

1. テキスト内の各位置から順にパターンとの一致を調べる
2. 一致しない文字が見つかったら、テキストのカーソルを 1 つ進めて再度パターンの先頭から比較を始める
3. パターン全体が一致したら、その位置を返す

**計算量**:
- 最良の場合：O(m)（m はパターンの長さ）
- 最悪の場合：O(n x m)（n はテキストの長さ）
- 平均の場合：O(n x m)

力まかせ法は単純で理解しやすいですが、テキストとパターンが長い場合には効率が悪くなります。そこで、より効率的なアルゴリズムが開発されました。

### フローチャート

```plantuml
@startuml
title 力まかせ法による文字列検索 (bfMatch)

start
:入力: テキスト $text, パターン $pattern;
:$pt = 0; // $text をなぞるカーソル
:$pp = 0; // $pattern をなぞるカーソル

while ($pt < strlen($text) && $pp < strlen($pattern)) is (ループ継続)
  if ($text[$pt] === $pattern[$pp]) then (はい)
    :$pt++;
    :$pp++;
  else (いいえ)
    :$pt = $pt - $pp + 1;
    :$pp = 0;
  endif
endwhile (ループ終了)

if ($pp === strlen($pattern)) then (はい)
  :return $pt - $pp;
else (いいえ)
  :return -1;
endif

stop
@enduml
```

アルゴリズムの流れ：
1. テキスト $text とパターン $pattern を入力として受け取ります
2. 変数 $pt を 0 で初期化します（$text をなぞるカーソル）
3. 変数 $pp を 0 で初期化します（$pattern をなぞるカーソル）
4. $pt が $text の長さ未満かつ $pp が $pattern の長さ未満である間、以下の処理を繰り返します：
   - $text[$pt] と $pattern[$pp] が一致する場合：両方のカーソルを進めます
   - 一致しない場合：$pt を $pt - $pp + 1 に更新し（次の比較開始位置）、$pp を 0 にリセットします
5. ループ終了後、$pp が $pattern の長さと等しい場合：$pt - $pp を返します（パターンが見つかった位置）
6. それ以外の場合：-1 を返します

---

## 2. KMP 法

KMP 法（Knuth-Morris-Pratt 法）は、力まかせ法を改良した効率的な文字列検索アルゴリズムです。失敗関数テーブル（スキップテーブル）を使い、不一致が発生した際にスキップ量を最適化します。パターン内の情報を利用して、不要な比較を省略します。

### Red -- 失敗するテストを書く

```php
public function testKMP法パターンが見つかる(): void
{
    $this->assertSame(12, Strings::kmpMatch($this->text, $this->pattern));
}

public function testKMP法パターンが見つからない(): void
{
    $this->assertSame(-1, Strings::kmpMatch('AAAA', 'BB'));
}
```

### Green -- テストを通す実装

```php
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
```

### 解説

KMP 法の核心は、パターン内の情報を利用して「スキップテーブル」を作成し、不一致が発生した場合に効率的にカーソルを移動させることです。

スキップテーブルは、パターン内の部分文字列が一致する場合に、どこまで戻ればよいかを示します。これにより、すでに比較した文字を再度比較する必要がなくなります。

**計算量**:
- 最良の場合：O(m)（m はパターンの長さ）
- 最悪の場合：O(n + m)（n はテキストの長さ）
- 平均の場合：O(n + m)

KMP 法は、力まかせ法よりも効率的ですが、スキップテーブルの作成と理解が複雑です。

### フローチャート

KMP 法は 2 つの主要なステップから成ります：スキップテーブルの作成と実際の検索です。

#### スキップテーブルの作成

```plantuml
@startuml
title KMP 法 - スキップテーブルの作成

start
:入力: パターン $pattern;
:$pt = 1; // $pattern をなぞるカーソル
:$pp = 0; // $pattern をなぞる別のカーソル
:$skip[strlen($pattern) + 1] = 0 の配列;
:$skip[$pt] = 0;

while ($pt < strlen($pattern)) is (ループ継続)
  if ($pattern[$pt] === $pattern[$pp]) then (はい)
    :$pt++;
    :$pp++;
    :$skip[$pt] = $pp;
  elseif ($pp === 0) then (はい)
    :$pt++;
    :$skip[$pt] = $pp;
  else (いいえ)
    :$pp = $skip[$pp];
  endif
endwhile (ループ終了)

:スキップテーブル $skip を返す;
stop
@enduml
```

#### 検索処理

```plantuml
@startuml
title KMP 法 - 検索処理

start
:入力: テキスト $text, パターン $pattern, スキップテーブル $skip;
:$pt = 0; // $text をなぞるカーソル
:$pp = 0; // $pattern をなぞるカーソル

while ($pt < strlen($text) && $pp < strlen($pattern)) is (ループ継続)
  if ($text[$pt] === $pattern[$pp]) then (はい)
    :$pt++;
    :$pp++;
  elseif ($pp === 0) then (はい)
    :$pt++;
  else (いいえ)
    :$pp = $skip[$pp];
  endif
endwhile (ループ終了)

if ($pp === strlen($pattern)) then (はい)
  :return $pt - $pp;
else (いいえ)
  :return -1;
endif

stop
@enduml
```

アルゴリズムの流れ：

1. **スキップテーブルの作成**:
   - パターン内の部分文字列が一致する場合に、どこまで戻ればよいかを示すテーブルを作成します
   - パターン自身を使って、パターン内の接頭辞と接尾辞の一致を調べます
   - 一致する最長の接頭辞の長さをスキップテーブルに格納します

2. **検索処理**:
   - テキストとパターンを先頭から比較していきます
   - 文字が一致する場合は、両方のカーソルを進めます
   - 不一致が発生した場合：
     - パターンのカーソルが先頭（$pp = 0）なら、テキストのカーソルだけを進めます
     - それ以外の場合は、スキップテーブルを使ってパターンのカーソルを効率的に移動させます
   - パターン全体が一致したら、その位置を返します

KMP 法の大きな利点は、不一致が発生した場合でも、すでに比較した情報を活用してパターンのカーソルを効率的に移動させることです。時間計算量は O(n + m) となり、テキストとパターンが長い場合に特に効果的です。

---

## 3. Boyer-Moore 法

Boyer-Moore 法は、さらに効率的な文字列検索アルゴリズムです。パターンを右から左へ比較し、不一致が発生した場合に大きくスキップすることで、多くの比較を省略します。

### Red -- 失敗するテストを書く

```php
public function testBM法パターンが見つかる(): void
{
    $this->assertSame(12, Strings::bmMatch($this->text, $this->pattern));
}

public function testBM法パターンが見つからない(): void
{
    $this->assertSame(-1, Strings::bmMatch('AAAA', 'BB'));
}
```

### Green -- テストを通す実装

```php
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
```

### 解説

Boyer-Moore 法の特徴は以下の通りです：

1. パターンを右から左へ比較する
2. 不一致が発生した場合、以下の 2 つのルールに基づいてスキップする：
   - 不一致文字ルール：テキスト内の不一致文字がパターン内に存在するかどうかに基づいてスキップ
   - 一致接尾辞ルール：パターン内の部分文字列の一致に基づいてスキップ

**計算量**:
- 最良の場合：O(n / m)（n はテキストの長さ、m はパターンの長さ）
- 最悪の場合：O(n x m)
- 平均の場合：O(n)

Boyer-Moore 法は、実用的な文字列検索アルゴリズムとして広く使用されています。特に、パターンが長い場合や、アルファベットの種類が多い場合に効率的です。

### フローチャート

Boyer-Moore 法も 2 つの主要なステップから成ります：スキップテーブルの作成と実際の検索です。

#### スキップテーブルの作成

```plantuml
@startuml
title Boyer-Moore 法 - スキップテーブルの作成

start
:入力: パターン $pattern;
:$skip = 連想配列;

repeat :$i = 0 から strlen($pattern)-1 まで;
  :$skip[$pattern[$i]] = strlen($pattern) - $i - 1;
repeat while ($i < strlen($pattern)-1)

:スキップテーブル $skip を返す;
stop
@enduml
```

#### 検索処理

```plantuml
@startuml
title Boyer-Moore 法 - 検索処理

start
:入力: テキスト $text, パターン $pattern, スキップテーブル $skip;
:$pt = strlen($pattern) - 1; // $text をなぞるカーソル

while ($pt < strlen($text)) is (ループ継続)
  :$pp = strlen($pattern) - 1; // $pattern をなぞるカーソル

  while ($text[$pt] === $pattern[$pp]) is (一致)
    if ($pp === 0) then (はい)
      :return $pt;
      stop
    end
    :$pt--;
    :$pp--;
  end
  while (不一致)

  :$pt += max($skip[$text[$pt]] ?? strlen($pattern), strlen($pattern) - $pp);
endwhile (ループ終了)

:return -1;
stop
@enduml
```

アルゴリズムの流れ：

1. **スキップテーブルの作成**:
   - 各文字について、パターン内での最後の出現位置に基づいてスキップ量を決定します
   - PHP では連想配列を使い、パターンに出現する文字のみをキーとして格納します
   - パターンに出現しない文字は `??`（Null 合体演算子）でデフォルト値を返します

2. **検索処理**:
   - パターンを右から左へ比較します（パターンの末尾から開始）
   - 文字が一致する限り、両方のカーソルを左に移動します
   - パターン全体が一致したら（$pp = 0 になったら）、その位置を返します
   - 不一致が発生した場合：
     - 不一致文字がパターン内にある場合、その位置に基づいてスキップします
     - パターン内にない場合、パターン全体をスキップします

Boyer-Moore 法の大きな特徴は、パターンを右から左へ比較することと、不一致が発生した場合に大きくスキップできることです。理想的な状況では、テキストの文字の多くを比較せずに済むため、非常に効率的です。最良の場合、O(n/m) という驚異的な時間計算量を達成できます。

---

## 4. 文字カウント・逆順・回文判定

```php
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
```

---

## テスト実行結果

```bash
$ ./vendor/bin/phpunit tests/StringsTest.php

...（13 テスト全パス）...

OK (13 tests, 13 assertions)
```

---

## 文字列探索アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| ブルートフォース | O(n x m) | シンプル、小規模に有効 |
| KMP 法 | O(n + m) | 最悪でも線形、前処理が必要 |
| Boyer-Moore 法 | O(n / m) 平均 | 大規模テキストで最速 |

## Python 版との違い

| 概念 | Python | PHP |
|------|--------|-----|
| 文字列逆順 | `s[::-1]` | `strrev($s)` |
| 文字アクセス | `s[i]` | `$s[$i]` |
| 文字カウント | `Counter(s)` / `dict` | 連想配列 + 手動カウント |
| 文字列長 | `len(s)` | `strlen($s)` |
| 文字列検索 | `s.find("x")` | `strpos($s, "x")` |
| 文字列置換 | `s.replace(a, b)` | `str_replace($a, $b, $s)` |
| 文字列分割 | `s.split(sep)` | `explode($sep, $s)` |
| 文字列結合 | `sep.join(lst)` | `implode($sep, $arr)` |
| フォーマット | `f"Name: {name}"` | `"Name: {$name}"` / `sprintf()` |
| 不変性 | 文字列は不変（immutable） | 文字列は可変（mutable） |
| スキップテーブル (BM) | `dict` + `dict.get(key, default)` | 連想配列 + `??`（Null 合体演算子） |

## まとめ

この章では、PHP における文字列処理について学びました：

1. **基本的な文字列操作** -- 文字列の生成、連結、`substr`、組み込み関数など
2. **文字列検索アルゴリズム**：
   - 力まかせ法（ブルートフォース法） -- 最も単純な方法
   - KMP 法 -- パターン内の情報を利用して効率化
   - Boyer-Moore 法 -- 右から左への比較と大きなスキップで効率化

文字列処理は、テキストデータを扱う多くのアプリケーションで重要な役割を果たします。効率的な文字列検索アルゴリズムを理解することで、大量のテキストデータを効率的に処理することができます。

テスト駆動開発の手法を用いることで、これらの複雑な文字列検索アルゴリズムの正確な実装と理解を深めることができました。

次の章では、リストについて学んでいきましょう。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
