package algorithm;

import java.util.Arrays;

/** 第3章 探索アルゴリズム */
public class Search {

    /** 線形探索（while 文） */
    public static int linearSearchWhile(int[] a, int key) {
        int i = 0;
        while (true) {
            if (i == a.length) return -1;
            if (a[i] == key) return i;
            i++;
        }
    }

    /** 線形探索（for 文） */
    public static int linearSearchFor(int[] a, int key) {
        for (int i = 0; i < a.length; i++) {
            if (a[i] == key) return i;
        }
        return -1;
    }

    /** 線形探索（番兵法） */
    public static int linearSearchSentinel(int[] a, int key) {
        int[] b = Arrays.copyOf(a, a.length + 1);
        b[a.length] = key; // 番兵
        int i = 0;
        while (b[i] != key) i++;
        return i == a.length ? -1 : i;
    }

    /** 二分探索 */
    public static int binarySearch(int[] a, int key) {
        int pl = 0;
        int pr = a.length - 1;
        while (pl <= pr) {
            int pc = (pl + pr) / 2;
            if (a[pc] == key) return pc;
            else if (a[pc] < key) pl = pc + 1;
            else pr = pc - 1;
        }
        return -1;
    }

    // --- チェイン法ハッシュ ---

    /** チェイン法ハッシュテーブル */
    public static class ChainedHash {
        private static class Node {
            int key;
            String value;
            Node next;

            Node(int key, String value, Node next) {
                this.key = key;
                this.value = value;
                this.next = next;
            }
        }

        private final int capacity;
        private final Node[] table;

        public ChainedHash(int capacity) {
            this.capacity = capacity;
            this.table = new Node[capacity];
        }

        private int hashValue(int key) {
            return key % capacity;
        }

        public String search(int key) {
            int h = hashValue(key);
            Node p = table[h];
            while (p != null) {
                if (p.key == key) return p.value;
                p = p.next;
            }
            return null;
        }

        public boolean add(int key, String value) {
            int h = hashValue(key);
            Node p = table[h];
            while (p != null) {
                if (p.key == key) return false;
                p = p.next;
            }
            table[h] = new Node(key, value, table[h]);
            return true;
        }

        public boolean remove(int key) {
            int h = hashValue(key);
            Node p = table[h];
            Node pp = null;
            while (p != null) {
                if (p.key == key) {
                    if (pp == null) table[h] = p.next;
                    else pp.next = p.next;
                    return true;
                }
                pp = p;
                p = p.next;
            }
            return false;
        }
    }

    // --- オープンアドレス法ハッシュ ---

    /** オープンアドレス法（線形探索法）ハッシュテーブル */
    public static class OpenHash {
        private enum Status { OCCUPIED, EMPTY, DELETED }

        private static class Bucket {
            int key;
            String value;
            Status stat;

            Bucket() { this.stat = Status.EMPTY; }
            Bucket(int key, String value) {
                this.key = key;
                this.value = value;
                this.stat = Status.OCCUPIED;
            }
        }

        private final int capacity;
        private final Bucket[] table;

        public OpenHash(int capacity) {
            this.capacity = capacity;
            this.table = new Bucket[capacity];
            for (int i = 0; i < capacity; i++) {
                table[i] = new Bucket();
            }
        }

        private int hashValue(int key) {
            return key % capacity;
        }

        public String search(int key) {
            int h = hashValue(key);
            for (int i = 0; i < capacity; i++) {
                Bucket p = table[h];
                if (p.stat == Status.EMPTY) break;
                if (p.stat == Status.OCCUPIED && p.key == key) return p.value;
                h = (h + 1) % capacity;
            }
            return null;
        }

        public boolean add(int key, String value) {
            if (search(key) != null) return false;
            int h = hashValue(key);
            for (int i = 0; i < capacity; i++) {
                Bucket p = table[h];
                if (p.stat == Status.EMPTY || p.stat == Status.DELETED) {
                    table[h] = new Bucket(key, value);
                    return true;
                }
                h = (h + 1) % capacity;
            }
            return false;
        }

        public boolean remove(int key) {
            int h = hashValue(key);
            for (int i = 0; i < capacity; i++) {
                Bucket p = table[h];
                if (p.stat == Status.EMPTY) return false;
                if (p.stat == Status.OCCUPIED && p.key == key) {
                    p.stat = Status.DELETED;
                    return true;
                }
                h = (h + 1) % capacity;
            }
            return false;
        }
    }
}
