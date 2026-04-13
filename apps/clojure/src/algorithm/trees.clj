(ns algorithm.trees
  "第9章 木構造（二分探索木）")

(defrecord BSTNode [key left right])

(defn bst-insert
  "二分探索木にキーを挿入する（不変データ構造版）"
  [tree key]
  (cond
    (nil? tree) (->BSTNode key nil nil)
    (= key (:key tree)) tree ;; 重複は無視
    (< key (:key tree)) (->BSTNode (:key tree) (bst-insert (:left tree) key) (:right tree))
    :else (->BSTNode (:key tree) (:left tree) (bst-insert (:right tree) key))))

(defn bst-search
  "二分探索木からキーを検索する"
  [tree key]
  (cond
    (nil? tree) false
    (= key (:key tree)) true
    (< key (:key tree)) (recur (:left tree) key)
    :else (recur (:right tree) key)))

(defn- find-min
  "部分木の最小ノードを見つける"
  [tree]
  (if (nil? (:left tree))
    tree
    (recur (:left tree))))

(defn bst-delete
  "二分探索木からキーを削除する（不変データ構造版）"
  [tree key]
  (cond
    (nil? tree) nil
    (< key (:key tree)) (->BSTNode (:key tree) (bst-delete (:left tree) key) (:right tree))
    (> key (:key tree)) (->BSTNode (:key tree) (:left tree) (bst-delete (:right tree) key))
    ;; key == (:key tree): 削除対象
    :else
    (cond
      ;; 葉ノード
      (and (nil? (:left tree)) (nil? (:right tree))) nil
      ;; 左子のみ
      (nil? (:right tree)) (:left tree)
      ;; 右子のみ
      (nil? (:left tree)) (:right tree)
      ;; 子が2つ: 右部分木の最小値で置き換え
      :else
      (let [successor (find-min (:right tree))]
        (->BSTNode (:key successor) (:left tree) (bst-delete (:right tree) (:key successor)))))))

(defn in-order
  "中順走査（昇順）"
  [tree]
  (if (nil? tree)
    []
    (concat (in-order (:left tree))
            [(:key tree)]
            (in-order (:right tree)))))

(defn pre-order
  "前順走査"
  [tree]
  (if (nil? tree)
    []
    (concat [(:key tree)]
            (pre-order (:left tree))
            (pre-order (:right tree)))))

(defn post-order
  "後順走査"
  [tree]
  (if (nil? tree)
    []
    (concat (post-order (:left tree))
            (post-order (:right tree))
            [(:key tree)])))
