(ns algorithm.search-algorithms
  "第3章 探索アルゴリズム")

(defn seq-search
  "線形探索: 配列 a から key-val と等しい要素のインデックスを返す"
  [a key-val]
  (loop [i 0]
    (cond
      (>= i (count a)) -1
      (= (nth a i) key-val) i
      :else (recur (inc i)))))

(defn seq-search-ex
  "番兵法: 配列 a の末尾に番兵を追加して線形探索する"
  [a key-val]
  (let [a-with-sentinel (conj (vec a) key-val)
        n (count a)]
    (loop [i 0]
      (if (= (nth a-with-sentinel i) key-val)
        (if (= i n) -1 i)
        (recur (inc i))))))

(defn bin-search
  "二分探索: ソート済み配列 a から key-val のインデックスを返す"
  [a key-val]
  (loop [pl 0 pr (dec (count a))]
    (if (> pl pr)
      -1
      (let [pc (quot (+ pl pr) 2)
            v (nth a pc)]
        (cond
          (= v key-val) pc
          (< v key-val) (recur (inc pc) pr)
          :else (recur pl (dec pc)))))))

;; --- チェイン法ハッシュ ---

(defn make-chained-hash
  "チェイン法ハッシュテーブルを作成する"
  [capacity]
  (atom {:capacity capacity
         :table (vec (repeat capacity nil))}))

(defn- hash-value [capacity key-val]
  (if (integer? key-val)
    (mod key-val capacity)
    (mod (Math/abs (.hashCode (str key-val))) capacity)))

(defn hash-search
  "ハッシュテーブルからキーを検索して値を返す"
  [h key-val]
  (let [{:keys [capacity table]} @h
        idx (hash-value capacity key-val)]
    (loop [chain (nth table idx)]
      (cond
        (nil? chain) nil
        (= (:key (first chain)) key-val) (:value (first chain))
        :else (recur (next chain))))))

(defn hash-add
  "ハッシュテーブルにキーと値を追加する。重複キーは false を返す"
  [h key-val value]
  (if (some? (hash-search h key-val))
    false
    (let [{:keys [capacity table]} @h
          idx (hash-value capacity key-val)
          chain (nth table idx)
          new-chain (cons {:key key-val :value value} chain)]
      (swap! h assoc :table (assoc table idx new-chain))
      true)))

(defn hash-remove
  "ハッシュテーブルからキーを削除する。見つからなければ false を返す"
  [h key-val]
  (let [{:keys [capacity table]} @h
        idx (hash-value capacity key-val)
        chain (nth table idx)
        new-chain (remove #(= (:key %) key-val) chain)]
    (if (= (count chain) (count new-chain))
      false
      (do
        (swap! h assoc :table (assoc table idx (seq new-chain)))
        true))))
