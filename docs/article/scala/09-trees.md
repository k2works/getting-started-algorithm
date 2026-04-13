# 第 9 章 木構造

## はじめに

この章では二分探索木（BST）を Scala で実装します。Scala の型クラス `Ordering[T]` を活用した汎用実装です。

## 木構造とは

木構造とは、ノードとエッジで構成される階層的なデータ構造です。

基本用語：

- **ルート（root）**: 木の最上位ノード
- **葉（leaf）**: 子を持たないノード
- **高さ（height）**: ルートから最も深い葉までのエッジ数

二分探索木（BST）は「左部分木のキー < 親キー < 右部分木のキー」という性質を持ちます。

---

## 1. 二分探索木

### ノード型の定義

```scala
class BinarySearchTree[T: Ordering]:
  import Ordering.Implicits.*

  private class Node(var key: T, var left: Node | Null = null, var right: Node | Null = null)
  private var root: Node | Null = null
```

`[T: Ordering]` は「T が Ordering 型クラスを持つ」というコンテキスト境界です。

### 挿入（Insert）

```scala
def insert(key: T): Unit =
  if root == null then { root = Node(key); _size += 1; return }
  var ptr = root
  while true do
    val cmp = summon[Ordering[T]].compare(key, ptr.key)
    if cmp == 0 then return  // 重複は無視
    if cmp < 0 then
      if ptr.left == null then { ptr.left = Node(key); _size += 1; return }
      ptr = ptr.left
    else
      if ptr.right == null then { ptr.right = Node(key); _size += 1; return }
      ptr = ptr.right
```

---

## 2. 走査（Traversal）

### 中順走査（In-Order）— 昇順出力

```scala
def inOrder(): List[T] =
  val result = ArrayBuffer[T]()
  def traverse(n: Node | Null): Unit =
    if n != null then
      traverse(n.left); result += n.key; traverse(n.right)
  traverse(root)
  result.toList
```

中順走査の結果は常に昇順になります。

### 前順走査（Pre-Order）

```scala
def preOrder(): List[T] =
  // 自分 → 左 → 右
```

### 後順走査（Post-Order）

```scala
def postOrder(): List[T] =
  // 左 → 右 → 自分
```

---

## テスト実行結果

```
Tests: succeeded 12, failed 0
```

## まとめ

| 操作 | 平均計算量 | 最悪計算量 | 前提条件 |
|------|-----------|-----------|---------|
| 探索 | O(log n) | O(n) | BST 性質を満たすこと |
| 挿入 | O(log n) | O(n) | BST 性質を満たすこと |
| 削除 | O(log n) | O(n) | BST 性質を満たすこと |
| 中順走査 | O(n) | O(n) | なし |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
