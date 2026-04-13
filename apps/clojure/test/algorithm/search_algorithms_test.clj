(ns algorithm.search-algorithms-test
  (:require [clojure.test :refer :all]
            [algorithm.search-algorithms :refer :all]))

(deftest seq-search-test
  (testing "線形探索"
    (is (= 3 (seq-search [6 4 3 2 1 2 8] 2)))
    (is (= 0 (seq-search ["DTS" "AAC" "FLAC"] "DTS")))
    (is (= -1 (seq-search [1 2 3] 99)))))

(deftest seq-search-ex-test
  (testing "番兵法"
    (is (= 3 (seq-search-ex [6 4 3 2 1 2 8] 2)))
    (is (= -1 (seq-search-ex [1 2 3] 99)))))

(deftest bin-search-test
  (testing "二分探索"
    (is (= 3 (bin-search [1 2 3 5 7 8 9] 5)))
    (is (= 0 (bin-search [1 2 3 5 7 8 9] 1)))
    (is (= 6 (bin-search [1 2 3 5 7 8 9] 9)))
    (is (= -1 (bin-search [1 2 3 5 7 8 9] 4)))))

(deftest chained-hash-test
  (testing "チェイン法ハッシュ"
    (let [h (make-chained-hash 13)]
      (hash-add h 1 "赤尾")
      (hash-add h 5 "武田")
      (hash-add h 10 "小野")
      (hash-add h 12 "鈴木")
      (hash-add h 14 "神崎")
      (is (= "赤尾" (hash-search h 1)))
      (is (= "神崎" (hash-search h 14)))
      (is (nil? (hash-search h 100)))
      (hash-add h 100 "山田")
      (is (= "山田" (hash-search h 100)))
      (is (false? (hash-add h 1 "重複")))
      (hash-remove h 100)
      (is (nil? (hash-search h 100)))
      (is (false? (hash-remove h 999))))))
