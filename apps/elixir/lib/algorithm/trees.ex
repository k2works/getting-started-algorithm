defmodule Algorithm.BinarySearchTree do
  @moduledoc "二分探索木（イミュータブル実装）"

  defstruct [:value, :left, :right]

  @doc "空の BST を作成"
  def new, do: nil

  @doc "値を挿入"
  def insert(nil, value), do: %__MODULE__{value: value, left: nil, right: nil}

  def insert(%__MODULE__{value: v} = tree, value) when value < v,
    do: %{tree | left: insert(tree.left, value)}

  def insert(%__MODULE__{value: v} = tree, value) when value > v,
    do: %{tree | right: insert(tree.right, value)}

  def insert(tree, _value), do: tree

  @doc "値の存在確認"
  def member?(nil, _value), do: false
  def member?(%__MODULE__{value: v}, value) when v == value, do: true

  def member?(%__MODULE__{value: v, left: left}, value) when value < v,
    do: member?(left, value)

  def member?(%__MODULE__{right: right}, value), do: member?(right, value)

  @doc "中順走査（昇順）"
  def in_order(nil), do: []

  def in_order(%__MODULE__{value: v, left: l, right: r}),
    do: in_order(l) ++ [v] ++ in_order(r)

  @doc "前順走査"
  def pre_order(nil), do: []

  def pre_order(%__MODULE__{value: v, left: l, right: r}),
    do: [v] ++ pre_order(l) ++ pre_order(r)

  @doc "後順走査"
  def post_order(nil), do: []

  def post_order(%__MODULE__{value: v, left: l, right: r}),
    do: post_order(l) ++ post_order(r) ++ [v]
end
