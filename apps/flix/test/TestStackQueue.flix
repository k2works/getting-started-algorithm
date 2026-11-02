mod TestStackQueue {
    /// 空のスタックは要素を持たず、満杯でもない。
    @Test
    def stack_initial_state(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 3, 0);
            Assert.assertEq(expected = true, StackQueue.stackIsEmpty(0));
            Assert.assertEq(expected = false, StackQueue.stackIsFull(0, values))
        }

    /// スタックからは最後に追加した要素を先に取り出す。
    @Test
    def stack_push_and_pop_lifo(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 3, 0);
            let firstSize = StackQueue.stackPush(1, values, 0);
            let secondSize = StackQueue.stackPush(2, values, 1);
            let thirdSize = StackQueue.stackPush(3, values, 2);
            Assert.assertEq(expected = Some(1), firstSize);
            Assert.assertEq(expected = Some(2), secondSize);
            Assert.assertEq(expected = Some(3), thirdSize);
            Assert.assertEq(expected = Some((3, 2)), StackQueue.stackPop(values, 3));
            Assert.assertEq(expected = Some((2, 1)), StackQueue.stackPop(values, 2));
            Assert.assertEq(expected = Some((1, 0)), StackQueue.stackPop(values, 1))
        }

    /// スタックの peek は要素を取り出さない。
    @Test
    def stack_peek_preserves_size(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 2, 0);
            let newSize = StackQueue.stackPush(8, values, 0);
            Assert.assertEq(expected = Some(1), newSize);
            Assert.assertEq(expected = Some(8), StackQueue.stackPeek(values, 1));
            Assert.assertEq(expected = Some((8, 0)), StackQueue.stackPop(values, 1))
        }

    /// 満杯のスタックへの追加と空のスタックからの取得は None。
    @Test
    def stack_rejects_overflow_and_underflow(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 1, 0);
            let newSize = StackQueue.stackPush(1, values, 0);
            Assert.assertEq(expected = Some(1), newSize);
            Assert.assertEq(expected = None, StackQueue.stackPush(2, values, 1));
            Assert.assertEq(expected = None, StackQueue.stackPop(values, 0));
            Assert.assertEq(expected = None, StackQueue.stackPeek(values, 0))
        }

    /// 容量 0 のスタックには追加できない。
    @Test
    def stack_zero_capacity(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = true, StackQueue.stackIsFull(0, values));
            Assert.assertEq(expected = None, StackQueue.stackPush(1, values, 0))
        }

    /// 範囲外のスタック状態では配列を参照しない。
    @Test
    def stack_rejects_invalid_size(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 2, 0);
            Assert.assertEq(expected = None, StackQueue.stackPush(1, values, -1));
            Assert.assertEq(expected = None, StackQueue.stackPop(values, 3));
            Assert.assertEq(expected = None, StackQueue.stackPeek(values, 3))
        }

    /// 空のキューからは要素を取り出せない。
    @Test
    def queue_initial_state(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 3, 0);
            Assert.assertEq(expected = true, StackQueue.queueIsEmpty(0));
            Assert.assertEq(expected = false, StackQueue.queueIsFull(0, values));
            Assert.assertEq(expected = None, StackQueue.queueDequeue(values, 0, 0));
            Assert.assertEq(expected = None, StackQueue.queuePeek(values, 0, 0))
        }

    /// キューからは最初に追加した要素を先に取り出す。
    @Test
    def queue_enqueue_and_dequeue_fifo(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 3, 0);
            let firstState = StackQueue.queueEnqueue(1, values, 0, 0);
            let secondState = StackQueue.queueEnqueue(2, values, 1, 1);
            Assert.assertEq(expected = Some((1, 1)), firstState);
            Assert.assertEq(expected = Some((2, 2)), secondState);
            Assert.assertEq(expected = Some((1, 1, 1)), StackQueue.queueDequeue(values, 0, 2));
            Assert.assertEq(expected = Some((2, 2, 0)), StackQueue.queueDequeue(values, 1, 1))
        }

    /// リングバッファは末尾から先頭へ折り返して空き領域を再利用する。
    @Test
    def queue_wraps_around(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 3, 0);
            let first = StackQueue.queueEnqueue(1, values, 0, 0);
            let second = StackQueue.queueEnqueue(2, values, 1, 1);
            let third = StackQueue.queueEnqueue(3, values, 2, 2);
            Assert.assertEq(expected = Some((1, 1)), first);
            Assert.assertEq(expected = Some((2, 2)), second);
            Assert.assertEq(expected = Some((0, 3)), third);
            Assert.assertEq(expected = Some((1, 1, 2)), StackQueue.queueDequeue(values, 0, 3));
            Assert.assertEq(expected = Some((1, 3)), StackQueue.queueEnqueue(4, values, 0, 2));
            Assert.assertEq(expected = Some((2, 2, 2)), StackQueue.queueDequeue(values, 1, 3));
            Assert.assertEq(expected = Some((3, 0, 1)), StackQueue.queueDequeue(values, 2, 2));
            Assert.assertEq(expected = Some((4, 1, 0)), StackQueue.queueDequeue(values, 0, 1))
        }

    /// 満杯のキューへの追加は None を返す。
    @Test
    def queue_rejects_overflow(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 1, 0);
            let state = StackQueue.queueEnqueue(1, values, 0, 0);
            Assert.assertEq(expected = Some((0, 1)), state);
            Assert.assertEq(expected = None, StackQueue.queueEnqueue(2, values, 0, 1))
        }

    /// 容量 0 のキューでは追加・取得を行わない。
    @Test
    def queue_zero_capacity(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = true, StackQueue.queueIsFull(0, values));
            Assert.assertEq(expected = None, StackQueue.queueEnqueue(1, values, 0, 0));
            Assert.assertEq(expected = None, StackQueue.queueDequeue(values, 0, 0))
        }

    /// 範囲外のキュー状態では配列を参照しない。
    @Test
    def queue_rejects_invalid_state(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 2, 0);
            Assert.assertEq(expected = None, StackQueue.queueEnqueue(1, values, 2, 0));
            Assert.assertEq(expected = None, StackQueue.queueEnqueue(1, values, 0, -1));
            Assert.assertEq(expected = None, StackQueue.queueDequeue(values, 2, 1));
            Assert.assertEq(expected = None, StackQueue.queuePeek(values, 0, 3))
        }

    /// キューの peek は先頭要素と状態を維持する。
    @Test
    def queue_peek_preserves_state(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 2, 0);
            let state = StackQueue.queueEnqueue(7, values, 0, 0);
            Assert.assertEq(expected = Some((1, 1)), state);
            Assert.assertEq(expected = Some(7), StackQueue.queuePeek(values, 0, 1));
            Assert.assertEq(expected = Some((7, 1, 0)), StackQueue.queueDequeue(values, 0, 1))
        }
}
