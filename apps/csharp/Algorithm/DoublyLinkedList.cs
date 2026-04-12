namespace Algorithm;

/// <summary>第8章 双方向連結リスト（番兵ノード使用）</summary>
public class DoublyLinkedList<T>
{
    private class DNode(T? data) { public T? Data = data; public DNode? Prev; public DNode? Next; }

    private readonly DNode _sentinel;
    private int _size;

    public DoublyLinkedList()
    {
        _sentinel = new DNode(default);
        _sentinel.Prev = _sentinel;
        _sentinel.Next = _sentinel;
    }

    public int Size() => _size;
    public bool IsEmpty() => _size == 0;

    public bool Contains(T data)
    {
        var ptr = _sentinel.Next;
        while (ptr != _sentinel) { if (ptr!.Data!.Equals(data)) return true; ptr = ptr.Next; }
        return false;
    }

    public void AddFirst(T data)
    {
        var node = new DNode(data) { Prev = _sentinel, Next = _sentinel.Next };
        _sentinel.Next!.Prev = node; _sentinel.Next = node; _size++;
    }

    public void AddLast(T data)
    {
        var node = new DNode(data) { Prev = _sentinel.Prev, Next = _sentinel };
        _sentinel.Prev!.Next = node; _sentinel.Prev = node; _size++;
    }

    public bool Remove(T data)
    {
        if (IsEmpty()) return false;
        var ptr = _sentinel.Next;
        while (ptr != _sentinel)
        {
            if (ptr!.Data!.Equals(data))
            { ptr.Prev!.Next = ptr.Next; ptr.Next!.Prev = ptr.Prev; _size--; return true; }
            ptr = ptr.Next;
        }
        return false;
    }

    public void Clear() { _sentinel.Prev = _sentinel; _sentinel.Next = _sentinel; _size = 0; }

    public List<T> ToList()
    {
        var result = new List<T>();
        var ptr = _sentinel.Next;
        while (ptr != _sentinel) { result.Add(ptr!.Data!); ptr = ptr.Next; }
        return result;
    }
}
