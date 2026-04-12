package algorithm;

/** 第8章 配列による連結リスト（カーソル版） */
public class ArrayLinkedList {

    private static final int NULL = -1;

    private static class ArrayNode {
        int data;
        int next;
        int dnext; // 削除済みリストの次ポインタ

        ArrayNode() { data = 0; next = NULL; dnext = NULL; }
        ArrayNode(int data, int next) { this.data = data; this.next = next; this.dnext = NULL; }
    }

    private int head;
    private int max;
    private int deleted;
    private final int capacity;
    private final ArrayNode[] n;
    private int size;

    public ArrayLinkedList(int capacity) {
        this.capacity = capacity;
        this.head = NULL;
        this.max = NULL;
        this.deleted = NULL;
        this.n = new ArrayNode[capacity];
        for (int i = 0; i < capacity; i++) n[i] = new ArrayNode();
        this.size = 0;
    }

    public int size() { return size; }

    private int getInsertIndex() {
        if (deleted == NULL) {
            if (max + 1 < capacity) {
                max++;
                return max;
            }
            return NULL;
        }
        int rec = deleted;
        deleted = n[rec].dnext;
        return rec;
    }

    public void addFirst(int data) {
        int ptr = head;
        int rec = getInsertIndex();
        if (rec != NULL) {
            head = rec;
            n[head] = new ArrayNode(data, ptr);
            size++;
        }
    }

    public void addLast(int data) {
        if (head == NULL) {
            addFirst(data);
        } else {
            int ptr = head;
            while (n[ptr].next != NULL) ptr = n[ptr].next;
            int rec = getInsertIndex();
            if (rec != NULL) {
                n[ptr].next = rec;
                n[rec] = new ArrayNode(data, NULL);
                size++;
            }
        }
    }

    public int search(int data) {
        int ptr = head;
        while (ptr != NULL) {
            if (n[ptr].data == data) return ptr;
            ptr = n[ptr].next;
        }
        return NULL;
    }

    public void removeFirst() {
        if (head != NULL) {
            int ptr = head;
            head = n[ptr].next;
            n[ptr].dnext = deleted;
            deleted = ptr;
            size--;
        }
    }

    /** head ノードの data を返す（テスト用） */
    public int getHeadData() {
        if (head == NULL) throw new IndexOutOfBoundsException("empty");
        return n[head].data;
    }
}
