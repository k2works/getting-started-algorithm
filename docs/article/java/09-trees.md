# 第 9 章 木構造

## はじめに

この章では二分探索木（BST）を `Comparable<T>` を使ったジェネリクスで TDD 実装します。

---

## 1. 二分探索木の性質

- 左部分木の全てのキー < ルートのキー
- 右部分木の全てのキー > ルートのキー
- 左右の部分木もまた二分探索木

---

## 2. 挿入

```java
public void insert(T key) {
    if (root == null) { root = new BSTNode<>(key); size++; return; }
    BSTNode<T> ptr = root;
    while (true) {
        int cmp = key.compareTo(ptr.key);
        if (cmp == 0) return; // 重複は無視
        if (cmp < 0) {
            if (ptr.left == null) { ptr.left = new BSTNode<>(key); size++; return; }
            ptr = ptr.left;
        } else {
            if (ptr.right == null) { ptr.right = new BSTNode<>(key); size++; return; }
            ptr = ptr.right;
        }
    }
}
```

---

## 3. 削除

削除には 3 つのケースがあります。

1. **葉ノード**: そのまま削除
2. **子が 1 つ**: 子で置き換え
3. **子が 2 つ**: 右部分木の最小ノード（中順後継）で置き換え

---

## 4. 走査

| 走査 | 順序 | 用途 |
|------|------|------|
| 中順（inOrder） | 左 -> ルート -> 右 | 昇順出力 |
| 前順（preOrder） | ルート -> 左 -> 右 | 木の複製 |
| 後順（postOrder） | 左 -> 右 -> ルート | 木の削除 |

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| 比較 | `<` / `>` 演算子 | `Comparable<T>.compareTo()` |
| ジェネリクス制約 | なし | `<T extends Comparable<T>>` |
| null | `None` | `null` |

---

## テスト実行結果

```
TreeTest > BinarySearchTreeTest > 中順探索は昇順() PASSED
TreeTest > BinarySearchTreeTest > 葉ノードの削除() PASSED
TreeTest > BinarySearchTreeTest > 子が2つのノードの削除() PASSED
TreeTest > BinarySearchTreeTest > 根ノードの削除() PASSED
TreeTest > BinarySearchTreeTest > 深い後継ノードの削除() PASSED
```
