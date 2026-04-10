"""第9章 木構造 — テスト"""

import pytest

from algorithm.tree import (
    BinarySearchTree,
)


class TestBinarySearchTree:
    """二分探索木"""

    def setup_method(self):
        self.bst = BinarySearchTree()

    def test_initial_empty(self):
        assert self.bst.is_empty() is True

    def test_insert_and_search(self):
        self.bst.insert(5)
        assert self.bst.search(5) is not None
        assert self.bst.search(5).key == 5

    def test_search_not_found(self):
        assert self.bst.search(99) is None

    def test_insert_multiple(self):
        for v in [5, 3, 7, 1, 4, 6, 8]:
            self.bst.insert(v)
        for v in [5, 3, 7, 1, 4, 6, 8]:
            assert self.bst.search(v) is not None

    def test_inorder_traversal(self):
        """中順探索は昇順に返す"""
        for v in [5, 3, 7, 1, 4, 6, 8]:
            self.bst.insert(v)
        result = self.bst.inorder()
        assert result == [1, 3, 4, 5, 6, 7, 8]

    def test_preorder_traversal(self):
        """前順探索"""
        for v in [5, 3, 7]:
            self.bst.insert(v)
        result = self.bst.preorder()
        assert result == [5, 3, 7]

    def test_postorder_traversal(self):
        """後順探索"""
        for v in [5, 3, 7]:
            self.bst.insert(v)
        result = self.bst.postorder()
        assert result == [3, 7, 5]

    def test_min(self):
        for v in [5, 3, 7, 1, 4]:
            self.bst.insert(v)
        assert self.bst.min() == 1

    def test_max(self):
        for v in [5, 3, 7, 1, 4]:
            self.bst.insert(v)
        assert self.bst.max() == 7

    def test_min_empty_raises(self):
        with pytest.raises(Exception):
            self.bst.min()

    def test_max_empty_raises(self):
        with pytest.raises(Exception):
            self.bst.max()

    def test_delete_leaf(self):
        """葉ノードの削除"""
        for v in [5, 3, 7]:
            self.bst.insert(v)
        self.bst.delete(3)
        assert self.bst.search(3) is None
        assert self.bst.search(5) is not None
        assert self.bst.search(7) is not None

    def test_delete_node_with_one_child(self):
        """子が 1 つのノードの削除"""
        for v in [5, 3, 7, 1]:
            self.bst.insert(v)
        self.bst.delete(3)
        assert self.bst.search(3) is None
        assert self.bst.search(1) is not None

    def test_delete_node_with_two_children(self):
        """子が 2 つのノードの削除"""
        for v in [5, 3, 7, 1, 4]:
            self.bst.insert(v)
        self.bst.delete(3)
        assert self.bst.search(3) is None
        # 残りのノードが存在する
        for v in [1, 4, 5, 7]:
            assert self.bst.search(v) is not None

    def test_delete_root(self):
        """根ノードの削除"""
        for v in [5, 3, 7]:
            self.bst.insert(v)
        self.bst.delete(5)
        assert self.bst.search(5) is None
        # 残りのノードが存在する
        assert self.bst.search(3) is not None
        assert self.bst.search(7) is not None
        # 中順探索が整列を維持
        assert self.bst.inorder() == [3, 7]

    def test_delete_not_found(self):
        """存在しないキーの削除は何もしない"""
        self.bst.insert(5)
        self.bst.delete(99)
        assert self.bst.search(5) is not None

    def test_len(self):
        for v in [5, 3, 7]:
            self.bst.insert(v)
        assert len(self.bst) == 3

    def test_contains(self):
        self.bst.insert(42)
        assert 42 in self.bst
        assert 0 not in self.bst

    def test_delete_single_root(self):
        """根のみのとき根を削除すると空になる"""
        self.bst.insert(5)
        self.bst.delete(5)
        assert self.bst.is_empty() is True

    def test_insert_duplicate(self):
        """重複キーの挿入は無視される"""
        self.bst.insert(5)
        self.bst.insert(5)
        assert len(self.bst) == 1

    def test_delete_node_right_child_only(self):
        """右子のみのノードを削除（左子なし）"""
        for v in [5, 3, 7, 8]:
            self.bst.insert(v)
        self.bst.delete(7)
        assert self.bst.search(7) is None
        assert self.bst.search(8) is not None

    def test_delete_node_with_deep_successor(self):
        """後継ノードが深い位置にある場合（右部分木の最左ノードを探すループ）"""
        for v in [10, 5, 20, 15, 25, 12, 18]:
            self.bst.insert(v)
        # 20 の右部分木: 25, 左部分木: 15(12, 18)
        # 20 の後継は 25 だが successor.left=None なので ループなし
        # 10 の後継は 12 で、ループが必要: 20.left=15, 15.left=12
        self.bst.delete(10)
        assert self.bst.search(10) is None
        assert self.bst.inorder() == [5, 12, 15, 18, 20, 25]

    def test_delete_right_child_of_parent(self):
        """右子として親に繋がっているノードを削除"""
        for v in [5, 3, 7]:
            self.bst.insert(v)
        self.bst.delete(7)
        assert self.bst.search(7) is None
        assert self.bst.search(5) is not None
