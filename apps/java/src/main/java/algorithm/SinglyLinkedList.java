package algorithm;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/** 第8章 単方向連結リスト */
public class SinglyLinkedList<T> implements Iterable<T> {

    public static class EmptyException extends RuntimeException {
        public EmptyException() { super("リストは空です"); }
    }

    static class Node<T> {
        T data;
        Node<T> next;
        Node(T data, Node<T> next) { this.data = data; this.next = next; }
        Node(T data) { this(data, null); }
    }

    private Node<T> head;
    private int size;

    public SinglyLinkedList() { head = null; size = 0; }

    public int size() { return size; }
    public boolean isEmpty() { return head == null; }

    public boolean contains(T data) { return search(data) != null; }

    Node<T> search(T data) {
        Node<T> ptr = head;
        while (ptr != null) {
            if (ptr.data.equals(data)) return ptr;
            ptr = ptr.next;
        }
        return null;
    }

    public void addFirst(T data) {
        head = new Node<>(data, head);
        size++;
    }

    public void addLast(T data) {
        if (head == null) {
            head = new Node<>(data);
        } else {
            Node<T> ptr = head;
            while (ptr.next != null) ptr = ptr.next;
            ptr.next = new Node<>(data);
        }
        size++;
    }

    public void removeFirst() {
        if (head == null) throw new EmptyException();
        head = head.next;
        size--;
    }

    public void removeLast() {
        if (head == null) throw new EmptyException();
        if (head.next == null) {
            head = null;
        } else {
            Node<T> ptr = head;
            while (ptr.next != null && ptr.next.next != null) ptr = ptr.next;
            ptr.next = null;
        }
        size--;
    }

    public boolean remove(T data) {
        if (head == null) return false;
        if (head.data.equals(data)) {
            head = head.next;
            size--;
            return true;
        }
        Node<T> ptr = head;
        while (ptr.next != null) {
            if (ptr.next.data.equals(data)) {
                ptr.next = ptr.next.next;
                size--;
                return true;
            }
            ptr = ptr.next;
        }
        return false;
    }

    public void clear() {
        head = null;
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
            private Node<T> ptr = head;
            @Override public boolean hasNext() { return ptr != null; }
            @Override public T next() { T d = ptr.data; ptr = ptr.next; return d; }
        };
    }
}
