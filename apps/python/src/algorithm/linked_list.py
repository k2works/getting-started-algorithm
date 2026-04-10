"""第8章 リスト（連結リスト）"""

from collections.abc import Iterator
from typing import Any


class _Node:
    """単方向連結リストのノード"""

    def __init__(self, data: Any, next_node: "_Node | None" = None) -> None:
        self.data = data
        self.next: _Node | None = next_node


class LinkedList:
    """線形リスト（単方向連結リスト）"""

    class Empty(Exception):
        """リストが空の場合の例外"""

    def __init__(self) -> None:
        self.head: _Node | None = None
        self.no = 0  # 要素数

    def __len__(self) -> int:
        return self.no

    def __contains__(self, data: Any) -> bool:
        return self.search(data) is not None

    def __iter__(self) -> Iterator[_Node]:
        ptr = self.head
        while ptr is not None:
            yield ptr
            ptr = ptr.next

    def is_empty(self) -> bool:
        return self.head is None

    def search(self, data: Any) -> _Node | None:
        """dataと等しいノードを探索"""
        ptr = self.head
        while ptr is not None:
            if ptr.data == data:
                return ptr
            ptr = ptr.next
        return None

    def add_first(self, data: Any) -> None:
        """先頭にノードを挿入"""
        self.head = _Node(data, self.head)
        self.no += 1

    def add_last(self, data: Any) -> None:
        """末尾にノードを挿入"""
        if self.head is None:
            self.head = _Node(data)
        else:
            ptr = self.head
            while ptr.next is not None:
                ptr = ptr.next
            ptr.next = _Node(data)
        self.no += 1

    def remove_first(self) -> None:
        """先頭ノードを削除"""
        if self.head is None:
            raise LinkedList.Empty
        self.head = self.head.next
        self.no -= 1

    def remove_last(self) -> None:
        """末尾ノードを削除"""
        if self.head is None:
            raise LinkedList.Empty
        if self.head.next is None:
            self.head = None
        else:
            ptr = self.head
            while ptr.next is not None and ptr.next.next is not None:
                ptr = ptr.next
            ptr.next = None
        self.no -= 1

    def remove(self, node: _Node) -> None:
        """指定したノードを削除"""
        if self.head is None:
            return
        if self.head is node:
            self.head = self.head.next
            self.no -= 1
            return
        ptr = self.head
        while ptr.next is not None:
            if ptr.next is node:
                ptr.next = node.next
                self.no -= 1
                return
            ptr = ptr.next

    def clear(self) -> None:
        """全ノードを削除"""
        self.head = None
        self.no = 0


class _DNode:
    """双方向連結リストのノード"""

    def __init__(
        self,
        data: Any,
        prev: "_DNode | None" = None,
        next_node: "_DNode | None" = None,
    ) -> None:
        self.data = data
        self.prev: _DNode | None = prev
        self.next: _DNode | None = next_node


class DoublyLinkedList:
    """双方向連結リスト（番兵ノード使用）"""

    def __init__(self) -> None:
        # 番兵ノード（ダミー）: head.next が先頭、head.prev が末尾
        self.head = _DNode(None)
        self.head.prev = self.head
        self.head.next = self.head
        self.no = 0

    def __len__(self) -> int:
        return self.no

    def __contains__(self, data: Any) -> bool:
        return self.search(data) is not None

    def __iter__(self) -> Iterator[_DNode]:
        ptr = self.head.next
        while ptr is not self.head:
            yield ptr
            ptr = ptr.next

    def is_empty(self) -> bool:
        return self.no == 0

    def search(self, data: Any) -> _DNode | None:
        """dataと等しいノードを探索"""
        ptr = self.head.next
        while ptr is not self.head:
            if ptr.data == data:
                return ptr
            ptr = ptr.next
        return None

    def add_first(self, data: Any) -> None:
        """先頭にノードを挿入"""
        node = _DNode(data, self.head, self.head.next)
        self.head.next.prev = node
        self.head.next = node
        self.no += 1

    def add_last(self, data: Any) -> None:
        """末尾にノードを挿入"""
        node = _DNode(data, self.head.prev, self.head)
        self.head.prev.next = node
        self.head.prev = node
        self.no += 1

    def remove(self, node: _DNode) -> None:
        """指定したノードを削除"""
        if self.is_empty():
            return
        node.prev.next = node.next
        node.next.prev = node.prev
        self.no -= 1

    def clear(self) -> None:
        """全ノードを削除"""
        self.head.prev = self.head
        self.head.next = self.head
        self.no = 0
