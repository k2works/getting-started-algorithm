namespace Algorithm;

/// <summary>第4章 固定長キュー（リングバッファ）</summary>
public class FixedQueue<T>
{
    public class EmptyException() : Exception("キューは空です");
    public class FullException() : Exception("キューは満杯です");

    private readonly object?[] _que;
    private readonly int _capacity;
    private int _front, _rear, _num;

    public FixedQueue(int capacity) { _capacity = capacity; _que = new object[capacity]; }

    public bool IsEmpty() => _num <= 0;
    public bool IsFull() => _num >= _capacity;
    public int Size() => _num;
    public int GetCapacity() => _capacity;

    public void Enque(T value)
    {
        if (IsFull()) throw new FullException();
        _que[_rear] = value; _rear = (_rear + 1) % _capacity; _num++;
    }

    public T Deque()
    {
        if (IsEmpty()) throw new EmptyException();
        T value = (T)_que[_front]!; _front = (_front + 1) % _capacity; _num--;
        return value;
    }

    public T Peek() { if (IsEmpty()) throw new EmptyException(); return (T)_que[_front]!; }

    public int Find(T value)
    {
        for (int i = 0; i < _num; i++)
        {
            int idx = (i + _front) % _capacity;
            if (_que[idx] is T v && v!.Equals(value)) return i;
        }
        return -1;
    }

    public bool Contains(T value) => Find(value) != -1;

    public int Count(T value)
    {
        int c = 0;
        for (int i = 0; i < _num; i++)
        {
            int idx = (i + _front) % _capacity;
            if (_que[idx] is T v && v!.Equals(value)) c++;
        }
        return c;
    }

    public void Clear() { _front = _rear = _num = 0; }
}
