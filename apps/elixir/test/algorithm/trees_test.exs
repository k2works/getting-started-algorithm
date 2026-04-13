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
  end
end
