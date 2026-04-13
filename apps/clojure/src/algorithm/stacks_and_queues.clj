(ns algorithm.stacks-and-queues
  "第4章 スタックとキュー")

;; --- スタック ---

(defn make-stack
  "固定長スタックを作成する"
  [capacity]
  (atom {:data [] :max capacity}))

(defn stack-empty?
  "スタックが空かどうかを判定する"
  [s]
  (empty? (:data @s)))

(defn stack-full?
  "スタックが満杯かどうかを判定する"
  [s]
  (>= (count (:data @s)) (:max @s)))

(defn stack-push
  "スタックに値をプッシュする"
  [s val]
  (if (stack-full? s)
    (throw (Exception. "Stack is full"))
    (swap! s update :data conj val)))

(defn stack-pop
  "スタックから値をポップする"
  [s]
  (if (stack-empty? s)
    (throw (Exception. "Stack is empty"))
    (let [v (peek (:data @s))]
      (swap! s update :data pop)
      v)))

(defn stack-peek
  "スタックの先頭要素を参照する（取り出さない）"
  [s]
  (if (stack-empty? s)
    (throw (Exception. "Stack is empty"))
    (peek (:data @s))))

;; --- キュー（リングバッファ） ---

(defn make-queue
  "固定長キューを作成する"
  [capacity]
  (atom {:data (vec (repeat capacity nil))
         :capacity capacity
         :front 0
         :rear 0
         :num 0}))

(defn queue-empty?
  "キューが空かどうかを判定する"
  [q]
  (zero? (:num @q)))

(defn queue-full?
  "キューが満杯かどうかを判定する"
  [q]
  (>= (:num @q) (:capacity @q)))

(defn enqueue
  "キューに値をエンキューする"
  [q val]
  (if (queue-full? q)
    (throw (Exception. "Queue is full"))
    (let [{:keys [rear capacity]} @q]
      (swap! q (fn [state]
                 (-> state
                     (assoc-in [:data rear] val)
                     (assoc :rear (mod (inc rear) capacity))
                     (update :num inc)))))))

(defn dequeue
  "キューから値をデキューする"
  [q]
  (if (queue-empty? q)
    (throw (Exception. "Queue is empty"))
    (let [{:keys [front capacity data]} @q
          v (nth data front)]
      (swap! q (fn [state]
                 (-> state
                     (assoc :front (mod (inc front) capacity))
                     (update :num dec))))
      v)))

(defn queue-peek
  "キューの先頭要素を参照する（取り出さない）"
  [q]
  (if (queue-empty? q)
    (throw (Exception. "Queue is empty"))
    (nth (:data @q) (:front @q))))
