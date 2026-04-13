(ns algorithm.strings-test
  (:require [clojure.test :refer :all]
            [algorithm.strings :refer :all]))

(deftest bf-match-test
  (testing "ブルートフォース文字列探索"
    (is (= 12 (bf-match "ABCXDEZCABACABAB" "ABAB")))
    (is (= 0 (bf-match "ABCDE" "ABC")))
    (is (= 2 (bf-match "ABCDE" "CDE")))
    (is (= -1 (bf-match "ABCDE" "XYZ")))
    (is (= 0 (bf-match "ABCDE" "")))
    (is (= -1 (bf-match "AB" "ABCDE")))
    (is (= 2 (bf-match "ABCDE" "C")))))

(deftest kmp-match-test
  (testing "KMP 文字列探索"
    (is (= 12 (kmp-match "ABCXDEZCABACABAB" "ABAB")))
    (is (= 0 (kmp-match "ABCDE" "ABC")))
    (is (= -1 (kmp-match "ABCDE" "XYZ")))
    (is (= 0 (kmp-match "ABCDE" "")))
    (is (= 0 (kmp-match "AAABAAAB" "AAAB")))))

(deftest bm-match-test
  (testing "Boyer-Moore 文字列探索"
    (is (= 12 (bm-match "ABCXDEZCABACABAB" "ABAB")))
    (is (= 0 (bm-match "ABCDE" "ABC")))
    (is (= -1 (bm-match "ABCDE" "XYZ")))
    (is (= 0 (bm-match "ABCDE" "")))))

(deftest count-chars-test
  (testing "文字のカウント"
    (let [result (count-chars "hello world")]
      (is (= 3 (get result \l)))
      (is (= 2 (get result \o)))
      (is (= 1 (get result \space))))
    (is (= {} (count-chars "")))))

(deftest str-reverse-test
  (testing "文字列の逆順"
    (is (= "olleh" (str-reverse "hello")))
    (is (= "" (str-reverse "")))
    (is (= "a" (str-reverse "a")))
    (is (= "racecar" (str-reverse "racecar")))))

(deftest is-palindrome?-test
  (testing "回文判定"
    (is (true? (is-palindrome? "racecar")))
    (is (false? (is-palindrome? "hello")))
    (is (true? (is-palindrome? "a")))
    (is (true? (is-palindrome? "")))
    (is (true? (is-palindrome? "abba")))))
