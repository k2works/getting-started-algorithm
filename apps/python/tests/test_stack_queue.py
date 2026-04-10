"""第4章 スタックとキュー — テスト"""

import pytest

from algorithm.stack_queue import (
    FixedStack,
    FixedQueue,
)


class TestFixedStack:
    """固定長スタック"""

    def setup_method(self):
        self.stack = FixedStack(64)

    def test_initial_state(self):
        assert self.stack.is_empty() is True
        assert self.stack.is_full() is False

    def test_push_and_peek(self):
        self.stack.push(1)
        assert self.stack.peek() == 1

    def test_push_and_pop(self):
        self.stack.push(1)
        assert self.stack.pop() == 1

    def test_push_multiple(self):
        self.stack.push(1)
        self.stack.push(2)
        self.stack.push(3)
        assert self.stack.pop() == 3  # LIFO
        assert self.stack.pop() == 2
        assert self.stack.pop() == 1

    def test_is_full(self):
        small = FixedStack(3)
        small.push(1)
        small.push(2)
        small.push(3)
        assert small.is_full() is True

    def test_pop_empty_raises(self):
        with pytest.raises(Exception):
            self.stack.pop()

    def test_push_full_raises(self):
        small = FixedStack(2)
        small.push(1)
        small.push(2)
        with pytest.raises(Exception):
            small.push(3)

    def test_peek_empty_raises(self):
        with pytest.raises(Exception):
            self.stack.peek()

    def test_find(self):
        self.stack.push(10)
        self.stack.push(20)
        self.stack.push(30)
        assert self.stack.find(20) == 1  # 底から2番目（index 0-based from bottom, but return index from top)

    def test_find_not_found(self):
        self.stack.push(10)
        assert self.stack.find(99) == -1

    def test_count(self):
        self.stack.push(5)
        self.stack.push(5)
        self.stack.push(10)
        assert self.stack.count(5) == 2
        assert self.stack.count(10) == 1
        assert self.stack.count(99) == 0

    def test_contains(self):
        self.stack.push(42)
        assert self.stack.__contains__(42) is True
        assert self.stack.__contains__(0) is False

    def test_clear(self):
        self.stack.push(1)
        self.stack.push(2)
        self.stack.clear()
        assert self.stack.is_empty() is True

    def test_len(self):
        self.stack.push(1)
        self.stack.push(2)
        assert len(self.stack) == 2

    def test_capacity(self):
        assert self.stack.capacity == 64

    def test_dump(self, capsys):
        self.stack.push(1)
        self.stack.push(2)
        self.stack.dump()
        captured = capsys.readouterr()
        assert "1" in captured.out

    def test_dump_empty(self, capsys):
        self.stack.dump()
        captured = capsys.readouterr()
        assert "空" in captured.out


class TestFixedQueue:
    """固定長キュー（リングバッファ）"""

    def setup_method(self):
        self.queue = FixedQueue(64)

    def test_initial_state(self):
        assert self.queue.is_empty() is True
        assert self.queue.is_full() is False

    def test_enque_and_deque(self):
        self.queue.enque(1)
        assert self.queue.deque() == 1

    def test_enque_multiple(self):
        self.queue.enque(1)
        self.queue.enque(2)
        self.queue.enque(3)
        assert self.queue.deque() == 1  # FIFO
        assert self.queue.deque() == 2
        assert self.queue.deque() == 3

    def test_peek(self):
        self.queue.enque(10)
        self.queue.enque(20)
        assert self.queue.peek() == 10  # 先頭を参照

    def test_is_full(self):
        small = FixedQueue(3)
        small.enque(1)
        small.enque(2)
        small.enque(3)
        assert small.is_full() is True

    def test_deque_empty_raises(self):
        with pytest.raises(Exception):
            self.queue.deque()

    def test_enque_full_raises(self):
        small = FixedQueue(2)
        small.enque(1)
        small.enque(2)
        with pytest.raises(Exception):
            small.enque(3)

    def test_peek_empty_raises(self):
        with pytest.raises(Exception):
            self.queue.peek()

    def test_find(self):
        self.queue.enque(10)
        self.queue.enque(20)
        self.queue.enque(30)
        assert self.queue.find(10) == 0  # 先頭

    def test_find_not_found(self):
        self.queue.enque(10)
        assert self.queue.find(99) == -1

    def test_count(self):
        self.queue.enque(5)
        self.queue.enque(5)
        self.queue.enque(10)
        assert self.queue.count(5) == 2

    def test_contains(self):
        self.queue.enque(42)
        assert self.queue.__contains__(42) is True
        assert self.queue.__contains__(0) is False

    def test_clear(self):
        self.queue.enque(1)
        self.queue.enque(2)
        self.queue.clear()
        assert self.queue.is_empty() is True

    def test_len(self):
        self.queue.enque(1)
        self.queue.enque(2)
        assert len(self.queue) == 2

    def test_capacity(self):
        assert self.queue.capacity == 64

    def test_dump(self, capsys):
        self.queue.enque(1)
        self.queue.enque(2)
        self.queue.dump()
        captured = capsys.readouterr()
        assert "1" in captured.out

    def test_dump_empty(self, capsys):
        self.queue.dump()
        captured = capsys.readouterr()
        assert "空" in captured.out

    def test_ring_buffer_wrap_around(self):
        """リングバッファの折り返し動作確認"""
        small = FixedQueue(3)
        small.enque(1)
        small.enque(2)
        small.enque(3)
        small.deque()  # 1 を取り出す
        small.enque(4)  # 空き位置（先頭）に追加
        assert small.deque() == 2
        assert small.deque() == 3
        assert small.deque() == 4
