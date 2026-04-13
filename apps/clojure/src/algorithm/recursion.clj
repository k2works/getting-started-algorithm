(ns algorithm.recursion
  "第5章 再帰アルゴリズム")

(defn factorial
  "n の階乗を再帰的に計算する"
  [n]
  (if (<= n 0)
    1
    (* n (factorial (dec n)))))

(defn gcd
  "ユークリッドの互除法で最大公約数を求める"
  [x y]
  (if (zero? y)
    x
    (recur y (mod x y))))

(defn recursive-sum
  "1 から n までの和を再帰的に計算する"
  [n]
  (if (<= n 0)
    0
    (+ n (recursive-sum (dec n)))))

(defn hanoi
  "ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す"
  [n src dst via]
  (if (= n 1)
    [[src dst]]
    (concat (hanoi (dec n) src via dst)
            [[src dst]]
            (hanoi (dec n) via dst src))))

(defn maze-solve
  "迷路をバックトラッキングで解く。maze[r][c] == 0: 通路, 1: 壁"
  ([maze row col goal-row goal-col]
   (maze-solve maze row col goal-row goal-col #{}))
  ([maze row col goal-row goal-col visited]
   (if (and (= row goal-row) (= col goal-col))
     true
     (let [rows (count maze)
           cols (count (first maze))
           visited (conj visited [row col])
           directions [[-1 0] [1 0] [0 -1] [0 1]]]
       (boolean
        (some (fn [[dr dc]]
                (let [nr (+ row dr)
                      nc (+ col dc)]
                  (when (and (<= 0 nr (dec rows))
                             (<= 0 nc (dec cols))
                             (zero? (get-in maze [nr nc]))
                             (not (contains? visited [nr nc])))
                    (maze-solve maze nr nc goal-row goal-col visited))))
              directions))))))
