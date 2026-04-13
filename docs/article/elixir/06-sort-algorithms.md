# 第 6 章 ソートアルゴリズム

## はじめに

ソートはデータを一定の順序に並べ替える操作で、コンピュータサイエンスの最も基本的なアルゴリズムの一つです。この章では、8 種類のソートアルゴリズムを TDD で実装します。

Elixir のリストは不変であるため、ソートは常に新しいリストを返します。一部のアルゴリズムでは、ランダムアクセスが必要なためタプルに変換して処理しています。

---

## 1. バブルソート

隣接する要素を比較し、順序が逆なら交換する操作を繰り返します。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/sort_algorithms_test.exs
defmodule Algorithm.SortAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SortAlgorithms

  @sorted [1, 2, 3, 4, 5, 6, 7, 8]
  @unsorted [5, 3, 8, 1, 4, 7, 2, 6]

  test "bubble_sort/1" do
    assert SortAlgorithms.bubble_sort(@unsorted) == @sorted
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
def bubble_sort(list) do
  n = length(list)
  arr = List.to_tuple(list)

  result =
    Enum.reduce(1..n, arr, fn _, acc ->
      Enum.reduce(0..(n - 2), acc, fn i, a ->
        x = elem(a, i)
        y = elem(a, i + 1)
        if x > y, do: a |> put_elem(i, y) |> put_elem(i + 1, x), else: a
      end)
    end)

  Tuple.to_list(result)
end
```

- 計算量: O(n^2)

---

## 2. 選択ソート

未ソート部分から最小値を見つけ、先頭と交換する操作を繰り返します。

### テストとの実装

```elixir
test "selection_sort/1" do
  assert SortAlgorithms.selection_sort(@unsorted) == @sorted
end
```

```elixir
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
```

- 計算量: O(n^2)

---

## 3. 挿入ソート

ソート済み部分に新しい要素を適切な位置に挿入していきます。

### テストと実装

```elixir
test "insertion_sort/1" do
  assert SortAlgorithms.insertion_sort(@unsorted) == @sorted
end
```

```elixir
def insertion_sort(list) do
  Enum.reduce(list, [], fn x, sorted -> insert(sorted, x) end)
end

defp insert([], x), do: [x]
defp insert([h | t], x) when x <= h, do: [x, h | t]
defp insert([h | t], x), do: [h | insert(t, x)]
```

### Refactor

この実装は Elixir のリスト操作を最大限に活用しています。`insert/2` はパターンマッチで 3 つのケースを処理し、リストの先頭から適切な位置に要素を挿入します。

- 計算量: O(n^2)

---

## 4. シェルソート

挿入ソートを改良したアルゴリズムで、離れた要素同士を比較・交換します。

```elixir
test "shell_sort/1" do
  assert SortAlgorithms.shell_sort(@unsorted) == @sorted
end
```

- 計算量: O(n^1.5)（ギャップ列に依存）

---

## 5. クイックソート

ピボットを選び、それより小さい要素と大きい要素に分割して再帰的にソートします。

### テストと実装

```elixir
test "quick_sort/1" do
  assert SortAlgorithms.quick_sort(@unsorted) == @sorted
end
```

```elixir
def quick_sort([]), do: []
def quick_sort([pivot | rest]) do
  left  = Enum.filter(rest, &(&1 <= pivot))
  right = Enum.filter(rest, &(&1 > pivot))
  quick_sort(left) ++ [pivot] ++ quick_sort(right)
end
```

### Refactor

Elixir のパターンマッチでリストの先頭をピボットとして取り出し、`Enum.filter` で分割します。関数型言語ならではの簡潔なクイックソートです。

- 平均計算量: O(n log n)
- 最悪計算量: O(n^2)

---

## 6. マージソート

リストを半分に分割し、再帰的にソートした後、マージします。

### テストと実装

```elixir
test "merge_sort/1" do
  assert SortAlgorithms.merge_sort(@unsorted) == @sorted
end
```

```elixir
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
```

### Refactor

`merge/2` のパターンマッチは 4 つのケースを網羅しています。`when lh <= rh` のガード節で安定ソートを保証しています。

- 計算量: O(n log n)

---

## 7. ヒープソート

ヒープ構造を利用してソートします。

```elixir
test "heap_sort/1" do
  assert SortAlgorithms.heap_sort(@unsorted) == @sorted
end
```

- 計算量: O(n log n)

---

## 8. 度数ソート（計数ソート）

要素の出現回数を数えてソートします。比較を使わないため、条件が合えば O(n) で動作します。

### テストと実装

```elixir
test "counting_sort/2" do
  assert SortAlgorithms.counting_sort([3, 1, 4, 1, 5, 9, 2, 6], 9) ==
           [1, 1, 2, 3, 4, 5, 6, 9]
end
```

```elixir
def counting_sort(list, max) do
  counts =
    Enum.reduce(list, List.to_tuple(List.duplicate(0, max + 1)), fn x, acc ->
      put_elem(acc, x, elem(acc, x) + 1)
    end)

  Enum.reduce(0..max, [], fn i, acc ->
    acc ++ List.duplicate(i, elem(counts, i))
  end)
end
```

- 計算量: O(n + k)（k は最大値）

---

## ソートアルゴリズムの比較

| アルゴリズム | 平均 | 最悪 | 安定 | 備考 |
|-------------|------|------|------|------|
| バブルソート | O(n^2) | O(n^2) | Yes | 教育用 |
| 選択ソート | O(n^2) | O(n^2) | No | 交換回数が少ない |
| 挿入ソート | O(n^2) | O(n^2) | Yes | ほぼソート済みに強い |
| シェルソート | O(n^1.5) | -- | No | 挿入ソートの改良 |
| クイックソート | O(n log n) | O(n^2) | No | 実用的に最速 |
| マージソート | O(n log n) | O(n log n) | Yes | 安定かつ高速 |
| ヒープソート | O(n log n) | O(n log n) | No | 追加メモリ不要 |
| 度数ソート | O(n + k) | O(n + k) | Yes | 値の範囲が既知の場合 |

---

## まとめ

この章では、8 種類のソートアルゴリズムを Elixir で TDD 実装しました。

- **関数型クイックソート**: パターンマッチ + `Enum.filter` による最も Elixir らしい実装
- **挿入ソート**: リストのパターンマッチを活用した自然な実装
- **タプル変換**: ランダムアクセスが必要なアルゴリズムでは `List.to_tuple` で変換
