package algorithm;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** 第8章 双方向連結リスト（番兵ノード使用） */
public class DoublyLinkedList<T> implements Iterable<T> {

    private static class DNode<T> {
        T data;
        DNode<T> prev;
        DNode<T> next;

        DNode(T data, DNode<T> prev, DNode<T> next) {
            this.data = data;
            this.prev = prev;
            this.next = next;
        }
    }

    private final DNode<T> sentinel;
    private int size;

    public DoublyLinkedList() {
        sentinel = new DNode<>(null, null, null);
        sentinel.prev = sentinel;
        sentinel.next = sentinel;
        size = 0;
    }

    public int size() { return size; }
    public boolean isEmpty() { return size == 0; }

    public boolean contains(T data) {
        DNode<T> ptr = sentinel.next;
        while (ptr != sentinel) {
            if (ptr.data.equals(data)) return true;
            ptr = ptr.next;
        }
        return false;
    }

    public void addFirst(T data) {
        DNode<T> node = new DNode<>(data, sentinel, sentinel.next);
        sentinel.next.prev = node;
        sentinel.next = node;
        size++;
    }

    public void addLast(T data) {
        DNode<T> node = new DNode<>(data, sentinel.prev, sentinel);
        sentinel.prev.next = node;
        sentinel.prev = node;
        size++;
    }

    public boolean remove(T data) {
        if (isEmpty()) return false;
        DNode<T> ptr = sentinel.next;
        while (ptr != sentinel) {
            if (ptr.data.equals(data)) {
                ptr.prev.next = ptr.next;
                ptr.next.prev = ptr.prev;
                size--;
                return true;
            }
            ptr = ptr.next;
        }
        return false;
    }

    public void clear() {
        sentinel.prev = sentinel;
        sentinel.next = sentinel;
        size = 0;
    }

    public List<T> toList() {
        List<T> result = new ArrayList<>();
        for (T data : this) result.add(data);
        return result;
    }

    @Override
    public Iterator<T> iterator() {
        return new Iterator<>() {
            private DNode<T> ptr = sentinel.next;
            @Override public boolean hasNext() { return ptr != sentinel; }
            @Override public T next() { T d = ptr.data; ptr = ptr.next; return d; }
        };
    }
}
