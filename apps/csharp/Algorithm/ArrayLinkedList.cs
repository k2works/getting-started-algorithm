namespace Algorithm;

/// <summary>第8章 配列による連結リスト（カーソル版）</summary>
public class ArrayLinkedList
{
    private const int Null = -1;

    private struct ArrayNode { public int Data; public int Next; public int Dnext; }

    private int _head, _max, _deleted;
    private readonly int _capacity;
    private readonly ArrayNode[] _n;
    private int _size;

    public ArrayLinkedList(int capacity)
    {
        _capacity = capacity; _head = Null; _max = Null; _deleted = Null;
        _n = new ArrayNode[capacity];
        for (int i = 0; i < capacity; i++) { _n[i].Next = Null; _n[i].Dnext = Null; }
    }

    public int Size() => _size;

    private int GetInsertIndex()
    {
        if (_deleted == Null) { if (_max + 1 < _capacity) { _max++; return _max; } return Null; }
        int rec = _deleted; _deleted = _n[rec].Dnext; return rec;
    }

    public void AddFirst(int data)
    {
        int ptr = _head, rec = GetInsertIndex();
        if (rec != Null) { _head = rec; _n[_head] = new ArrayNode { Data = data, Next = ptr, Dnext = Null }; _size++; }
    }

    public void AddLast(int data)
    {
        if (_head == Null) { AddFirst(data); return; }
        int ptr = _head;
        while (_n[ptr].Next != Null) ptr = _n[ptr].Next;
        int rec = GetInsertIndex();
        if (rec != Null) { _n[ptr].Next = rec; _n[rec] = new ArrayNode { Data = data, Next = Null, Dnext = Null }; _size++; }
    }

    public int Search(int data)
    {
        int ptr = _head;
        while (ptr != Null) { if (_n[ptr].Data == data) return ptr; ptr = _n[ptr].Next; }
        return Null;
    }

    public void RemoveFirst()
    {
        if (_head == Null) return;
        int ptr = _head; _head = _n[ptr].Next; _n[ptr].Dnext = _deleted; _deleted = ptr; _size--;
    }

    public int GetHeadData()
    {
        if (_head == Null) throw new IndexOutOfRangeException("empty");
        return _n[_head].Data;
    }
}
