(ns algorithm.sort-algorithms
  "第6章 ソートアルゴリズム")

(defn bubble-sort
  "バブルソート（純粋関数版）"
  [a]
  (let [arr (int-array a)
        n (alength arr)]
    (loop [i 0]
      (if (>= i (dec n))
        (vec arr)
        (let [swapped (loop [j (dec n) sw false]
                        (if (<= j i)
                          sw
                          (if (> (aget arr (dec j)) (aget arr j))
                            (let [tmp (aget arr (dec j))]
                              (aset arr (dec j) (aget arr j))
                              (aset arr j tmp)
                              (recur (dec j) true))
                            (recur (dec j) sw))))]
          (if (not swapped)
            (vec arr)
            (recur (inc i))))))))

(defn selection-sort
  "選択ソート（純粋関数版）"
  [a]
  (let [arr (int-array a)
        n (alength arr)]
    (loop [i 0]
      (if (>= i (dec n))
        (vec arr)
        (let [min-idx (loop [j (inc i) mi i]
                        (if (>= j n)
                          mi
                          (recur (inc j) (if (< (aget arr j) (aget arr mi)) j mi))))]
          (when (not= min-idx i)
            (let [tmp (aget arr i)]
              (aset arr i (aget arr min-idx))
              (aset arr min-idx tmp)))
          (recur (inc i)))))))

(defn insertion-sort
  "挿入ソート（純粋関数版）"
  [a]
  (let [arr (int-array a)
        n (alength arr)]
    (loop [i 1]
      (if (>= i n)
        (vec arr)
        (let [key-val (aget arr i)]
          (loop [j (dec i)]
            (if (and (>= j 0) (> (aget arr j) key-val))
              (do (aset arr (inc j) (aget arr j))
                  (recur (dec j)))
              (aset arr (inc j) key-val)))
          (recur (inc i)))))))

(defn shell-sort
  "シェルソート（純粋関数版）"
  [a]
  (let [arr (int-array a)
        n (alength arr)]
    (loop [gap (loop [g 1] (if (< (* g 3 (+ 1)) n) (recur (+ (* g 3) 1)) g))]
      (if (<= gap 0)
        (vec arr)
        (do
          (loop [i gap]
            (when (< i n)
              (let [key-val (aget arr i)]
                (loop [j (- i gap)]
                  (if (and (>= j 0) (> (aget arr j) key-val))
                    (do (aset arr (+ j gap) (aget arr j))
                        (recur (- j gap)))
                    (aset arr (+ j gap) key-val))))
              (recur (inc i))))
          (recur (quot gap 3)))))))

(defn quick-sort
  "クイックソート（純粋関数版）"
  [a]
  (if (<= (count a) 1)
    (vec a)
    (let [pivot (nth a (quot (count a) 2))
          less (filter #(< % pivot) a)
          equal (filter #(= % pivot) a)
          greater (filter #(> % pivot) a)]
      (vec (concat (quick-sort less) equal (quick-sort greater))))))

(defn merge-sort-alg
  "マージソート（純粋関数版）"
  [a]
  (if (<= (count a) 1)
    (vec a)
    (let [mid (quot (count a) 2)
          left (merge-sort-alg (subvec (vec a) 0 mid))
          right (merge-sort-alg (subvec (vec a) mid))]
      (vec (loop [l left r right result []]
             (cond
               (empty? l) (into result r)
               (empty? r) (into result l)
               (<= (first l) (first r)) (recur (rest l) r (conj result (first l)))
               :else (recur l (rest r) (conj result (first r)))))))))

(defn heap-sort
  "ヒープソート（純粋関数版）"
  [a]
  (if (empty? a)
    []
    (let [arr (int-array a)
          n (alength arr)
          down-heap (fn [^ints arr left right]
                      (let [temp (aget arr left)]
                        (loop [parent left]
                          (if (>= parent (quot (inc right) 2))
                            (aset arr parent temp)
                            (let [cl (inc (* parent 2))
                                  cr (inc cl)
                                  child (if (and (<= cr right) (> (aget arr cr) (aget arr cl))) cr cl)]
                              (if (>= temp (aget arr child))
                                (aset arr parent temp)
                                (do (aset arr parent (aget arr child))
                                    (recur child))))))))]
      ;; ヒープ構築
      (loop [i (quot (dec n) 2)]
        (when (>= i 0)
          (down-heap arr i (dec n))
          (recur (dec i))))
      ;; ソート
      (loop [i (dec n)]
        (when (> i 0)
          (let [tmp (aget arr 0)]
            (aset arr 0 (aget arr i))
            (aset arr i tmp))
          (down-heap arr 0 (dec i))
          (recur (dec i))))
      (vec arr))))
