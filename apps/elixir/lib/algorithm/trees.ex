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

  @doc "ノードの削除"
  def delete(nil, _value), do: nil

  def delete(%__MODULE__{value: v, left: l, right: r}, value) when value < v,
    do: %__MODULE__{value: v, left: delete(l, value), right: r}

  def delete(%__MODULE__{value: v, left: l, right: r}, value) when value > v,
    do: %__MODULE__{value: v, left: l, right: delete(r, value)}

  def delete(%__MODULE__{value: _v, left: nil, right: r}, _value), do: r
  def delete(%__MODULE__{value: _v, left: l, right: nil}, _value), do: l

  def delete(%__MODULE__{value: _v, left: l, right: r}, _value) do
    min_val = find_min(r)
    %__MODULE__{value: min_val, left: l, right: delete(r, min_val)}
  end

  @doc "最小値を取得"
  def find_min(nil), do: nil
  def find_min(%__MODULE__{left: nil, value: v}), do: v
  def find_min(%__MODULE__{left: l}), do: find_min(l)

  @doc "最大値を取得"
  def find_max(nil), do: nil
  def find_max(%__MODULE__{right: nil, value: v}), do: v
  def find_max(%__MODULE__{right: r}), do: find_max(r)

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
