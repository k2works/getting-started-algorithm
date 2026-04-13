defmodule Algorithm.BasicAlgorithms do
  @moduledoc """
  基本的なアルゴリズム
  """

  @doc "3 つの値のうち最大値を返す"
  def max3(a, b, c) do
    a |> max(b) |> max(c)
  end

  @doc "3 つの値のうち中央値を返す"
  def mid3(a, b, c) do
    [a, b, c] |> Enum.sort() |> Enum.at(1)
  end
end
