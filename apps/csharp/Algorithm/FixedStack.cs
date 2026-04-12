namespace Algorithm;

/// <summary>第4章 固定長スタック</summary>
public class FixedStack<T>
{
    public class EmptyException() : Exception("スタックは空です");
    public class FullException() : Exception("スタックは満杯です");

    private readonly object?[] _stk;
    private readonly int _capacity;
    private int _ptr;

    public FixedStack(int capacity) { _capacity = capacity; _stk = new object[capacity]; _ptr = 0; }

    public bool IsEmpty() => _ptr <= 0;
    public bool IsFull() => _ptr >= _capacity;
    public int Size() => _ptr;
    public int GetCapacity() => _capacity;

    public void Push(T value) { if (IsFull()) throw new FullException(); _stk[_ptr++] = value; }

    public T Pop() { if (IsEmpty()) throw new EmptyException(); return (T)_stk[--_ptr]!; }

    public T Peek() { if (IsEmpty()) throw new EmptyException(); return (T)_stk[_ptr - 1]!; }

    public int Find(T value)
    {
        for (int i = _ptr - 1; i >= 0; i--)
            if (_stk[i] is T v && v!.Equals(value)) return i;
        return -1;
    }

    public bool Contains(T value) => Find(value) != -1;

    public int Count(T value)
    {
        int c = 0;
        for (int i = 0; i < _ptr; i++)
            if (_stk[i] is T v && v!.Equals(value)) c++;
        return c;
    }

    public void Clear() => _ptr = 0;
}
