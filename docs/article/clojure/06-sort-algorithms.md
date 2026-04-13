# 第 6 章 ソートアルゴリズム

## はじめに

バブルソート、選択ソート、挿入ソート、シェルソート、クイックソート、マージソート、ヒープソートを Clojure で TDD 実装します。

### 目次

- [バブルソート](#バブルソート)
- [選択ソート](#選択ソート)
- [挿入ソート](#挿入ソート)
- [シェルソート](#シェルソート)
- [クイックソート](#クイックソート)
- [マージソート](#マージソート)
- [ヒープソート](#ヒープソート)

---

## バブルソート

### Red -- 失敗するテストを書く

```clojure
(deftest bubble-sort-test
  (testing "バブルソート"
    (is (= [1 3 4 6 7 8 9] (bubble-sort [6 4 3 7 1 9 8])))
    (is (= [] (bubble-sort [])))))
```

### Green -- テストを通す実装

`int-array` を使って Java 配列上で in-place 操作し、結果を `vec` で返します。

**計算量**: O(n^2) 最悪、O(n) 最良

---

## 選択ソート

未整列部分の最小値を探し、先頭と交換します。

**計算量**: O(n^2)

---

## 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入します。

**計算量**: O(n^2) 最悪、O(n) 最良

---

## シェルソート

Knuth 数列で gap を決定し、gap ごとの挿入ソートを繰り返します。

**計算量**: O(n^(3/2))

---

## クイックソート

### Green -- テストを通す実装

Clojure らしい純粋関数型の実装です。

```clojure
(defn quick-sort [a]
  (if (<= (count a) 1)
    (vec a)
    (let [pivot (nth a (quot (count a) 2))
          less (filter #(< % pivot) a)
          equal (filter #(= % pivot) a)
          greater (filter #(> % pivot) a)]
      (vec (concat (quick-sort less) equal (quick-sort greater))))))
```

**計算量**: O(n log n) 平均

---

## マージソート

### Green -- テストを通す実装

```clojure
(defn merge-sort-alg [a]
  (if (<= (count a) 1)
    (vec a)
    (let [mid (quot (count a) 2)
          left (merge-sort-alg (subvec (vec a) 0 mid))
          right (merge-sort-alg (subvec (vec a) mid))]
      (vec (loop [l left r right result []]
             (cond
               (empty? l) (into result r)
               (empty? r) (into result l)
               (<= (first l) (first r))
               (recur (rest l) r (conj result (first l)))
               :else
               (recur l (rest r) (conj result (first r)))))))))
```

**計算量**: O(n log n)

---

## ヒープソート

`int-array` を使った in-place ヒープソートです。

**計算量**: O(n log n)

---

## まとめ

| アルゴリズム | 関数名 | 計算量（平均） | 安定性 |
|------------|--------|-------------|-------|
| バブルソート | `bubble-sort` | O(n^2) | 安定 |
| 選択ソート | `selection-sort` | O(n^2) | 不安定 |
| 挿入ソート | `insertion-sort` | O(n^2) | 安定 |
| シェルソート | `shell-sort` | O(n^(3/2)) | 不安定 |
| クイックソート | `quick-sort` | O(n log n) | 不安定 |
| マージソート | `merge-sort-alg` | O(n log n) | 安定 |
| ヒープソート | `heap-sort` | O(n log n) | 不安定 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
