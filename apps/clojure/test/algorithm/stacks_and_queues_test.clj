(ns algorithm.stacks-and-queues-test
  (:require [clojure.test :refer :all]
            [algorithm.stacks-and-queues :refer :all]))

(deftest stack-test
  (testing "スタックの初期状態"
    (let [s (make-stack 64)]
      (is (true? (stack-empty? s)))
      (is (false? (stack-full? s)))))

  (testing "push と peek"
    (let [s (make-stack 64)]
      (stack-push s 1)
      (is (= 1 (stack-peek s)))))

  (testing "push と pop"
    (let [s (make-stack 64)]
      (stack-push s 1)
      (is (= 1 (stack-pop s)))))

  (testing "LIFO 順序"
    (let [s (make-stack 64)]
      (stack-push s 1)
      (stack-push s 2)
      (stack-push s 3)
      (is (= 3 (stack-pop s)))
      (is (= 2 (stack-pop s)))
      (is (= 1 (stack-pop s)))))

  (testing "満杯判定"
    (let [s (make-stack 3)]
      (stack-push s 1)
      (stack-push s 2)
      (stack-push s 3)
      (is (true? (stack-full? s)))))

  (testing "空のスタックから pop で例外"
    (let [s (make-stack 64)]
      (is (thrown? Exception (stack-pop s)))))

  (testing "満杯のスタックに push で例外"
    (let [s (make-stack 2)]
      (stack-push s 1)
      (stack-push s 2)
      (is (thrown? Exception (stack-push s 3))))))

(deftest queue-test
  (testing "キューの初期状態"
    (let [q (make-queue 64)]
      (is (true? (queue-empty? q)))
      (is (false? (queue-full? q)))))

  (testing "enqueue と dequeue"
    (let [q (make-queue 64)]
      (enqueue q 1)
      (is (= 1 (dequeue q)))))

  (testing "FIFO 順序"
    (let [q (make-queue 64)]
      (enqueue q 1)
      (enqueue q 2)
      (enqueue q 3)
      (is (= 1 (dequeue q)))
      (is (= 2 (dequeue q)))
      (is (= 3 (dequeue q)))))

  (testing "peek"
    (let [q (make-queue 64)]
      (enqueue q 10)
      (enqueue q 20)
      (is (= 10 (queue-peek q)))))

  (testing "満杯判定"
    (let [q (make-queue 3)]
      (enqueue q 1)
      (enqueue q 2)
      (enqueue q 3)
      (is (true? (queue-full? q)))))

  (testing "空のキューから dequeue で例外"
    (let [q (make-queue 64)]
      (is (thrown? Exception (dequeue q)))))

  (testing "リングバッファの折り返し"
    (let [q (make-queue 3)]
      (enqueue q 1)
      (enqueue q 2)
      (enqueue q 3)
      (dequeue q)
      (enqueue q 4)
      (is (= 2 (dequeue q)))
      (is (= 3 (dequeue q)))
      (is (= 4 (dequeue q))))))
