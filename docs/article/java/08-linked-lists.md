# 第 8 章 リスト

## はじめに

この章では 3 種類の連結リスト（単方向、双方向、配列カーソル版）を TDD で実装します。

---

## 1. 単方向連結リスト

`SinglyLinkedList<T>` はジェネリクスで型安全なリストを提供します。`Iterable<T>` を実装しているため、拡張 for 文で走査できます。

```java
public class SinglyLinkedList<T> implements Iterable<T> {
    static class Node<T> {
        T data;
        Node<T> next;
    }

    public void addFirst(T data) {
        head = new Node<>(data, head);
        size++;
    }
}
```

---

## 2. 双方向連結リスト

番兵ノード（ダミーヘッド）を使用し、先頭・末尾の挿入削除を $O(1)$ で実現します。

```java
public class DoublyLinkedList<T> implements Iterable<T> {
    // sentinel.next = 先頭、sentinel.prev = 末尾
}
```

---

## 3. 配列カーソル版連結リスト

配列上にノードを配置し、インデックスをポインタとして使用します。削除されたスロットは空きリストで管理し再利用します。

---

## Python との比較

| 概念 | Python | Java |
|------|--------|------|
| ジェネリクス | `Any` 型ヒント | `<T>` ジェネリクス |
| イテレータ | `__iter__` / `yield` | `Iterable<T>` / `Iterator<T>` |
| null チェック | `is None` | `== null` |

---

## テスト実行結果

```
LinkedListTest > SinglyLinkedListTest > addFirst() PASSED
LinkedListTest > SinglyLinkedListTest > イテレーション() PASSED
LinkedListTest > DoublyLinkedListTest > remove() PASSED
LinkedListTest > ArrayLinkedListTest > 削除スロットの再利用() PASSED
```
