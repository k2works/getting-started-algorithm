defmodule Algorithm.Recursion do
  @moduledoc """
  再帰アルゴリズム
  """

  @doc "階乗（末尾再帰）"
  def factorial(n), do: factorial(n, 1)
  defp factorial(0, acc), do: acc
  defp factorial(n, acc), do: factorial(n - 1, n * acc)

  @doc "最大公約数（ユークリッドの互除法）"
  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))

  @doc "ハノイの塔"
  def hanoi(n, from, to) do
    aux = determine_aux(from, to)
    do_hanoi(n, from, to, aux)
  end

  defp determine_aux(from, to) do
    ["A", "B", "C"]
    |> Enum.reject(&(&1 == from or &1 == to))
    |> hd()
  end

  defp do_hanoi(1, from, to, _aux), do: [{from, to}]

  defp do_hanoi(n, from, to, aux) do
    do_hanoi(n - 1, from, aux, to) ++ [{from, to}] ++ do_hanoi(n - 1, aux, to, from)
  end

  @doc "真に再帰的な関数"
  def recure(n), do: do_recure(n, []) |> Enum.reverse()

  defp do_recure(n, acc) when n <= 0, do: acc

  defp do_recure(n, acc) do
    acc = do_recure(n - 1, acc)
    acc = [n | acc]
    do_recure(n - 2, acc)
  end

  @doc "迷路探索（バックトラッキング）"
  def maze_solve(maze, start, goal) do
    do_maze_solve(maze, start, goal, MapSet.new())
  end

  defp do_maze_solve(_maze, pos, goal, _visited) when pos == goal, do: true

  defp do_maze_solve(maze, {row, col}, goal, visited) do
    visited = MapSet.put(visited, {row, col})

    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.any?(fn {dr, dc} ->
      nr = row + dr
      nc = col + dc

      nr >= 0 and nr < length(maze) and
        nc >= 0 and nc < length(hd(maze)) and
        Enum.at(Enum.at(maze, nr), nc) == 0 and
        not MapSet.member?(visited, {nr, nc}) and
        do_maze_solve(maze, {nr, nc}, goal, visited)
    end)
  end

  @doc "8 クイーン問題"
  def eight_queens do
    solve_queens(8, 0, [])
  end

  defp solve_queens(n, row, placed) when row == n, do: [placed]

  defp solve_queens(n, row, placed) do
    0..(n - 1)
    |> Enum.filter(&safe?(&1, row, placed))
    |> Enum.flat_map(&solve_queens(n, row + 1, placed ++ [{row, &1}]))
  end

  defp safe?(col, row, placed) do
    Enum.all?(placed, fn {r, c} ->
      c != col and abs(c - col) != abs(r - row)
    end)
  end
end
