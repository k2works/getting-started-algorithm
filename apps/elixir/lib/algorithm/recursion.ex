defmodule Algorithm.Recursion do
  @moduledoc """
  再帰アルゴリズム
  """

  @doc "階乗（末尾再帰）"
  def factorial(n), do: factorial(n, 1)
  defp factorial(0, acc), do: acc
  defp factorial(n, acc), do: factorial(n - 1, n * acc)

  @doc "最大公約数（ユークリッドの互除法）"
  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))

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
    do_hanoi(n - 1, from, aux, to) ++ [{from, to}] ++ do_hanoi(n - 1, aux, to, from)
  end

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
end
