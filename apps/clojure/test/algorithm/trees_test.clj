(ns algorithm.trees-test
  (:require [clojure.test :refer :all]
            [algorithm.trees :refer :all]))

(deftest bst-insert-and-search-test
  (testing "挿入と検索"
    (let [tree (-> nil
                   (bst-insert 5)
                   (bst-insert 3)
                   (bst-insert 7))]
      (is (true? (bst-search tree 5)))
      (is (true? (bst-search tree 3)))
      (is (true? (bst-search tree 7)))
      (is (false? (bst-search tree 99))))))

(deftest bst-search-empty-test
  (testing "空の木での検索"
    (is (false? (bst-search nil 5)))))

(deftest bst-traversal-test
  (testing "走査"
    (let [tree (reduce bst-insert nil [5 3 7 1 4 6 8])]
      (is (= [1 3 4 5 6 7 8] (in-order tree)))
      (is (= [5 3 1 4 7 6 8] (pre-order tree)))
      (is (= [1 4 3 6 8 7 5] (post-order tree))))))

(deftest bst-delete-leaf-test
  (testing "葉ノードの削除"
    (let [tree (reduce bst-insert nil [5 3 7])]
      (let [result (bst-delete tree 3)]
        (is (false? (bst-search result 3)))
        (is (true? (bst-search result 5)))
        (is (true? (bst-search result 7)))))))

(deftest bst-delete-one-child-test
  (testing "子が1つのノードの削除"
    (let [tree (reduce bst-insert nil [5 3 7 1])]
      (let [result (bst-delete tree 3)]
        (is (false? (bst-search result 3)))
        (is (true? (bst-search result 1)))))))

(deftest bst-delete-two-children-test
  (testing "子が2つのノードの削除"
    (let [tree (reduce bst-insert nil [5 3 7 1 4])]
      (let [result (bst-delete tree 3)]
        (is (false? (bst-search result 3)))
        (is (true? (bst-search result 1)))
        (is (true? (bst-search result 4)))
        (is (true? (bst-search result 5)))
        (is (true? (bst-search result 7)))))))

(deftest bst-delete-root-test
  (testing "根ノードの削除"
    (let [tree (reduce bst-insert nil [5 3 7])]
      (let [result (bst-delete tree 5)]
        (is (false? (bst-search result 5)))
        (is (true? (bst-search result 3)))
        (is (true? (bst-search result 7)))
        (is (= [3 7] (in-order result)))))))

(deftest bst-delete-not-found-test
  (testing "存在しないキーの削除"
    (let [tree (bst-insert nil 5)]
      (let [result (bst-delete tree 99)]
        (is (true? (bst-search result 5)))))))

(deftest bst-find-min-max-test
  (testing "最小キー・最大キーの取得"
    (let [tree (reduce bst-insert nil [5 3 7 1 4 6 8])]
      (is (= 1 (:key (find-min tree))))
      (is (= 8 (:key (find-max tree)))))))

(deftest bst-insert-duplicate-test
  (testing "重複キーの挿入は無視される"
    (let [tree (-> nil (bst-insert 5) (bst-insert 5))]
      (is (= [5] (in-order tree))))))
