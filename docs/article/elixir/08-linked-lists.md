# 第 8 章 リスト

## はじめに

この章では、連結リスト（Linked List）のデータ構造を TDD で実装します。Elixir の組み込みリストは既に連結リストとして実装されていますが、ここでは `Agent` を使って可変状態を持つリスト操作を明示的に実装し、データ構造の概念を学びます。

---

## 1. 単方向連結リスト

各ノードがデータと次のノードへの参照を持つ、最も基本的な連結リストです。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/linked_lists_test.exs
defmodule Algorithm.LinkedListsTest do
  use ExUnit.Case
  alias Algorithm.LinkedList

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
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/linked_lists.ex
defmodule Algorithm.LinkedList do
  @moduledoc "Agent ベースの単方向連結リスト"

  def new, do: Agent.start_link(fn -> [] end)

  def append(pid, value),
    do: Agent.update(pid, fn list -> list ++ [value] end)

  def prepend(pid, value),
    do: Agent.update(pid, fn list -> [value | list] end)

  def remove(pid, value),
    do: Agent.update(pid, fn list -> List.delete(list, value) end)

  def search(pid, value) do
    Agent.get(pid, fn list ->
      case Enum.find_index(list, &(&1 == value)) do
        nil -> :not_found
        idx -> {:ok, idx}
      end
    end)
  end

  def to_list(pid), do: Agent.get(pid, & &1)
end
```

### Refactor -- Agent による状態管理

`Agent` プロセスが内部状態としてリストを保持し、各操作は `Agent.update/2` や `Agent.get/2` を通じて状態を変更・取得します。

- **`append`**: `list ++ [value]` で末尾に追加（O(n)）
- **`prepend`**: `[value | list]` で先頭に追加（O(1)）
- **`remove`**: `List.delete/2` で最初に一致する要素を削除

### 計算量

| 操作 | 計算量 |
|------|--------|
| prepend | O(1) |
| append | O(n) |
| remove | O(n) |
| search | O(n) |

---

## 2. 双方向連結リスト

各ノードが前後両方のノードへの参照を持つリストです。

### Red -- 失敗するテストを書く

```elixir
alias Algorithm.DoublyLinkedList

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
```

### Green -- テストを通す最小限の実装

```elixir
defmodule Algorithm.DoublyLinkedList do
  @moduledoc "Agent ベースの双方向連結リスト（内部はリストで表現）"

  def new, do: Agent.start_link(fn -> [] end)

  def append(pid, value),
    do: Agent.update(pid, fn list -> list ++ [value] end)

  def prepend(pid, value),
    do: Agent.update(pid, fn list -> [value | list] end)

  def remove(pid, value),
    do: Agent.update(pid, fn list -> List.delete(list, value) end)

  def to_list(pid), do: Agent.get(pid, & &1)
end
```

### Refactor -- Elixir での連結リストの考え方

Elixir の組み込みリストは既に単方向連結リストとして実装されています。双方向連結リストは、命令型言語のようにポインタ操作で実装するのではなく、`Agent` + リストの抽象化で表現しています。

実際の Elixir アプリケーションでは、双方向の走査が必要な場合は `:queue` モジュール（Erlang 標準ライブラリ）を使うか、リストの反転を組み合わせて対応します。

---

## 3. Elixir のリスト操作パターン

Elixir の組み込みリストで使える主要な操作をまとめます。

```elixir
# 先頭への追加（O(1)）
[0 | [1, 2, 3]]
# => [0, 1, 2, 3]

# パターンマッチによる分解
[head | tail] = [1, 2, 3]
# head => 1, tail => [2, 3]

# Enum モジュールによる操作
Enum.map([1, 2, 3], &(&1 * 2))     # => [2, 4, 6]
Enum.filter([1, 2, 3], &(&1 > 1))  # => [2, 3]
Enum.reduce([1, 2, 3], 0, &+/2)    # => 6

# リスト内包表記
for x <- [1, 2, 3], x > 1, do: x * 2
# => [4, 6]
```

---

## まとめ

この章では、連結リストのデータ構造を TDD で実装しました。

- **`Agent`**: 可変状態の管理に使用
- **`[value | list]`**: リストの先頭への追加（cons 操作、O(1)）
- **`list ++ [value]`**: リストの末尾への追加（O(n)）
- **`List.delete/2`**: 要素の削除

Elixir では、リスト操作は先頭への追加が最も効率的です。パフォーマンスが重要な場合は、先頭への追加を使い、最後に `Enum.reverse/1` で反転するパターンがよく使われます。
