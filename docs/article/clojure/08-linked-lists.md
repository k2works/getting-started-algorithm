# 第 8 章 リスト

## はじめに

単方向連結リストを `defrecord` と `atom` で Clojure 実装します。不変データ構造のノードを `atom` で管理する設計です。

### 目次

- [連結リスト](#連結リスト)

---

## 連結リスト

### Red -- 失敗するテストを書く

```clojure
(deftest linked-list-test
  (testing "先頭に挿入"
    (let [lst (make-linked-list)]
      (ll-insert-front lst 1)
      (is (= 1 (ll-size lst)))
      (is (= [1] (ll-to-vec lst)))))

  (testing "検索"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 10)
      (ll-insert-back lst 20)
      (is (true? (ll-search lst 20)))
      (is (false? (ll-search lst 99)))))

  (testing "削除"
    (let [lst (make-linked-list)]
      (ll-insert-back lst 1)
      (ll-insert-back lst 2)
      (ll-insert-back lst 3)
      (ll-delete lst 2)
      (is (= [1 3] (ll-to-vec lst))))))
```

### Green -- テストを通す実装

```clojure
(defrecord Node [data next])

(defn make-linked-list []
  (atom {:head nil :size 0}))

(defn ll-insert-front [lst val]
  (swap! lst (fn [{:keys [head size]}]
               {:head (->Node val head)
                :size (inc size)})))

(defn ll-search [lst val]
  (loop [current (:head @lst)]
    (cond
      (nil? current) false
      (= (:data current) val) true
      :else (recur (:next current)))))
```

`defrecord` で不変ノードを定義し、`atom` でリスト全体の状態を管理します。挿入・削除時にはノードチェーンを再構築します。

### 設計上の考慮

Clojure では通常、組み込みの `list` や `vector` を使いますが、教育目的で連結リストを手動実装しています。`atom` の `swap!` で安全に状態遷移を行います。

**計算量**:

| 操作 | 計算量 |
|------|--------|
| 先頭挿入 | O(1) |
| 末尾挿入 | O(n) |
| 検索 | O(n) |
| 削除 | O(n) |

---

## まとめ

| 操作 | 関数名 | 計算量 | Clojure の特徴 |
|------|--------|--------|---------------|
| 作成 | `make-linked-list` | O(1) | `atom` |
| 先頭挿入 | `ll-insert-front` | O(1) | `->Node` で新ノード作成 |
| 末尾挿入 | `ll-insert-back` | O(n) | チェーン再構築 |
| 検索 | `ll-search` | O(n) | `loop/recur` |
| 削除 | `ll-delete` | O(n) | チェーン再構築 |
| 変換 | `ll-to-vec` | O(n) | `loop` で走査 |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
