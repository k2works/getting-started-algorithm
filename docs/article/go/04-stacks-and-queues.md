# 第 4 章 スタックとキュー

## はじめに

スタックとキューは、データの追加・取り出し順序が異なる基本的なデータ構造です。

---

## 1. スタック（LIFO）

Go では例外の代わりに `error` 型の複数戻り値を使います。

```go
type Stack struct {
    data     []int
    capacity int
    ptr      int
}

func NewStack(capacity int) *Stack {
    return &Stack{data: make([]int, capacity), capacity: capacity}
}

func (s *Stack) Push(v int) error {
    if s.ptr == s.capacity {
        return errors.New("stack is full")
    }
    s.data[s.ptr] = v
    s.ptr++
    return nil
}

func (s *Stack) Pop() (int, error) {
    if s.ptr == 0 {
        return 0, errors.New("stack is empty")
    }
    s.ptr--
    return s.data[s.ptr], nil
}

func (s *Stack) Peek() (int, error) {
    if s.ptr == 0 {
        return 0, errors.New("stack is empty")
    }
    return s.data[s.ptr-1], nil
}
```

### テスト

```go
func TestStack(t *testing.T) {
    s := chapter04.NewStack(5)
    s.Push(1)
    s.Push(2)
    val, err := s.Pop()
    if err != nil || val != 2 {
        t.Errorf("Pop() = %v, %v; want 2, nil", val, err)
    }
}
```

---

## 2. キュー（FIFO）

リングバッファで効率的に実装します。

```go
type Queue struct {
    data     []int
    capacity int
    front    int
    rear     int
    num      int
}

func (q *Queue) Enqueue(v int) error {
    if q.num == q.capacity {
        return errors.New("queue is full")
    }
    q.data[q.rear] = v
    q.rear = (q.rear + 1) % q.capacity
    q.num++
    return nil
}

func (q *Queue) Dequeue() (int, error) {
    if q.num == 0 {
        return 0, errors.New("queue is empty")
    }
    v := q.data[q.front]
    q.front = (q.front + 1) % q.capacity
    q.num--
    return v, nil
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| 例外 | `raise FixedStack.Full` | `return errFull`（error 型） |
| クラス | `class FixedStack:` | `type Stack struct { ... }` |
| コンストラクタ | `def __init__(self):` | `func NewStack(...) *Stack` |
| `len()` | `def __len__(self):` | `func (s *Stack) Len() int` |
| エラー確認 | `try/except` | `if err != nil { ... }` |
