mod TestLists {
    /// 標準 List の先頭追加と末尾連結を確認する。
    @Test
    def linkedList_prepend_and_append(): Unit \ Assert =
        let values = Lists.fromList(1 :: 2 :: Nil);
        let updated = Lists.append(3, Lists.prepend(0, values));
        Assert.assertEq(expected = 4, Lists.length(updated));
        Assert.assertEq(expected = 0 :: 1 :: 2 :: 3 :: Nil, Lists.toList(updated))

    /// enum で表した単方向リストの探索は先頭の一致位置を返す。
    @Test
    def linkedList_search_first_match(): Unit \ Assert =
        let values = Lists.chainFromList(4 :: 7 :: 7 :: 9 :: Nil);
        Assert.assertEq(expected = Some(1), Lists.chainSearch(7, values))

    /// enum で表した単方向リストは未発見を None で返す。
    @Test
    def linkedList_search_not_found(): Unit \ Assert =
        Assert.assertEq(expected = None, Lists.chainSearch(3, Lists.Chain.ChainEmpty))

    /// 空の独自リストを先頭から削除しても失敗状態を返す。
    @Test
    def linkedList_remove_empty(): Unit \ Assert =
        let empty: Lists.Chain[Int32] = Lists.Chain.ChainEmpty;
        let result = match Lists.chainRemoveFirst(empty) {
            case None => true
            case Some(_) => false
        };
        Assert.assertEq(expected = true, result)

    /// 先頭を削除すると残りのリストを保つ。
    @Test
    def linkedList_remove_first(): Unit \ Assert =
        let values = Lists.chainFromList(5 :: 6 :: 7 :: Nil);
        match Lists.chainRemoveFirst(values) {
            case None => Assert.assertEq(expected = true, false)
            case Some((value, rest)) =>
                Assert.assertEq(expected = 5, value);
                Assert.assertEq(expected = 6 :: 7 :: Nil, Lists.chainToList(rest))
        }

    /// 配列カーソルリストは先頭追加後の順序とサイズを保つ。
    @Test
    def cursorList_add_first_and_traverse(): Unit \ Assert =
        region rc {
            let (values, links) = Lists.cursorCreate(rc, 3);
            match Lists.cursorInsertFirst(1, values, links, -1, 0, 0) {
                case None => Assert.assertEq(expected = true, false)
                case Some((head1, free1, size1)) =>
                    match Lists.cursorInsertFirst(2, values, links, head1, free1, size1) {
                        case None => Assert.assertEq(expected = true, false)
                        case Some((head2, free2, size2)) =>
                            let result = Lists.cursorToList(values, links, head2, size2);
                            Assert.assertEq(expected = Some(2 :: 1 :: Nil), result);
                            Assert.assertEq(expected = 2, free2)
                    }
            }
        }

    /// カーソル配列が満杯なら新しいノードを追加しない。
    @Test
    def cursorList_rejects_overflow(): Unit \ Assert =
        region rc {
            let (values, links) = Lists.cursorCreate(rc, 1);
            let first = Lists.cursorInsertFirst(1, values, links, -1, 0, 0);
            match first {
                case None => Assert.assertEq(expected = true, false)
                case Some((head, free, size)) =>
                    Assert.assertEq(
                        expected = None,
                        Lists.cursorInsertFirst(2, values, links, head, free, size)
                    )
            }
        }

    /// 削除したカーソルをフリーリストから再利用する。
    @Test
    def cursorList_reuses_removed_cursor(): Unit \ Assert =
        region rc {
            let (values, links) = Lists.cursorCreate(rc, 2);
            match Lists.cursorInsertFirst(1, values, links, -1, 0, 0) {
                case None => Assert.assertEq(expected = true, false)
                case Some((head1, free1, size1)) =>
                    match Lists.cursorInsertFirst(2, values, links, head1, free1, size1) {
                        case None => Assert.assertEq(expected = true, false)
                        case Some((head2, free2, size2)) =>
                            match Lists.cursorRemoveFirst(values, links, head2, free2, size2) {
                                case None => Assert.assertEq(expected = true, false)
                                case Some((removed, newHead, newFree, newSize)) =>
                                    Assert.assertEq(expected = 2, removed);
                                    match Lists.cursorInsertFirst(3, values, links, newHead, newFree, newSize) {
                                        case None => Assert.assertEq(expected = true, false)
                                        case Some((finalHead, finalFree, finalSize)) =>
                                            Assert.assertEq(
                                                expected = Some(3 :: 1 :: Nil),
                                                Lists.cursorToList(values, links, finalHead, finalSize)
                                            );
                                            Assert.assertEq(expected = -1, finalFree)
                                    }
                            }
                    }
            }
        }

    /// 不整合なカーソル状態は安全に None を返す。
    @Test
    def cursorList_rejects_invalid_chain(): Unit \ Assert =
        region rc {
            let (values, links) = Lists.cursorCreate(rc, 2);
            Assert.assertEq(expected = None, Lists.cursorToList(values, links, 3, 1));
            Assert.assertEq(expected = None, Lists.cursorToList(values, links, -1, 1))
        }

    /// zipper の左右移動で注目位置と要素順を保つ。
    @Test
    def zipper_moves_both_directions(): Unit \ Assert =
        let start = (Nil, 1 :: 2 :: 3 :: Nil);
        match Lists.zipperMoveNext(start) {
            case None => Assert.assertEq(expected = true, false)
            case Some(next) =>
                Assert.assertEq(expected = 1 :: 2 :: 3 :: Nil, Lists.zipperToList(next));
                match Lists.zipperMovePrevious(next) {
                    case None => Assert.assertEq(expected = true, false)
                    case Some(previous) =>
                        let (left, _) = previous;
                        Assert.assertEq(expected = Nil, left);
                        Assert.assertEq(expected = 1 :: 2 :: 3 :: Nil, Lists.zipperToList(previous))
                }
        }

    /// zipper は注目位置への挿入と削除を不変に行う。
    @Test
    def zipper_inserts_and_removes_at_focus(): Unit \ Assert =
        let inserted = Lists.zipperInsert(9, (1 :: Nil, 2 :: 3 :: Nil));
        Assert.assertEq(expected = 1 :: 9 :: 2 :: 3 :: Nil, Lists.zipperToList(inserted));
        match Lists.zipperRemove(inserted) {
            case None => Assert.assertEq(expected = true, false)
            case Some((removed, rest)) =>
                Assert.assertEq(expected = 9, removed);
                Assert.assertEq(expected = 1 :: 2 :: 3 :: Nil, Lists.zipperToList(rest))
        }

    /// 空の zipper からの移動と削除は None を返す。
    @Test
    def zipper_handles_empty_boundaries(): Unit \ Assert =
        let empty: (List[Int32], List[Int32]) = (Nil, Nil);
        Assert.assertEq(expected = None, Lists.zipperMoveNext(empty));
        Assert.assertEq(expected = None, Lists.zipperMovePrevious(empty));
        Assert.assertEq(expected = None, Lists.zipperRemove(empty))

    /// 循環リストの左回転は末尾要素を先頭へ回す。
    @Test
    def circularList_rotate_left(): Unit \ Assert =
        Assert.assertEq(expected = 2 :: 3 :: 1 :: Nil, Lists.rotateLeft(1 :: 2 :: 3 :: Nil));
        let empty: List[Int32] = Nil;
        Assert.assertEq(expected = Nil, Lists.rotateLeft(empty));
        Assert.assertEq(expected = 1 :: Nil, Lists.rotateLeft(1 :: Nil))
}
