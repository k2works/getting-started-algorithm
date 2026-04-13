# 第 5 章 再帰アルゴリズム

## はじめに

再帰とは、関数が自分自身を呼び出すことで問題を解決する手法です。Elixir は関数型言語であり、ループ構文（`for`/`while`）の代わりに再帰を多用します。特に BEAM VM は末尾再帰最適化（TCO: Tail Call Optimization）をサポートしているため、適切に書けばスタックオーバーフローを起こしません。

---

## 1. 階乗

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/recursion_test.exs
defmodule Algorithm.RecursionTest do
  use ExUnit.Case
  alias Algorithm.Recursion

  describe "factorial/1" do
    test "0 の階乗は 1" do
      assert Recursion.factorial(0) == 1
    end

    test "5 の階乗は 120" do
      assert Recursion.factorial(5) == 120
    end
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/recursion.ex
defmodule Algorithm.Recursion do
  @moduledoc "再帰アルゴリズム"

  @doc "階乗（末尾再帰）"
  def factorial(n), do: factorial(n, 1)
  defp factorial(0, acc), do: acc
  defp factorial(n, acc), do: factorial(n - 1, n * acc)
end
```

### Refactor -- 末尾再帰最適化

通常の再帰版:
```elixir
def factorial_naive(0), do: 1
def factorial_naive(n), do: n * factorial_naive(n - 1)
```

末尾再帰版では、アキュムレータ `acc` に途中結果を蓄積し、再帰呼び出しが関数の最後の操作になるようにしています。BEAM VM はこのパターンを検出してスタックフレームを再利用するため、大きな `n` でもスタックオーバーフローしません。

---

## 2. 最大公約数（ユークリッドの互除法）

### Red -- 失敗するテストを書く

```elixir
describe "gcd/2" do
  test "最大公約数を求める" do
    assert Recursion.gcd(22, 8) == 2
    assert Recursion.gcd(15, 10) == 5
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "最大公約数（ユークリッドの互除法）"
def gcd(a, 0), do: a
def gcd(a, b), do: gcd(b, rem(a, b))
```

### Refactor -- パターンマッチの活用

ユークリッドの互除法は、パターンマッチによる再帰で非常に簡潔に表現できます。第 2 引数が 0 になったときが基底条件（base case）で、そうでなければ `b` と `a` を `b` で割った余りで再帰します。

この実装は末尾再帰であり、かつ Elixir のパターンマッチの美しさを示す典型的な例です。

---

## 3. ハノイの塔

### Red -- 失敗するテストを書く

```elixir
describe "hanoi/3" do
  test "ハノイの塔の手順リストを返す" do
    result = Recursion.hanoi(3, "A", "C")
    assert length(result) == 7
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "ハノイの塔"
def hanoi(n, from, to) do
  aux = determine_aux(from, to)
  do_hanoi(n, from, to, aux)
end

defp determine_aux(from, to) do
  ["A", "B", "C"]
  |> Enum.reject(&(&1 == from or &1 == to))
  |> hd()
end

defp do_hanoi(1, from, to, _aux), do: [{from, to}]

defp do_hanoi(n, from, to, aux) do
  do_hanoi(n - 1, from, aux, to) ++
    [{from, to}] ++
    do_hanoi(n - 1, aux, to, from)
end
```

### Refactor

ハノイの塔のアルゴリズムは 3 つのステップで構成されます：

1. n-1 枚のディスクを `from` から `aux` へ移動
2. 最大のディスクを `from` から `to` へ移動
3. n-1 枚のディスクを `aux` から `to` へ移動

n 枚のディスクの移動回数は 2^n - 1 回です（n=3 の場合は 7 回）。

---

## 4. 8 クイーン問題

8x8 のチェスボード上に 8 個のクイーンを、互いに攻撃し合わないように配置する問題です。

### Red -- 失敗するテストを書く

```elixir
describe "eight_queens/0" do
  test "8 クイーン問題の解が 92 通りある" do
    solutions = Recursion.eight_queens()
    assert length(solutions) == 92
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "8 クイーン問題"
def eight_queens do
  solve_queens(8, 0, [])
end

defp solve_queens(n, row, placed) when row == n, do: [placed]

defp solve_queens(n, row, placed) do
  0..(n - 1)
  |> Enum.filter(&safe?(&1, row, placed))
  |> Enum.flat_map(&solve_queens(n, row + 1, placed ++ [{row, &1}]))
end

defp safe?(col, row, placed) do
  Enum.all?(placed, fn {r, c} ->
    c != col and abs(c - col) != abs(r - row)
  end)
end
```

### Refactor -- バックトラッキング

`Enum.filter` で安全な列を絞り込み、`Enum.flat_map` で各候補について再帰的に探索します。これはバックトラッキングの関数型スタイルでの実装です。

`safe?/3` 関数は、既に配置されたクイーンとの衝突チェックを行います：

- 同じ列にないか（`c != col`）
- 同じ斜めライン上にないか（`abs(c - col) != abs(r - row)`）

---

## まとめ

この章では、再帰アルゴリズムを TDD で実装しました。

- **末尾再帰最適化**: アキュムレータパターンによる効率的な再帰
- **パターンマッチ**: 基底条件と再帰条件の明確な分離
- **`Enum.filter` + `Enum.flat_map`**: バックトラッキングの関数型表現
- **ガード節 `when`**: 条件による関数の分岐

Elixir では再帰が「当たり前の道具」です。末尾再帰を意識することで、命令型言語のループと同等のパフォーマンスを実現できます。
