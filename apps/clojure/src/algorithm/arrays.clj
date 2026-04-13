(ns algorithm.arrays
  "第2章 配列")

(defn max-of
  "配列の要素の最大値を返す"
  [a]
  (reduce max a))

(defn reverse-arr
  "配列を反転した新しい vector を返す"
  [a]
  (vec (rseq (vec a))))

(defn card-conv
  "整数値 x を r 進数に変換した文字列を返す"
  [x r]
  (let [dchar "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    (loop [x x digits []]
      (if (zero? x)
        (apply str (reverse digits))
        (recur (quot x r)
               (conj digits (nth dchar (rem x r))))))))

(defn prime1
  "x 以下の素数を列挙する（第1版）— 除算回数を返す"
  [x]
  (loop [n 2 counter 0]
    (if (> n x)
      counter
      (let [c (loop [i 2 cnt 0]
                (if (>= i n)
                  cnt
                  (let [new-cnt (inc cnt)]
                    (if (zero? (rem n i))
                      new-cnt
                      (recur (inc i) new-cnt)))))]
        (recur (inc n) (+ counter c))))))

(defn prime2
  "x 以下の素数を列挙する（第2版）— 除算回数を返す"
  [x]
  (let [prime (int-array 500)]
    (aset prime 0 2)
    (loop [n 3 ptr 1 counter 0]
      (if (> n x)
        counter
        (let [[is-prime c]
              (loop [i 1 cnt 0]
                (if (>= i ptr)
                  [true cnt]
                  (let [new-cnt (inc cnt)]
                    (if (zero? (rem n (aget prime i)))
                      [false new-cnt]
                      (recur (inc i) new-cnt)))))]
          (when is-prime
            (aset prime ptr (int n)))
          (recur (+ n 2)
                 (if is-prime (inc ptr) ptr)
                 (+ counter c)))))))

(defn prime3
  "x 以下の素数を列挙する（第3版）— 除算回数を返す"
  [x]
  (let [prime (int-array 500)]
    (aset prime 0 2)
    (aset prime 1 3)
    (loop [n 5 ptr 2 counter 0]
      (if (> n 1000)
        counter
        (let [[is-prime c]
              (loop [i 1 cnt 0]
                (let [p (aget prime i)]
                  (if (> (* p p) n)
                    [true (inc cnt)]
                    (let [new-cnt (+ cnt 2)]
                      (if (zero? (rem n p))
                        [false new-cnt]
                        (recur (inc i) new-cnt))))))]
          (when is-prime
            (aset prime ptr (int n)))
          (recur (+ n 2)
                 (if is-prime (inc ptr) ptr)
                 (+ counter c)))))))
