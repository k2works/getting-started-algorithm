"""第4章 スタックとキュー"""

from typing import Any


class FixedStack:
    """固定長スタック"""

    class Empty(Exception):
        """スタックが空の場合の例外"""

    class Full(Exception):
        """スタックが満杯の場合の例外"""

    def __init__(self, capacity: int) -> None:
        self.stk: list[Any] = [None] * capacity
        self.capacity = capacity
        self.ptr = 0  # スタックポインタ（積まれた要素数）

    def __len__(self) -> int:
        return self.ptr

    def __contains__(self, value: Any) -> bool:
        return self.find(value) != -1

    def is_empty(self) -> bool:
        """スタックが空かどうかを判定"""
        return self.ptr <= 0

    def is_full(self) -> bool:
        """スタックが満杯かどうかを判定"""
        return self.ptr >= self.capacity

    def push(self, value: Any) -> None:
        """スタックにvalueをプッシュ"""
        if self.is_full():
            raise FixedStack.Full
        self.stk[self.ptr] = value
        self.ptr += 1

    def pop(self) -> Any:
        """スタックからポップ"""
        if self.is_empty():
            raise FixedStack.Empty
        self.ptr -= 1
        return self.stk[self.ptr]

    def peek(self) -> Any:
        """スタックの先頭要素を参照（取り出さない）"""
        if self.is_empty():
            raise FixedStack.Empty
        return self.stk[self.ptr - 1]

    def find(self, value: Any) -> int:
        """スタック内のvalueを探索してインデックスを返す（底からのインデックス）"""
        for i in range(self.ptr - 1, -1, -1):
            if self.stk[i] == value:
                return i
        return -1

    def count(self, value: Any) -> int:
        """スタック内のvalueの個数を返す"""
        return self.stk[:self.ptr].count(value)

    def clear(self) -> None:
        """スタックを空にする"""
        self.ptr = 0

    def dump(self) -> None:
        """スタックの全要素を底から頂上に向かって表示"""
        if self.is_empty():
            print("スタックは空です")
        else:
            print(self.stk[:self.ptr])


class FixedQueue:
    """固定長キュー（リングバッファ）"""

    class Empty(Exception):
        """キューが空の場合の例外"""

    class Full(Exception):
        """キューが満杯の場合の例外"""

    def __init__(self, capacity: int) -> None:
        self.que: list[Any] = [None] * capacity
        self.capacity = capacity
        self.front = 0   # 先頭インデックス
        self.rear = 0    # 末尾インデックス
        self.num = 0     # キューに積まれた要素数

    def __len__(self) -> int:
        return self.num

    def __contains__(self, value: Any) -> bool:
        return self.find(value) != -1

    def is_empty(self) -> bool:
        """キューが空かどうかを判定"""
        return self.num <= 0

    def is_full(self) -> bool:
        """キューが満杯かどうかを判定"""
        return self.num >= self.capacity

    def enque(self, value: Any) -> None:
        """キューにvalueをエンキュー"""
        if self.is_full():
            raise FixedQueue.Full
        self.que[self.rear] = value
        self.rear += 1
        self.num += 1
        if self.rear == self.capacity:
            self.rear = 0  # リングバッファの折り返し

    def deque(self) -> Any:
        """キューからデキュー"""
        if self.is_empty():
            raise FixedQueue.Empty
        value = self.que[self.front]
        self.front += 1
        self.num -= 1
        if self.front == self.capacity:
            self.front = 0  # リングバッファの折り返し
        return value

    def peek(self) -> Any:
        """キューの先頭要素を参照（取り出さない）"""
        if self.is_empty():
            raise FixedQueue.Empty
        return self.que[self.front]

    def find(self, value: Any) -> int:
        """キュー内のvalueを探索してインデックスを返す（先頭からのインデックス）"""
        for i in range(self.num):
            idx = (i + self.front) % self.capacity
            if self.que[idx] == value:
                return i
        return -1

    def count(self, value: Any) -> int:
        """キュー内のvalueの個数を返す"""
        c = 0
        for i in range(self.num):
            idx = (i + self.front) % self.capacity
            if self.que[idx] == value:
                c += 1
        return c

    def clear(self) -> None:
        """キューを空にする"""
        self.front = self.rear = self.num = 0

    def dump(self) -> None:
        """キューの全要素を先頭から末尾に向かって表示"""
        if self.is_empty():
            print("キューは空です")
        else:
            for i in range(self.num):
                print(self.que[(i + self.front) % self.capacity], end=" ")
            print()
