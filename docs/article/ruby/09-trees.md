# 第 9 章 木構造

## はじめに

木（Tree）は、ノードと枝（エッジ）からなる階層的なデータ構造です。この章では、二分探索木（BST）を TDD で実装します。

---

## 1. 二分探索木（Binary Search Tree）

**BST の性質**：
- 左部分木のすべてのキー < ルートのキー
- 右部分木のすべてのキー > ルートのキー
- 左右の部分木もまた二分探索木

### ノードクラス

```ruby
class BSTNode
  attr_accessor :key, :left, :right

  def initialize(key)
    @key = key
    @left = nil
    @right = nil
  end
end
```

### Red — テストを書く

```ruby
describe "Algorithm::BinarySearchTree" do
  let(:bst) do
    tree = Algorithm::BinarySearchTree.new
    [5, 3, 7, 1, 4, 6, 8].each { |k| tree.insert(k) }
    tree
  end

  it "挿入と探索" do
    expect(bst.search(5).key).to eq(5)
    expect(bst.search(99)).to be nil
  end

  it "中順探索（昇順）" do
    expect(bst.inorder).to eq([1, 3, 4, 5, 6, 7, 8])
  end

  it "ルートノードの削除" do
    bst.delete(5)
    expect(bst.include?(5)).to be false
    expect(bst.inorder).to eq([1, 3, 4, 6, 7, 8])
  end
end
```

### Green — 実装

```ruby
class BinarySearchTree
  class Empty < StandardError; end

  def initialize
    @root = nil
    @no = 0
  end

  def search(key)
    ptr = @root
    while ptr
      return ptr if key == ptr.key
      ptr = key < ptr.key ? ptr.left : ptr.right
    end
    nil
  end

  def insert(key)
    if @root.nil?
      @root = BSTNode.new(key)
      @no += 1
      return
    end

    ptr = @root
    loop do
      return if key == ptr.key  # 重複は無視

      if key < ptr.key
        if ptr.left.nil?
          ptr.left = BSTNode.new(key)
          @no += 1
          return
        end
        ptr = ptr.left
      else
        if ptr.right.nil?
          ptr.right = BSTNode.new(key)
          @no += 1
          return
        end
        ptr = ptr.right
      end
    end
  end

  def delete(key)
    parent = nil
    ptr = @root
    is_left_child = false

    # 削除対象を探す
    while ptr
      break if key == ptr.key
      parent = ptr
      if key < ptr.key
        is_left_child = true
        ptr = ptr.left
      else
        is_left_child = false
        ptr = ptr.right
      end
    end

    return if ptr.nil?
    @no -= 1

    if ptr.left.nil? && ptr.right.nil?
      replace_node(parent, is_left_child, nil)
    elsif ptr.right.nil?
      replace_node(parent, is_left_child, ptr.left)
    elsif ptr.left.nil?
      replace_node(parent, is_left_child, ptr.right)
    else
      # 右部分木の最小ノードで置き換え
      successor_parent = ptr
      successor = ptr.right
      while successor.left
        successor_parent = successor
        successor = successor.left
      end
      ptr.key = successor.key
      if successor_parent.equal?(ptr)
        successor_parent.right = successor.right
      else
        successor_parent.left = successor.right
      end
      @no += 1
    end
  end

  def inorder
    result = []
    _inorder(@root, result)
    result
  end

  def preorder
    result = []
    _preorder(@root, result)
    result
  end

  def postorder
    result = []
    _postorder(@root, result)
    result
  end

  def min
    raise Empty if @root.nil?
    ptr = @root
    ptr = ptr.left while ptr.left
    ptr.key
  end

  def max
    raise Empty if @root.nil?
    ptr = @root
    ptr = ptr.right while ptr.right
    ptr.key
  end

  private

  def replace_node(parent, is_left_child, new_node)
    if parent.nil?
      @root = new_node
    elsif is_left_child
      parent.left = new_node
    else
      parent.right = new_node
    end
  end

  def _inorder(node, result)
    return if node.nil?
    _inorder(node.left, result)
    result << node.key
    _inorder(node.right, result)
  end

  def _preorder(node, result)
    return if node.nil?
    result << node.key
    _preorder(node.left, result)
    _preorder(node.right, result)
  end

  def _postorder(node, result)
    return if node.nil?
    _postorder(node.left, result)
    _postorder(node.right, result)
    result << node.key
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| プライベートメソッド | `_` プレフィックス慣習 | `private` キーワード |
| 同一性チェック | `successor_parent is ptr` | `successor_parent.equal?(ptr)` |
| `None` | `None` | `nil` |
| 再帰探索 | `_inorder(node, result)` | `_inorder(node, result)` |

Ruby では `private` キーワード以下のメソッドがプライベートになります（Python の `_` プレフィックス慣習とは異なります）。

---

## 木の走査

```plantuml
@startuml
title 二分探索木の走査

digraph bst {
  5 -> 3
  5 -> 7
  3 -> 1
  3 -> 4
  7 -> 6
  7 -> 8
}

note right
  中順（Inorder）: 1, 3, 4, 5, 6, 7, 8（昇順）
  前順（Preorder）: 5, 3, 1, 4, 7, 6, 8
  後順（Postorder）: 1, 4, 3, 6, 8, 7, 5
end note
@enduml
```

---

## まとめ

| 操作 | 計算量（平均） | 計算量（最悪） |
|------|--------------|--------------|
| 探索 | O(log n) | O(n) |
| 挿入 | O(log n) | O(n) |
| 削除 | O(log n) | O(n) |
| 中順走査 | O(n) | O(n) |

最悪計算量が O(n) になるのは木が偏った場合（昇順でデータを挿入した場合など）です。AVL 木や赤黒木による平衡化で O(log n) を保証できます。

### Ruby の特徴

- `private` キーワードで以下のメソッドをプライベート化
- `node.equal?(other)` でオブジェクトの同一性チェック（`==` は値比較）
- `while ptr.left` で `nil` 以外の間ループ（Truthy/Falsy の活用）
- `result << node.key` で配列への末尾追加
