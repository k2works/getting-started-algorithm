# 第 3 章 探索アルゴリズム

## 3.1 はじめに

第 2 章では配列を走査・更新する方法を学びました。この章では、データの中から指定したキーを見つける探索アルゴリズムを実装します。線形探索と番兵法、二分探索、ハッシュ法（チェイン法）を比較します。

探索結果は `Option[Int32]` や `Option[String]` で表します。見つかった場合は `Some(value)`、見つからなかった場合は `None` です。`-1` のような番兵値と違い、配列の正当なインデックスと失敗を型で区別できます。

### この章の TODO リスト

- [x] 線形探索で最初に一致するインデックスを返す
- [x] 番兵法で線形探索し、入力を変更しない
- [x] 整列済み配列を二分探索する
- [x] チェイン法のハッシュテーブルを作る
- [x] ハッシュテーブルで追加・検索・削除を行う
- [x] 空入力、未発見、重複、衝突をテストする

## 3.2 探索アルゴリズムとは

探索は、コレクション内からキーと一致する要素を見つけ、その位置や関連する値を返す処理です。アルゴリズムを選ぶときは、データが整列済みか、追加・削除があるか、同じデータを何度検索するかを考えます。

Flix 版の関数とテストは `src/Search.flix` と `test/TestSearch.flix` に置きます。Flix 0.75.1 の配列 API に合わせ、`Array.get` で要素を読み取ります。更新するハッシュテーブルは `Array.put` を使い、関数の型に配列領域の効果 `\ r` を示します。

## 3.3 線形探索

線形探索は先頭から順に調べる、もっとも単純な探索方法です。配列が整列されている必要はなく、同じキーが複数ある場合は最初の位置を返します。

### Red — 成功・失敗・空配列を書く

`test/TestSearch.flix` にテストを追加します。

```flix
@Test
def linearSearch_found(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 6 :: 4 :: 3 :: 2 :: 1 :: 2 :: 8 :: Nil);
        Assert.assertEq(expected = Some(3), Search.linearSearch(values, 2))
    }

@Test
def linearSearch_empty(): Unit \ Assert =
    region rc {
        let values = Array.repeat(rc, 0, 0);
        Assert.assertEq(expected = None, Search.linearSearch(values, 2))
    }

@Test
def linearSearch_not_found(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 1 :: 2 :: 3 :: Nil);
        Assert.assertEq(expected = None, Search.linearSearch(values, 99))
    }
```

### Green — 先頭から走査する

`src/Search.flix` に実装します。

```flix
pub def linearSearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
    let length = Array.length(values);
    def loop(i) =
        if (i >= length)
            None
        else if (Array.get(i, values) == key)
            Some(i)
        else
            loop(i + 1);
    loop(0)
```

添字 `i` は 0 から配列長未満の範囲だけを参照します。各要素は最大 1 回比較されるため、最良時間は O(1)、最悪時間と平均時間は O(n) です。追加領域は O(1) です。末尾再帰で次の添字に進みます。

## 3.4 番兵法

線形探索では、各反復で「配列の末尾に達したか」と「キーに一致したか」の 2 条件を調べます。番兵法では探索キーを配列の末尾に置き、ループ内の終了条件を一致判定 1 つにします。

Flix の配列は更新可能ですが、入力配列に番兵を追加してしまうと呼び出し側のデータが変わります。この実装では、入力の値をコピーし、コピーの末尾に番兵を置きます。

### Red — 入力を変更しないこともテストする

```flix
@Test
def sentinelSearch_found(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 6 :: 4 :: 3 :: 2 :: 1 :: Nil);
        Assert.assertEq(expected = Some(3), Search.sentinelSearch(values, 2))
    }

@Test
def sentinelSearch_does_not_change_input(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 1 :: 2 :: 3 :: Nil);
        let result = Search.sentinelSearch(values, 9);
        Assert.assertEq(expected = None, result);
        Assert.assertEq(expected = 3, Array.length(values))
    }
```

### Green — コピーの末尾に番兵を置く

```flix
pub def sentinelSearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
    let length = Array.length(values);
    region rc {
        let extended = Array.init(rc, i -> if (i == length) key else Array.get(i, values), length + 1);
        def loop(i) =
            if (Array.get(i, extended) == key)
                if (i == length) None else Some(i)
            else
                loop(i + 1);
        loop(0)
    }
```

番兵によってループ中の配列長チェックを省けます。ただし、この安全な実装では入力をコピーするため、コピーだけで O(n) 時間・O(n) 領域が必要です。探索自体も O(n) なので、一般的な Flix コードで常に線形探索より速いとは限りません。番兵法の主な学習点は終了条件の簡略化と、番兵を追加する副作用の扱いです。

## 3.5 二分探索

二分探索は中央の値とキーを比較して、探索範囲を半分ずつ狭めます。**配列が昇順に整列されていること** が前提条件です。未整列データに適用すると正しい結果を保証できません。

### Red — 範囲の端・未発見・重複をテストする

```flix
@Test
def binarySearch_found(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
        Assert.assertEq(expected = Some(3), Search.binarySearch(values, 5))
    }

@Test
def binarySearch_not_found(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 1 :: 2 :: 3 :: 5 :: 7 :: 8 :: 9 :: Nil);
        Assert.assertEq(expected = None, Search.binarySearch(values, 4))
    }

@Test
def binarySearch_duplicate_returns_first(): Unit \ Assert =
    region rc {
        let values = List.toArray(rc, 1 :: 2 :: 2 :: 2 :: 3 :: Nil);
        Assert.assertEq(expected = Some(1), Search.binarySearch(values, 2))
    }
```

### Green — 下限位置を探す

```flix
pub def binarySearch(values: Array[Int32, r], key: Int32): Option[Int32] \ r =
    let length = Array.length(values);
    def lowerBound(left, right) =
        if (left >= right)
            left
        else {
            let middle = left + (right - left) / 2;
            if (Array.get(middle, values) < key)
                lowerBound(middle + 1, right)
            else
                lowerBound(left, middle)
        };
    let index = lowerBound(0, length);
    if (index < length and Array.get(index, values) == key)
        Some(index)
    else
        None
```

探索範囲は半開区間 `[left, right)` です。中央の値がキーより小さければ左端を `middle + 1` にし、それ以外は右端を `middle` にします。範囲が空になると `left` がキー以上となる最初の位置（lower bound）です。その位置の値を確認し、キーと一致すれば返します。この方法では重複値があっても最初のインデックスを返します。

各反復で範囲がほぼ半分になるため、時間計算量は O(log n)、追加領域は O(1) です。n が 1,000,000 なら、探索範囲を狭める回数は約 20 回です。空配列では `left` と `right` がともに 0 なので、範囲外アクセスは発生しません。

## 3.6 ハッシュ法 — チェイン法

ハッシュ法はキーからバケット番号を計算し、その位置からデータを探します。異なるキーが同じバケット番号になることを**衝突**と呼びます。チェイン法では、各バケットにキーと値のリストを持ち、衝突した要素を同じリストで管理します。

この教材では整数キーと文字列値に範囲を限定し、バケット配列の各要素を `List[(Int32, String)]` とします。Flix の標準 `Map` ではなくハッシュテーブルを自分で実装することで、ハッシュ値、衝突、チェインの動作を確かめます。

### Red — 衝突・重複・削除をテストする

容量 13 のテーブルでは、キー 1 と 14 はどちらもバケット 1 に割り当てられます。

```flix
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
```

### Green — バケットとチェインを操作する

負のキーにも有効な配列添字を返すよう、余りが負なら容量を加えます。容量が 0 以下の場合は `None` を返し、剰余演算を行いません。

```flix
pub def hashIndex(key: Int32, capacity: Int32): Option[Int32] =
    if (capacity <= 0)
        None
    else {
        let remainder = key `Int32.remainder` capacity;
        Some(if (remainder < 0) remainder + capacity else remainder)
    }
```

テーブルは `Array.init` で空リストのバケットを作ります。

```flix
pub def newHashTable(rc: Region[r], capacity: Int32): Array[List[(Int32, String)], r] \ r =
    Array.init(rc, _ -> Nil, if (capacity < 0) 0 else capacity)
```

検索では該当バケットのリストを走査します。追加時に同じキーが見つかれば `false` を返し、そうでなければ該当リストの先頭へ追加します。削除では一致した要素だけを取り除き、衝突チェインの残りを維持します。

```flix
pub def hashSearch(key: Int32, buckets: Array[List[(Int32, String)], r]): Option[String] \ r =
    match hashIndex(key, Array.length(buckets)) {
        case None => None
        case Some(index) =>
            let entries = Array.get(index, buckets);
            def find(xs) = match xs {
                case Nil => None
                case (entryKey, value) :: rest =>
                    if (entryKey == key) Some(value) else find(rest)
            };
            find(entries)
    }

pub def hashAdd(key: Int32, value: String, buckets: Array[List[(Int32, String)], r]): Bool \ r =
    match hashIndex(key, Array.length(buckets)) {
        case None => false
        case Some(index) =>
            match hashSearch(key, buckets) {
                case Some(_) => false
                case None =>
                    let entries = Array.get(index, buckets);
                    Array.put((key, value) :: entries, index, buckets);
                    true
            }
    }

pub def hashRemove(key: Int32, buckets: Array[List[(Int32, String)], r]): Bool \ r =
    match hashIndex(key, Array.length(buckets)) {
        case None => false
        case Some(index) =>
            let entries = Array.get(index, buckets);
            def remove(xs) = match xs {
                case Nil => None
                case (entryKey, value) :: rest =>
                    if (entryKey == key)
                        Some(rest)
                    else
                        match remove(rest) {
                            case None => None
                            case Some(updated) => Some((entryKey, value) :: updated)
                        }
            };
            match remove(entries) {
                case None => false
                case Some(updated) =>
                    Array.put(updated, index, buckets);
                    true
            }
    }
```

`hashRemove` は該当バケットを再帰的に調べ、見つけたキーを取り除いたリストを `Array.put` で戻します。削除対象がチェインの先頭、中間、末尾のいずれでも、ほかのキーは残ります。テーブル変更の効果は `\ r` として型に現れます。

平均的に各バケットのチェインが短ければ、検索・追加・削除は O(1) です。要素数を m、バケット数を capacity とすると、負荷率は `α = m / capacity` であり、平均時間は O(1 + α) と表せます。すべてのキーが同じバケットへ衝突する最悪の場合は O(m) です。チェイン法は衝突をなくすのではなく、同じ位置に複数の要素を保持して正しく扱います。

## 3.7 テストとアルゴリズムの比較

```bash
make test
make check
make format-check
```

| アルゴリズム | 前提条件 | 平均時間 | 最悪時間 | 追加領域 |
|---|---|---:|---:|---:|
| 線形探索 | なし | O(n) | O(n) | O(1) |
| 番兵法（入力コピーあり） | なし | O(n) | O(n) | O(n) |
| 二分探索 | 昇順に整列済み | O(log n) | O(log n) | O(1) |
| チェイン法ハッシュ検索 | テーブル作成済み | O(1 + α) | O(m) | O(m) |

同じデータを何度も検索し、更新も必要ならハッシュテーブルが適しています。一度だけ小さな未整列配列を調べるなら、前処理のない線形探索が単純です。配列をソート済みに保てる場合は、二分探索で検索時間を抑えられます。

## 3.8 まとめ

この章では、配列の先頭から探す線形探索、終了判定を簡略化する番兵法、整列済みデータの探索範囲を半分ずつ狭める二分探索、衝突をチェインで処理するハッシュ法を実装しました。見つからない結果は `None`、見つかった結果は `Some` とし、空配列・重複キー・負のキー・ハッシュ衝突もテストしました。

特に二分探索では、昇順という前提と半開区間の境界条件が正しさを支えています。ハッシュ法では、平均的な速さだけでなく負荷率と衝突時の最悪計算量も考慮します。

次章では、`List` とパターンマッチを使ってスタックとキューを実装し、LIFO と FIFO の違いをテストします。
