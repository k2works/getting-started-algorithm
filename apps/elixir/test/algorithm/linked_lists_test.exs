defmodule Algorithm.LinkedListsTest do
  use ExUnit.Case
  alias Algorithm.LinkedList
  alias Algorithm.DoublyLinkedList

  describe "LinkedList" do
    test "append と to_list が正しく動作する" do
      {:ok, list} = LinkedList.new()
      LinkedList.append(list, 1)
      LinkedList.append(list, 2)
      LinkedList.append(list, 3)
      assert LinkedList.to_list(list) == [1, 2, 3]
    end

    test "remove で要素を削除できる" do
      {:ok, list} = LinkedList.new()
      LinkedList.append(list, 1)
      LinkedList.append(list, 2)
      LinkedList.append(list, 3)
      LinkedList.remove(list, 2)
      assert LinkedList.to_list(list) == [1, 3]
    end
  end

  describe "LinkedList - 追加テスト" do
    test "prepend で先頭に追加できる" do
      {:ok, list} = LinkedList.new()
      LinkedList.append(list, 2)
      LinkedList.append(list, 3)
      LinkedList.prepend(list, 1)
      assert LinkedList.to_list(list) == [1, 2, 3]
    end

    test "search で要素を検索できる" do
      {:ok, list} = LinkedList.new()
      LinkedList.append(list, 10)
      LinkedList.append(list, 20)
      assert LinkedList.search(list, 20) == {:ok, 1}
    end

    test "search で見つからない場合 :not_found を返す" do
      {:ok, list} = LinkedList.new()
      LinkedList.append(list, 10)
      assert LinkedList.search(list, 99) == :not_found
    end
  end

  alias Algorithm.CursorList

  describe "CursorList" do
    test "新しいカーソルリストを作成できる" do
      cl = CursorList.new(10)
      assert CursorList.to_list(cl) == []
    end

    test "insert で先頭に要素を追加できる" do
      cl = CursorList.new(10) |> CursorList.insert(1) |> CursorList.insert(2)
      assert CursorList.to_list(cl) == [2, 1]
    end

    test "append で末尾に要素を追加できる" do
      cl = CursorList.new(10) |> CursorList.append(1) |> CursorList.append(2)
      assert CursorList.to_list(cl) == [1, 2]
    end

    test "delete で要素を削除できる" do
      cl =
        CursorList.new(10)
        |> CursorList.append(1)
        |> CursorList.append(2)
        |> CursorList.append(3)
        |> CursorList.delete(2)

      assert CursorList.to_list(cl) == [1, 3]
    end

    test "search で要素を検索できる" do
      cl = CursorList.new(10) |> CursorList.append(10) |> CursorList.append(20)
      assert CursorList.search(cl, 20) == {:ok, 1}
    end

    test "search で見つからない場合 :not_found を返す" do
      cl = CursorList.new(10) |> CursorList.append(10)
      assert CursorList.search(cl, 99) == :not_found
    end
  end

  describe "DoublyLinkedList" do
    test "append と to_list が正しく動作する" do
      {:ok, dll} = DoublyLinkedList.new()
      DoublyLinkedList.append(dll, 1)
      DoublyLinkedList.append(dll, 2)
      DoublyLinkedList.append(dll, 3)
      assert DoublyLinkedList.to_list(dll) == [1, 2, 3]
    end

    test "prepend で先頭に追加できる" do
      {:ok, dll} = DoublyLinkedList.new()
      DoublyLinkedList.append(dll, 2)
      DoublyLinkedList.append(dll, 3)
      DoublyLinkedList.prepend(dll, 1)
      assert DoublyLinkedList.to_list(dll) == [1, 2, 3]
    end
  end
end
