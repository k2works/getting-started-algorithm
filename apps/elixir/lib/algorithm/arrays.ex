defmodule Algorithm.Arrays do
  @moduledoc """
  配列操作
  """

  @doc "リストの最大値を返す"
  def max_of_list(list), do: Enum.max(list)

  @doc "リストの要素の並びを反転する"
  def reverse_list(list), do: Enum.reverse(list)

  @doc "10 進数を指定基数に変換した文字列を返す"
  def cardinal_number(n, radix) do
    digits = ~w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
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

  @doc "x 以下の素数を列挙する（第 1 版）— 除算回数を返す"
  def prime1(x) do
    Enum.reduce(2..x, 0, fn n, counter ->
      Enum.reduce_while(2..(n - 1)//1, counter, fn i, acc ->
        new_acc = acc + 1

        if rem(n, i) == 0 do
          {:halt, new_acc}
        else
          {:cont, new_acc}
        end
      end)
    end)
  end

  @doc "x 以下の素数を列挙する（第 2 版）— 除算回数を返す"
  def prime2(x) do
    {counter, _primes} =
      Enum.reduce(3..x//2, {0, [2]}, fn n, {counter, primes} ->
        # primes の先頭は最後に追加された素数なので、割り算は tail から（2 を除いた素数リスト）
        divisors = primes |> Enum.reverse() |> tl()

        {new_counter, is_prime} =
          Enum.reduce_while(divisors, {counter, true}, fn p, {acc, _} ->
            new_acc = acc + 1

            if rem(n, p) == 0 do
              {:halt, {new_acc, false}}
            else
              {:cont, {new_acc, true}}
            end
          end)

        if is_prime do
          {new_counter, [n | primes]}
        else
          {new_counter, primes}
        end
      end)

    counter
  end

  @doc "x 以下の素数を列挙する（第 3 版）— 除算回数を返す"
  def prime3(x) do
    {counter, _primes} =
      Enum.reduce(5..x//2, {0, [3, 2]}, fn n, {counter, primes} ->
        sorted_primes = Enum.reverse(primes)
        # index 1 からの素数（2 を除く）のうち p*p <= n のもの
        divisors = sorted_primes |> tl()

        {new_counter, is_prime} =
          Enum.reduce_while(divisors, {counter, true}, fn p, {acc, _} ->
            if p * p > n do
              {:halt, {acc + 1, true}}
            else
              new_acc = acc + 2

              if rem(n, p) == 0 do
                {:halt, {new_acc, false}}
              else
                {:cont, {new_acc, true}}
              end
            end
          end)

        if is_prime do
          {new_counter, [n | primes]}
        else
          {new_counter, primes}
        end
      end)

    counter
  end
end
