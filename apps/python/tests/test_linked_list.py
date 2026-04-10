"""第8章 リスト — テスト"""

import pytest

from algorithm.linked_list import (
    DoublyLinkedList,
    LinkedList,
)


class TestLinkedList:
    """線形リスト（単方向連結リスト）"""

    def setup_method(self):
        self.lst = LinkedList()

    def test_initial_empty(self):
        assert len(self.lst) == 0
        assert self.lst.is_empty() is True

    def test_add_first(self):
        self.lst.add_first(1)
        assert len(self.lst) == 1

    def test_add_last(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        assert len(self.lst) == 2

    def test_search_found(self):
        self.lst.add_last(10)
        self.lst.add_last(20)
        self.lst.add_last(30)
        node = self.lst.search(20)
        assert node is not None
        assert node.data == 20

    def test_search_not_found(self):
        self.lst.add_last(10)
        assert self.lst.search(99) is None

    def test_remove_first(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.remove_first()
        assert len(self.lst) == 1
        assert self.lst.search(1) is None

    def test_remove_last(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.remove_last()
        assert len(self.lst) == 1
        assert self.lst.search(2) is None

    def test_remove_node(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.add_last(3)
        node = self.lst.search(2)
        self.lst.remove(node)
        assert self.lst.search(2) is None
        assert len(self.lst) == 2

    def test_contains(self):
        self.lst.add_last(42)
        assert 42 in self.lst
        assert 0 not in self.lst

    def test_remove_first_empty_raises(self):
        with pytest.raises(LinkedList.Empty):
            self.lst.remove_first()

    def test_remove_last_empty_raises(self):
        with pytest.raises(LinkedList.Empty):
            self.lst.remove_last()

    def test_iter(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.add_last(3)
        data = [node.data for node in self.lst]
        assert data == [1, 2, 3]

    def test_clear(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.clear()
        assert self.lst.is_empty() is True

    def test_remove_last_single(self):
        """単一要素リストの末尾削除"""
        self.lst.add_last(1)
        self.lst.remove_last()
        assert self.lst.is_empty() is True

    def test_remove_last_multiple(self):
        """複数要素リストの末尾削除"""
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.add_last(3)
        self.lst.remove_last()
        assert self.lst.search(3) is None
        assert len(self.lst) == 2

    def test_remove_from_empty_list(self):
        """空のリストで remove を呼んでも何もしない"""
        import algorithm.linked_list as ll
        node = ll._Node(1)
        self.lst.remove(node)  # 空なので何もしない
        assert self.lst.is_empty() is True

    def test_remove_head_node(self):
        """先頭ノードを remove で削除"""
        self.lst.add_last(1)
        self.lst.add_last(2)
        head_node = self.lst.head
        self.lst.remove(head_node)
        assert self.lst.search(1) is None
        assert len(self.lst) == 1

    def test_remove_node_not_in_list(self):
        """リスト内にないノードの削除は何もしない"""
        self.lst.add_last(1)
        self.lst.add_last(2)
        import algorithm.linked_list as ll
        orphan = ll._Node(99)
        self.lst.remove(orphan)  # 何も起きない
        assert len(self.lst) == 2


class TestDoublyLinkedList:
    """双方向連結リスト"""

    def setup_method(self):
        self.lst = DoublyLinkedList()

    def test_initial_empty(self):
        assert len(self.lst) == 0
        assert self.lst.is_empty() is True

    def test_add_first(self):
        self.lst.add_first(1)
        assert len(self.lst) == 1

    def test_add_last(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        assert len(self.lst) == 2

    def test_search(self):
        self.lst.add_last(10)
        self.lst.add_last(20)
        node = self.lst.search(20)
        assert node is not None
        assert node.data == 20

    def test_search_not_found(self):
        assert self.lst.search(99) is None

    def test_remove(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.add_last(3)
        node = self.lst.search(2)
        self.lst.remove(node)
        assert self.lst.search(2) is None
        assert len(self.lst) == 2

    def test_contains(self):
        self.lst.add_last(42)
        assert 42 in self.lst
        assert 0 not in self.lst

    def test_iter(self):
        self.lst.add_last(1)
        self.lst.add_last(2)
        self.lst.add_last(3)
        data = [node.data for node in self.lst]
        assert data == [1, 2, 3]

    def test_clear(self):
        self.lst.add_last(1)
        self.lst.clear()
        assert self.lst.is_empty() is True

    def test_remove_from_empty(self):
        """空のリストからの削除は何もしない"""
        import algorithm.linked_list as ll
        orphan = ll._DNode(99)
        self.lst.remove(orphan)  # 空なので何もしない
        assert self.lst.is_empty() is True
