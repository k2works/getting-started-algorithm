defmodule Algorithm.SortAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SortAlgorithms

  @sorted [1, 2, 3, 4, 5, 6, 7, 8]
  @unsorted [5, 3, 8, 1, 4, 7, 2, 6]

  describe "bubble_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.bubble_sort(@unsorted) == @sorted
    end

    test "ソート済みリストはそのまま" do
      assert SortAlgorithms.bubble_sort(@sorted) == @sorted
    end
  end

  describe "selection_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.selection_sort(@unsorted) == @sorted
    end
  end

  describe "insertion_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.insertion_sort(@unsorted) == @sorted
    end
  end

  describe "shell_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.shell_sort(@unsorted) == @sorted
    end
  end

  describe "quick_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.quick_sort(@unsorted) == @sorted
    end

    test "空リスト" do
      assert SortAlgorithms.quick_sort([]) == []
    end
  end

  describe "merge_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.merge_sort(@unsorted) == @sorted
    end

    test "空リスト" do
      assert SortAlgorithms.merge_sort([]) == []
    end

    test "要素が 1 つ" do
      assert SortAlgorithms.merge_sort([42]) == [42]
    end
  end

  describe "heap_sort/1" do
    test "未ソートリストをソートする" do
      assert SortAlgorithms.heap_sort(@unsorted) == @sorted
    end
  end

  describe "counting_sort/2" do
    test "重複あり要素をソートする" do
      assert SortAlgorithms.counting_sort([3, 1, 4, 1, 5, 9, 2, 6], 9) ==
               [1, 1, 2, 3, 4, 5, 6, 9]
    end
  end
end
