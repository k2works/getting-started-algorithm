defmodule Algorithm.Stack do
  @moduledoc "Agent ベースのスタック"

  def new, do: Agent.start_link(fn -> [] end)

  def push(pid, value), do: Agent.update(pid, fn s -> [value | s] end)

  def pop(pid) do
    Agent.get_and_update(pid, fn
      [] -> {:empty, []}
      [h | t] -> {{:ok, h}, t}
    end)
  end

  def peek(pid) do
    Agent.get(pid, fn
      [] -> :empty
      [h | _] -> {:ok, h}
    end)
  end

  def empty?(pid), do: Agent.get(pid, &(&1 == []))
end

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

  def empty?(pid), do: Agent.get(pid, fn {f, r} -> f == [] and r == [] end)
end
