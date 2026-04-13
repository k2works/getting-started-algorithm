(ns algorithm.sort-algorithms-test
  (:require [clojure.test :refer :all]
            [algorithm.sort-algorithms :refer :all]))

(def unsorted [6 4 3 7 1 9 8])
(def sorted-expected [1 3 4 6 7 8 9])

(deftest bubble-sort-test
  (testing "バブルソート"
    (is (= sorted-expected (bubble-sort unsorted)))
    (is (= sorted-expected (bubble-sort sorted-expected)))
    (is (= [42] (bubble-sort [42])))
    (is (= [] (bubble-sort [])))
    (is (= [1 1 2 3 3] (bubble-sort [3 1 2 1 3])))))

(deftest selection-sort-test
  (testing "選択ソート"
    (is (= sorted-expected (selection-sort unsorted)))
    (is (= sorted-expected (selection-sort sorted-expected)))
    (is (= [1 1 2 3 3] (selection-sort [3 1 2 1 3])))))

(deftest insertion-sort-test
  (testing "挿入ソート"
    (is (= sorted-expected (insertion-sort unsorted)))
    (is (= sorted-expected (insertion-sort sorted-expected)))
    (is (= [1 1 2 3 3] (insertion-sort [3 1 2 1 3])))))

(deftest shell-sort-test
  (testing "シェルソート"
    (is (= sorted-expected (shell-sort unsorted)))
    (is (= sorted-expected (shell-sort sorted-expected)))
    (is (= [1 1 2 3 3] (shell-sort [3 1 2 1 3])))))

(deftest quick-sort-test
  (testing "クイックソート"
    (is (= sorted-expected (quick-sort unsorted)))
    (is (= sorted-expected (quick-sort sorted-expected)))
    (is (= [1] (quick-sort [1])))
    (is (= [1 1 2 3 3] (quick-sort [3 1 2 1 3])))))

(deftest merge-sort-test
  (testing "マージソート"
    (is (= sorted-expected (merge-sort-alg unsorted)))
    (is (= sorted-expected (merge-sort-alg sorted-expected)))
    (is (= [5] (merge-sort-alg [5])))
    (is (= [] (merge-sort-alg [])))
    (is (= [1 1 2 3 3] (merge-sort-alg [3 1 2 1 3])))))

(deftest heap-sort-test
  (testing "ヒープソート"
    (is (= sorted-expected (heap-sort unsorted)))
    (is (= sorted-expected (heap-sort sorted-expected)))
    (is (= [42] (heap-sort [42])))
    (is (= [] (heap-sort [])))
    (is (= [1 1 2 3 3] (heap-sort [3 1 2 1 3])))))
