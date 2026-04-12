using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第9章 木構造 テスト</summary>
public class TreeTest
{
    public class BinarySearchTreeTest
    {
        private readonly BinarySearchTree<int> _bst = new();

        [Fact] public void 初期状態は空() => Assert.True(_bst.IsEmpty());
        [Fact] public void insertしてcontains() { _bst.Insert(5); Assert.True(_bst.Contains(5)); }
        [Fact] public void 存在しないキー() => Assert.False(_bst.Contains(99));
        [Fact]
        public void 複数insert()
        { foreach (int v in new[] { 5, 3, 7, 1, 4, 6, 8 }) _bst.Insert(v); foreach (int v in new[] { 5, 3, 7, 1, 4, 6, 8 }) Assert.True(_bst.Contains(v)); }
        [Fact]
        public void 中順探索は昇順()
        { foreach (int v in new[] { 5, 3, 7, 1, 4, 6, 8 }) _bst.Insert(v); Assert.Equal([1, 3, 4, 5, 6, 7, 8], _bst.InOrder()); }
        [Fact]
        public void 前順探索()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); Assert.Equal([5, 3, 7], _bst.PreOrder()); }
        [Fact]
        public void 後順探索()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); Assert.Equal([3, 7, 5], _bst.PostOrder()); }
        [Fact]
        public void min()
        { foreach (int v in new[] { 5, 3, 7, 1, 4 }) _bst.Insert(v); Assert.Equal(1, _bst.Min()); }
        [Fact]
        public void max()
        { foreach (int v in new[] { 5, 3, 7, 1, 4 }) _bst.Insert(v); Assert.Equal(7, _bst.Max()); }
        [Fact] public void min_空で例外() => Assert.Throws<BinarySearchTree<int>.EmptyException>(() => _bst.Min());
        [Fact] public void max_空で例外() => Assert.Throws<BinarySearchTree<int>.EmptyException>(() => _bst.Max());
        [Fact]
        public void 葉ノードの削除()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); _bst.Delete(3); Assert.False(_bst.Contains(3)); Assert.True(_bst.Contains(5)); Assert.True(_bst.Contains(7)); }
        [Fact]
        public void 子が1つのノードの削除()
        { foreach (int v in new[] { 5, 3, 7, 1 }) _bst.Insert(v); _bst.Delete(3); Assert.False(_bst.Contains(3)); Assert.True(_bst.Contains(1)); }
        [Fact]
        public void 子が2つのノードの削除()
        { foreach (int v in new[] { 5, 3, 7, 1, 4 }) _bst.Insert(v); _bst.Delete(3); Assert.False(_bst.Contains(3)); foreach (int v in new[] { 1, 4, 5, 7 }) Assert.True(_bst.Contains(v)); }
        [Fact]
        public void 根ノードの削除()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); _bst.Delete(5); Assert.False(_bst.Contains(5)); Assert.True(_bst.Contains(3)); Assert.True(_bst.Contains(7)); Assert.Equal([3, 7], _bst.InOrder()); }
        [Fact]
        public void 存在しないキーの削除()
        { _bst.Insert(5); _bst.Delete(99); Assert.True(_bst.Contains(5)); }
        [Fact]
        public void size()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); Assert.Equal(3, _bst.Size()); }
        [Fact]
        public void contains()
        { _bst.Insert(42); Assert.True(_bst.Contains(42)); Assert.False(_bst.Contains(0)); }
        [Fact]
        public void 根のみ削除で空()
        { _bst.Insert(5); _bst.Delete(5); Assert.True(_bst.IsEmpty()); }
        [Fact]
        public void 重複キー挿入は無視()
        { _bst.Insert(5); _bst.Insert(5); Assert.Equal(1, _bst.Size()); }
        [Fact]
        public void 右子のみのノード削除()
        { foreach (int v in new[] { 5, 3, 7, 8 }) _bst.Insert(v); _bst.Delete(7); Assert.False(_bst.Contains(7)); Assert.True(_bst.Contains(8)); }
        [Fact]
        public void 深い後継ノードの削除()
        { foreach (int v in new[] { 10, 5, 20, 15, 25, 12, 18 }) _bst.Insert(v); _bst.Delete(10); Assert.False(_bst.Contains(10)); Assert.Equal([5, 12, 15, 18, 20, 25], _bst.InOrder()); }
        [Fact]
        public void 右子として親に繋がるノード削除()
        { foreach (int v in new[] { 5, 3, 7 }) _bst.Insert(v); _bst.Delete(7); Assert.False(_bst.Contains(7)); Assert.True(_bst.Contains(5)); }
    }
}
