mod TestTrees {
    def drainHeap(heap: Array[Int32, r], size: Int32): Option[List[Int32]] \ r =
        if (size == 0) {
            Some(Nil)
        } else {
            match Trees.heapRemoveMin(heap, size) {
                case None => None
                case Some((value, newSize)) =>
                    match drainHeap(heap, newSize) {
                        case None => None
                        case Some(rest) => Some(value :: rest)
                    }
            }
        }

    /// 二分探索木は値を保持し、キーで検索する。
    @Test
    def binarySearchTree_insert_and_search(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (withFive, insertedFive) = Trees.add(5, "five", empty);
        let (tree, insertedThree) = Trees.add(3, "three", withFive);
        Assert.assertEq(expected = true, insertedFive);
        Assert.assertEq(expected = true, insertedThree);
        Assert.assertEq(expected = Some("five"), Trees.search(5, tree));
        Assert.assertEq(expected = None, Trees.search(8, tree))

    /// 中順走査はキーの昇順で各値を返す。
    @Test
    def binarySearchTree_inorder_is_sorted(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree3, _) = Trees.add(7, "seven", tree2);
        let (tree4, _) = Trees.add(1, "one", tree3);
        let (tree5, _) = Trees.add(4, "four", tree4);
        Assert.assertEq(
            expected = (1, "one") :: (3, "three") :: (4, "four") :: (5, "five") :: (7, "seven") :: Nil,
            Trees.inorder(tree5)
        )

    /// 重複キーの追加は失敗し、既存の値を変更しない。
    @Test
    def binarySearchTree_rejects_duplicate_keys(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree, _) = Trees.add(5, "original", empty);
        let (unchanged, inserted) = Trees.add(5, "replacement", tree);
        Assert.assertEq(expected = false, inserted);
        Assert.assertEq(expected = Some("original"), Trees.search(5, unchanged))

    /// 葉ノードを削除しても他のノードを保持する。
    @Test
    def binarySearchTree_remove_leaf(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree3, _) = Trees.add(7, "seven", tree2);
        let (tree, removed) = Trees.remove(3, tree3);
        Assert.assertEq(expected = true, removed);
        Assert.assertEq(expected = None, Trees.search(3, tree));
        Assert.assertEq(expected = Some("seven"), Trees.search(7, tree))

    /// 子が 1 つのノードを削除すると、その子を接続する。
    @Test
    def binarySearchTree_remove_node_with_one_child(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree3, _) = Trees.add(2, "two", tree2);
        let (tree, removed) = Trees.remove(3, tree3);
        Assert.assertEq(expected = true, removed);
        Assert.assertEq(expected = (2, "two") :: (5, "five") :: Nil, Trees.inorder(tree))

    /// 子が 2 つのノードを先行順の最大値で置き換えて削除する。
    @Test
    def binarySearchTree_remove_node_with_two_children(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree3, _) = Trees.add(7, "seven", tree2);
        let (tree4, _) = Trees.add(1, "one", tree3);
        let (tree5, _) = Trees.add(4, "four", tree4);
        let (tree, removed) = Trees.remove(3, tree5);
        Assert.assertEq(expected = true, removed);
        Assert.assertEq(
            expected = (1, "one") :: (4, "four") :: (5, "five") :: (7, "seven") :: Nil,
            Trees.inorder(tree)
        )

    /// 存在しないキーの削除は木を変更しない。
    @Test
    def binarySearchTree_remove_missing_key(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree, _) = Trees.add(5, "five", empty);
        let (unchanged, removed) = Trees.remove(9, tree);
        Assert.assertEq(expected = false, removed);
        Assert.assertEq(expected = (5, "five") :: Nil, Trees.inorder(unchanged))

    /// 根ノードを削除しても両部分木の順序を維持する。
    @Test
    def binarySearchTree_remove_root_with_two_children(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree, _) = Trees.add(7, "seven", tree2);
        let (updated, removed) = Trees.remove(5, tree);
        Assert.assertEq(expected = true, removed);
        Assert.assertEq(expected = (3, "three") :: (7, "seven") :: Nil, Trees.inorder(updated))

    /// 最小値と最大値を返し、空木では None を返す。
    @Test
    def binarySearchTree_minimum_and_maximum(): Unit \ Assert =
        let empty: Trees.BST[String] = Trees.empty();
        Assert.assertEq(expected = None, Trees.minKey(empty));
        Assert.assertEq(expected = None, Trees.maxKey(empty));
        let (tree1, _) = Trees.add(5, "five", empty);
        let (tree2, _) = Trees.add(3, "three", tree1);
        let (tree, _) = Trees.add(7, "seven", tree2);
        Assert.assertEq(expected = Some(3), Trees.minKey(tree));
        Assert.assertEq(expected = Some(7), Trees.maxKey(tree))

    /// 最小ヒープからは値を昇順で取り出せる。
    @Test
    def minHeap_insert_and_remove_in_order(): Unit \ Assert =
        region rc {
            let heap = Trees.heapCreate(rc, 4);
            match Trees.heapInsert(3, heap, 0) {
                case None => Assert.assertEq(expected = true, false)
                case Some(size1) =>
                    match Trees.heapInsert(1, heap, size1) {
                        case None => Assert.assertEq(expected = true, false)
                        case Some(size2) =>
                            match Trees.heapInsert(4, heap, size2) {
                                case None => Assert.assertEq(expected = true, false)
                                case Some(size3) =>
                                    match Trees.heapInsert(2, heap, size3) {
                                        case None => Assert.assertEq(expected = true, false)
                                        case Some(size4) =>
                                            Assert.assertEq(
                                                expected = Some(1 :: 2 :: 3 :: 4 :: Nil),
                                                drainHeap(heap, size4)
                                            )
                                    }
                            }
                    }
            }
        }

    /// 空ヒープからの取り出しと容量超過を拒否する。
    @Test
    def minHeap_handles_empty_and_full_capacity(): Unit \ Assert =
        region rc {
            let heap = Trees.heapCreate(rc, 1);
            Assert.assertEq(expected = None, Trees.heapRemoveMin(heap, 0));
            match Trees.heapInsert(8, heap, 0) {
                case None => Assert.assertEq(expected = true, false)
                case Some(size) =>
                    Assert.assertEq(expected = None, Trees.heapInsert(9, heap, size));
                    match Trees.heapRemoveMin(heap, size) {
                        case None => Assert.assertEq(expected = true, false)
                        case Some((value, newSize)) =>
                            Assert.assertEq(expected = 8, value);
                            Assert.assertEq(expected = 0, newSize)
                    }
            }
        }
}
