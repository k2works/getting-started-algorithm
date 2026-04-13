# 第 4 章 スタックとキュー

## はじめに

スタックとキューは、データの追加と取り出しの順序に特徴を持つ基本的なデータ構造です。この章では、Elixir の `Agent` を使って可変状態を持つスタックとキューを TDD で実装します。

Elixir はすべてのデータが不変（イミュータブル）であるため、可変状態が必要な場合はプロセスを使います。`Agent` は、状態の読み書きを行うためのシンプルなプロセス抽象化です。

---

## 1. スタック（LIFO）

スタックは「後入れ先出し（Last In, First Out）」のデータ構造です。最後に追加した要素が最初に取り出されます。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/stacks_and_queues_test.exs
defmodule Algorithm.StacksAndQueuesTest do
  use ExUnit.Case
  alias Algorithm.Stack

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
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/stacks_and_queues.ex
defmodule Algorithm.Stack do
  @moduledoc "Agent ベースのスタック"

  def new, do: Agent.start_link(fn -> [] end)

  def push(pid, value),
    do: Agent.update(pid, fn s -> [value | s] end)

  def pop(pid) do
    Agent.get_and_update(pid, fn
      []       -> {:empty, []}
      [h | t]  -> {{:ok, h}, t}
    end)
  end

  def peek(pid) do
    Agent.get(pid, fn
      []      -> :empty
      [h | _] -> {:ok, h}
    end)
  end

  def empty?(pid), do: Agent.get(pid, &(&1 == []))
end
```

### Refactor -- Agent とパターンマッチ

`Agent.start_link/1` で空リスト `[]` を初期状態としたプロセスを起動します。スタックの状態はリストで表現し、先頭要素が最上部（top）に対応します。

`Agent.get_and_update/2` は、状態の読み取りと更新を 1 回のアトミック操作で行います。無名関数の中でパターンマッチを使い、空リストの場合と要素がある場合を分岐します。

### Elixir のパターンマッチ

```elixir
# リストの先頭と残りに分解
[head | tail] = [1, 2, 3]
# head => 1, tail => [2, 3]

# 空リストのマッチ
[] = []
```

---

## 2. キュー（FIFO）

キューは「先入れ先出し（First In, First Out）」のデータ構造です。最初に追加した要素が最初に取り出されます。

### Red -- 失敗するテストを書く

```elixir
alias Algorithm.Queue

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
```

### Green -- テストを通す最小限の実装

```elixir
defmodule Algorithm.Queue do
  @moduledoc "Agent ベースのキュー（front/rear リスト方式）"

  def new, do: Agent.start_link(fn -> {[], []} end)

  def enqueue(pid, value),
    do: Agent.update(pid, fn {front, rear} -> {front, [value | rear]} end)

  def dequeue(pid) do
    Agent.get_and_update(pid, fn
      {[], []} ->
        {:empty, {[], []}}

      {[], rear} ->
        [h | t] = Enum.reverse(rear)
        {{:ok, h}, {t, []}}

      {[h | t], rear} ->
        {{:ok, h}, {t, rear}}
    end)
  end

  def empty?(pid),
    do: Agent.get(pid, fn {f, r} -> f == [] and r == [] end)
end
```

### Refactor -- Banker's Queue

キューの内部状態を `{front, rear}` の 2 つのリストで管理しています。これは「Banker's Queue」と呼ばれる手法です。

- **enqueue**: `rear` リストの先頭に要素を追加（O(1)）
- **dequeue**: `front` リストの先頭から要素を取り出し（O(1)）
- `front` が空の場合: `rear` を反転して `front` にする（償却 O(1)）

単純なリストの末尾追加は O(n) ですが、2 つのリストを使うことで各操作を償却 O(1) に保てます。

---

## まとめ

この章では、スタックとキューを Elixir の `Agent` を使って TDD で実装しました。

- **`Agent`**: イミュータブルな Elixir で可変状態を扱うためのプロセス抽象化
- **パターンマッチ**: `fn` の中で複数のパターンを分岐
- **Banker's Queue**: 2 つのリストによる効率的なキュー実装
- **タプル `{:ok, value}` / `:empty`**: 結果の明示的な表現

Elixir のプロセスモデルは、並行プログラミングの基盤でもあります。`Agent` は最もシンプルなプロセス抽象化で、`GenServer` のより高度な機能を必要としない場合に適しています。
