(ns algorithm.arrays-test
  (:require [clojure.test :refer :all]
            [algorithm.arrays :refer :all]))

(deftest max-of-test
  (testing "配列の最大値"
    (is (= 192 (max-of [172 153 192 140 165])))
    (is (= 42 (max-of [42])))
    (is (= 5 (max-of [5 5 5])))))

(deftest reverse-arr-test
  (testing "配列の反転"
    (is (= [7 6 9 3 1 5 2] (reverse-arr [2 5 1 3 9 6 7])))
    (is (= [4 3 2 1] (reverse-arr [1 2 3 4])))
    (is (= [42] (reverse-arr [42])))))

(deftest card-conv-test
  (testing "基数変換"
    (is (= "11101" (card-conv 29 2)))
    (is (= "35" (card-conv 29 8)))
    (is (= "FF" (card-conv 255 16)))))

(deftest prime1-test
  (testing "素数列挙（第1版）"
    (is (= 78022 (prime1 1000)))))

(deftest prime2-test
  (testing "素数列挙（第2版）"
    (is (= 14622 (prime2 1000)))))

(deftest prime3-test
  (testing "素数列挙（第3版）"
    (is (= 3774 (prime3 1000)))))
