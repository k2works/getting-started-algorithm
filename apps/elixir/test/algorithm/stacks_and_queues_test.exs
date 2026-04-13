defmodule Algorithm.StacksAndQueuesTest do
  use ExUnit.Case
  alias Algorithm.Stack
  alias Algorithm.Queue

  describe "Stack" do
    test "push と pop が正しく動作する" do
      {:ok, stack} = Stack.new()
      Stack.push(stack, 1)
      Stack.push(stack, 2)
      Stack.push(stack, 3)
      assert Stack.pop(stack) == {:ok, 3}
      assert Stack.pop(stack) == {:ok, 2}
    end

    test "空スタックの pop は :empty を返す" do
      {:ok, stack} = Stack.new()
      assert Stack.pop(stack) == :empty
    end
  end

  describe "Queue" do
    test "enqueue と dequeue が正しく動作する" do
      {:ok, q} = Queue.new()
      Queue.enqueue(q, 1)
      Queue.enqueue(q, 2)
      Queue.enqueue(q, 3)
      assert Queue.dequeue(q) == {:ok, 1}
      assert Queue.dequeue(q) == {:ok, 2}
    end

    test "空キューの dequeue は :empty を返す" do
      {:ok, q} = Queue.new()
      assert Queue.dequeue(q) == :empty
    end
  end
end
