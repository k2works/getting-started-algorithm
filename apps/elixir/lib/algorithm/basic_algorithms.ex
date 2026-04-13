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

  @doc "整数値の符号を判定する"
  def judge_sign(n) when n > 0, do: "その値は正です。"
  def judge_sign(n) when n < 0, do: "その値は負です。"
  def judge_sign(0), do: "その値は0です。"

  @doc "再帰で 1 から n までの総和を求める"
  def sum_1_to_n(1), do: 1
  def sum_1_to_n(n) when n > 1, do: n + sum_1_to_n(n - 1)

  @doc "Enum で 1 から n までの総和を求める"
  def sum_1_to_n_enum(n) do
    1..n |> Enum.sum()
  end

  @doc "記号文字 '+' と '-' を交互に表示する"
  def alternative(n) do
    0..(n - 1)
    |> Enum.map(fn i -> if rem(i, 2) == 0, do: "+", else: "-" end)
    |> Enum.join()
  end

  @doc "縦横が整数で面積が area の長方形の辺の長さを列挙する"
  def rectangle(area) do
    1..area
    |> Enum.reduce_while("", fn i, acc ->
      cond do
        i * i > area -> {:halt, acc}
        rem(area, i) == 0 -> {:cont, acc <> "#{i}x#{div(area, i)} "}
        true -> {:cont, acc}
      end
    end)
  end

  @doc "九九の表を返す"
  def multiplication_table do
    header = String.duplicate("-", 27) <> "\n"

    body =
      for i <- 1..9, into: "" do
        row = for j <- 1..9, into: "", do: String.pad_leading("#{i * j}", 3)
        row <> "\n"
      end

    footer = String.duplicate("-", 27)
    header <> body <> footer
  end

  @doc "左下側が直角の二等辺三角形を返す"
  def triangle_lb(n) do
    for i <- 1..n, into: "" do
      String.duplicate("*", i) <> "\n"
    end
  end
end
