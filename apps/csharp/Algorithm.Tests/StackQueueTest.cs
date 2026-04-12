using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第4章 スタックとキュー テスト</summary>
public class StackQueueTest
{
    public class FixedStackTest
    {
        private readonly FixedStack<int> _stack = new(64);

        [Fact] public void 初期状態は空() { Assert.True(_stack.IsEmpty()); Assert.False(_stack.IsFull()); }
        [Fact] public void pushしてpeek() { _stack.Push(1); Assert.Equal(1, _stack.Peek()); }
        [Fact] public void pushしてpop() { _stack.Push(1); Assert.Equal(1, _stack.Pop()); }
        [Fact]
        public void 複数pushしてLIFO順にpop()
        { _stack.Push(1); _stack.Push(2); _stack.Push(3); Assert.Equal(3, _stack.Pop()); Assert.Equal(2, _stack.Pop()); Assert.Equal(1, _stack.Pop()); }
        [Fact]
        public void 満杯判定()
        { var s = new FixedStack<int>(3); s.Push(1); s.Push(2); s.Push(3); Assert.True(s.IsFull()); }
        [Fact] public void 空のpopで例外() => Assert.Throws<FixedStack<int>.EmptyException>(() => _stack.Pop());
        [Fact]
        public void 満杯のpushで例外()
        { var s = new FixedStack<int>(2); s.Push(1); s.Push(2); Assert.Throws<FixedStack<int>.FullException>(() => s.Push(3)); }
        [Fact] public void 空のpeekで例外() => Assert.Throws<FixedStack<int>.EmptyException>(() => _stack.Peek());
        [Fact] public void find() { _stack.Push(10); _stack.Push(20); _stack.Push(30); Assert.Equal(1, _stack.Find(20)); }
        [Fact] public void find_見つからない() { _stack.Push(10); Assert.Equal(-1, _stack.Find(99)); }
        [Fact]
        public void count()
        { _stack.Push(5); _stack.Push(5); _stack.Push(10); Assert.Equal(2, _stack.Count(5)); Assert.Equal(1, _stack.Count(10)); Assert.Equal(0, _stack.Count(99)); }
        [Fact] public void contains() { _stack.Push(42); Assert.True(_stack.Contains(42)); Assert.False(_stack.Contains(0)); }
        [Fact] public void clear() { _stack.Push(1); _stack.Push(2); _stack.Clear(); Assert.True(_stack.IsEmpty()); }
        [Fact] public void size() { _stack.Push(1); _stack.Push(2); Assert.Equal(2, _stack.Size()); }
        [Fact] public void capacity() => Assert.Equal(64, _stack.GetCapacity());
    }

    public class FixedQueueTest
    {
        private readonly FixedQueue<int> _queue = new(64);

        [Fact] public void 初期状態は空() { Assert.True(_queue.IsEmpty()); Assert.False(_queue.IsFull()); }
        [Fact] public void enqueしてdeque() { _queue.Enque(1); Assert.Equal(1, _queue.Deque()); }
        [Fact]
        public void 複数enqueしてFIFO順にdeque()
        { _queue.Enque(1); _queue.Enque(2); _queue.Enque(3); Assert.Equal(1, _queue.Deque()); Assert.Equal(2, _queue.Deque()); Assert.Equal(3, _queue.Deque()); }
        [Fact] public void peek() { _queue.Enque(10); _queue.Enque(20); Assert.Equal(10, _queue.Peek()); }
        [Fact]
        public void 満杯判定()
        { var q = new FixedQueue<int>(3); q.Enque(1); q.Enque(2); q.Enque(3); Assert.True(q.IsFull()); }
        [Fact] public void 空のdequeで例外() => Assert.Throws<FixedQueue<int>.EmptyException>(() => _queue.Deque());
        [Fact]
        public void 満杯のenqueで例外()
        { var q = new FixedQueue<int>(2); q.Enque(1); q.Enque(2); Assert.Throws<FixedQueue<int>.FullException>(() => q.Enque(3)); }
        [Fact] public void 空のpeekで例外() => Assert.Throws<FixedQueue<int>.EmptyException>(() => _queue.Peek());
        [Fact] public void find() { _queue.Enque(10); _queue.Enque(20); _queue.Enque(30); Assert.Equal(0, _queue.Find(10)); }
        [Fact] public void find_見つからない() { _queue.Enque(10); Assert.Equal(-1, _queue.Find(99)); }
        [Fact]
        public void count()
        { _queue.Enque(5); _queue.Enque(5); _queue.Enque(10); Assert.Equal(2, _queue.Count(5)); }
        [Fact] public void contains() { _queue.Enque(42); Assert.True(_queue.Contains(42)); Assert.False(_queue.Contains(0)); }
        [Fact] public void clear() { _queue.Enque(1); _queue.Enque(2); _queue.Clear(); Assert.True(_queue.IsEmpty()); }
        [Fact] public void size() { _queue.Enque(1); _queue.Enque(2); Assert.Equal(2, _queue.Size()); }
        [Fact] public void capacity() => Assert.Equal(64, _queue.GetCapacity());
        [Fact]
        public void リングバッファの折り返し()
        {
            var q = new FixedQueue<int>(3);
            q.Enque(1); q.Enque(2); q.Enque(3); q.Deque(); q.Enque(4);
            Assert.Equal(2, q.Deque()); Assert.Equal(3, q.Deque()); Assert.Equal(4, q.Deque());
        }
    }
}
