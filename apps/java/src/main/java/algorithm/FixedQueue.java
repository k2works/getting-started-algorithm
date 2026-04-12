package algorithm;

/** 第4章 固定長キュー（リングバッファ） */
public class FixedQueue<T> {

    public static class EmptyException extends RuntimeException {
        public EmptyException() { super("キューは空です"); }
    }

    public static class FullException extends RuntimeException {
        public FullException() { super("キューは満杯です"); }
    }

    private final Object[] que;
    private final int capacity;
    private int front;
    private int rear;
    private int num;

    public FixedQueue(int capacity) {
        this.capacity = capacity;
        this.que = new Object[capacity];
        this.front = 0;
        this.rear = 0;
        this.num = 0;
    }

    public boolean isEmpty() { return num <= 0; }
    public boolean isFull() { return num >= capacity; }
    public int size() { return num; }
    public int getCapacity() { return capacity; }

    public void enque(T value) {
        if (isFull()) throw new FullException();
        que[rear] = value;
        rear++;
        num++;
        if (rear == capacity) rear = 0;
    }

    @SuppressWarnings("unchecked")
    public T deque() {
        if (isEmpty()) throw new EmptyException();
        T value = (T) que[front];
        front++;
        num--;
        if (front == capacity) front = 0;
        return value;
    }

    @SuppressWarnings("unchecked")
    public T peek() {
        if (isEmpty()) throw new EmptyException();
        return (T) que[front];
    }

    public int find(T value) {
        for (int i = 0; i < num; i++) {
            int idx = (i + front) % capacity;
            if (que[idx].equals(value)) return i;
        }
        return -1;
    }

    public boolean contains(T value) {
        return find(value) != -1;
    }

    public int count(T value) {
        int c = 0;
        for (int i = 0; i < num; i++) {
            int idx = (i + front) % capacity;
            if (que[idx].equals(value)) c++;
        }
        return c;
    }

    public void clear() {
        front = rear = num = 0;
    }
}
