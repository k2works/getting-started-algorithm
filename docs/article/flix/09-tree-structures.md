# 第 9 章 木構造

## 9.1 はじめに

第 8 章では、順序を持つデータをリストで表現しました。この章では、親子関係を持つ木構造を扱います。二分探索木（BST: Binary Search Tree）では、各ノードの左部分木に小さいキー、右部分木に大きいキーを置くことで、探索・追加・削除を効率化します。

Flix では再帰 enum で木を表現できます。ノードは不変なので、追加や削除は既存ノードを書き換えるのではなく、新しい木を返します。もう一つの題材である最小ヒープは、完全二分木の形を配列に対応させ、領域 `r` の可変配列を更新して実装します。

### この章の TODO リスト

- [x] 再帰 enum で空木とノードを定義する
- [x] キーと値の追加・探索を行い、重複キーを拒否する
- [x] 葉・子 1 つ・子 2 つの各ケースでノードを削除する
- [x] 中順走査と最小・最大キー取得を実装する
- [x] 配列ベースの最小ヒープに追加・最小値削除を実装する
- [x] 空木・存在しないキー・配列容量などの境界値をテストする

実装は `apps/flix/src/Trees.flix`、テストは `apps/flix/test/TestTrees.flix` に置きます。

## 9.2 木構造と二分木

木はノードとノード間の辺で構成される階層的なデータ構造です。最上位のノードを **根（root）**、子を持たないノードを **葉（leaf）** と呼びます。二分木では、各ノードが持つ子は左と右の最大 2 つです。

二分探索木では、各ノード `node` について次の順序を保ちます。

- 左部分木にあるすべてのキーは `node` のキーより小さい
- 右部分木にあるすべてのキーは `node` のキーより大きい
- この章では重複キーを許可しない

この不変条件により、探索時には左か右のどちらか一方だけをたどれます。

```text
        5
       / \
      3   7
     / \
    1   4
```

この木の中順走査（左部分木 → ノード → 右部分木）は `1, 3, 4, 5, 7` となり、キーの昇順になります。

## 9.3 Red — 二分探索木の振る舞いをテストする

最初に、空木から追加・探索できること、見つからないキーは `None` になること、中順走査が昇順になることを確認します。`TestTrees.flix` では、さらに重複キーと削除の各ケースもテストしています。

```flix
@Test
def binarySearchTree_insert_and_search(): Unit \ Assert =
    let empty: Trees.BST[String] = Trees.empty();
    let (withFive, insertedFive) = Trees.add(5, "five", empty);
    let (tree, insertedThree) = Trees.add(3, "three", withFive);
    Assert.assertEq(expected = true, insertedFive);
    Assert.assertEq(expected = true, insertedThree);
    Assert.assertEq(expected = Some("five"), Trees.search(5, tree));
    Assert.assertEq(expected = None, Trees.search(8, tree))

@Test
def binarySearchTree_inorder_is_sorted(): Unit \ Assert =
    let empty: Trees.BST[String] = Trees.empty();
    let (tree1, _) = Trees.add(5, "five", empty);
    let (tree2, _) = Trees.add(3, "three", tree1);
    let (tree3, _) = Trees.add(7, "seven", tree2);
    let (tree4, _) = Trees.add(1, "one", tree3);
    let (tree, _) = Trees.add(4, "four", tree4);
    Assert.assertEq(
        expected = (1, "one") :: (3, "three") :: (4, "four") :: (5, "five") :: (7, "seven") :: Nil,
        Trees.inorder(tree)
    )
```

## 9.4 Green — 再帰 enum で二分探索木を表す

`BST[a]` の型引数 `a` は値の型です。キーは比較演算を明確にするため `Int32` とし、値は任意の型として保持します。

```flix
pub enum BST[a] {
    case Empty
    case Node(Int32, a, BST[a], BST[a])
}
```

`Empty` と `Node` が取りうる形をすべて列挙しているため、コンパイラがパターンマッチの網羅性を検査できます。ノードの追加は比較結果に従って再帰し、更新した側の部分木だけを新しいノードに組み込みます。

```flix
pub def add(key: Int32, value: a, tree: BST[a]): (BST[a], Bool) = match tree {
    case BST.Empty => (BST.Node(key, value, BST.Empty, BST.Empty), true)
    case BST.Node(nodeKey, nodeValue, left, right) =>
        if (key == nodeKey) {
            (tree, false)
        } else if (key < nodeKey) {
            let (updatedLeft, inserted) = add(key, value, left);
            if (inserted)
                (BST.Node(nodeKey, nodeValue, updatedLeft, right), true)
            else
                (tree, false)
        } else {
            let (updatedRight, inserted) = add(key, value, right);
            if (inserted)
                (BST.Node(nodeKey, nodeValue, left, updatedRight), true)
            else
                (tree, false)
        }
}
```

戻り値の `Bool` は追加できたかを示します。キーが重複する場合は `false` と元の木を返し、値を上書きしません。探索も比較結果に応じて片側だけを再帰します。

```flix
pub def search(key: Int32, tree: BST[a]): Option[a] = match tree {
    case BST.Empty => None
    case BST.Node(nodeKey, value, left, right) =>
        if (key == nodeKey)
            Some(value)
        else if (key < nodeKey)
            search(key, left)
        else
            search(key, right)
}
```

空木や未発見のキーは `None`、見つかった値は `Some(value)` で表します。番兵値を値型の中に混ぜず、探索結果の有無を `Option` で表現できます。

## 9.5 ノードの削除

削除対象の子の数によって処理が分かれます。

| 削除対象 | 新しい部分木 |
|---|---|
| 子が 0 個（葉） | `Empty` |
| 子が 1 個 | 唯一の子 |
| 子が 2 個 | 左部分木の最大キー（先行ノード）で置き換え、そのノードを左部分木から削除 |

子が 2 つある場合は、左部分木で最も大きいキーを削除対象の位置に移すと、左・右の大小関係を維持できます。`removeMax` は右端まで進み、そのノードを取り除いた部分木を再帰的に組み直します。

```flix
def removeMax(tree: BST[a]): Option[(Int32, a, BST[a])] = match tree {
    case BST.Empty => None
    case BST.Node(key, value, left, BST.Empty) => Some((key, value, left))
    case BST.Node(key, value, left, right) =>
        match removeMax(right) {
            case None => None
            case Some((maxKey, maxValue, updatedRight)) =>
                Some((maxKey, maxValue, BST.Node(key, value, left, updatedRight)))
        }
}
```

`remove` は探索に失敗した場合 `false` と元の木を返します。見つかった場合は、子の形をパターンマッチで分けて削除します。

```flix
pub def remove(key: Int32, tree: BST[a]): (BST[a], Bool) = match tree {
    case BST.Empty => (BST.Empty, false)
    case BST.Node(nodeKey, value, left, right) =>
        if (key < nodeKey) {
            let (updatedLeft, removed) = remove(key, left);
            if (removed)
                (BST.Node(nodeKey, value, updatedLeft, right), true)
            else
                (tree, false)
        } else if (key > nodeKey) {
            let (updatedRight, removed) = remove(key, right);
            if (removed)
                (BST.Node(nodeKey, value, left, updatedRight), true)
            else
                (tree, false)
        } else {
            match (left, right) {
                case (BST.Empty, _) => (right, true)
                case (_, BST.Empty) => (left, true)
                case _ =>
                    match removeMax(left) {
                        case None => (tree, false)
                        case Some((predecessorKey, predecessorValue, updatedLeft)) =>
                            (BST.Node(predecessorKey, predecessorValue, updatedLeft, right), true)
                    }
            }
        }
}
```

子 2 つのケースで `removeMax(left)` が `None` になることは、分岐条件上ありません。それでも結果型が `Option` であるため、関数は不正状態を安全に扱える形になっています。再帰で戻る経路上のノードだけを再構築し、それ以外の部分木は共有します。

## 9.6 木の走査と端のキー

中順走査は左部分木、ノード、右部分木の順でキーと値のペアを返します。蓄積用リストを引数に渡すため、結果の連結で二次時間になるのを避けられます。

```flix
pub def inorder(tree: BST[a]): List[(Int32, a)] =
    def loop(node, acc) = match node {
        case BST.Empty => acc
        case BST.Node(key, value, left, right) =>
            loop(left, (key, value) :: loop(right, acc))
    };
    loop(tree, Nil)
```

二分探索木では、中順走査が昇順になることが順序不変条件の確認にもなります。最小キーは左端、最大キーは右端をたどって取得します。木が空の場合はどちらも `None` です。

```flix
pub def minKey(tree: BST[a]): Option[Int32] = match tree {
    case BST.Empty => None
    case BST.Node(key, _, BST.Empty, _) => Some(key)
    case BST.Node(_, _, left, _) => minKey(left)
}
```

`maxKey` は左と右を入れ替えた同じ考え方です。

## 9.7 配列で表す最小ヒープ

ヒープは完全二分木の形を保ち、親と子の値の順序を保つ木です。最小ヒープでは親の値が子の値以下になります。要素を詰めて配列に置けば、添字 `i` の親・左の子・右の子は次の式で求められます。

| 関係 | 添字 |
|---|---:|
| 親 | `(i - 1) / 2` |
| 左の子 | `2 * i + 1` |
| 右の子 | `2 * i + 2` |

`heapCreate` は容量を確保します。`heapInsert` は末尾に値を置いて親と比較しながら上へ移動（bubble up）し、`heapRemoveMin` は根を取り出して末尾の値を根に移し、子と比較しながら下へ移動（sift down）します。これらの操作は領域 `r` の配列を更新するため、関数型の不変な BST とは異なり `\ r` 効果が型に現れます。

```flix
pub def heapInsert(value: Int32, heap: Array[Int32, r], size: Int32): Option[Int32] \ r =
    let capacity = Array.length(heap);
    if (size < 0 or size >= capacity) {
        None
    } else {
        Array.put(value, size, heap);
        heapBubbleUp(size, heap);
        Some(size + 1)
    }
```

`size` は有効な要素数で、ヒープの要素は配列の `[0, size)` にあります。追加時には `size` と配列容量の整合性を確認します。容量超過や負のサイズは `None` です。削除も空ヒープや容量を超えるサイズを `None` として扱い、正常時には最小値と新しいサイズを返します。

```flix
pub def heapRemoveMin(
    heap: Array[Int32, r],
    size: Int32
): Option[(Int32, Int32)] \ r =
    let capacity = Array.length(heap);
    if (size <= 0 or size > capacity) {
        None
    } else {
        let minimum = Array.get(0, heap);
        let newSize = size - 1;
        if (newSize == 0) {
            Some((minimum, 0))
        } else {
            Array.put(Array.get(newSize, heap), 0, heap);
            heapSiftDown(0, newSize, heap);
            Some((minimum, newSize))
        }
    }
```

ヒープの不変条件は「有効範囲の各親の値が子の値以下である」ことです。配列を直接確認する代わりに、テストでは `3, 1, 4, 2` を追加し、取り出し順が `1, 2, 3, 4` になることを確認します。空ヒープからの削除、容量 1 のヒープへの 2 個目の追加もテストします。

## 9.8 テストと計算量

`make test` で、BST の追加・探索・重複拒否・中順走査・削除の 3 ケース・存在しないキーの削除・最小最大キーを検証します。最小ヒープは昇順での全要素取り出し、空状態、容量超過を検証します。

二分探索木の計算量はノード数 `n` ではなく、根からの高さ `h` に依存します。

| 操作 | BST の時間 | 最悪（偏った木） | 追加領域 |
|---|---:|---:|---:|
| 探索・追加・削除 | O(h) | O(n) | 再帰スタック O(h) |
| 最小・最大キー | O(h) | O(n) | 再帰スタック O(h) |
| 中順走査 | O(n) | O(n) | 出力 O(n)、再帰スタック O(h) |
| 最小ヒープへの追加・最小値削除 | O(log n) | O(log n) | 配列容量 O(c) を事前確保 |

BST が十分に均衡していれば `h` は O(log n) ですが、昇順のキーを順に追加するなど偏ると `h` は O(n) になります。この実装は自動で平衡化しません。最悪計算量を保証する必要がある場合は、AVL 木や赤黒木などの平衡木を選びます。最小ヒープは形状を完全二分木に保つため、追加・削除で木の高さが O(log n) です。

## 9.9 まとめ

この章では、再帰 enum と網羅的パターンマッチによる二分探索木、配列ベースの最小ヒープを実装しました。BST は順序不変条件によって片側だけを探索し、削除では子の数ごとに部分木を組み直します。最小ヒープは配列添字で親子を求め、値を上下に移動してヒープ不変条件を保ちます。

両者は「木」という共通点がありますが、BST はキー順の探索に、ヒープは最小値（または最大値）の取り出しに適しています。必要な操作と最悪計算量を基準にデータ構造を選びます。
