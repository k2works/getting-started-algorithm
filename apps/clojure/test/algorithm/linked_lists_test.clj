(ns algorithm.linked-lists-test
  (:require [clojure.test :refer :all]
            [algorithm.linked-lists :refer :all]))

(deftest linked-list-test
  (testing "初期状態"
    (let [lst (make-linked-list)]
      (is (= 0 (ll-size lst)))
      (is (= [] (ll-to-vec lst)))))

  (testing "先頭に挿入"
    (let [lst (make-linked-list)]
      (ll-insert-front lst 1)
      (is (= 1 (ll-size lst)))
      (is (= [1] (ll-to-vec lst)))))

  (testing "末尾に挿入"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 1)
      (ll-insert-back lst 2)
      (is (= 2 (ll-size lst)))
      (is (= [1 2] (ll-to-vec lst)))))

  (testing "検索"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 10)
      (ll-insert-back lst 20)
      (ll-insert-back lst 30)
      (is (true? (ll-search lst 20)))
      (is (false? (ll-search lst 99)))))

  (testing "削除"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 1)
      (ll-insert-back lst 2)
      (ll-insert-back lst 3)
      (ll-delete lst 2)
      (is (false? (ll-search lst 2)))
      (is (= 2 (ll-size lst)))
      (is (= [1 3] (ll-to-vec lst)))))

  (testing "先頭要素の削除"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 1)
      (ll-insert-back lst 2)
      (ll-delete lst 1)
      (is (= [2] (ll-to-vec lst)))))

  (testing "存在しない要素の削除"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 1)
      (ll-delete lst 99)
      (is (= [1] (ll-to-vec lst)))))

  (testing "複数挿入の順序"
    (let [lst (make-linked-list)]
      (ll-insert-front lst 3)
      (ll-insert-front lst 2)
      (ll-insert-front lst 1)
      (is (= [1 2 3] (ll-to-vec lst))))))

(deftest doubly-linked-list-test
  (testing "初期状態"
    (let [dlst (make-doubly-linked-list)]
      (is (= 0 (dll-size dlst)))
      (is (= [] (dll-to-vec dlst)))
      (is (true? (dll-empty? dlst)))))

  (testing "末尾に挿入"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 1)
      (dll-add-last dlst 2)
      (dll-add-last dlst 3)
      (is (= 3 (dll-size dlst)))
      (is (= [1 2 3] (dll-to-vec dlst)))))

  (testing "先頭に挿入"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-first dlst 3)
      (dll-add-first dlst 2)
      (dll-add-first dlst 1)
      (is (= [1 2 3] (dll-to-vec dlst)))))

  (testing "検索"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 10)
      (dll-add-last dlst 20)
      (dll-add-last dlst 30)
      (is (true? (dll-search dlst 20)))
      (is (false? (dll-search dlst 99)))))

  (testing "値による削除"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 1)
      (dll-add-last dlst 2)
      (dll-add-last dlst 3)
      (dll-remove dlst 2)
      (is (= [1 3] (dll-to-vec dlst)))
      (is (= 2 (dll-size dlst)))))

  (testing "先頭の削除"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 1)
      (dll-add-last dlst 2)
      (dll-remove dlst 1)
      (is (= [2] (dll-to-vec dlst)))))

  (testing "末尾の削除"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 1)
      (dll-add-last dlst 2)
      (dll-remove dlst 2)
      (is (= [1] (dll-to-vec dlst)))))

  (testing "存在しない要素の削除"
    (let [dlst (make-doubly-linked-list)]
      (dll-add-last dlst 1)
      (dll-remove dlst 99)
      (is (= [1] (dll-to-vec dlst))))))
