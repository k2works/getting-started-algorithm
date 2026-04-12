// chapter04: スタックとキュー

// ============================================================
// 1. スタック（固定長スタック）
// ============================================================

/// 固定長スタック（LIFO）
pub struct Stack {
    capacity: usize,
    ptr: usize,
    data: Vec<i32>,
}

impl Stack {
    /// 指定した容量でスタックを生成する
    pub fn new(capacity: usize) -> Self {
        Stack {
            capacity,
            ptr: 0,
            data: vec![0; capacity],
        }
    }

    /// スタックに値をプッシュする
    pub fn push(&mut self, value: i32) -> Result<(), &'static str> {
        if self.is_full() {
            return Err("stack is full");
        }
        self.data[self.ptr] = value;
        self.ptr += 1;
        Ok(())
    }

    /// スタックから値をポップする
    pub fn pop(&mut self) -> Result<i32, &'static str> {
        if self.is_empty() {
            return Err("stack is empty");
        }
        self.ptr -= 1;
        Ok(self.data[self.ptr])
    }

    /// スタックの先頭要素を参照する（取り出さない）
    pub fn peek(&self) -> Result<i32, &'static str> {
        if self.is_empty() {
            return Err("stack is empty");
        }
        Ok(self.data[self.ptr - 1])
    }

    /// スタック内の値を探索してインデックスを返す（頂上から底に向かって探索）
    pub fn find(&self, value: i32) -> Option<usize> {
        for i in (0..self.ptr).rev() {
            if self.data[i] == value {
                return Some(i);
            }
        }
        None
    }

    /// スタック内の値の個数を返す
    pub fn count(&self, value: i32) -> usize {
        self.data[..self.ptr].iter().filter(|&&x| x == value).count()
    }

    /// スタックを空にする
    pub fn clear(&mut self) {
        self.ptr = 0;
    }

    /// スタックが空かどうかを判定する
    pub fn is_empty(&self) -> bool {
        self.ptr == 0
    }

    /// スタックが満杯かどうかを判定する
    pub fn is_full(&self) -> bool {
        self.ptr >= self.capacity
    }

    /// スタックに積まれている要素数を返す
    pub fn size(&self) -> usize {
        self.ptr
    }
}

// ============================================================
// 2. キュー（リングバッファキュー）
// ============================================================

/// 固定長キュー（リングバッファ、FIFO）
pub struct Queue {
    capacity: usize,
    num: usize,
    front: usize,
    rear: usize,
    data: Vec<i32>,
}

impl Queue {
    /// 指定した容量でキューを生成する
    pub fn new(capacity: usize) -> Self {
        Queue {
            capacity,
            num: 0,
            front: 0,
            rear: 0,
            data: vec![0; capacity],
        }
    }

    /// キューに値をエンキューする
    pub fn enqueue(&mut self, value: i32) -> Result<(), &'static str> {
        if self.is_full() {
            return Err("queue is full");
        }
        self.data[self.rear] = value;
        self.rear += 1;
        self.num += 1;
        if self.rear == self.capacity {
            self.rear = 0; // リングバッファの折り返し
        }
        Ok(())
    }

    /// キューから値をデキューする
    pub fn dequeue(&mut self) -> Result<i32, &'static str> {
        if self.is_empty() {
            return Err("queue is empty");
        }
        let value = self.data[self.front];
        self.front += 1;
        self.num -= 1;
        if self.front == self.capacity {
            self.front = 0; // リングバッファの折り返し
        }
        Ok(value)
    }

    /// キューの先頭要素を参照する（取り出さない）
    pub fn peek(&self) -> Result<i32, &'static str> {
        if self.is_empty() {
            return Err("queue is empty");
        }
        Ok(self.data[self.front])
    }

    /// キュー内の値を探索して論理インデックスを返す（先頭からの位置）
    pub fn find(&self, value: i32) -> Option<usize> {
        for i in 0..self.num {
            let idx = (i + self.front) % self.capacity;
            if self.data[idx] == value {
                return Some(i);
            }
        }
        None
    }

    /// キュー内の値の個数を返す
    pub fn count(&self, value: i32) -> usize {
        let mut c = 0;
        for i in 0..self.num {
            let idx = (i + self.front) % self.capacity;
            if self.data[idx] == value {
                c += 1;
            }
        }
        c
    }

    /// キューを空にする
    pub fn clear(&mut self) {
        self.front = 0;
        self.rear = 0;
        self.num = 0;
    }

    /// キューが空かどうかを判定する
    pub fn is_empty(&self) -> bool {
        self.num == 0
    }

    /// キューが満杯かどうかを判定する
    pub fn is_full(&self) -> bool {
        self.num >= self.capacity
    }

    /// キューに格納されている要素数を返す
    pub fn size(&self) -> usize {
        self.num
    }
}

// ============================================================
// テスト
// ============================================================

#[cfg(test)]
mod tests {
    use super::*;

    // --------------------------------------------------------
    // Stack テスト
    // --------------------------------------------------------

    mod stack_tests {
        use super::*;

        #[test]
        fn test_initial_state() {
            let stack = Stack::new(64);
            assert!(stack.is_empty());
            assert!(!stack.is_full());
            assert_eq!(stack.size(), 0);
        }

        #[test]
        fn test_push_and_pop() {
            let mut stack = Stack::new(64);
            assert!(stack.push(1).is_ok());
            assert_eq!(stack.pop(), Ok(1));
        }

        #[test]
        fn test_push_multiple_lifo() {
            let mut stack = Stack::new(64);
            stack.push(1).unwrap();
            stack.push(2).unwrap();
            stack.push(3).unwrap();
            assert_eq!(stack.pop(), Ok(3)); // LIFO
            assert_eq!(stack.pop(), Ok(2));
            assert_eq!(stack.pop(), Ok(1));
        }

        #[test]
        fn test_push_overflow() {
            let mut stack = Stack::new(2);
            stack.push(1).unwrap();
            stack.push(2).unwrap();
            assert_eq!(stack.push(3), Err("stack is full"));
        }

        #[test]
        fn test_pop_underflow() {
            let mut stack = Stack::new(64);
            assert_eq!(stack.pop(), Err("stack is empty"));
        }

        #[test]
        fn test_peek() {
            let mut stack = Stack::new(64);
            stack.push(10).unwrap();
            stack.push(20).unwrap();
            assert_eq!(stack.peek(), Ok(20));
            assert_eq!(stack.size(), 2); // peek は取り出さない
        }

        #[test]
        fn test_peek_empty() {
            let stack = Stack::new(64);
            assert_eq!(stack.peek(), Err("stack is empty"));
        }

        #[test]
        fn test_find_existing() {
            let mut stack = Stack::new(64);
            stack.push(10).unwrap();
            stack.push(20).unwrap();
            stack.push(30).unwrap();
            assert_eq!(stack.find(20), Some(1));
        }

        #[test]
        fn test_find_not_existing() {
            let mut stack = Stack::new(64);
            stack.push(10).unwrap();
            assert_eq!(stack.find(99), None);
        }

        #[test]
        fn test_find_empty() {
            let stack = Stack::new(64);
            assert_eq!(stack.find(1), None);
        }

        #[test]
        fn test_count() {
            let mut stack = Stack::new(64);
            stack.push(1).unwrap();
            stack.push(2).unwrap();
            stack.push(1).unwrap();
            stack.push(3).unwrap();
            stack.push(1).unwrap();
            assert_eq!(stack.count(1), 3);
            assert_eq!(stack.count(2), 1);
            assert_eq!(stack.count(99), 0);
        }

        #[test]
        fn test_clear() {
            let mut stack = Stack::new(64);
            stack.push(1).unwrap();
            stack.push(2).unwrap();
            stack.clear();
            assert!(stack.is_empty());
            assert_eq!(stack.size(), 0);
        }

        #[test]
        fn test_is_full() {
            let mut stack = Stack::new(3);
            stack.push(1).unwrap();
            stack.push(2).unwrap();
            assert!(!stack.is_full());
            stack.push(3).unwrap();
            assert!(stack.is_full());
        }

        #[test]
        fn test_size_tracking() {
            let mut stack = Stack::new(64);
            assert_eq!(stack.size(), 0);
            stack.push(1).unwrap();
            assert_eq!(stack.size(), 1);
            stack.push(2).unwrap();
            assert_eq!(stack.size(), 2);
            stack.pop().unwrap();
            assert_eq!(stack.size(), 1);
        }
    }

    // --------------------------------------------------------
    // Queue テスト
    // --------------------------------------------------------

    mod queue_tests {
        use super::*;

        #[test]
        fn test_initial_state() {
            let queue = Queue::new(64);
            assert!(queue.is_empty());
            assert!(!queue.is_full());
            assert_eq!(queue.size(), 0);
        }

        #[test]
        fn test_enqueue_and_dequeue() {
            let mut queue = Queue::new(64);
            assert!(queue.enqueue(1).is_ok());
            assert_eq!(queue.dequeue(), Ok(1));
        }

        #[test]
        fn test_enqueue_multiple_fifo() {
            let mut queue = Queue::new(64);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            queue.enqueue(3).unwrap();
            assert_eq!(queue.dequeue(), Ok(1)); // FIFO
            assert_eq!(queue.dequeue(), Ok(2));
            assert_eq!(queue.dequeue(), Ok(3));
        }

        #[test]
        fn test_enqueue_overflow() {
            let mut queue = Queue::new(2);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            assert_eq!(queue.enqueue(3), Err("queue is full"));
        }

        #[test]
        fn test_dequeue_underflow() {
            let mut queue = Queue::new(64);
            assert_eq!(queue.dequeue(), Err("queue is empty"));
        }

        #[test]
        fn test_ring_buffer_wrap_around() {
            let mut queue = Queue::new(3);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            queue.enqueue(3).unwrap();
            queue.dequeue().unwrap(); // 1 を取り出す
            queue.enqueue(4).unwrap(); // 空き位置（先頭）に追加
            assert_eq!(queue.dequeue(), Ok(2));
            assert_eq!(queue.dequeue(), Ok(3));
            assert_eq!(queue.dequeue(), Ok(4));
        }

        #[test]
        fn test_ring_buffer_full_cycle() {
            let mut queue = Queue::new(3);
            // 満杯にして全部取り出す x2 回
            for _ in 0..2 {
                queue.enqueue(10).unwrap();
                queue.enqueue(20).unwrap();
                queue.enqueue(30).unwrap();
                assert_eq!(queue.dequeue(), Ok(10));
                assert_eq!(queue.dequeue(), Ok(20));
                assert_eq!(queue.dequeue(), Ok(30));
            }
        }

        #[test]
        fn test_peek() {
            let mut queue = Queue::new(64);
            queue.enqueue(10).unwrap();
            queue.enqueue(20).unwrap();
            assert_eq!(queue.peek(), Ok(10)); // 先頭を参照
            assert_eq!(queue.size(), 2); // peek は取り出さない
        }

        #[test]
        fn test_peek_empty() {
            let queue = Queue::new(64);
            assert_eq!(queue.peek(), Err("queue is empty"));
        }

        #[test]
        fn test_find_existing() {
            let mut queue = Queue::new(64);
            queue.enqueue(10).unwrap();
            queue.enqueue(20).unwrap();
            queue.enqueue(30).unwrap();
            assert_eq!(queue.find(20), Some(1)); // 論理インデックス
        }

        #[test]
        fn test_find_not_existing() {
            let mut queue = Queue::new(64);
            queue.enqueue(10).unwrap();
            assert_eq!(queue.find(99), None);
        }

        #[test]
        fn test_find_empty() {
            let queue = Queue::new(64);
            assert_eq!(queue.find(1), None);
        }

        #[test]
        fn test_find_with_wrap_around() {
            let mut queue = Queue::new(3);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            queue.enqueue(3).unwrap();
            queue.dequeue().unwrap(); // front が 1 に進む
            queue.enqueue(4).unwrap(); // rear が折り返して 0 に
            // 論理的には [2, 3, 4]
            assert_eq!(queue.find(4), Some(2));
            assert_eq!(queue.find(2), Some(0));
        }

        #[test]
        fn test_count() {
            let mut queue = Queue::new(64);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            queue.enqueue(1).unwrap();
            queue.enqueue(3).unwrap();
            queue.enqueue(1).unwrap();
            assert_eq!(queue.count(1), 3);
            assert_eq!(queue.count(2), 1);
            assert_eq!(queue.count(99), 0);
        }

        #[test]
        fn test_clear() {
            let mut queue = Queue::new(64);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            queue.clear();
            assert!(queue.is_empty());
            assert_eq!(queue.size(), 0);
        }

        #[test]
        fn test_is_full() {
            let mut queue = Queue::new(3);
            queue.enqueue(1).unwrap();
            queue.enqueue(2).unwrap();
            assert!(!queue.is_full());
            queue.enqueue(3).unwrap();
            assert!(queue.is_full());
        }

        #[test]
        fn test_size_tracking() {
            let mut queue = Queue::new(64);
            assert_eq!(queue.size(), 0);
            queue.enqueue(1).unwrap();
            assert_eq!(queue.size(), 1);
            queue.enqueue(2).unwrap();
            assert_eq!(queue.size(), 2);
            queue.dequeue().unwrap();
            assert_eq!(queue.size(), 1);
        }
    }
}
