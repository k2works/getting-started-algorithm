(ns algorithm.linked-lists
  "第8章 リスト（連結リスト）")

(defrecord Node [data next])

(defn make-linked-list
  "連結リストを作成する"
  []
  (atom {:head nil :size 0}))

(defn ll-size
  "リストのサイズを返す"
  [lst]
  (:size @lst))

(defn ll-insert-front
  "先頭にノードを挿入する"
  [lst val]
  (swap! lst (fn [{:keys [head size]}]
               {:head (->Node val head)
                :size (inc size)})))

(defn ll-insert-back
  "末尾にノードを挿入する"
  [lst val]
  (swap! lst (fn [{:keys [head size]}]
               (if (nil? head)
                 {:head (->Node val nil) :size (inc size)}
                 (let [new-node (->Node val nil)]
                   {:head (loop [current head path []]
                            (if (nil? (:next current))
                              ;; 末尾に到達: 新ノードを繋げて全体を再構築
                              (let [updated (->Node (:data current) new-node)]
                                (reduce (fn [acc node]
                                          (->Node (:data node) acc))
                                        updated
                                        (reverse path)))
                              (recur (:next current) (conj path current))))
                    :size (inc size)})))))

(defn ll-search
  "値を検索する。見つかれば true、見つからなければ false"
  [lst val]
  (loop [current (:head @lst)]
    (cond
      (nil? current) false
      (= (:data current) val) true
      :else (recur (:next current)))))

(defn ll-delete
  "値に一致する最初のノードを削除する"
  [lst val]
  (swap! lst (fn [{:keys [head size]}]
               (cond
                 (nil? head) {:head nil :size size}
                 (= (:data head) val) {:head (:next head) :size (dec size)}
                 :else
                 (let [result (loop [current head path []]
                                (cond
                                  (nil? (:next current))
                                  nil ;; 見つからなかった
                                  (= (:data (:next current)) val)
                                  ;; 次のノードを削除
                                  (let [updated (->Node (:data current) (:next (:next current)))]
                                    (reduce (fn [acc node]
                                              (->Node (:data node) acc))
                                            updated
                                            (reverse path)))
                                  :else
                                  (recur (:next current) (conj path current))))]
                   (if result
                     {:head result :size (dec size)}
                     {:head head :size size}))))))

(defn ll-to-vec
  "リストの全要素を vector に変換する"
  [lst]
  (loop [current (:head @lst) result []]
    (if (nil? current)
      result
      (recur (:next current) (conj result (:data current))))))

;; === 双方向連結リスト ===
;; 各ノードは atom で、{:data :prev :next} マップを保持する。
;; 番兵ノード（sentinel）を使い、先頭・末尾の特殊処理を不要にする。

(defn- make-dnode
  "双方向リストのノードを作成する"
  [data prev next]
  (atom {:data data :prev prev :next next}))

(defn make-doubly-linked-list
  "双方向連結リストを作成する（番兵ノード使用）"
  []
  (let [sentinel (make-dnode nil nil nil)]
    (swap! sentinel assoc :prev sentinel :next sentinel)
    (atom {:sentinel sentinel :size 0})))

(defn dll-size
  "双方向リストのサイズを返す"
  [dlst]
  (:size @dlst))

(defn dll-empty?
  "双方向リストが空か判定する"
  [dlst]
  (let [sentinel (:sentinel @dlst)]
    (= (:next @sentinel) sentinel)))

(defn dll-add-last
  "末尾にノードを挿入する"
  [dlst val]
  (let [sentinel (:sentinel @dlst)
        prev-node (:prev @sentinel)
        new-node (make-dnode val prev-node sentinel)]
    (swap! prev-node assoc :next new-node)
    (swap! sentinel assoc :prev new-node)
    (swap! dlst update :size inc)))

(defn dll-add-first
  "先頭にノードを挿入する"
  [dlst val]
  (let [sentinel (:sentinel @dlst)
        next-node (:next @sentinel)
        new-node (make-dnode val sentinel next-node)]
    (swap! next-node assoc :prev new-node)
    (swap! sentinel assoc :next new-node)
    (swap! dlst update :size inc)))

(defn dll-search
  "値を検索する"
  [dlst val]
  (let [sentinel (:sentinel @dlst)]
    (loop [current (:next @sentinel)]
      (cond
        (= current sentinel) false
        (= (:data @current) val) true
        :else (recur (:next @current))))))

(defn dll-remove
  "値に一致する最初のノードを削除する"
  [dlst val]
  (let [sentinel (:sentinel @dlst)]
    (loop [current (:next @sentinel)]
      (when (not= current sentinel)
        (if (= (:data @current) val)
          (let [prev-node (:prev @current)
                next-node (:next @current)]
            (swap! prev-node assoc :next next-node)
            (swap! next-node assoc :prev prev-node)
            (swap! dlst update :size dec))
          (recur (:next @current)))))))

(defn dll-to-vec
  "双方向リストの全要素を vector に変換する"
  [dlst]
  (let [sentinel (:sentinel @dlst)]
    (loop [current (:next @sentinel) result []]
      (if (= current sentinel)
        result
        (recur (:next @current) (conj result (:data @current)))))))
