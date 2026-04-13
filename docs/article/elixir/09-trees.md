# 第 9 章 木構造

## はじめに

この章では、二分探索木（Binary Search Tree, BST）を TDD で実装します。Elixir のイミュータブルなデータ構造と再帰・パターンマッチを活用して、木構造の操作を簡潔に表現します。

木構造は、階層的なデータを表現するためのデータ構造です。二分探索木は、各ノードが最大 2 つの子ノードを持ち、左の子ノードは親より小さく、右の子ノードは親より大きいという制約を持ちます。

---

## 1. 二分探索木の定義

### Elixir の構造体（defstruct）で定義

```elixir
# lib/algorithm/trees.ex
defmodule Algorithm.BinarySearchTree do
  @moduledoc "二分探索木（イミュータブル実装）"

  defstruct [:value, :left, :right]

  @doc "空の BST を作成"
  def new, do: nil
end
```

`defstruct` で `value`、`left`、`right` の 3 つのフィールドを持つ構造体を定義します。空の木は `nil` で表現します。

---

## 2. 挿入

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/trees_test.exs
defmodule Algorithm.TreesTest do
  use ExUnit.Case
  alias Algorithm.BinarySearchTree, as: BST

  describe "BinarySearchTree" do
    test "insert と member? が正しく動作する" do
      tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
      assert BST.member?(tree, 3) == true
      assert BST.member?(tree, 4) == false
    end
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "値を挿入"
def insert(nil, value),
  do: %__MODULE__{value: value, left: nil, right: nil}

def insert(%__MODULE__{value: v} = tree, value) when value < v,
  do: %{tree | left: insert(tree.left, value)}

def insert(%__MODULE__{value: v} = tree, value) when value > v,
  do: %{tree | right: insert(tree.right, value)}

def insert(tree, _value), do: tree
```

### Refactor -- イミュータブルな木操作

Elixir のデータはすべてイミュータブルであるため、`insert` は既存の木を変更せず、新しい木を返します。`%{tree | left: ...}` は構造体の更新構文で、指定したフィールドだけが変更された新しい構造体を作成します。

パターンマッチの活用：

1. `nil` への挿入: 新しい葉ノードを作成
2. 値が小さい場合: 左部分木に再帰的に挿入
3. 値が大きい場合: 右部分木に再帰的に挿入
4. 値が等しい場合: 変更なし（重複を許さない）

---

## 3. 存在確認

```elixir
@doc "値の存在確認"
def member?(nil, _value), do: false
def member?(%__MODULE__{value: v}, value) when v == value, do: true
def member?(%__MODULE__{value: v, left: left}, value) when value < v,
  do: member?(left, value)
def member?(%__MODULE__{right: right}, value),
  do: member?(right, value)
```

関数頭部のパターンマッチとガード節で、4 つのケースを明確に分岐しています。

---

## 4. 走査（Traversal）

木構造の全ノードを訪問する方法には、中順（in-order）、前順（pre-order）、後順（post-order）の 3 種類があります。

### Red -- 失敗するテストを書く

```elixir
test "in_order で昇順に走査する" do
  tree =
    BST.new()
    |> BST.insert(5)
    |> BST.insert(3)
    |> BST.insert(7)
    |> BST.insert(1)
    |> BST.insert(4)

  assert BST.in_order(tree) == [1, 3, 4, 5, 7]
end

test "pre_order で前順に走査する" do
  tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
  assert BST.pre_order(tree) == [5, 3, 7]
end

test "post_order で後順に走査する" do
  tree = BST.new() |> BST.insert(5) |> BST.insert(3) |> BST.insert(7)
  assert BST.post_order(tree) == [3, 7, 5]
end
```

### Green -- テストを通す最小限の実装

```elixir
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
```

### Refactor -- 走査の違い

3 種類の走査は、現在のノードの値 `v` をリストに追加するタイミングだけが異なります：

| 走査 | 順序 | 用途 |
|------|------|------|
| 中順（in-order） | 左 → 自分 → 右 | BST の値を昇順に取得 |
| 前順（pre-order） | 自分 → 左 → 右 | 木のコピー |
| 後順（post-order） | 左 → 右 → 自分 | 木の削除（子を先に処理） |

BST の中順走査は必ず昇順になるため、ソートされたデータの取得に使えます。

---

## 5. パイプ演算子による木の構築

Elixir のパイプ演算子 `|>` を使うと、木の構築が非常に読みやすくなります。

```elixir
tree =
  BST.new()
  |> BST.insert(5)
  |> BST.insert(3)
  |> BST.insert(7)
  |> BST.insert(1)
  |> BST.insert(4)
```

各 `insert` は新しい木を返すので、パイプで次の `insert` に渡せます。これはイミュータブルデータとパイプ演算子の組み合わせの美しい例です。

---

## 計算量

| 操作 | 平均 | 最悪（偏った木） |
|------|------|-----------------|
| 挿入 | O(log n) | O(n) |
| 検索 | O(log n) | O(n) |
| 走査 | O(n) | O(n) |

最悪ケースは、挿入順がソート済みの場合に発生し、木が偏ってリスト状になります。平衡二分木（AVL 木、赤黒木）を使えば最悪でも O(log n) を保証できます。

---

## まとめ

この章では、二分探索木を Elixir で TDD 実装しました。

- **`defstruct`**: 木のノードを構造体で定義
- **パターンマッチ**: `nil`（空の木）と `%__MODULE__{}` の分岐
- **イミュータブルな木操作**: `%{tree | left: ...}` による構造体更新
- **パイプ演算子 `|>`**: 木の構築を読みやすく表現
- **3 種類の走査**: 再帰とリスト連結による簡潔な実装

Elixir の関数型スタイルは、木構造のような再帰的なデータ構造と非常に相性が良いことがわかります。パターンマッチと再帰の組み合わせで、木の操作を宣言的に記述できます。
