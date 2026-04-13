defmodule Algorithm.StacksAndQueuesTest do
  use ExUnit.Case
  alias Algorithm.Stack
  alias Algorithm.Queue

  describe "Stack" do
    test "初期状態は空である" do
      {:ok, stack} = Stack.new()
      assert Stack.empty?(stack) == true
    end

    test "push と pop が正しく動作する（LIFO）" do
      {:ok, stack} = Stack.new()
      Stack.push(stack, 1)
      Stack.push(stack, 2)
      Stack.push(stack, 3)
      assert Stack.pop(stack) == {:ok, 3}
      assert Stack.pop(stack) == {:ok, 2}
      assert Stack.pop(stack) == {:ok, 1}
    end

    test "空スタックの pop は :empty を返す" do
      {:ok, stack} = Stack.new()
      assert Stack.pop(stack) == :empty
    end

    test "peek は頂上の値を参照するが取り出さない" do
      {:ok, stack} = Stack.new()
      Stack.push(stack, 1)
      Stack.push(stack, 2)
      assert Stack.peek(stack) == {:ok, 2}
      # peek 後もスタックの状態は変わらない
      assert Stack.peek(stack) == {:ok, 2}
    end

    test "空スタックの peek は :empty を返す" do
      {:ok, stack} = Stack.new()
      assert Stack.peek(stack) == :empty
    end

    test "push 後は空でない" do
      {:ok, stack} = Stack.new()
      Stack.push(stack, 42)
      assert Stack.empty?(stack) == false
    end
  end

  describe "Queue" do
    test "初期状態は空である" do
      {:ok, q} = Queue.new()
      assert Queue.empty?(q) == true
    end

    test "enqueue と dequeue が正しく動作する（FIFO）" do
      {:ok, q} = Queue.new()
      Queue.enqueue(q, 1)
      Queue.enqueue(q, 2)
      Queue.enqueue(q, 3)
      assert Queue.dequeue(q) == {:ok, 1}
      assert Queue.dequeue(q) == {:ok, 2}
      assert Queue.dequeue(q) == {:ok, 3}
    end

    test "空キューの dequeue は :empty を返す" do
      {:ok, q} = Queue.new()
      assert Queue.dequeue(q) == :empty
    end

    test "enqueue 後は空でない" do
      {:ok, q} = Queue.new()
      Queue.enqueue(q, 42)
      assert Queue.empty?(q) == false
    end

    test "dequeue と enqueue を交互に実行できる" do
      {:ok, q} = Queue.new()
      Queue.enqueue(q, 1)
      Queue.enqueue(q, 2)
      assert Queue.dequeue(q) == {:ok, 1}
      Queue.enqueue(q, 3)
      assert Queue.dequeue(q) == {:ok, 2}
      assert Queue.dequeue(q) == {:ok, 3}
    end
  end
end
