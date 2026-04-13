defmodule Algorithm.SearchAlgorithms do
  @moduledoc """
  探索アルゴリズム
  """

  @doc "線形探索"
  def linear_search(list, key) do
    case Enum.find_index(list, &(&1 == key)) do
      nil -> :not_found
      idx -> {:ok, idx}
    end
  end

  @doc "二分探索（ソート済みリストに対して）"
  def binary_search(list, key) do
    arr = List.to_tuple(list)
    do_binary(arr, key, 0, tuple_size(arr) - 1)
  end

  defp do_binary(_arr, _key, lo, hi) when lo > hi, do: :not_found

  defp do_binary(arr, key, lo, hi) do
    mid = div(lo + hi, 2)
    val = elem(arr, mid)

    cond do
      val == key -> {:ok, mid}
      val < key -> do_binary(arr, key, mid + 1, hi)
      true -> do_binary(arr, key, lo, mid - 1)
    end
  end

  @doc "ハッシュ法による探索"
  def hash_search(map, key) do
    case Map.get(map, key) do
      nil -> :not_found
      value -> {:ok, value}
    end
  end
end
