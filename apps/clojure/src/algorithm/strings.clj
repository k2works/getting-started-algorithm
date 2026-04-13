(ns algorithm.strings
  "第7章 文字列処理")

(defn bf-match
  "ブルートフォース文字列探索"
  [txt pat]
  (let [n (count txt)
        m (count pat)]
    (if (zero? m)
      0
      (loop [i 0]
        (if (> i (- n m))
          -1
          (let [matched (loop [j 0]
                          (cond
                            (>= j m) true
                            (not= (nth txt (+ i j)) (nth pat j)) false
                            :else (recur (inc j))))]
            (if matched i (recur (inc i)))))))))

(defn- build-kmp-table
  "KMP 法の失敗関数テーブルを構築する"
  [pat]
  (let [m (count pat)
        table (int-array m 0)]
    (loop [i 1 k 0]
      (when (< i m)
        (let [k (loop [k k]
                  (if (and (> k 0) (not= (nth pat k) (nth pat i)))
                    (recur (aget table (dec k)))
                    k))
              k (if (= (nth pat k) (nth pat i)) (inc k) k)]
          (aset table i k)
          (recur (inc i) k))))
    (vec table)))

(defn kmp-match
  "KMP 文字列探索"
  [txt pat]
  (let [n (count txt)
        m (count pat)]
    (if (zero? m)
      0
      (let [table (build-kmp-table pat)]
        (loop [i 0 j 0]
          (if (>= i n)
            -1
            (let [j (loop [j j]
                      (if (and (> j 0) (not= (nth txt i) (nth pat j)))
                        (recur (nth table (dec j)))
                        j))
                  j (if (= (nth txt i) (nth pat j)) (inc j) j)]
              (if (= j m)
                (- i m -1)
                (recur (inc i) j)))))))))

(defn bm-match
  "Boyer-Moore 文字列探索（Bad Character ルールのみ）"
  [txt pat]
  (let [n (count txt)
        m (count pat)]
    (if (zero? m)
      0
      (let [bad-char (into {} (map-indexed (fn [i c] [c i]) pat))]
        (loop [s 0]
          (if (> s (- n m))
            -1
            (let [j (loop [j (dec m)]
                      (cond
                        (< j 0) j
                        (= (nth pat j) (nth txt (+ s j))) (recur (dec j))
                        :else j))]
              (if (< j 0)
                s
                (let [skip (- j (get bad-char (nth txt (+ s j)) -1))]
                  (recur (+ s (max 1 skip))))))))))))

(defn count-chars
  "文字列中の各文字の出現回数を map で返す"
  [s]
  (if (empty? s)
    {}
    (frequencies s)))

(defn str-reverse
  "文字列を逆順にして返す"
  [s]
  (apply str (reverse s)))

(defn is-palindrome?
  "文字列が回文かどうかを判定する"
  [s]
  (= s (str-reverse s)))
