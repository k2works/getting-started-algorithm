defmodule Algorithm.Strings do
  @moduledoc "文字列処理"

  @doc "ブルートフォース文字列探索"
  def brute_force_search(text, pattern) do
    t = String.graphemes(text)
    p = String.graphemes(pattern)
    tlen = length(t)
    plen = length(p)

    result =
      Enum.find(0..(tlen - plen), fn i ->
        Enum.slice(t, i, plen) == p
      end)

    case result do
      nil -> :not_found
      idx -> {:ok, idx}
    end
  end

  @doc "KMP 法による文字列探索"
  def kmp_search(text, pattern) do
    t = String.graphemes(text)
    p = String.graphemes(pattern)
    plen = length(p)

    if plen == 0 do
      {:ok, 0}
    else
      failure = build_failure_table(p, plen)
      do_kmp_search(t, p, failure, 0, 0, length(t), plen)
    end
  end

  defp build_failure_table(p, plen) do
    table = List.to_tuple(List.duplicate(0, plen))

    if plen <= 1 do
      table
    else
      {table, _} =
        Enum.reduce(1..(plen - 1), {table, 0}, fn i, {tbl, k} ->
          k = retreat(p, tbl, k, i)

          k =
            if Enum.at(p, k) == Enum.at(p, i),
              do: k + 1,
              else: k

          {put_elem(tbl, i, k), k}
        end)

      table
    end
  end

  defp retreat(_p, _tbl, 0, _i), do: 0

  defp retreat(p, tbl, k, i) do
    if Enum.at(p, k) != Enum.at(p, i) do
      retreat(p, tbl, elem(tbl, k - 1), i)
    else
      k
    end
  end

  defp do_kmp_search(_t, _p, _f, ti, _pj, tlen, _plen) when ti >= tlen, do: :not_found

  defp do_kmp_search(t, p, f, ti, pj, tlen, plen) do
    if Enum.at(t, ti) == Enum.at(p, pj) do
      if pj + 1 == plen do
        {:ok, ti - pj}
      else
        do_kmp_search(t, p, f, ti + 1, pj + 1, tlen, plen)
      end
    else
      if pj > 0 do
        do_kmp_search(t, p, f, ti, elem(f, pj - 1), tlen, plen)
      else
        do_kmp_search(t, p, f, ti + 1, 0, tlen, plen)
      end
    end
  end

  @doc "各文字の出現回数を返す"
  def char_count(str) do
    str
    |> String.graphemes()
    |> Enum.frequencies()
  end

  @doc "文字列を逆順にする"
  def reverse_string(str) do
    str |> String.graphemes() |> Enum.reverse() |> Enum.join()
  end

  @doc "回文判定"
  def palindrome?(str) do
    str == reverse_string(str)
  end
end
