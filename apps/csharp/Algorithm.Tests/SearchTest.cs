using Xunit;
using Algorithm;

namespace Algorithm.Tests;

/// <summary>第3章 探索アルゴリズム テスト</summary>
public class SearchTest
{
    public class LinearSearchTest
    {
        [Fact] public void while文で探索_見つかる() => Assert.Equal(3, Search.LinearSearchWhile([6, 4, 3, 2, 1, 2, 8], 2));
        [Fact] public void while文で探索_見つからない() => Assert.Equal(-1, Search.LinearSearchWhile([1, 2, 3], 99));
        [Fact] public void for文で探索_見つかる() => Assert.Equal(3, Search.LinearSearchFor([6, 4, 3, 2, 1, 2, 8], 2));
        [Fact] public void for文で探索_見つからない() => Assert.Equal(-1, Search.LinearSearchFor([1, 2, 3], 99));
        [Fact] public void 番兵法で探索_見つかる() => Assert.Equal(3, Search.LinearSearchSentinel([6, 4, 3, 2, 1, 2, 8], 2));
        [Fact] public void 番兵法で探索_見つからない() => Assert.Equal(-1, Search.LinearSearchSentinel([1, 2, 3], 99));
    }

    public class BinarySearchTest
    {
        [Fact] public void 中央の要素を探索() => Assert.Equal(3, Search.BinarySearch([1, 2, 3, 5, 7, 8, 9], 5));
        [Fact] public void 先頭の要素を探索() => Assert.Equal(0, Search.BinarySearch([1, 2, 3, 5, 7, 8, 9], 1));
        [Fact] public void 末尾の要素を探索() => Assert.Equal(6, Search.BinarySearch([1, 2, 3, 5, 7, 8, 9], 9));
        [Fact] public void 見つからない() => Assert.Equal(-1, Search.BinarySearch([1, 2, 3, 5, 7, 8, 9], 4));
    }

    public class ChainedHashTest
    {
        private Search.ChainedHash MakeHash()
        {
            var h = new Search.ChainedHash(13);
            h.Add(1, "赤尾"); h.Add(5, "武田"); h.Add(10, "小野");
            h.Add(12, "鈴木"); h.Add(14, "神崎");
            return h;
        }

        [Fact] public void 探索_見つかる() { var h = MakeHash(); Assert.Equal("赤尾", h.Search(1)); Assert.Equal("神崎", h.Search(14)); }
        [Fact] public void 探索_見つからない() => Assert.Null(MakeHash().Search(100));
        [Fact] public void 追加して探索() { var h = MakeHash(); h.Add(100, "山田"); Assert.Equal("山田", h.Search(100)); }
        [Fact] public void 重複キーは追加できない() => Assert.False(MakeHash().Add(1, "重複"));
        [Fact] public void 削除() { var h = MakeHash(); h.Add(100, "山田"); Assert.True(h.Remove(100)); Assert.Null(h.Search(100)); }
        [Fact] public void 衝突したノードの削除() { var h = MakeHash(); Assert.True(h.Remove(1)); Assert.True(h.Remove(14)); Assert.Null(h.Search(1)); Assert.Null(h.Search(14)); }
        [Fact] public void 存在しないキーの削除() => Assert.False(MakeHash().Remove(999));
    }

    public class OpenHashTest
    {
        private Search.OpenHash MakeHash()
        {
            var h = new Search.OpenHash(13);
            h.Add(1, "赤尾"); h.Add(5, "武田"); h.Add(10, "小野");
            h.Add(12, "鈴木"); h.Add(14, "神崎");
            return h;
        }

        [Fact] public void 探索_見つかる() => Assert.Equal("赤尾", MakeHash().Search(1));
        [Fact] public void 探索_見つからない() => Assert.Null(MakeHash().Search(999));
        [Fact] public void 追加して探索() { var h = MakeHash(); h.Add(100, "山田"); Assert.Equal("山田", h.Search(100)); }
        [Fact] public void 重複キーは追加できない() => Assert.False(MakeHash().Add(1, "重複"));
        [Fact] public void 削除() { var h = MakeHash(); h.Add(100, "山田"); Assert.True(h.Remove(100)); Assert.Null(h.Search(100)); }
        [Fact] public void 存在しないキーの削除() => Assert.False(MakeHash().Remove(999));

        [Fact]
        public void テーブル満杯時の追加()
        {
            var small = new Search.OpenHash(3);
            small.Add(0, "a"); small.Add(1, "b"); small.Add(2, "c");
            Assert.False(small.Add(99, "d"));
        }

        [Fact]
        public void テーブル満杯時の存在しないキー削除()
        {
            var small = new Search.OpenHash(3);
            small.Add(0, "a"); small.Add(1, "b"); small.Add(2, "c");
            Assert.False(small.Remove(99));
        }
    }
}
