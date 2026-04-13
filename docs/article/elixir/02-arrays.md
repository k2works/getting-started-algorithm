# 第 2 章 配列

## はじめに

この章では、Elixir のリスト操作を中心に、配列に関連するアルゴリズムを TDD で実装します。Elixir のリストは連結リストとして実装されていますが、`Enum` モジュールを使うことで配列的な操作も簡潔に記述できます。

---

## 1. リストの最大値

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/arrays_test.exs
defmodule Algorithm.ArraysTest do
  use ExUnit.Case
  alias Algorithm.Arrays

  describe "max_of_list/1" do
    test "リストの最大値を返す" do
      assert Arrays.max_of_list([3, 1, 4, 1, 5, 9, 2, 6]) == 9
    end
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/arrays.ex
defmodule Algorithm.Arrays do
  @moduledoc "配列操作"

  @doc "リストの最大値を返す"
  def max_of_list(list), do: Enum.max(list)
end
```

### Refactor

`Enum.max/1` は Elixir の標準ライブラリで、リスト内の最大値を効率的に返します。Elixir の設計思想として、よく使う操作は `Enum` モジュールに集約されているため、自前で実装する必要はありません。

---

## 2. 基数変換

10 進数を指定した基数（2 進数、16 進数など）に変換するアルゴリズムです。

### Red -- 失敗するテストを書く

```elixir
describe "cardinal_number/2" do
  test "10 進数を指定の基数に変換した文字列を返す" do
    assert Arrays.cardinal_number(29, 2) == "11101"
    assert Arrays.cardinal_number(59, 16) == "3B"
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "10 進数を指定基数に変換した文字列を返す"
def cardinal_number(n, radix) do
  digits = ~w(0 1 2 3 4 5 6 7 8 9 A B C D E F)
  do_convert(n, radix, digits, [])
end

defp do_convert(0, _radix, _digits, acc), do: Enum.join(acc)

defp do_convert(n, radix, digits, acc) do
  digit = Enum.at(digits, rem(n, radix))
  do_convert(div(n, radix), radix, digits, [digit | acc])
end
```

### Refactor -- パターンマッチと再帰

Elixir では再帰とパターンマッチを組み合わせてループを表現します。`do_convert/4` は末尾再帰で、基数で割った余りを繰り返し取得し、アキュムレータ `acc` の先頭に追加していきます。`n` が 0 になったときにパターンマッチで再帰を終了します。

### アルゴリズムの考え方

1. 10 進数を基数で割り、余りを記録する
2. 商を新たな 10 進数として繰り返す
3. 商が 0 になったら、記録した余りを逆順に並べる

`~w()` シギルは文字列のリストを簡潔に記述するための Elixir の構文です。

---

## 3. 素数列挙（エラトステネスの篩）

### Red -- 失敗するテストを書く

```elixir
describe "prime_numbers/1" do
  test "n 以下の素数リストを返す" do
    assert Arrays.prime_numbers(20) == [2, 3, 5, 7, 11, 13, 17, 19]
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "n 以下の素数リストを返す（エラトステネスの篩）"
def prime_numbers(n) do
  sieve = Enum.into(2..n, MapSet.new())
  do_sieve(sieve, 2, n)
end

defp do_sieve(sieve, p, n) when p * p > n,
  do: MapSet.to_list(sieve) |> Enum.sort()

defp do_sieve(sieve, p, n) do
  if MapSet.member?(sieve, p) do
    composites =
      (p * p)..n//p
      |> Enum.into(MapSet.new())

    new_sieve = MapSet.difference(sieve, composites)
    do_sieve(new_sieve, p + 1, n)
  else
    do_sieve(sieve, p + 1, n)
  end
end
```

### Refactor -- MapSet の活用

Elixir の `MapSet` は集合操作（差集合 `difference`、包含チェック `member?`）を効率的に行えるデータ構造です。エラトステネスの篩では、合成数を集合から除去していく操作が自然に表現できます。

`(p * p)..n//p` は Elixir 1.12 以降で使えるステップ付きレンジです。p の 2 乗から n まで p 刻みで合成数を生成します。

### アルゴリズムの考え方

1. 2 から n までの整数の集合を作成する
2. 最小の素数 p の倍数を集合から除去する
3. 次の素数に移動して繰り返す
4. p の 2 乗が n を超えたら、残った要素がすべて素数

---

## まとめ

この章では、Elixir のリスト操作に関するアルゴリズムを TDD で実装しました。

- **`Enum` モジュール** によるリスト操作（`max`、`join`、`sort`）
- **再帰とパターンマッチ** による繰り返し処理の表現
- **`MapSet`** を使った集合操作
- **`~w()` シギル** や **ステップ付きレンジ** などの Elixir 固有の構文

Elixir では、再帰とパターンマッチがループの代わりを担います。次の章では、探索アルゴリズムを学びます。
