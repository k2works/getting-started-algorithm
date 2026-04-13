defmodule Algorithm.SearchAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SearchAlgorithms

  describe "linear_search/2" do
    test "値が見つかった場合にインデックスを返す" do
      assert SearchAlgorithms.linear_search([1, 3, 5, 7, 9], 5) == {:ok, 2}
    end

    test "値が見つからない場合に :not_found を返す" do
      assert SearchAlgorithms.linear_search([1, 3, 5], 4) == :not_found
    end
  end

  describe "binary_search/2" do
    test "ソート済みリストから値を二分探索する" do
      assert SearchAlgorithms.binary_search([1, 3, 5, 7, 9], 7) == {:ok, 3}
    end

    test "値が見つからない場合に :not_found を返す" do
      assert SearchAlgorithms.binary_search([1, 3, 5, 7, 9], 4) == :not_found
    end
  end

  describe "hash_search/2" do
    test "ハッシュマップから値を検索する" do
      map = %{1 => "a", 2 => "b", 3 => "c"}
      assert SearchAlgorithms.hash_search(map, 2) == {:ok, "b"}
      assert SearchAlgorithms.hash_search(map, 4) == :not_found
    end
  end
end
