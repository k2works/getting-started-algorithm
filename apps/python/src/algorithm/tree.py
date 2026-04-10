"""第9章 木構造"""

from typing import Any


class _BSTNode:
    """二分探索木のノード"""

    def __init__(self, key: Any) -> None:
        self.key = key
        self.left: _BSTNode | None = None
        self.right: _BSTNode | None = None


class BinarySearchTree:
    """二分探索木（Binary Search Tree）

    性質:
    - 左部分木のすべてのキー < ルートのキー
    - 右部分木のすべてのキー > ルートのキー
    - 左右の部分木もまた二分探索木
    """

    class Empty(Exception):
        """木が空の場合の例外"""

    def __init__(self) -> None:
        self.root: _BSTNode | None = None
        self.no = 0

    def __len__(self) -> int:
        return self.no

    def __contains__(self, key: Any) -> bool:
        return self.search(key) is not None

    def is_empty(self) -> bool:
        return self.root is None

    def search(self, key: Any) -> _BSTNode | None:
        """keyを持つノードを探索

        >>> bst = BinarySearchTree()
        >>> bst.insert(5)
        >>> bst.search(5).key
        5
        """
        ptr = self.root
        while ptr is not None:
            if key == ptr.key:
                return ptr
            elif key < ptr.key:
                ptr = ptr.left
            else:
                ptr = ptr.right
        return None

    def insert(self, key: Any) -> None:
        """keyを挿入（重複は無視）"""
        if self.root is None:
            self.root = _BSTNode(key)
            self.no += 1
            return
        ptr = self.root
        while True:
            if key == ptr.key:
                return  # 重複は無視
            elif key < ptr.key:
                if ptr.left is None:
                    ptr.left = _BSTNode(key)
                    self.no += 1
                    return
                ptr = ptr.left
            else:
                if ptr.right is None:
                    ptr.right = _BSTNode(key)
                    self.no += 1
                    return
                ptr = ptr.right

    def delete(self, key: Any) -> None:
        """keyを持つノードを削除"""
        parent: _BSTNode | None = None
        ptr = self.root
        is_left_child = False

        # 削除対象ノードを探す
        while ptr is not None:
            if key == ptr.key:
                break
            parent = ptr
            if key < ptr.key:
                is_left_child = True
                ptr = ptr.left
            else:
                is_left_child = False
                ptr = ptr.right

        if ptr is None:
            return  # 見つからなかった

        self.no -= 1

        if ptr.left is None and ptr.right is None:
            # 葉ノード
            self._replace_node(parent, is_left_child, None)
        elif ptr.right is None:
            # 右子なし（左子のみ）
            self._replace_node(parent, is_left_child, ptr.left)
        elif ptr.left is None:
            # 左子なし（右子のみ）
            self._replace_node(parent, is_left_child, ptr.right)
        else:
            # 子が 2 つ: 右部分木の最小ノード（中順後継）で置き換える
            successor_parent = ptr
            successor = ptr.right
            while successor.left is not None:
                successor_parent = successor
                successor = successor.left
            ptr.key = successor.key
            # 後継ノードを削除
            if successor_parent is ptr:
                successor_parent.right = successor.right
            else:
                successor_parent.left = successor.right
            self.no += 1  # delete で既に -1 しているので +1 で調整

    def _replace_node(
        self,
        parent: _BSTNode | None,
        is_left_child: bool,
        new_node: _BSTNode | None,
    ) -> None:
        """parentの子ノードをnew_nodeで置き換える"""
        if parent is None:
            self.root = new_node
        elif is_left_child:
            parent.left = new_node
        else:
            parent.right = new_node

    def min(self) -> Any:
        """最小キーを返す"""
        if self.root is None:
            raise BinarySearchTree.Empty
        ptr = self.root
        while ptr.left is not None:
            ptr = ptr.left
        return ptr.key

    def max(self) -> Any:
        """最大キーを返す"""
        if self.root is None:
            raise BinarySearchTree.Empty
        ptr = self.root
        while ptr.right is not None:
            ptr = ptr.right
        return ptr.key

    def inorder(self) -> list[Any]:
        """中順探索（昇順）でキーのリストを返す"""
        result: list[Any] = []
        self._inorder(self.root, result)
        return result

    def _inorder(self, node: _BSTNode | None, result: list) -> None:
        if node is None:
            return
        self._inorder(node.left, result)
        result.append(node.key)
        self._inorder(node.right, result)

    def preorder(self) -> list[Any]:
        """前順探索でキーのリストを返す"""
        result: list[Any] = []
        self._preorder(self.root, result)
        return result

    def _preorder(self, node: _BSTNode | None, result: list) -> None:
        if node is None:
            return
        result.append(node.key)
        self._preorder(node.left, result)
        self._preorder(node.right, result)

    def postorder(self) -> list[Any]:
        """後順探索でキーのリストを返す"""
        result: list[Any] = []
        self._postorder(self.root, result)
        return result

    def _postorder(self, node: _BSTNode | None, result: list) -> None:
        if node is None:
            return
        self._postorder(node.left, result)
        self._postorder(node.right, result)
        result.append(node.key)
