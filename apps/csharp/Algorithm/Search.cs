namespace Algorithm;

/// <summary>第3章 探索アルゴリズム</summary>
public static class Search
{
    public static int LinearSearchWhile(int[] a, int key)
    {
        int i = 0;
        while (true)
        {
            if (i == a.Length) return -1;
            if (a[i] == key) return i;
            i++;
        }
    }

    public static int LinearSearchFor(int[] a, int key)
    {
        for (int i = 0; i < a.Length; i++)
            if (a[i] == key) return i;
        return -1;
    }

    public static int LinearSearchSentinel(int[] a, int key)
    {
        int[] b = new int[a.Length + 1];
        a.CopyTo(b, 0);
        b[a.Length] = key;
        int i = 0;
        while (b[i] != key) i++;
        return i == a.Length ? -1 : i;
    }

    public static int BinarySearch(int[] a, int key)
    {
        int pl = 0, pr = a.Length - 1;
        while (pl <= pr)
        {
            int pc = (pl + pr) / 2;
            if (a[pc] == key) return pc;
            else if (a[pc] < key) pl = pc + 1;
            else pr = pc - 1;
        }
        return -1;
    }

    // --- チェイン法ハッシュ ---
    public class ChainedHash
    {
        private class Node(int key, string value, Node? next)
        {
            public int Key = key;
            public string Value = value;
            public Node? Next = next;
        }

        private readonly int _capacity;
        private readonly Node?[] _table;

        public ChainedHash(int capacity) { _capacity = capacity; _table = new Node[capacity]; }

        private int HashValue(int key) => key % _capacity;

        public string? Search(int key)
        {
            var p = _table[HashValue(key)];
            while (p != null) { if (p.Key == key) return p.Value; p = p.Next; }
            return null;
        }

        public bool Add(int key, string value)
        {
            int h = HashValue(key);
            var p = _table[h];
            while (p != null) { if (p.Key == key) return false; p = p.Next; }
            _table[h] = new Node(key, value, _table[h]);
            return true;
        }

        public bool Remove(int key)
        {
            int h = HashValue(key);
            Node? p = _table[h], pp = null;
            while (p != null)
            {
                if (p.Key == key)
                {
                    if (pp == null) _table[h] = p.Next; else pp.Next = p.Next;
                    return true;
                }
                pp = p; p = p.Next;
            }
            return false;
        }
    }

    // --- オープンアドレス法ハッシュ ---
    public class OpenHash
    {
        private enum Status { Occupied, Empty, Deleted }

        private class Bucket
        {
            public int Key;
            public string Value = "";
            public Status Stat = Status.Empty;
        }

        private readonly int _capacity;
        private readonly Bucket[] _table;

        public OpenHash(int capacity)
        {
            _capacity = capacity;
            _table = new Bucket[capacity];
            for (int i = 0; i < capacity; i++) _table[i] = new Bucket();
        }

        private int HashValue(int key) => key % _capacity;

        public string? Search(int key)
        {
            int h = HashValue(key);
            for (int i = 0; i < _capacity; i++)
            {
                var p = _table[h];
                if (p.Stat == Status.Empty) break;
                if (p.Stat == Status.Occupied && p.Key == key) return p.Value;
                h = (h + 1) % _capacity;
            }
            return null;
        }

        public bool Add(int key, string value)
        {
            if (Search(key) != null) return false;
            int h = HashValue(key);
            for (int i = 0; i < _capacity; i++)
            {
                var p = _table[h];
                if (p.Stat == Status.Empty || p.Stat == Status.Deleted)
                {
                    _table[h] = new Bucket { Key = key, Value = value, Stat = Status.Occupied };
                    return true;
                }
                h = (h + 1) % _capacity;
            }
            return false;
        }

        public bool Remove(int key)
        {
            int h = HashValue(key);
            for (int i = 0; i < _capacity; i++)
            {
                var p = _table[h];
                if (p.Stat == Status.Empty) return false;
                if (p.Stat == Status.Occupied && p.Key == key) { p.Stat = Status.Deleted; return true; }
                h = (h + 1) % _capacity;
            }
            return false;
        }
    }
}
