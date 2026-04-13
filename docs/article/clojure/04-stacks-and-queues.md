# 第 4 章 スタックとキュー

## はじめに

スタック（LIFO）とキュー（FIFO）を `atom` を使って Clojure で TDD 実装します。

### 目次

- [スタック](#スタック)
- [キュー（リングバッファ）](#キューリングバッファ)

---

## スタック

### Red -- 失敗するテストを書く

```clojure
(deftest stack-test
  (testing "LIFO 順序"
    (let [s (make-stack 64)]
      (stack-push s 1)
      (stack-push s 2)
      (stack-push s 3)
      (is (= 3 (stack-pop s)))
      (is (= 2 (stack-pop s)))
      (is (= 1 (stack-pop s))))))
```

### Green -- テストを通す実装

```clojure
(defn make-stack [capacity]
  (atom {:data [] :max capacity}))

(defn stack-push [s val]
  (if (stack-full? s)
    (throw (Exception. "Stack is full"))
    (swap! s update :data conj val)))

(defn stack-pop [s]
  (if (stack-empty? s)
    (throw (Exception. "Stack is empty"))
    (let [v (peek (:data @s))]
      (swap! s update :data pop)
      v)))
```

Clojure の `vector` は末尾の `conj`・`peek`・`pop` が O(1) なので、スタックとして自然に使えます。

**計算量**: push O(1)、pop O(1)

---

## キュー（リングバッファ）

### Red -- 失敗するテストを書く

```clojure
(deftest queue-test
  (testing "FIFO 順序"
    (let [q (make-queue 64)]
      (enqueue q 1)
      (enqueue q 2)
      (enqueue q 3)
      (is (= 1 (dequeue q)))
      (is (= 2 (dequeue q)))
      (is (= 3 (dequeue q))))))
```

### Green -- テストを通す実装

```clojure
(defn make-queue [capacity]
  (atom {:data (vec (repeat capacity nil))
         :capacity capacity
         :front 0 :rear 0 :num 0}))

(defn enqueue [q val]
  (if (queue-full? q)
    (throw (Exception. "Queue is full"))
    (let [{:keys [rear capacity]} @q]
      (swap! q (fn [state]
                 (-> state
                     (assoc-in [:data rear] val)
                     (assoc :rear (mod (inc rear) capacity))
                     (update :num inc)))))))
```

リングバッファ方式で `mod` を使って循環させます。

**計算量**: enqueue O(1)、dequeue O(1)

---

## まとめ

| データ構造 | 操作 | 計算量 | Clojure の特徴 |
|-----------|------|--------|---------------|
| スタック | push / pop | O(1) | `atom` + `vector` の末尾操作 |
| キュー | enqueue / dequeue | O(1) | `atom` + リングバッファ |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
