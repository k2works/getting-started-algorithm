defmodule Algorithm.SortAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SortAlgorithms

  @sorted [1, 2, 3, 4, 5, 6, 7, 8]
  @unsorted [5, 3, 8, 1, 4, 7, 2, 6]

  test "bubble_sort/1" do
    assert SortAlgorithms.bubble_sort(@unsorted) == @sorted
  end

  test "selection_sort/1" do
    assert SortAlgorithms.selection_sort(@unsorted) == @sorted
  end

  test "insertion_sort/1" do
    assert SortAlgorithms.insertion_sort(@unsorted) == @sorted
  end

  test "shell_sort/1" do
    assert SortAlgorithms.shell_sort(@unsorted) == @sorted
  end

  test "quick_sort/1" do
    assert SortAlgorithms.quick_sort(@unsorted) == @sorted
  end

  test "merge_sort/1" do
    assert SortAlgorithms.merge_sort(@unsorted) == @sorted
  end

  test "heap_sort/1" do
    assert SortAlgorithms.heap_sort(@unsorted) == @sorted
  end

  test "counting_sort/2" do
    assert SortAlgorithms.counting_sort([3, 1, 4, 1, 5, 9, 2, 6], 9) ==
             [1, 1, 2, 3, 4, 5, 6, 9]
  end
end
