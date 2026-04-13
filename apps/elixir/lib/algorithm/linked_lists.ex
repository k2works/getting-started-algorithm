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

defmodule Algorithm.CursorList do
  @moduledoc "配列カーソルによるリスト実装（イミュータブル）"

  defstruct data: %{}, next: %{}, head: -1, size: 0, max: 0, deleted: []

  @doc "指定容量のカーソルリストを作成"
  def new(_capacity) do
    %__MODULE__{}
  end

  @doc "先頭に要素を挿入"
  def insert(%__MODULE__{} = cl, value) do
    idx = alloc_index(cl)

    %{cl |
      data: Map.put(cl.data, idx, value),
      next: Map.put(cl.next, idx, cl.head),
      head: idx,
      size: cl.size + 1,
      max: max(cl.max, idx + 1),
      deleted: tl_or_empty(cl.deleted)
    }
  end

  @doc "末尾に要素を追加"
  def append(%__MODULE__{head: -1} = cl, value) do
    insert(cl, value)
  end

  def append(%__MODULE__{} = cl, value) do
    idx = alloc_index(cl)
    last = find_last(cl, cl.head)

    %{cl |
      data: Map.put(cl.data, idx, value),
      next: Map.put(cl.next, idx, -1) |> Map.put(last, idx),
      size: cl.size + 1,
      max: max(cl.max, idx + 1),
      deleted: tl_or_empty(cl.deleted)
    }
  end

  @doc "値を指定して要素を削除"
  def delete(%__MODULE__{} = cl, value) do
    do_delete(cl, cl.head, -1, value)
  end

  @doc "値を検索し、見つかった場合はリスト内のインデックスを返す"
  def search(%__MODULE__{} = cl, value) do
    do_search(cl, cl.head, 0, value)
  end

  @doc "リストを Elixir リストに変換"
  def to_list(%__MODULE__{head: -1}), do: []

  def to_list(%__MODULE__{} = cl) do
    collect(cl, cl.head, []) |> Enum.reverse()
  end

  # --- private ---

  defp alloc_index(%__MODULE__{deleted: [idx | _]}), do: idx
  defp alloc_index(%__MODULE__{max: max}), do: max

  defp tl_or_empty([_ | rest]), do: rest
  defp tl_or_empty([]), do: []

  defp find_last(cl, idx) do
    next = Map.get(cl.next, idx, -1)
    if next == -1, do: idx, else: find_last(cl, next)
  end

  defp collect(_cl, -1, acc), do: acc

  defp collect(cl, idx, acc) do
    collect(cl, Map.get(cl.next, idx, -1), [Map.get(cl.data, idx) | acc])
  end

  defp do_delete(cl, -1, _prev, _value), do: cl

  defp do_delete(cl, idx, prev, value) do
    if Map.get(cl.data, idx) == value do
      next_idx = Map.get(cl.next, idx, -1)

      cl =
        if prev == -1 do
          %{cl | head: next_idx}
        else
          %{cl | next: Map.put(cl.next, prev, next_idx)}
        end

      %{cl |
        size: cl.size - 1,
        deleted: [idx | cl.deleted]
      }
    else
      do_delete(cl, Map.get(cl.next, idx, -1), idx, value)
    end
  end

  defp do_search(_cl, -1, _pos, _value), do: :not_found

  defp do_search(cl, idx, pos, value) do
    if Map.get(cl.data, idx) == value do
      {:ok, pos}
    else
      do_search(cl, Map.get(cl.next, idx, -1), pos + 1, value)
    end
  end
end

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
