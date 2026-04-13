(ns algorithm.basic-algorithms-test
  (:require [clojure.test :refer :all]
            [algorithm.basic-algorithms :refer :all]))

(deftest max3-test
  (testing "3値の最大値"
    (are [a b c expected]
         (= expected (max3 a b c))
      3 2 1 3
      3 2 2 3
      3 1 2 3
      3 2 3 3
      2 1 3 3
      3 3 2 3
      3 3 3 3
      2 2 3 3
      2 3 1 3
      2 3 2 3
      1 3 2 3
      2 3 3 3
      1 2 3 3)))

(deftest med3-test
  (testing "3値の中央値"
    (are [a b c expected]
         (= expected (med3 a b c))
      3 2 1 2
      3 2 2 2
      3 1 2 2
      3 2 3 3
      2 1 3 2
      3 3 2 3
      3 3 3 3
      2 2 3 2
      2 3 1 2
      2 3 2 2
      1 3 2 2
      2 3 3 3
      1 2 3 2)))

(deftest judge-sign-test
  (testing "符号判定"
    (is (= "その値は正です。" (judge-sign 17)))
    (is (= "その値は負です。" (judge-sign -5)))
    (is (= "その値は0です。" (judge-sign 0)))))

(deftest sum1-to-n-while-test
  (testing "1からnまでの総和（loop/recur版）"
    (is (= 15 (sum1-to-n-while 5)))))

(deftest sum1-to-n-for-test
  (testing "1からnまでの総和（reduce版）"
    (is (= 15 (sum1-to-n-for 5)))))

(deftest alternative1-test
  (testing "記号文字の交互表示（剰余判定）"
    (is (= "+-+-+-+-+-+-" (alternative1 12)))
    (is (= "+-+-+" (alternative1 5)))))

(deftest alternative2-test
  (testing "記号文字の交互表示（文字列繰り返し）"
    (is (= "+-+-+-+-+-+-" (alternative2 12)))
    (is (= "+-+-+" (alternative2 5)))))

(deftest rectangle-test
  (testing "長方形の辺の長さを列挙"
    (is (= "1x32 2x16 4x8 " (rectangle 32)))))

(deftest multiplication-table-test
  (testing "九九の表"
    (let [expected (str "---------------------------\n"
                        "  1  2  3  4  5  6  7  8  9\n"
                        "  2  4  6  8 10 12 14 16 18\n"
                        "  3  6  9 12 15 18 21 24 27\n"
                        "  4  8 12 16 20 24 28 32 36\n"
                        "  5 10 15 20 25 30 35 40 45\n"
                        "  6 12 18 24 30 36 42 48 54\n"
                        "  7 14 21 28 35 42 49 56 63\n"
                        "  8 16 24 32 40 48 56 64 72\n"
                        "  9 18 27 36 45 54 63 72 81\n"
                        "---------------------------")]
      (is (= expected (multiplication-table))))))

(deftest triangle-lb-test
  (testing "直角三角形"
    (is (= "*\n**\n***\n****\n*****\n" (triangle-lb 5)))))
