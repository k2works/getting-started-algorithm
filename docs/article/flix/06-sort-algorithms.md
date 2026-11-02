# 第 6 章 ソートアルゴリズム

## 6.1 はじめに

第 5 章では再帰とバックトラッキングを学びました。この章では、データを昇順に並べ替える 5 つのソートアルゴリズムを TDD で実装し、計算量、安定性、追加領域を比較します。

バブルソート、選択ソート、挿入ソート、マージソートは Flix の更新可能な配列 `Array[Int32, r]` を使い、入力を in-place で変更します。一方、クイックソートは不変な `List[Int32]` を受け取り、ソート済みの新しいリストを返します。アルゴリズムの考え方だけでなく、データ構造と入力変更の契約もテストで確認します。

### この章の TODO リスト

- [x] 隣接要素を比較するバブルソートを実装する
- [x] 未整列部分の最小値を選ぶ選択ソートを実装する
- [x] 整列済み部分へ値を挿入する挿入ソートを実装する
- [x] 分割統治によるクイックソートを不変リストで実装する
- [x] 補助配列を使う安定なマージソートを実装する
- [x] 空・単一要素・整列済み・逆順・重複値をテストする
- [x] in-place 更新と不変リストの契約、計算量を比較する

## 6.2 配列の準備とテストの観点

配列のソート関数は、テスト内で `List.toArray` を使って入力を作ります。`Array.toList` に変換すると、期待する結果を不変リストで比較できます。

```flix
region rc {
    let values = List.toArray(rc, 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil);
    Sort.bubbleSort(values);
    Assert.assertEq(
        expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil,
        Array.toList(values)
    )
}
```

各アルゴリズムで通常の入力に加え、空配列、要素 1 個、整列済み、逆順、重複値を確認します。配列版は呼び出し後に同じ配列を読み直し、不変リスト版は返された値と元のリストを別々に確認します。

## 6.3 バブルソート

隣り合う要素を比較し、左が大きければ交換します。右端から左へ走査するため、各パスで未整列部分の最小値が先頭へ移動します。

### Red — 並べ替えと境界値をテストする

```flix
@Test
def bubbleSort_sorts_values(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 6 :: 4 :: 3 :: 7 :: 1 :: 9 :: 8 :: Nil);
        Sort.bubbleSort(values);
        Assert.assertEq(
            expected = 1 :: 3 :: 4 :: 6 :: 7 :: 8 :: 9 :: Nil,
            Array.toList(values)
        )
    }
```

### Green — 隣接要素を比較して交換する

```flix
pub def bubbleSort(values: Array[Int32, r]): Unit \ r =
    let length = Array.length(values);

    def pass(i) =
        if (i >= length - 1) {
            ()
        } else {
            def compare(j, swapped) =
                if (j <= i) {
                    if (swapped) pass(i + 1) else ()
                } else {
                    let left = Array.get(j - 1, values);
                    let right = Array.get(j, values);
                    if (left > right) {
                        Array.put(right, j - 1, values);
                        Array.put(left, j, values);
                        compare(j - 1, true)
                    } else {
                        compare(j - 1, swapped)
                    }
                };
            compare(length - 1, false)
        };

    pass(0)
```

`swapped` が `false` のままパスを終えた場合、配列は既に整列済みなので次のパスを省きます。比較条件は `>` なので、同じ値どうしを交換せず、バブルソートは安定です。最悪時間は O(n²)、整列済み入力は早期終了により O(n)、追加領域は O(1) です。

## 6.4 選択ソート

未整列部分から最小値の位置を探し、その部分の先頭と交換します。交換回数は少なくできますが、整列済み入力でも未整列部分を毎回走査します。

```flix
pub def selectionSort(values: Array[Int32, r]): Unit \ r =
    let length = Array.length(values);

    def selectionPass(i) =
        if (i >= length - 1) {
            ()
        } else {
            def findMinimum(j, minimumIndex) =
                if (j >= length) {
                    minimumIndex
                } else if (Array.get(j, values) < Array.get(minimumIndex, values)) {
                    findMinimum(j + 1, j)
                } else {
                    findMinimum(j + 1, minimumIndex)
                };

            let minimumIndex = findMinimum(i + 1, i);
            if (minimumIndex != i) {
                let current = Array.get(i, values);
                let minimum = Array.get(minimumIndex, values);
                Array.put(minimum, i, values);
                Array.put(current, minimumIndex, values)
            };
            selectionPass(i + 1)
        };

    selectionPass(0)
```

各パスで未整列部分の最小値を選ぶため、比較回数は入力の並びにかかわらず O(n²) です。離れた位置の要素を交換することで同値要素の順序が変わる場合があるため、選択ソートは一般に不安定です。追加領域は O(1) です。

## 6.5 挿入ソート

先頭側を整列済みの部分として保ち、次の値を適切な位置へ挿入します。値より大きい要素を右へずらし、空いた位置に値を入れます。

```flix
pub def insertionSort(values: Array[Int32, r]): Unit \ r =
    let length = Array.length(values);

    def insert(i) =
        if (i >= length) {
            ()
        } else {
            let value = Array.get(i, values);
            def shift(j) =
                if (j <= 0) {
                    j
                } else {
                    let previous = Array.get(j - 1, values);
                    if (previous > value) {
                        Array.put(previous, j, values);
                        shift(j - 1)
                    } else {
                        j
                    }
                };
            let position = shift(i);
            Array.put(value, position, values);
            insert(i + 1)
        };

    insert(1)
```

既に整列済みなら各値は 1 回の比較で位置が決まるため O(n) です。逆順では各値を先頭までずらすため O(n²) です。比較条件に `>` を使い、同じ値を追い越さないので安定です。追加領域は O(1) です。

## 6.6 クイックソート

クイックソートは、基準値（pivot）より小さい値と、それ以外の値に分け、分割した部分を再帰的にソートします。Flix 版では不変リストを使い、入力を変更せず、新しいリストを返します。

```flix
pub def quickSort(values: List[Int32]): List[Int32] =
    def append(xs, ys) = match xs {
        case Nil => ys
        case head :: tail => head :: append(tail, ys)
    };

    def partition(xs, pivot, less, greater) = match xs {
        case Nil => (less, greater)
        case head :: tail =>
            if (head < pivot) {
                partition(tail, pivot, head :: less, greater)
            } else {
                partition(tail, pivot, less, head :: greater)
            }
    };

    def sort(xs) = match xs {
        case Nil => Nil
        case pivot :: tail =>
            let (less, greater) = partition(tail, pivot, Nil, Nil);
            append(sort(less), pivot :: sort(greater))
    };

    sort(values)
```

この実装はリストの先頭を pivot にします。分割が均等なら平均時間は O(n log n) ですが、整列済みなどで片側に偏ると最悪 O(n²) です。最初の要素を pivot に選ぶこの実装では、整列済み入力が偏った分割になる点に注意してください。再帰深さは平均 O(log n)、最悪 O(n) です。`partition` は各再帰段で新しいリストを作るため、in-place 版と同じ O(log n) の追加領域ではありません。最悪ケースでは O(n²) 個のリスト要素を累計して作ることがあります。

同じ値は `greater` 側に分けられます。`Int32` だけを扱うため同値要素の順序を観察できませんが、一般のレコードへ拡張した場合に安定性が保証される実装ではありません。

## 6.7 マージソート

マージソートは配列を半分ずつに分割してソートし、整列済みの 2 つの範囲を小さい順に結合します。結合時に左側の値が右側以下なら左を先に選ぶことで、同値の相対順序を保ちます。

```flix
pub def mergeSort(values: Array[Int32, r]): Unit \ r =
    let length = Array.length(values);
    region rc {
        let scratch = Array.repeat(rc, length, 0);

        def sort(low, high) =
            if (low >= high) {
                ()
            } else {
                let middle = low + (high - low) / 2;
                sort(low, middle);
                sort(middle + 1, high);

                def merge(left, right, output) =
                    if (output > high) {
                        ()
                    } else if (left > middle) {
                        Array.put(Array.get(right, values), output, scratch);
                        merge(left, right + 1, output + 1)
                    } else if (right > high) {
                        Array.put(Array.get(left, values), output, scratch);
                        merge(left + 1, right, output + 1)
                    } else {
                        let leftValue = Array.get(left, values);
                        let rightValue = Array.get(right, values);
                        if (leftValue <= rightValue) {
                            Array.put(leftValue, output, scratch);
                            merge(left + 1, right, output + 1)
                        } else {
                            Array.put(rightValue, output, scratch);
                            merge(left, right + 1, output + 1)
                        }
                    };

                def copyBack(i) =
                    if (i > high) {
                        ()
                    } else {
                        Array.put(Array.get(i, scratch), i, values);
                        copyBack(i + 1)
                    };

                merge(low, middle + 1, low);
                copyBack(low)
            };

        sort(0, length - 1)
    }
```

再帰で分割する深さは O(log n) で、各段で全要素をマージするため時間計算量は O(n log n) です。領域効果 `\ r` を持つ入力配列を更新しつつ、`region rc` の補助配列をローカルに確保します。補助配列は O(n)、再帰スタックは O(log n) です。

## 6.8 テストと計算量の比較

```bash
make test
make check
make format-check
```

`test/TestSort.flix` では、配列版の in-place 更新、空・単一要素、整列済み・逆順、重複値を確認します。クイックソートでは戻り値が整列済みであることと、元の不変リストが保持されることを確認します。

| アルゴリズム | 最良時間 | 平均時間 | 最悪時間 | 追加領域・再帰スタック | 安定 |
|---|---:|---:|---:|---|:---:|
| バブルソート（早期終了） | O(n) | O(n²) | O(n²) | O(1) | はい |
| 選択ソート | O(n²) | O(n²) | O(n²) | O(1) | いいえ |
| 挿入ソート | O(n) | O(n²) | O(n²) | O(1) | はい |
| クイックソート（先頭 pivot・不変リスト） | O(n log n) | O(n log n) | O(n²) | 再帰 O(log n) 平均、O(n) 最悪。最悪時のリスト累計生成 O(n²) | 保証しない |
| マージソート | O(n log n) | O(n log n) | O(n log n) | 補助配列 O(n)、スタック O(log n) | はい |

安定性とは、ソートキーが同じ要素どうしの元の順序が保たれる性質です。この章の実装は `Int32` のみをソートするため、同じ値を持つ異なるレコードで安定性を直接観察するテストはありません。配列版と不変リスト版の違いは API の型と入力を読み直すテストで確認します。

## 6.9 まとめ

バブルソートと挿入ソートは、整列済み入力を早く処理できる一方、逆順では O(n²) になります。選択ソートは比較回数が常に O(n²) ですが、交換は各パスで高々 1 回です。クイックソートは平均 O(n log n) でも pivot の選び方で最悪 O(n²) になり、この Flix 版はさらに不変リストの生成コストを持ちます。マージソートは常に O(n log n) で安定ですが、補助配列に O(n) の領域が必要です。

Flix では、配列を更新するアルゴリズムには `Array[Int32, r]` と領域効果を使い、不変なクイックソートには `List[Int32]` を使いました。アルゴリズムの計算量だけでなく、データ構造と変更契約を含めて比較することが重要です。

次章では文字列処理を扱い、文字列のインデックスと文字単位の処理を確認します。
