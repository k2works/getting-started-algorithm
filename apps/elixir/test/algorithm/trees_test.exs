defmodule Algorithm.TreesTest do
  use ExUnit.Case
  alias Algorithm.BinarySearchTree, as: BST

  describe "BinarySearchTree" do
    test "insert と member? が正しく動作する" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      assert BST.member?(tree, 3) == true
      assert BST.member?(tree, 4) == false
    end

    test "in_order で昇順に走査する" do
      tree =
        BST.new()
        |> BST.insert(5)
        |> BST.insert(3)
        |> BST.insert(7)
        |> BST.insert(1)
        |> BST.insert(4)

      assert BST.in_order(tree) == [1, 3, 4, 5, 7]
    end

    test "pre_order で前順に走査する" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      assert BST.pre_order(tree) == [5, 3, 7]
    end

    test "post_order で後順に走査する" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      assert BST.post_order(tree) == [3, 7, 5]
    end

    test "delete で葉ノードを削除できる" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      tree = BST.delete(tree, 3)
      assert BST.member?(tree, 3) == false
      assert BST.in_order(tree) == [5, 7]
    end

    test "delete で子が 1 つのノードを削除できる" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7) |> BST.insert(1)
      tree = BST.delete(tree, 3)
      assert BST.member?(tree, 3) == false
      assert BST.in_order(tree) == [1, 5, 7]
    end

    test "delete で子が 2 つのノードを削除できる" do
      tree =
        BST.new()
        |> BST.insert(5)
        |> BST.insert(3)
        |> BST.insert(7)
        |> BST.insert(1)
        |> BST.insert(4)

      tree = BST.delete(tree, 3)
      assert BST.member?(tree, 3) == false
      assert BST.in_order(tree) == [1, 4, 5, 7]
    end

    test "delete で存在しない値を指定すると木は変わらない" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3)
      tree = BST.delete(tree, 99)
      assert BST.in_order(tree) == [3, 5]
    end

    test "delete でルートノードを削除できる" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      tree = BST.delete(tree, 5)
      assert BST.member?(tree, 5) == false
      assert BST.in_order(tree) == [3, 7]
    end

    test "find_min で最小値を取得できる" do
      tree =
        BST.new()
        |> BST.insert(5)
        |> BST.insert(3)
        |> BST.insert(7)
        |> BST.insert(1)

      assert BST.find_min(tree) == 1
    end

    test "find_max で最大値を取得できる" do
      tree =
        BST.new()
        |> BST.insert(5)
        |> BST.insert(3)
        |> BST.insert(7)
        |> BST.insert(8)

      assert BST.find_max(tree) == 8
    end
  end
end
