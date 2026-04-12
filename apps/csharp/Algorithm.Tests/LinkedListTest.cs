using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第8章 リスト テスト</summary>
public class LinkedListTest
{
    public class SinglyLinkedListTest
    {
        private readonly SinglyLinkedList<int> _lst = new();

        [Fact] public void 初期状態は空() { Assert.Equal(0, _lst.Size()); Assert.True(_lst.IsEmpty()); }
        [Fact] public void addFirst() { _lst.AddFirst(1); Assert.Equal(1, _lst.Size()); }
        [Fact] public void addLast() { _lst.AddLast(1); _lst.AddLast(2); Assert.Equal(2, _lst.Size()); }
        [Fact] public void 探索_見つかる() { _lst.AddLast(10); _lst.AddLast(20); _lst.AddLast(30); Assert.True(_lst.Contains(20)); }
        [Fact] public void 探索_見つからない() { _lst.AddLast(10); Assert.False(_lst.Contains(99)); }
        [Fact] public void removeFirst() { _lst.AddLast(1); _lst.AddLast(2); _lst.RemoveFirst(); Assert.Equal(1, _lst.Size()); Assert.False(_lst.Contains(1)); }
        [Fact] public void removeLast() { _lst.AddLast(1); _lst.AddLast(2); _lst.RemoveLast(); Assert.Equal(1, _lst.Size()); Assert.False(_lst.Contains(2)); }
        [Fact] public void removeByValue() { _lst.AddLast(1); _lst.AddLast(2); _lst.AddLast(3); Assert.True(_lst.Remove(2)); Assert.False(_lst.Contains(2)); Assert.Equal(2, _lst.Size()); }
        [Fact] public void contains() { _lst.AddLast(42); Assert.True(_lst.Contains(42)); Assert.False(_lst.Contains(0)); }
        [Fact] public void removeFirst_空で例外() => Assert.Throws<SinglyLinkedList<int>.EmptyException>(() => _lst.RemoveFirst());
        [Fact] public void removeLast_空で例外() => Assert.Throws<SinglyLinkedList<int>.EmptyException>(() => _lst.RemoveLast());
        [Fact] public void イテレーション() { _lst.AddLast(1); _lst.AddLast(2); _lst.AddLast(3); Assert.Equal([1, 2, 3], _lst.ToList()); }
        [Fact] public void clear() { _lst.AddLast(1); _lst.AddLast(2); _lst.Clear(); Assert.True(_lst.IsEmpty()); }
        [Fact] public void removeLast_単一要素() { _lst.AddLast(1); _lst.RemoveLast(); Assert.True(_lst.IsEmpty()); }
        [Fact] public void remove_空リスト() => Assert.False(_lst.Remove(1));
        [Fact] public void remove_存在しない値() { _lst.AddLast(1); _lst.AddLast(2); Assert.False(_lst.Remove(99)); Assert.Equal(2, _lst.Size()); }
    }

    public class DoublyLinkedListTest
    {
        private readonly DoublyLinkedList<int> _lst = new();

        [Fact] public void 初期状態は空() { Assert.Equal(0, _lst.Size()); Assert.True(_lst.IsEmpty()); }
        [Fact] public void addFirst() { _lst.AddFirst(1); Assert.Equal(1, _lst.Size()); }
        [Fact] public void addLast() { _lst.AddLast(1); _lst.AddLast(2); Assert.Equal(2, _lst.Size()); }
        [Fact] public void contains() { _lst.AddLast(10); _lst.AddLast(20); Assert.True(_lst.Contains(20)); Assert.False(_lst.Contains(99)); }
        [Fact] public void remove() { _lst.AddLast(1); _lst.AddLast(2); _lst.AddLast(3); Assert.True(_lst.Remove(2)); Assert.False(_lst.Contains(2)); Assert.Equal(2, _lst.Size()); }
        [Fact] public void イテレーション() { _lst.AddLast(1); _lst.AddLast(2); _lst.AddLast(3); Assert.Equal([1, 2, 3], _lst.ToList()); }
        [Fact] public void clear() { _lst.AddLast(1); _lst.Clear(); Assert.True(_lst.IsEmpty()); }
        [Fact] public void remove_空リスト() => Assert.False(_lst.Remove(99));
    }

    public class ArrayLinkedListTest
    {
        [Fact] public void 初期化() => Assert.Equal(0, new ArrayLinkedList(100).Size());
        [Fact] public void addFirst() { var al = new ArrayLinkedList(100); al.AddFirst(1); al.AddFirst(2); Assert.Equal(2, al.Size()); }
        [Fact] public void addFirst_順序() { var al = new ArrayLinkedList(100); al.AddFirst(1); al.AddFirst(2); al.AddFirst(3); Assert.Equal(3, al.GetHeadData()); }
        [Fact] public void addLast() { var al = new ArrayLinkedList(100); al.AddLast(1); al.AddLast(2); Assert.Equal(2, al.Size()); }
        [Fact] public void addLast_順序() { var al = new ArrayLinkedList(100); al.AddLast(1); al.AddLast(2); al.AddLast(3); Assert.Equal(1, al.GetHeadData()); }
        [Fact] public void search_見つかる() { var al = new ArrayLinkedList(100); al.AddLast(10); al.AddLast(20); al.AddLast(30); Assert.True(al.Search(20) >= 0); }
        [Fact] public void search_見つからない() { var al = new ArrayLinkedList(100); al.AddLast(10); Assert.Equal(-1, al.Search(99)); }
        [Fact] public void removeFirst() { var al = new ArrayLinkedList(100); al.AddLast(1); al.AddLast(2); al.AddLast(3); al.RemoveFirst(); Assert.Equal(2, al.Size()); Assert.Equal(-1, al.Search(1)); }
        [Fact] public void removeFirst_空() { var al = new ArrayLinkedList(100); al.RemoveFirst(); Assert.Equal(0, al.Size()); }
        [Fact] public void 削除スロットの再利用() { var al = new ArrayLinkedList(100); al.AddFirst(1); al.AddFirst(2); al.RemoveFirst(); al.AddFirst(3); Assert.Equal(2, al.Size()); }
        [Fact] public void 容量超過() { var al = new ArrayLinkedList(2); al.AddFirst(1); al.AddFirst(2); al.AddFirst(3); Assert.Equal(2, al.Size()); }
    }
}
