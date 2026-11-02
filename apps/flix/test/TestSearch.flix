mod TestSearch {
    /// 線形探索は最初に見つかった位置を返す。
    @Test
    def linearSearch_found(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 6 :: 4 :: 3 :: 2 :: 1 :: 2 :: 8 :: Nil);
            Assert.assertEq(expected = Some(3), Search.linearSearch(values, 2))
        }

    /// 線形探索は空配列で None を返す。
    @Test
    def linearSearch_empty(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = None, Search.linearSearch(values, 2))
        }

    /// 線形探索でキーが見つからない。
    @Test
    def linearSearch_not_found(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: Nil);
            Assert.assertEq(expected = None, Search.linearSearch(values, 99))
        }

    /// 番兵法は一致する要素の位置を返す。
    @Test
    def sentinelSearch_found(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 6 :: 4 :: 3 :: 2 :: 1 :: Nil);
            Assert.assertEq(expected = Some(3), Search.sentinelSearch(values, 2))
        }

    /// 番兵法では探索用の番兵を入力配列に残さない。
    @Test
    def sentinelSearch_does_not_change_input(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: Nil);
            let result = Search.sentinelSearch(values, 9);
            Assert.assertEq(expected = None, result);
            Assert.assertEq(expected = 3, Array.length(values))
        }

    /// 番兵法は空配列でも安全に探索できる。
    @Test
    def sentinelSearch_empty(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = None, Search.sentinelSearch(values, 2))
        }

    /// 二分探索で中央付近の要素を見つける。
    @Test
    def binarySearch_found(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
            Assert.assertEq(expected = Some(3), Search.binarySearch(values, 5))
        }

    /// 二分探索は先頭要素を見つける。
    @Test
    def binarySearch_first(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
            Assert.assertEq(expected = Some(0), Search.binarySearch(values, 1))
        }

    /// 二分探索は末尾要素を見つける。
    @Test
    def binarySearch_last(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
            Assert.assertEq(expected = Some(6), Search.binarySearch(values, 9))
        }

    /// 二分探索で存在しないキーを探す。
    @Test
    def binarySearch_not_found(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
            Assert.assertEq(expected = None, Search.binarySearch(values, 4))
        }

    /// 二分探索は空配列を扱う。
    @Test
    def binarySearch_empty(): Unit \ Assert =
        region rc {
            let values = Array.repeat(rc, 0, 0);
            Assert.assertEq(expected = None, Search.binarySearch(values, 4))
        }

    /// 重複キーでは最初のインデックスを返す。
    @Test
    def binarySearch_duplicate_returns_first(): Unit \ Assert =
        region rc {
            let values = List.toArray(rc, 1 :: 2 :: 2 :: 2 :: 3 :: Nil);
            Assert.assertEq(expected = Some(1), Search.binarySearch(values, 2))
        }

    /// ハッシュ関数はキーを有効なバケットに割り当てる。
    @Test
    def hashIndex_positive_key(): Unit \ Assert =
        Assert.assertEq(expected = Some(1), Search.hashIndex(14, 13))

    /// ハッシュ関数は負のキーにも有効なバケットを返す。
    @Test
    def hashIndex_negative_key(): Unit \ Assert =
        Assert.assertEq(expected = Some(12), Search.hashIndex(-1, 13))

    /// バケット数が 0 の場合はハッシュ値を計算しない。
    @Test
    def hashIndex_zero_capacity(): Unit \ Assert =
        Assert.assertEq(expected = None, Search.hashIndex(1, 0))

    /// チェイン法で異なるバケットの値を検索する。
    @Test
    def hashSearch_found(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let firstAdded = Search.hashAdd(1, "赤尾", buckets);
            let secondAdded = Search.hashAdd(2, "神崎", buckets);
            Assert.assertEq(expected = true, firstAdded);
            Assert.assertEq(expected = true, secondAdded);
            Assert.assertEq(expected = Some("神崎"), Search.hashSearch(2, buckets))
        }

    /// 同じバケットに衝突したキーも個別に検索する。
    @Test
    def hashSearch_collision(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let firstAdded = Search.hashAdd(1, "赤尾", buckets);
            let secondAdded = Search.hashAdd(14, "神崎", buckets);
            Assert.assertEq(expected = true, firstAdded);
            Assert.assertEq(expected = true, secondAdded);
            Assert.assertEq(expected = Some("赤尾"), Search.hashSearch(1, buckets));
            Assert.assertEq(expected = Some("神崎"), Search.hashSearch(14, buckets))
        }

    /// 存在しないキーの検索結果は None。
    @Test
    def hashSearch_not_found(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let added = Search.hashAdd(1, "赤尾", buckets);
            Assert.assertEq(expected = true, added);
            Assert.assertEq(expected = None, Search.hashSearch(100, buckets))
        }

    /// 重複したキーは追加しない。
    @Test
    def hashAdd_rejects_duplicate(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let first = Search.hashAdd(1, "赤尾", buckets);
            let second = Search.hashAdd(1, "重複", buckets);
            Assert.assertEq(expected = true, first);
            Assert.assertEq(expected = false, second);
            Assert.assertEq(expected = Some("赤尾"), Search.hashSearch(1, buckets))
        }

    /// 同じハッシュ値でも異なるキーは追加できる。
    @Test
    def hashAdd_allows_collision(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let first = Search.hashAdd(1, "赤尾", buckets);
            let second = Search.hashAdd(14, "神崎", buckets);
            Assert.assertEq(expected = true, first);
            Assert.assertEq(expected = true, second)
        }

    /// 衝突したチェインからキーを削除する。
    @Test
    def hashRemove_from_collision_chain(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            let firstAdded = Search.hashAdd(1, "赤尾", buckets);
            let secondAdded = Search.hashAdd(14, "神崎", buckets);
            Assert.assertEq(expected = true, firstAdded);
            Assert.assertEq(expected = true, secondAdded);
            let removed = Search.hashRemove(1, buckets);
            Assert.assertEq(expected = true, removed);
            Assert.assertEq(expected = None, Search.hashSearch(1, buckets));
            Assert.assertEq(expected = Some("神崎"), Search.hashSearch(14, buckets))
        }

    /// 見つからないキーの削除は false を返す。
    @Test
    def hashRemove_missing_key(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 13);
            Assert.assertEq(expected = false, Search.hashRemove(1, buckets))
        }

    /// 空のハッシュテーブルでは追加と検索は失敗する。
    @Test
    def hash_zero_capacity(): Unit \ Assert =
        region rc {
            let buckets = Search.newHashTable(rc, 0);
            Assert.assertEq(expected = false, Search.hashAdd(1, "赤尾", buckets));
            Assert.assertEq(expected = None, Search.hashSearch(1, buckets))
        }
}
