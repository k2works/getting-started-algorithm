# 第 1 章 基本的なアルゴリズム

## 1.1 はじめに

この続編では、TDD の基本サイクルを Flix で繰り返しながら、アルゴリズムとデータ構造を実装します。前作の「テスト駆動開発から始める Flix 入門」で学んだ `@Test`、`Assert`、型・効果検査、Red → Green → Refactor を前提に進めます。

この章では、3 値の最大値と中央値、条件分岐、総和、二重反復を題材にします。Flix では `Int32` などの型を明示し、`List.range` や `List.map`、`List.foldLeft` を組み合わせて、繰り返し処理を不変データの変換として表現できます。

### この章の TODO リスト

- [ ] 3 つの整数から最大値を求める
- [ ] 3 つの整数から中央値を求める
- [ ] 整数の符号を判定する
- [ ] 1 から n までの総和を求める
- [ ] 九九の表をリストとして作る

## 1.2 準備

この章は `apps/flix/` にプロジェクトがあり、Flix の Nix 開発環境が用意されていることを前提とします。現時点ではこのリポジトリに Flix 環境がないため、環境を整備してから以下のコマンドを実行してください。準備項目は [執筆計画](../outline.md) に記載しています。

```bash
# Flix 開発環境に入る
nix develop path:.#flix

# Flix プロジェクトへ移動
cd apps/flix

# flix.toml で固定したバージョンを取得
version="$(sed -n 's/^flix[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' flix.toml)"
curl -fL --retry 2 \
  -o flix.jar \
  "https://github.com/flix/flix/releases/download/v${version}/flix.jar"

# テストを実行
make test
```

`flix.jar` は `.gitignore` 対象のため、初回に取得します。詳しい手順は [Flix 環境セットアップ手順書](../../operation/Flix開発環境セットアップ手順書.md) を参照してください。

Flix の標準テストを使います。テスト関数には `@Test` を付け、アサーションが使う `Assert` 効果を戻り値の型に記述します。

```flix
@Test
def example_test(): Unit \ Assert =
    Assert.assertEq(expected = 3, 1 + 2)
```

## 1.3 アルゴリズムとは

アルゴリズムとは、問題を解決するための明確な手順です。プログラムは、その手順をコンピューターが実行できる形で表現したものです。アルゴリズムをテストで確かめるときは、通常の入力だけでなく、同じ値が並ぶ場合や境界値も仕様として確認します。

Flix は静的型付け言語なので、関数が未定義の場合や値の型が合わない場合、実行前に検査で検出できます。テストがまだ存在しない関数を呼び出すときに発生するコンパイルエラーも、テストファーストの Red です。

## 1.4 3 値の最大値

3 つの整数 `a`、`b`、`c` のうち最も大きい値を返す関数を作ります。まず、各位置の値が最大になる場合と、値が等しい場合をテストします。

### Red — 失敗するテストを書く

`test/TestBasicAlgorithms.flix` にテストを追加します。

```flix
mod TestBasicAlgorithms {
    /// 最大値が a の場合。
    @Test
    def max3_a_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 2, 1))

    /// 最大値が b の場合。
    @Test
    def max3_b_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(1, 3, 2))

    /// 最大値が c の場合。
    @Test
    def max3_c_is_largest(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(1, 2, 3))

    /// 2 つの値が同じ最大値になる場合。
    @Test
    def max3_two_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 3, 1))

    /// すべての値が同じ場合。
    @Test
    def max3_all_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 3, 3))
}
```

まだ `BasicAlgorithms.max3` がないため、Flix のコンパイル時検査で失敗します。

```bash
make test
```

### Green — 比較して最大値を決める

`src/BasicAlgorithms.flix` に実装を追加します。

```flix
mod BasicAlgorithms {
    /// 3 つの整数の最大値を返す。
    pub def max3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (a >= c) a else c
        else
            if (b >= c) b else c
}
```

最初に `a` と `b` を比べ、その大きい方を `c` と比べます。比較結果のどちらの場合も、同じ値のときに正しい値を返すよう `>=` を使っています。Flix の `if` は値を返す式なので、分岐ごとの値がそのまま関数の結果になります。

```bash
make test
```

### Refactor — 比較の網羅性を確認する

5 つのテストは、最大値が各引数にある場合、同値の場合を確認します。必要に応じてテストを追加し、引数の順序や負の値も確認できます。たとえば `max3(-3, -1, -2)` の期待値は `-1` です。実装は入力値を変更しない純粋関数なので、同じ入力に対して常に同じ結果を返します。

## 1.5 3 値の中央値

中央値は、3 つの値を小さい順に並べたときに中央に来る値です。最大値とは異なり、最大・最小以外の値を選ぶ必要があるため、大小関係を場合分けします。

### Red — 順序と同値をテストする

`test/TestBasicAlgorithms.flix` の `TestBasicAlgorithms` モジュールに追加します。

```flix
    /// a > b > c の場合。
    @Test
    def med3_a_b_c(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 2, 1))

    /// a > b = c の場合。
    @Test
    def med3_b_equals_c(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 2, 2))

    /// a > c > b の場合。
    @Test
    def med3_a_c_b(): Unit \ Assert =
        Assert.assertEq(expected = 2, BasicAlgorithms.med3(3, 1, 2))

    /// a = c > b の場合。
    @Test
    def med3_a_equals_c(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.med3(3, 2, 3))

    /// すべての値が同じ場合。
    @Test
    def med3_all_values_are_equal(): Unit \ Assert =
        Assert.assertEq(expected = 3, BasicAlgorithms.med3(3, 3, 3))
```

`med3` が未定義のため、テストはコンパイル時検査で失敗します。

### Green — 条件分岐で中央値を選ぶ

`src/BasicAlgorithms.flix` の `BasicAlgorithms` モジュールに追加します。

```flix
    /// 3 つの整数の中央値を返す。
    pub def med3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (b >= c) b
            else if (a <= c) a
            else c
        else
            if (a > c) a
            else if (b > c) c
            else b
```

各分岐は、3 値の大小関係から中央の値を選びます。同じ値を含むケースもテストし、`>` と `>=` の違いが結果に影響しないことを確認します。

## 1.6 条件判定と分岐

整数が正、負、または 0 のどれかを判定します。結果を文字列にすることで、各分岐の振る舞いをテストできます。

### Red — 3 つの条件をテストする

```flix
    /// 正の整数を判定する。
    @Test
    def judgeSign_positive(): Unit \ Assert =
        Assert.assertEq(expected = "正", BasicAlgorithms.judgeSign(17))

    /// 負の整数を判定する。
    @Test
    def judgeSign_negative(): Unit \ Assert =
        Assert.assertEq(expected = "負", BasicAlgorithms.judgeSign(-5))

    /// 0 を判定する。
    @Test
    def judgeSign_zero(): Unit \ Assert =
        Assert.assertEq(expected = "0", BasicAlgorithms.judgeSign(0))
```

### Green — `if` 式で分岐する

```flix
    /// 整数の符号を文字列で返す。
    pub def judgeSign(n: Int32): String =
        if (n > 0) "正"
        else if (n < 0) "負"
        else "0"
```

Flix では `if` 式の各分岐が同じ型の値を返します。この例ではどの分岐も `String` を返すため、関数の戻り値型と一致します。

## 1.7 1 から n までの総和

繰り返し処理で 1 から `n` までの数を足し合わせます。命令型言語でカウンターと累積変数を更新する代わりに、Flix では `List.range` で数列を作り、`List.foldLeft` で 1 つの値に畳み込めます。

### Red — 境界値と通常値をテストする

```flix
    /// 1 から 5 までの総和。
    @Test
    def sum1ToN_five(): Unit \ Assert =
        Assert.assertEq(expected = 15, BasicAlgorithms.sum1ToN(5))

    /// 1 から 1 までの総和。
    @Test
    def sum1ToN_one(): Unit \ Assert =
        Assert.assertEq(expected = 1, BasicAlgorithms.sum1ToN(1))

    /// 0 以下の入力は空の範囲として 0 を返す。
    @Test
    def sum1ToN_zero(): Unit \ Assert =
        Assert.assertEq(expected = 0, BasicAlgorithms.sum1ToN(0))
```

### Green — 範囲を畳み込む

```flix
    /// 1 から n までの整数の総和を返す。n が 0 以下なら 0 を返す。
    pub def sum1ToN(n: Int32): Int32 =
        if (n <= 0) 0
        else List.range(1, n + 1) |> List.foldLeft((total, value) -> total + value, 0)
```

`List.range` の終端は含まれないため、`n` までを含める目的で `n + 1` を指定します。`List.foldLeft` は初期値 `0` から開始し、各 `value` を `total` に加算します。リストと中間値を変更せず、最終的な総和を返します。

## 1.8 九九の表と二重反復

二重ループでは、一方の繰り返しの中で別の繰り返しを行います。Flix では `List.map` を入れ子にし、外側の数ごとに内側のリストを作ることで、九九の表を `List[List[Int32]]` として表せます。

### Red — 行と値をテストする

```flix
    /// 九九の表は 9 行ある。
    @Test
    def multiplicationTable_has_nine_rows(): Unit \ Assert =
        Assert.assertEq(expected = 9, List.length(BasicAlgorithms.multiplicationTable()))

    /// 最初の行は 1 の段。
    @Test
    def multiplicationTable_first_row(): Unit \ Assert =
        Assert.assertEq(
            expected = Some(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: Nil),
            List.nth(0, BasicAlgorithms.multiplicationTable())
        )

    /// 最後の行は 9 の段。
    @Test
    def multiplicationTable_last_row(): Unit \ Assert =
        Assert.assertEq(
            expected = Some(9 :: 18 :: 27 :: 36 :: 45 :: 54 :: 63 :: 72 :: 81 :: Nil),
            List.nth(8, BasicAlgorithms.multiplicationTable())
        )
```

`List.nth` は 0 始まりの位置を受け取り、結果を `Option` で返します。そのため、行が存在する場合の期待値は `Some(...)` で表します。

### Green — `List.map` を入れ子にする

```flix
    /// 1 から 9 までの九九の表を行ごとのリストとして返す。
    pub def multiplicationTable(): List[List[Int32]] =
        List.range(1, 10)
            |> List.map(i ->
                List.range(1, 10)
                    |> List.map(j -> i * j)
            )
```

外側の `List.map` が段を、内側の `List.map` がその段の各値を作ります。たとえば `i` が 3 のとき、内側は `3 * 1` から `3 * 9` までのリストになります。`List.range(1, 10)` は終端の 10 を含まないため、1 から 9 までが対象です。

## 1.9 この章の実装

各 Red のテストを先に追加し、それぞれの Green 実装を `src/BasicAlgorithms.flix` にまとめると、最終的なモジュールは次のようになります。

```flix
mod BasicAlgorithms {
    /// 3 つの整数の最大値を返す。
    pub def max3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (a >= c) a else c
        else
            if (b >= c) b else c

    /// 3 つの整数の中央値を返す。
    pub def med3(a: Int32, b: Int32, c: Int32): Int32 =
        if (a >= b)
            if (b >= c) b
            else if (a <= c) a
            else c
        else
            if (a > c) a
            else if (b > c) c
            else b

    /// 整数の符号を文字列で返す。
    pub def judgeSign(n: Int32): String =
        if (n > 0) "正"
        else if (n < 0) "負"
        else "0"

    /// 1 から n までの整数の総和を返す。n が 0 以下なら 0 を返す。
    pub def sum1ToN(n: Int32): Int32 =
        if (n <= 0) 0
        else List.range(1, n + 1) |> List.foldLeft((total, value) -> total + value, 0)

    /// 1 から 9 までの九九の表を行ごとのリストとして返す。
    pub def multiplicationTable(): List[List[Int32]] =
        List.range(1, 10)
            |> List.map(i ->
                List.range(1, 10)
                    |> List.map(j -> i * j)
            )
}
```

`test/TestBasicAlgorithms.flix` には、この章で示したテストを `TestBasicAlgorithms` モジュールにまとめます。テストを実行し、型・効果検査と整形も確認してください。

```bash
make test
make check
make format-check
```

Flix のバージョンや環境が準備されていない場合は、実行結果を確認できていないコード例を完成済みとみなさず、環境整備後に各コードブロックを検証します。

## 1.10 まとめ

この章では、基本的なアルゴリズムを TDD で実装しました。

| アルゴリズム | Flix の表現 | 確認したこと |
|-------------|-------------|-------------|
| 3 値の最大値 | 比較と `if` 式 | 各引数が最大の場合、同値の場合 |
| 3 値の中央値 | 条件分岐 | 値の順序と同値の場合 |
| 符号判定 | `if` 式 | 正、負、0 の分岐 |
| 1 から n までの総和 | `List.range` と `List.foldLeft` | 範囲の終端と 0 の境界 |
| 九九の表 | 入れ子の `List.map` | 二重反復と `Option` による行の取得 |

Flix では、計算を純粋関数に分け、不変なリスト変換として反復処理を表せます。次章では配列を題材に、添字による操作やデータの並べ替えを扱います。
