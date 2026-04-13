# 第 5 章 再帰アルゴリズム

## はじめに

階乗、最大公約数、ハノイの塔、迷路探索を再帰で Clojure 実装します。`recur` による末尾再帰最適化も活用します。

### 目次

- [階乗](#階乗)
- [最大公約数（ユークリッドの互除法）](#最大公約数ユークリッドの互除法)
- [再帰的な合計](#再帰的な合計)
- [ハノイの塔](#ハノイの塔)
- [迷路探索](#迷路探索)

---

## 階乗

### Red -- 失敗するテストを書く

```clojure
(deftest factorial-test
  (testing "階乗"
    (is (= 1 (factorial 0)))
    (is (= 120 (factorial 5)))
    (is (= 3628800 (factorial 10)))))
```

### Green -- テストを通す実装

```clojure
(defn factorial [n]
  (if (<= n 0) 1 (* n (factorial (dec n)))))
```

**計算量**: O(n)

---

## 最大公約数（ユークリッドの互除法）

### Green -- テストを通す実装

```clojure
(defn gcd [x y]
  (if (zero? y) x (recur y (mod x y))))
```

`recur` を使うことで末尾再帰最適化が行われ、スタックオーバーフローを防ぎます。

**計算量**: O(log(min(x, y)))

---

## 再帰的な合計

```clojure
(defn recursive-sum [n]
  (if (<= n 0) 0 (+ n (recursive-sum (dec n)))))
```

---

## ハノイの塔

### Red -- 失敗するテストを書く

```clojure
(deftest hanoi-test
  (testing "ハノイの塔"
    (is (= [["A" "C"]] (hanoi 1 "A" "C" "B")))
    (is (= 7 (count (hanoi 3 "A" "C" "B"))))))
```

### Green -- テストを通す実装

```clojure
(defn hanoi [n src dst via]
  (if (= n 1)
    [[src dst]]
    (concat (hanoi (dec n) src via dst)
            [[src dst]]
            (hanoi (dec n) via dst src))))
```

**計算量**: O(2^n)

---

## 迷路探索

### Green -- テストを通す実装

```clojure
(defn maze-solve
  ([maze row col goal-row goal-col]
   (maze-solve maze row col goal-row goal-col #{}))
  ([maze row col goal-row goal-col visited]
   (if (and (= row goal-row) (= col goal-col))
     true
     (let [visited (conj visited [row col])
           directions [[-1 0] [1 0] [0 -1] [0 1]]]
       (boolean
        (some (fn [[dr dc]]
                (let [nr (+ row dr) nc (+ col dc)]
                  (when (and (<= 0 nr) (< nr (count maze))
                             (<= 0 nc) (< nc (count (first maze)))
                             (zero? (get-in maze [nr nc]))
                             (not (contains? visited [nr nc])))
                    (maze-solve maze nr nc goal-row goal-col visited))))
              directions))))))
```

Clojure の不変 `set` を `visited` として渡すことで、バックトラック時に自然に状態が復元されます。

---

## まとめ

| アルゴリズム | 関数名 | 計算量 | Clojure の特徴 |
|------------|--------|--------|---------------|
| 階乗 | `factorial` | O(n) | 通常の再帰 |
| GCD | `gcd` | O(log n) | `recur` で末尾再帰最適化 |
| ハノイの塔 | `hanoi` | O(2^n) | `concat` でリスト結合 |
| 迷路探索 | `maze-solve` | O(V + E) | 不変 `set` + `some` |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
