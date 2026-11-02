# 第 8 章 リスト

## 8.1 はじめに

第 7 章では不変な文字列と文字列探索を扱いました。この章では、データを順序付けて保持するリストを学びます。Python 版の単方向連結リスト、配列カーソル、循環双方向リストを参照しながら、Flix 標準 `List`、再帰 enum、更新可能な配列、左右に移動できる zipper を使って、各表現の特徴と不変条件を確認します。

配列は添字による読み取りが O(1) ですが、途中に要素を挿入すると後続要素の移動が必要です。連結リストは先頭要素の追加・削除が O(1) ですが、任意位置へのアクセスや値の探索には先頭からの走査が必要です。Flix 標準 `List` は不変な単方向連結リストです。先頭に値を追加するときは既存部分を共有できるため、元のリストを壊さずに O(1) で操作できます。

### この章の TODO リスト

- [x] 標準 `List` の不変性と先頭追加・末尾追加の計算量を確認する
- [x] enum とパターンマッチで独自の単方向リストを表現する
- [x] 先頭削除・探索・リスト変換を実装する
- [x] 添字をリンクとして使う配列カーソルリストを実装する
- [x] 削除ノードのフリーリスト再利用と不正状態をテストする
- [x] zipper による双方向移動・着目位置での挿入削除を実装する
- [x] リストの左回転で循環的な走査を表現し、実ポインタの循環構造と区別する

実装は `src/Lists.flix`、テストは `test/TestLists.flix` に置きます。

## 8.2 標準 `List` と不変な先頭操作

Flix の標準 `List[a]` は `Nil` または `head :: tail` です。先頭へ追加する操作は新しい先頭ノードを作り、既存の末尾部分を共有します。リストが不変なので、更新後も元のリストはそのまま残ります。

```flix
let values = 1 :: 2 :: Nil;
let extended = 0 :: values;
// values   = 1 :: 2 :: Nil
// extended = 0 :: 1 :: 2 :: Nil
```

### Red — 追加後の順序とサイズを確認する

`test/TestLists.flix` で先頭追加と末尾追加をテストします。

```flix
@Test
def linkedList_prepend_and_append(): Unit \ Assert =
    let values = Lists.fromList(1 :: 2 :: Nil);
    let updated = Lists.append(3, Lists.prepend(0, values));
    Assert.assertEq(expected = 4, Lists.length(updated));
    Assert.assertEq(expected = 0 :: 1 :: 2 :: 3 :: Nil, Lists.toList(updated))
```

### Green — 先頭追加は共有、末尾追加は再帰で作り直す

`src/Lists.flix` の標準リスト操作は次のとおりです。

```flix
pub def prepend(value: a, values: List[a]): List[a] =
    value :: values

pub def append(value: a, values: List[a]): List[a] = match values {
    case Nil => value :: Nil
    case head :: tail => head :: append(value, tail)
}
```

`prepend` は新しい先頭ノードだけを作るため O(1) 時間・領域です。末尾追加では末尾まで走査し、先頭からのノードを新たに作るため O(n) 時間・追加領域です。元のリストは変更されません。多くの値を順に追加するなら、先頭へ積んで最後に一度だけ反転する方法や、末尾追加に適した別のデータ構造を検討します。

## 8.3 enum による単方向連結リスト

標準 `List` も再帰的な代数的データ型ですが、ここでは構造を明示するため `Chain[a]` を定義します。Flix の enum はノードのどちらかの形を型で表し、パターンマッチの網羅性をコンパイラが検査します。

```flix
pub enum Chain[a] {
    case ChainEmpty
    case ChainNode(a, Chain[a])
}
```

`ChainEmpty` は空、`ChainNode(value, tail)` は値と後続ノードです。ノードは不変なので、追加・削除は既存のノードを破壊するのではなく、新しい構造を返します。

### Red — 探索と空リストの削除をテストする

```flix
@Test
def linkedList_search_first_match(): Unit \ Assert =
    let values = Lists.chainFromList(4 :: 7 :: 7 :: 9 :: Nil);
    Assert.assertEq(expected = Some(1), Lists.chainSearch(7, values))

@Test
def linkedList_remove_empty(): Unit \ Assert =
    let empty: Lists.Chain[Int32] = Lists.Chain.ChainEmpty;
    let result = match Lists.chainRemoveFirst(empty) {
        case None => true
        case Some(_) => false
    };
    Assert.assertEq(expected = true, result)
```

### Green — 先頭を分解し、残りを返す

```flix
pub def chainSearch(value: a, values: Chain[a]): Option[Int32] with Eq[a] =
    def loop(index, xs) = match xs {
        case Chain.ChainEmpty => None
        case Chain.ChainNode(head, tail) =>
            if (head == value) Some(index) else loop(index + 1, tail)
    };
    loop(0, values)

pub def chainRemoveFirst(values: Chain[a]): Option[(a, Chain[a])] = match values {
    case Chain.ChainEmpty => None
    case Chain.ChainNode(value, tail) => Some((value, tail))
}
```

探索は一致が先頭なら O(1)、末尾や未発見なら O(n) です。先頭削除は値と末尾を返すだけなので O(1) 時間・追加領域です。空の削除は `None` で表し、存在しないノードを無理に取り出しません。

## 8.4 配列カーソルによる線形リスト

ポインタの代わりに配列の添字をリンクとして使うと、配列内に連結リストを表現できます。この添字を **カーソル** と呼びます。Flix の可変配列は領域 `r` に確保され、各変更関数の型に `\ r` 効果が現れます。

この章の最小カーソル実装は、データ用配列 `values` と次カーソル配列 `links` を使います。リスト先頭、フリーリスト先頭、要素数は呼び出し側で明示的に受け渡します。

```flix
pub def cursorCreate(rc: Region[r], capacity: Int32):
    (Array[Int32, r], Array[Int32, r]) \ r =
    let size = if (capacity < 0) 0 else capacity;
    let values = Array.repeat(rc, size, 0);
    let links = Array.init(rc, i -> if (i + 1 < size) i + 1 else -1, size);
    (values, links)
```

初期状態では、利用可能なカーソルを `0 -> 1 -> ... -> capacity-1 -> -1` とつないでいます。`-1` は「次がない」を表す sentinel です。先頭追加ではフリーリストの先頭を取り出し、そのノードの次に現在のリスト先頭を設定します。

```flix
pub def cursorInsertFirst(
    value: Int32,
    values: Array[Int32, r],
    links: Array[Int32, r],
    head: Int32,
    free: Int32,
    size: Int32
): Option[(Int32, Int32, Int32)] \ r =
    let capacity = Array.length(values);
    if (
        Array.length(links) != capacity or
        size < 0 or size >= capacity or
        head < -1 or head >= capacity or
        free < 0 or free >= capacity
    ) {
        None
    } else {
        let nextFree = Array.get(free, links);
        if (nextFree < -1 or nextFree >= capacity) {
            None
        } else {
            Array.put(value, free, values);
            Array.put(head, free, links);
            Some((free, nextFree, size + 1))
        }
    }
```

戻り値は `(新しい head, 新しい free, 新しい size)` です。配列を書き換えるため、状態を引数と戻り値に明示していてもデータ配列自体は可変です。空きカーソルがなければ `None` を返し、配列範囲外を参照しません。先頭追加は O(1) です。

先頭削除では、取り外したカーソルをフリーリストの先頭につなぎ直します。これにより、削除済みの配列スロットを後続の追加で再利用できます。

```flix
let value = Array.get(head, values);
let nextHead = Array.get(head, links);
Array.put(free, head, links);
Some((value, nextHead, head, size - 1))
```

フリーリストの不変条件は「フリーなカーソルは互いに一度ずつ連結され、現行リストと共有しない」ことです。配列カーソルのインデックスが範囲内であること、`size` が利用ノード数と一致することも必要です。`cursorToList` は指定された要素数だけ走査し、途中のカーソルが範囲外、または走査後に余分なリンクが残る不整合を `None` で拒否します。

追加・先頭削除は O(1)、全要素の変換と探索は O(n) です。記憶領域は初期確保した容量 c に対して O(c) で、削除したノードをフリーリストで再利用します。整数の `-1` を値として格納できないという制約はありません。sentinel はデータ配列ではなくリンク配列にだけ使います。

## 8.5 zipper による双方向移動

Flix の不変リストでは、Python のようにノードに `prev` と `next` の可変参照を持たせて、両方向のリンクを更新する設計は適しません。代わりに、注目位置の左側を逆順にした `left` と、注目位置以降を保持する `right` の組を **zipper** として扱います。

```text
元の順序: 1 -> 2 -> 3
zipper:   (1 :: Nil, 2 :: 3 :: Nil)
                       ^
                    注目位置
```

`left` の先頭へ値を移す操作が「左へ進む」、`right` の先頭から `left` へ値を移す操作が「右へ進む」です。移動は既存リストを変更せず、新しいペアを返します。

```flix
pub def zipperMoveNext(zipper: (List[a], List[a])): Option[(List[a], List[a])] =
    let (left, right) = zipper;
    match right {
        case Nil => None
        case value :: rest => Some((value :: left, rest))
    }

pub def zipperMovePrevious(zipper: (List[a], List[a])): Option[(List[a], List[a])] =
    let (left, right) = zipper;
    match left {
        case Nil => None
        case value :: rest => Some((rest, value :: right))
    }
```

zipper の不変条件は、`reverse(left) ++ right` が常に元のリスト順を表すことです。左右移動と先頭での挿入・削除は O(1)。内容を通常のリストに戻すには `left` を反転して `right` と連結するため O(n) 時間・追加領域が必要です。

## 8.6 循環リストを関数型で表す

Python 版の循環双方向リストは、番兵ノードを含めて最後と最初を実際にリンクします。Flix の不変値で自己参照する循環リンクを直接作る代わりに、この章ではリストを左へ 1 回回転する関数で循環的な走査を表します。

```flix
pub def rotateLeft(values: List[a]): List[a] = match values {
    case Nil => Nil
    case head :: tail =>
        def appendLast(xs) = match xs {
            case Nil => head :: Nil
            case value :: rest => value :: appendLast(rest)
        };
        appendLast(tail)
}
```

たとえば `1 :: 2 :: 3 :: Nil` は `2 :: 3 :: 1 :: Nil` になります。空リストは空のまま、要素 1 個のリストは同じ値を返します。実際の循環リンク構造ではないため、ノード参照をたどって無限に周回する用途と混同しないでください。`rotateLeft` は末尾まで走査して新しいリストを作るため O(n) 時間・領域です。

## 8.7 テストと計算量の比較

`test/TestLists.flix` では、空リスト、重複値、未発見、配列容量超過、削除カーソルの再利用、不正リンク、zipper の両端、循環回転をテストします。

```bash
make test
make check
make format-check
```

| 表現・操作 | 先頭追加 / 削除 | 末尾追加 | 探索 / 任意位置アクセス | 主な領域 |
|---|---:|---:|---:|---:|
| 標準 `List` | O(1) | O(n) | O(n) | 不変ノード、先頭側を共有 |
| `Chain[a]` enum | O(1) | O(n) | O(n) | 不変ノード、先頭側を共有 |
| 配列カーソル | O(1) | 末尾への走査を加えると O(n) | O(n) | 容量 c の配列を O(c) |
| zipper | 注目位置では O(1) | 末尾操作は位置に依存 | O(n) で移動 | 左右の不変リスト |
| 循環左回転 | — | — | 回転 O(n) | 新しい不変リスト O(n) |

連結リストの「挿入・削除 O(1)」は、対象ノードまたは挿入位置をすでに保持している場合の計算量です。値の探索を含めると O(n) が必要です。Flix の zipper は着目位置を明示することで、その位置での編集を O(1) にし、双方向リンクを可変更新せずに位置操作を表現します。

## 8.8 まとめ

この章では、標準 `List` と再帰 enum による単方向リスト、配列カーソル、zipper を比較しました。先頭操作は O(1) ですが、末尾追加・検索・任意位置への移動は走査に比例します。配列カーソルはリンクを整数で表現して空きノードを再利用し、zipper は不変リストの左右で双方向移動を表現します。

循環リストの実装は、言語のデータ表現に合わせて選ぶ必要があります。この Flix 版では循環ポインタを構築せず、回転処理を循環的な順序の例として示しました。実際の循環双方向リンクの更新とは異なる点を理解し、要求される操作に適した表現を選んでください。

次章では木構造を扱い、再帰 enum で二分探索木を表現して、挿入・探索・削除の不変条件を確認します。
