(ns algorithm.recursion-test
  (:require [clojure.test :refer :all]
            [algorithm.recursion :refer :all]))

(deftest factorial-test
  (testing "階乗"
    (is (= 1 (factorial 0)))
    (is (= 1 (factorial 1)))
    (is (= 120 (factorial 5)))
    (is (= 3628800 (factorial 10)))))

(deftest gcd-test
  (testing "最大公約数"
    (is (= 2 (gcd 22 8)))
    (is (= 4 (gcd 12 4)))
    (is (= 1 (gcd 7 11)))
    (is (= 15 (gcd 15 15)))))

(deftest recursive-sum-test
  (testing "再帰的な合計"
    (is (= 1 (recursive-sum 1)))
    (is (= 15 (recursive-sum 5)))
    (is (= 55 (recursive-sum 10)))))

(deftest hanoi-test
  (testing "ハノイの塔"
    (is (= [["A" "C"]] (hanoi 1 "A" "C" "B")))
    (is (= [["A" "B"] ["A" "C"] ["B" "C"]] (hanoi 2 "A" "C" "B")))
    (is (= 7 (count (hanoi 3 "A" "C" "B"))))
    (doseq [n (range 1 6)]
      (is (= (int (dec (Math/pow 2 n))) (count (hanoi n "A" "C" "B")))))))

(deftest maze-solve-test
  (testing "迷路探索"
    (let [solvable [[1 1 1 1 1]
                    [1 0 0 0 1]
                    [1 0 1 0 1]
                    [1 0 0 0 1]
                    [1 1 1 1 1]]
          unsolvable [[1 1 1 1 1]
                      [1 0 1 0 1]
                      [1 1 1 1 1]
                      [1 0 0 0 1]
                      [1 1 1 1 1]]]
      (is (true? (maze-solve solvable 1 1 3 3)))
      (is (false? (maze-solve unsolvable 1 1 3 1))))))
