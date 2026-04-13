(ns algorithm.basic-algorithms
  "第1章 基本的なアルゴリズム")

(defn max3
  "3つの整数値の最大値を返す"
  [a b c]
  (max a b c))

(defn med3
  "3つの整数値の中央値を返す"
  [a b c]
  (let [sorted (sort [a b c])]
    (nth sorted 1)))

(defn judge-sign
  "整数値の符号を判定する"
  [n]
  (cond
    (pos? n) "その値は正です。"
    (neg? n) "その値は負です。"
    :else    "その値は0です。"))

(defn sum1-to-n-while
  "loop/recur で 1 から n までの総和を求める"
  [n]
  (loop [i 1 total 0]
    (if (> i n)
      total
      (recur (inc i) (+ total i)))))

(defn sum1-to-n-for
  "reduce で 1 から n までの総和を求める"
  [n]
  (reduce + (range 1 (inc n))))

(defn alternative1
  "記号文字 '+' と '-' を交互に表示する（剰余判定方式）"
  [n]
  (apply str (map #(if (even? %) \+ \-) (range n))))

(defn alternative2
  "記号文字 '+' と '-' を交互に表示する（パターン繰り返し方式）"
  [n]
  (let [base (apply str (repeat (quot n 2) "+-"))]
    (if (odd? n)
      (str base "+")
      base)))

(defn rectangle
  "縦横が整数で面積が area の長方形の辺の長さを列挙する"
  [area]
  (loop [i 1 result ""]
    (if (> (* i i) area)
      result
      (recur (inc i)
             (if (zero? (rem area i))
               (str result i "x" (quot area i) " ")
               result)))))

(defn multiplication-table
  "九九の表を返す"
  []
  (let [header (apply str (repeat 27 "-"))
        rows (for [i (range 1 10)]
               (apply str (for [j (range 1 10)]
                            (format "%3d" (* i j)))))]
    (str header "\n"
         (clojure.string/join "\n" rows) "\n"
         header)))

(defn triangle-lb
  "左下側が直角の二等辺三角形を返す"
  [n]
  (apply str (for [i (range 1 (inc n))]
               (str (apply str (repeat i "*")) "\n"))))
