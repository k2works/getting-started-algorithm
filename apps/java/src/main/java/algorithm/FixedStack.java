package algorithm;

import java.util.Arrays;

/** 第4章 固定長スタック */
public class FixedStack<T> {

    public static class EmptyException extends RuntimeException {
        public EmptyException() { super("スタックは空です"); }
    }

    public static class FullException extends RuntimeException {
        public FullException() { super("スタックは満杯です"); }
    }

    private final Object[] stk;
    private final int capacity;
    private int ptr;

    public FixedStack(int capacity) {
        this.capacity = capacity;
        this.stk = new Object[capacity];
        this.ptr = 0;
    }

    public boolean isEmpty() { return ptr <= 0; }
    public boolean isFull() { return ptr >= capacity; }
    public int size() { return ptr; }
    public int getCapacity() { return capacity; }

    public void push(T value) {
        if (isFull()) throw new FullException();
        stk[ptr++] = value;
    }

    @SuppressWarnings("unchecked")
    public T pop() {
        if (isEmpty()) throw new EmptyException();
        return (T) stk[--ptr];
    }

    @SuppressWarnings("unchecked")
    public T peek() {
        if (isEmpty()) throw new EmptyException();
        return (T) stk[ptr - 1];
    }

    public int find(T value) {
        for (int i = ptr - 1; i >= 0; i--) {
            if (stk[i].equals(value)) return i;
        }
        return -1;
    }

    public boolean contains(T value) {
        return find(value) != -1;
    }

    public int count(T value) {
        int c = 0;
        for (int i = 0; i < ptr; i++) {
            if (stk[i].equals(value)) c++;
        }
        return c;
    }

    public void clear() { ptr = 0; }

    @SuppressWarnings("unchecked")
    public Object[] dump() {
        return Arrays.copyOf(stk, ptr);
    }
}
