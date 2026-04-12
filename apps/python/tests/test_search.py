"""第3章 探索アルゴリズム — テスト"""

from algorithm.search import (
    ChainedHash,
    OpenHash,
    bseach,
    ssearch_for,
    ssearch_sentinel,
    ssearch_while,
)


class TestSsearch:
    """線形探索"""

    def test_ssearch_while_int(self):
        assert ssearch_while([6, 4, 3, 2, 1, 2, 8], 2) == 3

    def test_ssearch_while_float(self):
        assert ssearch_while([12.7, 3.14, 6.4, 7.2], 6.4) == 2

    def test_ssearch_while_tuple(self):
        assert ssearch_while((4, 7, 5.6, 2, 3.14, 1), 5.6) == 2

    def test_ssearch_while_str(self):
        assert ssearch_while(["DTS", "AAC", "FLAC"], "DTS") == 0

    def test_ssearch_while_not_found(self):
        assert ssearch_while([1, 2, 3], 99) == -1

    def test_ssearch_for_int(self):
        assert ssearch_for([6, 4, 3, 2, 1, 2, 8], 2) == 3

    def test_ssearch_for_str(self):
        assert ssearch_for(["DTS", "AAC", "FLAC"], "DTS") == 0

    def test_ssearch_for_not_found(self):
        assert ssearch_for([1, 2, 3], 99) == -1


class TestSsearchSentinel:
    """線形探索 — 番兵法"""

    def test_ssearch_sentinel_found(self):
        assert ssearch_sentinel([6, 4, 3, 2, 1, 2, 8], 2) == 3

    def test_ssearch_sentinel_not_found(self):
        assert ssearch_sentinel([1, 2, 3], 99) == -1


class TestBseach:
    """二分探索"""

    def test_bseach_found(self):
        assert bseach([1, 2, 3, 5, 7, 8, 9], 5) == 3

    def test_bseach_first(self):
        assert bseach([1, 2, 3, 5, 7, 8, 9], 1) == 0

    def test_bseach_last(self):
        assert bseach([1, 2, 3, 5, 7, 8, 9], 9) == 6

    def test_bseach_not_found(self):
        assert bseach([1, 2, 3, 5, 7, 8, 9], 4) == -1


class TestChainedHash:
    """チェイン法ハッシュ"""

    def setup_method(self):
        self.h = ChainedHash(13)
        self.h.add(1, "赤尾")
        self.h.add(5, "武田")
        self.h.add(10, "小野")
        self.h.add(12, "鈴木")
        self.h.add(14, "神崎")

    def test_search_found(self):
        assert self.h.search(1) == "赤尾"
        assert self.h.search(14) == "神崎"

    def test_search_not_found(self):
        assert self.h.search(100) is None

    def test_search_str_key(self):
        self.h.add("abc", "文字列キー")
        assert self.h.search("abc") == "文字列キー"

    def test_add(self):
        self.h.add(100, "山田")
        assert self.h.search(100) == "山田"

    def test_add_duplicate(self):
        # 同じキーは追加できない
        assert self.h.add(1, "重複") is False

    def test_remove_head(self):
        # 連結リストの先頭ノードを削除
        self.h.add(100, "山田")
        self.h.remove(100)
        assert self.h.search(100) is None

    def test_remove_middle(self):
        # 衝突して連結された後続ノードを削除（1 と 14 は同一バケットに衝突: 1%13=1, 14%13=1）
        self.h.remove(1)  # 先頭ノード削除
        self.h.remove(14)  # 後続ノード削除
        assert self.h.search(1) is None
        assert self.h.search(14) is None

    def test_remove_not_found(self):
        assert self.h.remove(999) is False


class TestOpenHash:
    """オープンアドレス法ハッシュ"""

    def setup_method(self):
        self.h = OpenHash(13)
        self.h.add(1, "赤尾")
        self.h.add(5, "武田")
        self.h.add(10, "小野")
        self.h.add(12, "鈴木")
        self.h.add(14, "神崎")

    def test_search_found(self):
        assert self.h.search(1) == "赤尾"

    def test_search_str_key(self):
        self.h.add("hello", "文字列")
        assert self.h.search("hello") == "文字列"

    def test_search_not_found(self):
        assert self.h.search(999) is None

    def test_add(self):
        self.h.add(100, "山田")
        assert self.h.search(100) == "山田"

    def test_add_duplicate(self):
        assert self.h.add(1, "重複") is False

    def test_remove(self):
        self.h.add(100, "山田")
        self.h.remove(100)
        assert self.h.search(100) is None

    def test_remove_not_found(self):
        assert self.h.remove(999) is False

    def test_add_full_table(self):
        # テーブルが満杯の場合は False を返す
        h = OpenHash(3)
        h.add(0, "a")
        h.add(1, "b")
        h.add(2, "c")
        assert h.add(99, "d") is False  # 空きスロットなし

    def test_remove_all_occupied_no_match(self):
        # テーブルが全部 OCCUPIED で対象キーがない場合
        h = OpenHash(3)
        h.add(0, "a")
        h.add(1, "b")
        h.add(2, "c")
        assert h.remove(99) is False
