defmodule Algorithm.Arrays do
  @moduledoc """
  配列操作
  """

  @doc "リストの最大値を返す"
  def max_of_list(list), do: Enum.max(list)

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

  @doc "n 以下の素数リストを返す（エラトステネスの篩）"
  def prime_numbers(n) do
    sieve = Enum.into(2..n, MapSet.new())
    do_sieve(sieve, 2, n)
  end

  defp do_sieve(sieve, p, n) when p * p > n, do: MapSet.to_list(sieve) |> Enum.sort()

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
end
