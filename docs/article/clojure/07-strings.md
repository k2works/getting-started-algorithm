# 第 7 章 文字列処理

## はじめに

ブルートフォース法、KMP 法、Boyer-Moore 法による文字列探索と、文字カウント、逆順、回文判定を Clojure で TDD 実装します。

### 目次

- [ブルートフォース法](#ブルートフォース法)
- [KMP 法](#kmp-法)
- [Boyer-Moore 法](#boyer-moore-法)
- [文字カウント](#文字カウント)
- [文字列の逆順](#文字列の逆順)
- [回文判定](#回文判定)

---

## ブルートフォース法

### Red -- 失敗するテストを書く

```clojure
(deftest bf-match-test
  (testing "ブルートフォース文字列探索"
    (is (= 12 (bf-match "ABCXDEZCABACABAB" "ABAB")))
    (is (= -1 (bf-match "ABCDE" "XYZ")))
    (is (= 0 (bf-match "ABCDE" "")))))
```

### Green -- テストを通す実装

```clojure
(defn bf-match [txt pat]
  (let [n (count txt) m (count pat)]
    (if (zero? m) 0
      (loop [i 0]
        (if (> i (- n m)) -1
          (let [matched (loop [j 0]
                          (cond
                            (>= j m) true
                            (not= (nth txt (+ i j)) (nth pat j)) false
                            :else (recur (inc j))))]
            (if matched i (recur (inc i)))))))))
```

**計算量**: O(n * m)

---

## KMP 法

失敗関数テーブルを使い、比較の重複を避けます。

**計算量**: O(n + m)

---

## Boyer-Moore 法

Bad Character ルールでスキップ量を最大化します。

**計算量**: 平均 O(n / m)

---

## 文字カウント

### Green -- テストを通す実装

```clojure
(defn count-chars [s]
  (if (empty? s) {} (frequencies s)))
```

Clojure の組み込み `frequencies` 関数を活用します。

---

## 文字列の逆順

```clojure
(defn str-reverse [s]
  (apply str (reverse s)))
```

---

## 回文判定

```clojure
(defn is-palindrome? [s]
  (= s (str-reverse s)))
```

---

## まとめ

| アルゴリズム | 関数名 | 計算量 | Clojure の特徴 |
|------------|--------|--------|---------------|
| ブルートフォース | `bf-match` | O(n * m) | `loop/recur` |
| KMP 法 | `kmp-match` | O(n + m) | `int-array` でテーブル構築 |
| Boyer-Moore 法 | `bm-match` | O(n / m) 平均 | `map` で Bad Character テーブル |
| 文字カウント | `count-chars` | O(n) | `frequencies` |
| 逆順 | `str-reverse` | O(n) | `reverse` + `apply str` |
| 回文判定 | `is-palindrome?` | O(n) | 述語関数（`?` 接尾辞） |

## 参考文献

- 『新・明解アルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
