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
