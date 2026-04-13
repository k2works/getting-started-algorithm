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
