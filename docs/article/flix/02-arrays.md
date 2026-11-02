# 第 2 章 配列

## 2.1 はじめに

第 1 章では、整数やリストを使った基本的なアルゴリズムを実装しました。この章では、同じ型の値を連続して扱う配列を使い、走査、要素の交換、基数変換、素数の列挙を学びます。

Flix の `Array[a, r]` は要素型 `a` とメモリ領域 `r` を持つ可変配列です。配列を作成して使う処理は `region rc { ... }` の中に置き、`Array.get` と `Array.put` で要素を読み書きします。配列を変更する関数の型には、変更が属する領域の効果 `\ r` が現れます。領域の外へ配列を返さず、結果だけを取り出せば、呼び出し側には一時的な可変状態を隠せます。

この章で扱う数値処理は、結果を返す純粋関数として実装します。配列を直接変更する反転だけは、その破壊的変更をテストで確認します。

### この章の TODO リスト

- [x] 配列の最大値を求める
- [x] 配列の要素をその場で反転する
- [x] 整数を基数変換する
- [x] 素朴な試し割りで素数を列挙する
- [x] 既知の素数を使って試し割りを改善する
- [x] 平方根以下の素数だけで試し割りする

## 2.2 準備

Flix の Nix 開発シェルを起動し、JAR がまだない場合は `flix.toml` のバージョンに合わせて取得します。

```bash
nix develop path:.#flix
cd apps/flix

version="$(sed -n 's/^flix[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' flix.toml)"
if [ ! -f flix.jar ]; then
  curl -fL --retry 2 \
    -o flix.jar \
    "https://github.com/flix/flix/releases/download/v${version}/flix.jar"
fi

make test
```

`flix.jar` は Git の追跡対象外です。詳しい手順は [Flix 環境セットアップ手順書](../../operation/Flix開発環境セットアップ手順書.md) を参照してください。

この章のテストと実装は、それぞれ `test/TestArrays.flix` と `src/Arrays.flix` に置きます。コードの前にテストを書き、`make test` を実行してコンパイルエラーやアサーション失敗を確認します。

## 2.3 Flix の配列

Flix の配列は、作成時に要素型と領域が決まります。リストから配列を作る場合は `List.toArray` を使います。

```flix
region rc {
    let values = List.toArray(rc, 11 :: 22 :: 33 :: Nil);
    Array.put(99, 1, values);
    Array.toList(values)
}
```

`Array.put` は配列の 1 番目の位置を変更し、結果は `[11, 99, 33]` です。インデックスは 0 から始まります。配列は可変ですが、`List` は不変です。入力の変更が仕様かどうかを関数の型とテストで明示します。

## 2.4 配列の最大値

空配列には最大値がありません。そこで、結果を `Option[Int32]` とし、空配列なら `None`、それ以外なら `Some(maximum)` を返します。

### Red — 通常値と境界値を書く

`test/TestArrays.flix` にテストを追加します。

```flix
@Test
def maxOf_returns_largest_value(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 172 :: 153 :: 192 :: 140 :: 165 :: Nil);
        Assert.assertEq(expected = Some(192), Arrays.maxOf(values))
    }

@Test
def maxOf_empty_array(): Unit \ Assert =
    region rc {
        let values = Array.repeat(rc, 0, 0);
        Assert.assertEq(expected = None, Arrays.maxOf(values))
    }

@Test
def maxOf_negative_values(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, -8 :: -3 :: -12 :: Nil);
        Assert.assertEq(expected = Some(-3), Arrays.maxOf(values))
    }
```

まだ `Arrays.maxOf` がないため、テストはコンパイル時に失敗します。空配列のテストは、空入力の結果を `None` とする契約も示します。

### Green — 先頭を暫定最大値にする

`src/Arrays.flix` に実装します。

```flix
pub def maxOf(values: Array[Int32, r]): Option[Int32] \ r =
    let length = Array.length(values);
    def loop(i, maximum) =
        if (i >= length)
            maximum
        else {
            let value = Array.get(i, values);
            loop(i + 1, if (value > maximum) value else maximum)
        };
    if (length == 0) {
        None
    } else {
        Some(loop(1, Array.get(0, values)))
    }
```

最初の要素を暫定最大値にし、残りを左から順に比較します。`maximum` は「処理済みの範囲にある最大値」というループ不変条件を保ちます。全要素を 1 回ずつ見るため、時間計算量は O(n)、追加領域は O(1) です。ループを末尾再帰で表現しており、Flix の末尾呼び出し除去により呼び出しスタックも増えません。空配列を先に判定してから `Array.get(0, values)` を呼ぶため、範囲外アクセスも避けられます。

## 2.5 配列の要素を反転する

配列の両端の要素を交換し、内側へ進めると、配列全体を逆順にできます。この操作は入力配列を書き換えるため、関数の戻り値ではなく呼び出し後の配列を検証します。

### Red — 反転後の配列を確認する

```flix
@Test
def reverseArray_reverses_values_in_place(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 2 :: 5 :: 1 :: 3 :: 9 :: 6 :: 7 :: Nil);
        Arrays.reverseArray(values);
        Assert.assertEq(
            expected = 7 :: 6 :: 9 :: 3 :: 1 :: 5 :: 2 :: Nil,
            Array.toList(values)
        )
    }
```

### Green — 左右の要素を交換する

```flix
pub def reverseArray(values: Array[a, r]): Unit \ r =
    let last = Array.length(values) - 1;
    def loop(left, right) =
        if (left >= right) {
            ()
        } else {
            let leftValue = Array.get(left, values);
            let rightValue = Array.get(right, values);
            Array.put(rightValue, left, values);
            Array.put(leftValue, right, values);
            loop(left + 1, right - 1)
        };
    loop(0, last)
```

配列の要素数を n とすると、交換回数は `floor(n / 2)` 回です。時間計算量は O(n)、追加領域は O(1) です。奇数個なら中央の要素は交換せず、空配列や 1 要素配列ではループ本体に入りません。関数の型 `Unit \ r` は配列領域に属する変更を表しています。

## 2.6 基数変換

10 進数の整数を 2 進数、8 進数、16 進数などに変換します。基数 r で x を割った余りが最下位桁になり、商をさらに r で割る操作を繰り返します。余りは下位桁から得られるため、結果の先頭に追加していくと、最終的に上位桁から並んだリストになります。

この実装では、負数と 2〜36 の範囲外の基数を受け付けず `None` を返します。0 はどの基数でも `"0"` です。10 以上の桁には `A`〜`Z` を使います。

### Red — 入力と桁をテストする

```flix
@Test
def cardConv_binary(): Unit \ Assert =
    Assert.assertEq(expected = Some("11101"), Arrays.cardConv(29, 2))

@Test
def cardConv_hexadecimal(): Unit \ Assert =
    Assert.assertEq(expected = Some("FF"), Arrays.cardConv(255, 16))

@Test
def cardConv_zero(): Unit \ Assert =
    Assert.assertEq(expected = Some("0"), Arrays.cardConv(0, 2))

@Test
def cardConv_invalid_base(): Unit \ Assert =
    Assert.assertEq(expected = None, Arrays.cardConv(10, 1))
```

8 進数の `Arrays.cardConv(29, 8)` は `Some("35")` になります。さらに負の値と最大基数 36 もテストし、`Some("Z")` を確認します。

### Green — 余りを桁へ変換する

```flix
pub def cardConv(value: Int32, base: Int32): Option[String] =
    def digits(n, acc) =
        if (n == 0)
            acc
        else
            digits(n / base, (n `Int32.remainder` base) :: acc);

    if (value < 0 or base < 2 or base > 36) {
        None
    } else if (value == 0) {
        Some("0")
    } else {
        Some(digitsToString(digits(value, Nil)))
    }

def digitsToString(digits: List[Int32]): String = region rc {
    let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let digitArray = List.toArray(rc, digits);
    String.init(i -> String.get(Array.get(i, digitArray), alphabet), List.length(digits))
}
```

`digits` は商が 0 になるまで再帰し、余りを先頭に積みます。最後に `digitsToString` が各桁をアルファベットから選び、文字列にします。桁数を k とすると、変換は O(k)、文字列生成も O(k) です。`Int32` の範囲では k は最大でも 32 程度です。

## 2.7 素数の列挙

素数かどうかを調べる素朴な試し割りから始め、既知の素数を使い、最後に平方根を利用します。各関数は 1000 以下の候補で実行した **剰余演算（`remainder`）の回数** を返します。3 つとも同じ計測基準を使い、結果を比較できるようにします。

### 第 1 版 — すべての整数で試し割りする

```flix
pub def prime1(limit: Int32): Int32 =
    def divisions(n, divisor, count) =
        if (divisor >= n)
            count
        else if (n `Int32.remainder` divisor == 0)
            count + 1
        else
            divisions(n, divisor + 1, count + 1);

    def candidates(n, count) =
        if (n > limit)
            count
        else
            candidates(n + 1, count + divisions(n, 2, 0));

    if (limit < 2) 0 else candidates(2, 0)
```

`n` が合成数なら約数が見つかった時点で終了し、素数なら `n - 2` 個の除数候補を試します。上限を N とすると計算量の上界は O(N²) です。`divisions` は検査回数を引数で持つため末尾再帰になり、再帰の深さに比例したスタックを使いません。

### 第 2 版 — 奇数候補と既知の素数を使う

2 より大きい偶数は素数ではないため、候補を 3 から 2 ずつ増やします。割る値もすでに見つけた奇素数だけにします。実装では `Array` に既知の素数を格納し、`Array.put` で追加します。

```flix
def findDivisor(n, i, primeCount, count) =
    if (i >= primeCount)
        (false, count)
    else if (n `Int32.remainder` Array.get(i, primes) == 0)
        (true, count + 1)
    else
        findDivisor(n, i + 1, primeCount, count + 1);
```

ここでは平方根で打ち切らず、候補が合成数の場合は約数が見つかるまで、素数の場合は見つけた奇素数をすべて調べます。既知の素数の数は O(N) 以下であり、全体の時間計算量の安全な上界は O(N²)、保存領域は O(N) です。

### 第 3 版 — 平方根以下だけを調べる

ある数 n が合成数なら、少なくとも 1 つの約数は √n 以下です。したがって、既知の素数 p について `p * p <= n` の間だけ試し割りすれば十分です。2 より大きい偶数は候補から除外しているため、約数候補も 3 から調べます。

```flix
def findDivisor(n, i, primeCount, count) =
    if (i >= primeCount)
        (false, count)
    else if (Array.get(i, primes) * Array.get(i, primes) > n)
        (false, count)
    else if (n `Int32.remainder` Array.get(i, primes) == 0)
        (true, count + 1)
    else
        findDivisor(n, i + 1, primeCount, count + 1);
```

N 以下の各候補で √N 以下の除数しか調べないため、単純な上界は O(N√N) です。素数を保存する領域は O(N) です。

### テストと比較

```flix
@Test
def prime1_counts_divisions_to_1000(): Unit \ Assert =
    Assert.assertEq(expected = 78022, Arrays.prime1(1000))

@Test
def prime2_counts_divisions_to_1000(): Unit \ Assert =
    Assert.assertEq(expected = 14622, Arrays.prime2(1000))

@Test
def prime3_counts_divisions_to_1000(): Unit \ Assert =
    Assert.assertEq(expected = 1804, Arrays.prime3(1000))
```

| 版 | 改善 | 1000 以下の剰余演算回数 |
|---|---|---:|
| `prime1` | すべての整数を候補・除数にする | 78,022 |
| `prime2` | 奇数候補と既知の奇素数を使う | 14,622 |
| `prime3` | さらに √n 以下で打ち切る | 1,804 |

`prime3` は Python 原本のカウンター値 3,774 と一致しません。原本の第 3 版は剰余演算のほかにループ条件や素数登録もカウンターへ加算します。この Flix 版では 3 つの版を比較できるよう、剰余演算の回数だけを一貫して数えています。

## 2.8 まとめ

| アルゴリズム | 計算量 | 追加領域 | 入力の変更 |
|---|---:|---:|---|
| `maxOf` | O(n) | O(1) | なし |
| `reverseArray` | O(n) | O(1) | あり |
| `cardConv` | O(k)（k は桁数） | O(k) | なし |
| `prime1` | O(N²) | O(1) | なし |
| `prime2` | O(N²) 以下 | O(N) | なし |
| `prime3` | O(N√N) 以下 | O(N) | なし |

この章では、Flix の配列を領域内で生成・変更する方法、空配列を `Option` で安全に表す方法、入力を破壊的に更新する処理と純粋な結果計算を区別する方法を学びました。また、候補や除数の範囲を絞ることで、同じ問題を解くための計算回数が大きく変わることを確認しました。

すべてのテストと型・効果検査は次のコマンドで実行できます。

```bash
make test
make check
make format-check
```

次章では、線形探索、番兵法、二分探索、ハッシュ法を実装します。二分探索では、データが整列済みであることが正しさの前提になります。
