defmodule Algorithm.SearchAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SearchAlgorithms
  alias Algorithm.SearchAlgorithms.ChainedHash
  alias Algorithm.SearchAlgorithms.OpenHash

  describe "linear_search/2" do
    test "値が見つかった場合にインデックスを返す" do
      assert SearchAlgorithms.linear_search([6, 4, 3, 2, 1, 2, 8], 2) == {:ok, 3}
    end

    test "先頭の値を見つける" do
      assert SearchAlgorithms.linear_search(["DTS", "AAC", "FLAC"], "DTS") == {:ok, 0}
    end

    test "値が見つからない場合に :not_found を返す" do
      assert SearchAlgorithms.linear_search([1, 2, 3], 99) == :not_found
    end
  end

  describe "linear_search_sentinel/2" do
    test "番兵法で値を見つける" do
      assert SearchAlgorithms.linear_search_sentinel([6, 4, 3, 2, 1, 2, 8], 2) == {:ok, 3}
    end

    test "番兵法で値が見つからない場合" do
      assert SearchAlgorithms.linear_search_sentinel([1, 2, 3], 99) == :not_found
    end
  end

  describe "binary_search/2" do
    test "ソート済みリストから値を二分探索する" do
      assert SearchAlgorithms.binary_search([1, 2, 3, 5, 7, 8, 9], 5) == {:ok, 3}
    end

    test "先頭の値を見つける" do
      assert SearchAlgorithms.binary_search([1, 2, 3, 5, 7, 8, 9], 1) == {:ok, 0}
    end

    test "末尾の値を見つける" do
      assert SearchAlgorithms.binary_search([1, 2, 3, 5, 7, 8, 9], 9) == {:ok, 6}
    end

    test "値が見つからない場合に :not_found を返す" do
      assert SearchAlgorithms.binary_search([1, 2, 3, 5, 7, 8, 9], 4) == :not_found
    end
  end

  describe "hash_search/2" do
    test "ハッシュマップから値を検索する" do
      map = %{1 => "a", 2 => "b", 3 => "c"}
      assert SearchAlgorithms.hash_search(map, 2) == {:ok, "b"}
      assert SearchAlgorithms.hash_search(map, 4) == :not_found
    end
  end

  describe "ChainedHash" do
    test "値を追加して検索する" do
      hash = ChainedHash.new(13)
      hash = ChainedHash.add(hash, 1, "赤尾")
      hash = ChainedHash.add(hash, 14, "神崎")

      assert ChainedHash.search(hash, 1) == {:ok, "赤尾"}
      assert ChainedHash.search(hash, 14) == {:ok, "神崎"}
    end

    test "存在しないキーを検索すると :not_found を返す" do
      hash = ChainedHash.new(13)
      assert ChainedHash.search(hash, 100) == :not_found
    end

    test "重複キーの追加は既存値を保持する" do
      hash = ChainedHash.new(13)
      hash = ChainedHash.add(hash, 1, "赤尾")
      hash = ChainedHash.add(hash, 1, "重複")
      assert ChainedHash.search(hash, 1) == {:ok, "赤尾"}
    end

    test "キーを削除できる" do
      hash = ChainedHash.new(13)
      hash = ChainedHash.add(hash, 1, "赤尾")
      hash = ChainedHash.remove(hash, 1)
      assert ChainedHash.search(hash, 1) == :not_found
    end
  end

  describe "OpenHash" do
    test "値を追加して検索する" do
      hash = OpenHash.new(13)
      hash = OpenHash.add(hash, 1, "赤尾")
      hash = OpenHash.add(hash, 14, "神崎")

      assert OpenHash.search(hash, 1) == {:ok, "赤尾"}
      assert OpenHash.search(hash, 14) == {:ok, "神崎"}
    end

    test "存在しないキーを検索すると :not_found を返す" do
      hash = OpenHash.new(13)
      assert OpenHash.search(hash, 100) == :not_found
    end

    test "キーを削除できる" do
      hash = OpenHash.new(13)
      hash = OpenHash.add(hash, 1, "赤尾")
      hash = OpenHash.remove(hash, 1)
      assert OpenHash.search(hash, 1) == :not_found
    end

    test "削除後も衝突したキーを検索できる" do
      hash = OpenHash.new(13)
      hash = OpenHash.add(hash, 1, "赤尾")
      hash = OpenHash.add(hash, 14, "神崎")
      hash = OpenHash.remove(hash, 1)
      assert OpenHash.search(hash, 14) == {:ok, "神崎"}
    end
  end
end
