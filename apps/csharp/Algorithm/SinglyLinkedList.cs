namespace Algorithm;

/// <summary>第8章 単方向連結リスト</summary>
public class SinglyLinkedList<T>
{
    public class EmptyException() : Exception("リストは空です");

    private class Node(T data, Node? next = null) { public T Data = data; public Node? Next = next; }

    private Node? _head;
    private int _size;

    public int Size() => _size;
    public bool IsEmpty() => _head == null;
    public bool Contains(T data) => Search(data) != null;

    private Node? Search(T data)
    {
        var ptr = _head;
        while (ptr != null) { if (ptr.Data!.Equals(data)) return ptr; ptr = ptr.Next; }
        return null;
    }

    public void AddFirst(T data) { _head = new Node(data, _head); _size++; }

    public void AddLast(T data)
    {
        if (_head == null) { _head = new Node(data); }
        else { var ptr = _head; while (ptr.Next != null) ptr = ptr.Next; ptr.Next = new Node(data); }
        _size++;
    }

    public void RemoveFirst()
    {
        if (_head == null) throw new EmptyException();
        _head = _head.Next; _size--;
    }

    public void RemoveLast()
    {
        if (_head == null) throw new EmptyException();
        if (_head.Next == null) { _head = null; }
        else { var ptr = _head; while (ptr.Next?.Next != null) ptr = ptr.Next; ptr.Next = null; }
        _size--;
    }

    public bool Remove(T data)
    {
        if (_head == null) return false;
        if (_head.Data!.Equals(data)) { _head = _head.Next; _size--; return true; }
        var ptr = _head;
        while (ptr.Next != null)
        {
            if (ptr.Next.Data!.Equals(data)) { ptr.Next = ptr.Next.Next; _size--; return true; }
            ptr = ptr.Next;
        }
        return false;
    }

    public void Clear() { _head = null; _size = 0; }

    public List<T> ToList()
    {
        var result = new List<T>();
        var ptr = _head;
        while (ptr != null) { result.Add(ptr.Data); ptr = ptr.Next; }
        return result;
    }
}
