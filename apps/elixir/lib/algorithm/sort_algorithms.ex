defmodule Algorithm.SortAlgorithms do
  @moduledoc "ソートアルゴリズム集"

  @doc "バブルソート"
  def bubble_sort(list) do
    n = length(list)
    arr = List.to_tuple(list)

    result =
      Enum.reduce(1..n, arr, fn _, acc ->
        Enum.reduce(0..(n - 2), acc, fn i, a ->
          x = elem(a, i)
          y = elem(a, i + 1)

          if x > y do
            a |> put_elem(i, y) |> put_elem(i + 1, x)
          else
            a
          end
        end)
      end)

    Tuple.to_list(result)
  end

  @doc "選択ソート"
  def selection_sort(list) do
    n = length(list)
    arr = List.to_tuple(list)

    result =
      Enum.reduce(0..(n - 2), arr, fn i, acc ->
        {_min_val, min_idx} =
          Enum.reduce((i + 1)..(n - 1), {elem(acc, i), i}, fn j, {mv, mi} ->
            v = elem(acc, j)
            if v < mv, do: {v, j}, else: {mv, mi}
          end)

        if min_idx != i do
          vi = elem(acc, i)
          vm = elem(acc, min_idx)
          acc |> put_elem(i, vm) |> put_elem(min_idx, vi)
        else
          acc
        end
      end)

    Tuple.to_list(result)
  end

  @doc "挿入ソート"
  def insertion_sort(list) do
    Enum.reduce(list, [], fn x, sorted ->
      insert(sorted, x)
    end)
  end

  defp insert([], x), do: [x]
  defp insert([h | t], x) when x <= h, do: [x, h | t]
  defp insert([h | t], x), do: [h | insert(t, x)]

  @doc "シェルソート"
  def shell_sort(list) do
    n = length(list)
    gaps = Stream.iterate(1, &(&1 * 3 + 1)) |> Enum.take_while(&(&1 < n)) |> Enum.reverse()
    arr = List.to_tuple(list)

    result =
      Enum.reduce(gaps, arr, fn gap, a ->
        Enum.reduce(gap..(n - 1), a, fn i, b ->
          tmp = elem(b, i)
          do_shell_inner(b, i, gap, tmp)
        end)
      end)

    Tuple.to_list(result)
  end

  defp do_shell_inner(arr, j, gap, tmp) when j >= gap and elem(arr, j - gap) > tmp do
    new_arr = put_elem(arr, j, elem(arr, j - gap))
    do_shell_inner(new_arr, j - gap, gap, tmp)
  end

  defp do_shell_inner(arr, j, _gap, tmp), do: put_elem(arr, j, tmp)

  @doc "クイックソート"
  def quick_sort([]), do: []

  def quick_sort([pivot | rest]) do
    left = Enum.filter(rest, &(&1 <= pivot))
    right = Enum.filter(rest, &(&1 > pivot))
    quick_sort(left) ++ [pivot] ++ quick_sort(right)
  end

  @doc "マージソート"
  def merge_sort([]), do: []
  def merge_sort([x]), do: [x]

  def merge_sort(list) do
    mid = div(length(list), 2)
    {left, right} = Enum.split(list, mid)
    merge(merge_sort(left), merge_sort(right))
  end

  defp merge([], right), do: right
  defp merge(left, []), do: left
  defp merge([lh | lt], [rh | rt]) when lh <= rh, do: [lh | merge(lt, [rh | rt])]
  defp merge([lh | lt], [rh | rt]), do: [rh | merge([lh | lt], rt)]

  @doc "ヒープソート"
  def heap_sort(list) do
    arr = List.to_tuple(list)
    n = tuple_size(arr)
    arr2 = Enum.reduce((div(n, 2) - 1)..0//-1, arr, fn i, a -> downheap(a, i, n) end)

    Enum.reduce((n - 1)..1//-1, arr2, fn i, a ->
      swapped = a |> put_elem(0, elem(a, i)) |> put_elem(i, elem(a, 0))
      downheap(swapped, 0, i)
    end)
    |> Tuple.to_list()
  end

  defp downheap(arr, i, n) do
    left = 2 * i + 1
    right = 2 * i + 2

    largest =
      if left < n and elem(arr, left) > elem(arr, i), do: left, else: i

    largest =
      if right < n and elem(arr, right) > elem(arr, largest), do: right, else: largest

    if largest != i do
      swapped = arr |> put_elem(i, elem(arr, largest)) |> put_elem(largest, elem(arr, i))
      downheap(swapped, largest, n)
    else
      arr
    end
  end

  @doc "度数ソート"
  def counting_sort(list, max) do
    counts =
      Enum.reduce(list, List.to_tuple(List.duplicate(0, max + 1)), fn x, acc ->
        put_elem(acc, x, elem(acc, x) + 1)
      end)

    Enum.reduce(0..max, [], fn i, acc ->
      acc ++ List.duplicate(i, elem(counts, i))
    end)
  end
end
