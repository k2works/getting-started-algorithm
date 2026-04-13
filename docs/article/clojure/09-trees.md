# 第 9 章 木構造

## はじめに

二分探索木（BST）を `defrecord` で不変データ構造として Clojure 実装します。挿入・削除・走査をすべて純粋関数として実装します。

### 目次

- [二分探索木](#二分探索木)
- [走査（前順・中順・後順）](#走査)

---

## 二分探索木

### Red -- 失敗するテストを書く

```clojure
(deftest bst-insert-and-search-test
  (testing "挿入と検索"
    (let [tree (-> nil
                   (bst-insert 5)
                   (bst-insert 3)
                   (bst-insert 7))]
      (is (true? (bst-search tree 5)))
      (is (false? (bst-search tree 99))))))

(deftest bst-traversal-test
  (testing "走査"
    (let [tree (reduce bst-insert nil [5 3 7 1 4 6 8])]
      (is (= [1 3 4 5 6 7 8] (in-order tree)))
      (is (= [5 3 1 4 7 6 8] (pre-order tree)))
      (is (= [1 4 3 6 8 7 5] (post-order tree))))))
```

### Green -- テストを通す実装

```clojure
(defrecord BSTNode [key left right])

(defn bst-insert [tree key]
  (cond
    (nil? tree) (->BSTNode key nil nil)
    (= key (:key tree)) tree
    (< key (:key tree))
    (->BSTNode (:key tree) (bst-insert (:left tree) key) (:right tree))
    :else
    (->BSTNode (:key tree) (:left tree) (bst-insert (:right tree) key))))

(defn bst-search [tree key]
  (cond
    (nil? tree) false
    (= key (:key tree)) true
    (< key (:key tree)) (recur (:left tree) key)
    :else (recur (:right tree) key)))
```

不変データ構造の BST では、挿入・削除のたびに新しいノードを作成します。変更されないサブツリーは共有されるため、メモリ効率は O(log n) です。

### 削除

```clojure
(defn bst-delete [tree key]
  (cond
    (nil? tree) nil
    (< key (:key tree))
    (->BSTNode (:key tree) (bst-delete (:left tree) key) (:right tree))
    (> key (:key tree))
    (->BSTNode (:key tree) (:left tree) (bst-delete (:right tree) key))
    :else
    (cond
      (and (nil? (:left tree)) (nil? (:right tree))) nil
      (nil? (:right tree)) (:left tree)
      (nil? (:left tree)) (:right tree)
      :else
      (let [successor (find-min (:right tree))]
        (->BSTNode (:key successor)
                   (:left tree)
                   (bst-delete (:right tree) (:key successor)))))))
```

---

## 走査

```clojure
(defn in-order [tree]
  (if (nil? tree) []
    (concat (in-order (:left tree))
            [(:key tree)]
            (in-order (:right tree)))))

(defn pre-order [tree]
  (if (nil? tree) []
    (concat [(:key tree)]
            (pre-order (:left tree))
            (pre-order (:right tree)))))

(defn post-order [tree]
  (if (nil? tree) []
    (concat (post-order (:left tree))
            (post-order (:right tree))
            [(:key tree)])))
```

---

## まとめ

| 操作 | 関数名 | 計算量（平均） | Clojure の特徴 |
|------|--------|-------------|---------------|
| 挿入 | `bst-insert` | O(log n) | 不変ツリーの構造共有 |
| 検索 | `bst-search` | O(log n) | `recur` で末尾再帰 |
| 削除 | `bst-delete` | O(log n) | 純粋関数として再構築 |
| 中順走査 | `in-order` | O(n) | `concat` でリスト結合 |
| 前順走査 | `pre-order` | O(n) | `concat` でリスト結合 |
| 後順走査 | `post-order` | O(n) | `concat` でリスト結合 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
