namespace Algorithm;

/// <summary>第9章 二分探索木</summary>
public class BinarySearchTree<T> where T : IComparable<T>
{
    public class EmptyException() : Exception("木は空です");

    private class BSTNode(T key) { public T Key = key; public BSTNode? Left, Right; }

    private BSTNode? _root;
    private int _size;

    public int Size() => _size;
    public bool IsEmpty() => _root == null;
    public bool Contains(T key) => Search(key) != null;

    private BSTNode? Search(T key)
    {
        var ptr = _root;
        while (ptr != null)
        {
            int cmp = key.CompareTo(ptr.Key);
            if (cmp == 0) return ptr;
            ptr = cmp < 0 ? ptr.Left : ptr.Right;
        }
        return null;
    }

    public void Insert(T key)
    {
        if (_root == null) { _root = new BSTNode(key); _size++; return; }
        var ptr = _root;
        while (true)
        {
            int cmp = key.CompareTo(ptr.Key);
            if (cmp == 0) return;
            if (cmp < 0) { if (ptr.Left == null) { ptr.Left = new BSTNode(key); _size++; return; } ptr = ptr.Left; }
            else { if (ptr.Right == null) { ptr.Right = new BSTNode(key); _size++; return; } ptr = ptr.Right; }
        }
    }

    public void Delete(T key)
    {
        BSTNode? parent = null; var ptr = _root; bool isLeft = false;
        while (ptr != null)
        {
            int cmp = key.CompareTo(ptr.Key);
            if (cmp == 0) break;
            parent = ptr;
            if (cmp < 0) { isLeft = true; ptr = ptr.Left; } else { isLeft = false; ptr = ptr.Right; }
        }
        if (ptr == null) return;
        _size--;
        if (ptr.Left == null && ptr.Right == null) Replace(parent, isLeft, null);
        else if (ptr.Right == null) Replace(parent, isLeft, ptr.Left);
        else if (ptr.Left == null) Replace(parent, isLeft, ptr.Right);
        else
        {
            var succParent = ptr; var succ = ptr.Right;
            while (succ.Left != null) { succParent = succ; succ = succ.Left; }
            ptr.Key = succ.Key;
            if (succParent == ptr) succParent.Right = succ.Right; else succParent.Left = succ.Right;
            _size++;
        }
    }

    private void Replace(BSTNode? parent, bool isLeft, BSTNode? node)
    {
        if (parent == null) _root = node;
        else if (isLeft) parent.Left = node;
        else parent.Right = node;
    }

    public T Min() { if (_root == null) throw new EmptyException(); var p = _root; while (p.Left != null) p = p.Left; return p.Key; }
    public T Max() { if (_root == null) throw new EmptyException(); var p = _root; while (p.Right != null) p = p.Right; return p.Key; }

    public List<T> InOrder() { var r = new List<T>(); InOrderHelper(_root, r); return r; }
    private void InOrderHelper(BSTNode? n, List<T> r) { if (n == null) return; InOrderHelper(n.Left, r); r.Add(n.Key); InOrderHelper(n.Right, r); }

    public List<T> PreOrder() { var r = new List<T>(); PreOrderHelper(_root, r); return r; }
    private void PreOrderHelper(BSTNode? n, List<T> r) { if (n == null) return; r.Add(n.Key); PreOrderHelper(n.Left, r); PreOrderHelper(n.Right, r); }

    public List<T> PostOrder() { var r = new List<T>(); PostOrderHelper(_root, r); return r; }
    private void PostOrderHelper(BSTNode? n, List<T> r) { if (n == null) return; PostOrderHelper(n.Left, r); PostOrderHelper(n.Right, r); r.Add(n.Key); }
}
