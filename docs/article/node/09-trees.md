# 第 9 章 木構造

## はじめに

この章では **二分探索木（BST: Binary Search Tree）** を学びます。二分探索木は探索・挿入・削除が平均 O(log n) で行える効率的なデータ構造です。

---

## 二分探索木の性質

- 左部分木のすべてのキー < ルートのキー
- 右部分木のすべてのキー > ルートのキー
- 左右の部分木もまた二分探索木

---

## 1. ノードとクラス設計

### Red — 失敗するテストを書く

```typescript
test('挿入と検索', () => {
  bst.insert(5);
  expect(bst.search(5)?.key).toBe(5);
});
test('中順探索は昇順', () => {
  [5, 3, 7, 1, 4, 6, 8].forEach(v => bst.insert(v));
  expect(bst.inorder()).toEqual([1, 3, 4, 5, 6, 7, 8]);
});
```

### Green — 最小限の実装

```typescript
class BSTNode<T> {
  constructor(
    public key: T,
    public left: BSTNode<T> | null = null,
    public right: BSTNode<T> | null = null,
  ) {}
}

export class BinarySearchTree<T> {
  private root: BSTNode<T> | null = null;

  search(key: T): BSTNode<T> | null {
    let ptr = this.root;
    while (ptr !== null) {
      if (key === ptr.key) return ptr;
      ptr = key < ptr.key ? ptr.left : ptr.right;
    }
    return null;
  }
}
```

TypeScript の `<T>` によるジェネリクスで任意の型のキーを扱えます。

---

## 2. 挿入

```typescript
insert(key: T): void {
  if (this.root === null) { this.root = new BSTNode<T>(key); this.no++; return; }
  let ptr = this.root;
  while (true) {
    if (key === ptr.key) return; // 重複は無視
    if (key < ptr.key) {
      if (ptr.left === null) { ptr.left = new BSTNode<T>(key); this.no++; return; }
      ptr = ptr.left;
    } else {
      if (ptr.right === null) { ptr.right = new BSTNode<T>(key); this.no++; return; }
      ptr = ptr.right;
    }
  }
}
```

---

## 3. 削除

削除は 3 ケースに分かれます。

```typescript
delete(key: T): void {
  // ... 対象ノードを探す ...
  if (ptr.left === null && ptr.right === null) {
    // ① 葉ノード: そのまま削除
    this.replaceNode(parent, isLeftChild, null);
  } else if (ptr.right === null) {
    // ② 右子なし: 左子で置き換え
    this.replaceNode(parent, isLeftChild, ptr.left);
  } else if (ptr.left === null) {
    // ③ 左子なし: 右子で置き換え
    this.replaceNode(parent, isLeftChild, ptr.right);
  } else {
    // ④ 子が 2 つ: 右部分木の最小（中順後継）で置き換え
    let successor = ptr.right;
    while (successor.left !== null) successor = successor.left;
    ptr.key = successor.key;
    // 後継ノードを削除
  }
}
```

---

## 4. 木の走査

```typescript
// 中順探索（昇順）
inorder(): T[] {
  const result: T[] = [];
  function traverse(node: BSTNode<T> | null): void {
    if (node === null) return;
    traverse(node.left);
    result.push(node.key);
    traverse(node.right);
  }
  traverse(this.root);
  return result;
}
```

| 走査方法 | 順序 | 用途 |
|---------|------|------|
| 前順（preorder） | 根 → 左 → 右 | 木のコピー |
| 中順（inorder） | 左 → 根 → 右 | ソート済みリスト |
| 後順（postorder） | 左 → 右 → 根 | 木の削除 |

---

## テスト実行結果

```bash
$ npm test tests/tree.test.ts

Tests:  22 passed, 22 total
```

---

## 全テスト一括確認

```bash
$ npm test

Test Suites: 9 passed, 9 total
Tests:       236 passed, 2 skipped, 238 total
```

---

## まとめ

| 操作 | 平均計算量 | 最悪計算量 |
|------|-----------|-----------|
| 検索 | O(log n) | O(n) |
| 挿入 | O(log n) | O(n) |
| 削除 | O(log n) | O(n) |
| 中順探索 | O(n) | O(n) |

最悪（偏った木）を避けるには AVL 木や赤黒木などの平衡二分探索木が必要です。

## Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| ジェネリクス | `class BST[T]:` | `class BST<T>` |
| Optional 型 | `_Node \| None` | `BSTNode<T> \| null` |
| 内部クラス | `class Empty(Exception)` | `throw new Error(...)` |
| `__len__` | `def __len__(self)` | `get size()` |
| `__contains__` | `def __contains__(self, x)` | `contains(x)` |
| 比較演算子 | `key < ptr.key` | `key < ptr.key`（同じ） |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
