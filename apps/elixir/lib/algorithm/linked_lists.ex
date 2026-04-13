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
