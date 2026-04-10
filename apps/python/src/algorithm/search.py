"""第3章 探索アルゴリズム"""

import copy
import hashlib
from collections.abc import Sequence
from enum import Enum
from typing import Any


def ssearch_while(a: Sequence, key: Any) -> int:
    """シーケンスaからkeyと等価な要素を線形探索（while文）

    >>> ssearch_while([6, 4, 3, 2, 1, 2, 8], 2)
    3
    """
    i = 0
    while True:
        if i == len(a):
            return -1
        if a[i] == key:
            return i
        i += 1


def ssearch_for(a: Sequence, key: Any) -> int:
    """シーケンスaからkeyと等価な要素を線形探索（for文）

    >>> ssearch_for([6, 4, 3, 2, 1, 2, 8], 2)
    3
    """
    for i in range(len(a)):
        if a[i] == key:
            return i
    return -1


def ssearch_sentinel(seq: Sequence, key: Any) -> int:
    """シーケンスseqからkeyと一致する要素を線形探索（番兵法）

    >>> ssearch_sentinel([6, 4, 3, 2, 1, 2, 8], 2)
    3
    """
    a = copy.deepcopy(list(seq))
    a.append(key)  # 番兵を追加

    i = 0
    while True:
        if a[i] == key:
            break
        i += 1
    return -1 if i == len(seq) else i


def bseach(a: Sequence, key: Any) -> int:
    """シーケンスaからkeyと一致する要素を二分探索

    >>> bseach([1, 2, 3, 5, 7, 8, 9], 5)
    3
    """
    pl = 0
    pr = len(a) - 1

    while True:
        pc = (pl + pr) // 2
        if a[pc] == key:
            return pc
        elif a[pc] < key:
            pl = pc + 1
        else:
            pr = pc - 1
        if pl > pr:
            break
    return -1


class _Node:
    """チェイン法ハッシュのノード"""

    def __init__(self, key: Any, value: Any, next_node: Any) -> None:
        self.key = key
        self.value = value
        self.next = next_node


class ChainedHash:
    """チェイン法を実現するハッシュクラス"""

    def __init__(self, capacity: int) -> None:
        self.capacity = capacity
        self.table: list[Any] = [None] * self.capacity

    def _hash_value(self, key: Any) -> int:
        if isinstance(key, int):
            return key % self.capacity
        return int(hashlib.sha256(str(key).encode()).hexdigest(), 16) % self.capacity

    def search(self, key: Any) -> Any:
        """キーkeyを持つ要素を探索して値を返す"""
        h = self._hash_value(key)
        p = self.table[h]
        while p is not None:
            if p.key == key:
                return p.value
            p = p.next
        return None

    def add(self, key: Any, value: Any) -> bool:
        """キーがkeyで値がvalueの要素を追加"""
        h = self._hash_value(key)
        p = self.table[h]
        while p is not None:
            if p.key == key:
                return False
            p = p.next
        self.table[h] = _Node(key, value, self.table[h])
        return True

    def remove(self, key: Any) -> bool:
        """キーkeyを持つ要素を削除"""
        h = self._hash_value(key)
        p = self.table[h]
        pp = None
        while p is not None:
            if p.key == key:
                if pp is None:
                    self.table[h] = p.next
                else:
                    pp.next = p.next
                return True
            pp = p
            p = p.next
        return False


class _Status(Enum):
    """バケットの状態"""

    OCCUPIED = 0
    EMPTY = 1
    DELETED = 2


class _Bucket:
    """オープンアドレス法ハッシュのバケット"""

    def __init__(
        self,
        key: Any = None,
        value: Any = None,
        stat: _Status = _Status.EMPTY,
    ) -> None:
        self.key = key
        self.value = value
        self.stat = stat

    def set_status(self, stat: _Status) -> None:
        self.stat = stat


class OpenHash:
    """オープンアドレス法（線形探索法）を実現するハッシュクラス"""

    def __init__(self, capacity: int) -> None:
        self.capacity = capacity
        self.table = [_Bucket() for _ in range(self.capacity)]

    def _hash_value(self, key: Any) -> int:
        if isinstance(key, int):
            return key % self.capacity
        return int(hashlib.md5(str(key).encode()).hexdigest(), 16) % self.capacity

    def search(self, key: Any) -> Any:
        """キーkeyを持つ要素を探索して値を返す"""
        h = self._hash_value(key)
        for _ in range(self.capacity):
            p = self.table[h]
            if p.stat == _Status.EMPTY:
                break
            elif p.stat == _Status.OCCUPIED and p.key == key:
                return p.value
            h = (h + 1) % self.capacity
        return None

    def add(self, key: Any, value: Any) -> bool:
        """キーkeyで値valueの要素を追加"""
        if self.search(key) is not None:
            return False
        h = self._hash_value(key)
        for _ in range(self.capacity):
            p = self.table[h]
            if p.stat in (_Status.EMPTY, _Status.DELETED):
                self.table[h] = _Bucket(key, value, _Status.OCCUPIED)
                return True
            h = (h + 1) % self.capacity
        return False

    def remove(self, key: Any) -> bool:
        """キーkeyを持つ要素を削除"""
        h = self._hash_value(key)
        for _ in range(self.capacity):
            p = self.table[h]
            if p.stat == _Status.EMPTY:
                return False
            elif p.stat == _Status.OCCUPIED and p.key == key:
                p.set_status(_Status.DELETED)
                return True
            h = (h + 1) % self.capacity
        return False
