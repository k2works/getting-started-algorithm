# 第 6 章 ソートアルゴリズム

## はじめに

前章では再帰アルゴリズムを学びました。この章では、データを特定の順序に並べ替える「ソートアルゴリズム」を TDD で実装します。

ソートは、コンピュータサイエンスにおける最も基本的かつ重要な操作の一つです。データが整列されていると、検索や他の操作が効率的に行えるようになります。様々なソートアルゴリズムが存在し、それぞれに長所と短所があります。

この章では、テスト駆動開発の手法を用いて、基本的なソートアルゴリズムから高度なものまで、様々なソート手法を実装していきます。

### 目次

1. [ソートとは](#ソートとは)
2. [バブルソート](#1-バブルソート)
3. [選択ソート](#2-選択ソート)
4. [挿入ソート](#3-挿入ソート)
5. [シェルソート](#4-シェルソート)
6. [クイックソート](#5-クイックソート)
7. [マージソート](#6-マージソート)
8. [ヒープソート](#7-ヒープソート)
9. [度数ソート](#8-度数ソート)

---

## ソートとは

ソートとは、データを特定の順序（通常は昇順または降順）に並べ替える操作です。ソートアルゴリズムは、以下のような特性によって評価されます：

- **時間計算量**: アルゴリズムの実行に必要な時間
- **空間計算量**: アルゴリズムが使用するメモリ量
- **安定性**: 同じ値を持つ要素の相対的な順序が保存されるか
- **適応性**: 既にある程度ソートされているデータに対する効率性

それでは、具体的なソートアルゴリズムを見ていきましょう。

---

## 1. バブルソート

隣接する要素を比較・交換し、最大値を末尾へ「浮き上がらせる」アルゴリズムです。

### Red — 失敗するテストを書く

```python
# tests/test_sort.py
class TestBubbleSort:
    def test_bubble_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        bubble_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]

    def test_already_sorted(self):
        a = [1, 3, 4, 6, 7, 8, 9]
        bubble_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
# src/algorithm/sort.py
def bubble_sort(a: list) -> None:
    """バブルソート（in-place）"""
    n = len(a)
    for i in range(n - 1):
        swapped = False
        for j in range(n - 1, i, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                swapped = True
        if not swapped:
            break  # 交換なし → 整列完了
```

### フローチャート

```plantuml
@startuml
title バブルソート (bubble_sort)

start
:入力: 配列 a;
:n = len(a);

repeat :i = 0 から n-2 まで;
  repeat :j = n-1 から i+1 まで（逆順）;
    if (a[j-1] > a[j]) then (はい)
      :a[j-1]とa[j]を交換;
    endif
  repeat while (j > i+1)
repeat while (i < n-2)

:出力: ソート済み配列 a;
stop
@enduml
```

この図は、バブルソート（単純交換ソート）のアルゴリズムのフローチャートです。

アルゴリズムの流れ：
1. 配列 a を入力として受け取ります
2. 変数 n に配列の長さを代入します
3. 0 から n-2 までの各インデックス i について、以下の処理を繰り返します：
   - n-1 から i+1 までの各インデックス j について（逆順に）、以下の処理を繰り返します：
     - a[j-1] が a[j] より大きい場合、a[j-1] と a[j] を交換します
4. ソート済みの配列 a を出力します

各パスが終わるごとに、最大の要素が配列の末尾に移動します。そのため、i 回目のパスでは、配列の末尾の i 個の要素は既にソート済みとなり、次のパスでは考慮する必要がありません。

### バブルソートの最適化

バブルソートは、以下のような最適化が可能です：

#### 交換回数による打ち切り

ある走査で交換が一度も行われなければ、配列は既にソート済みであるため、処理を終了できます。

```python
def bubble_sort2(a: list) -> None:
    """単純交換ソート（第2版：交換回数による打ち切り）"""
    n = len(a)
    for i in range(n - 1):
        exchng = 0  # パスにおける交換回数
        for j in range(n - 1, i, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                exchng += 1
        if exchng == 0:  # 交換が行われなければ終了
            break
```

#### 走査範囲の限定

各走査で、最後に交換が行われた位置より先は既にソート済みであるため、次の走査ではその位置までしか見る必要がありません。

```python
def bubble_sort3(a: list) -> None:
    """単純交換ソート（第3版：走査範囲の限定）"""
    n = len(a)
    k = 0
    while k < n - 1:
        last = n - 1
        for j in range(n - 1, k, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                last = j
        k = last
```

### シェーカーソート

シェーカーソート（双方向バブルソート）は、バブルソートの変種で、走査を交互に上向きと下向きに行います。これにより、小さな値が先頭に、大きな値が末尾に同時に移動します。

```python
def shaker_sort(a: list) -> None:
    """シェーカーソート（双方向バブルソート）"""
    left = 0
    right = len(a) - 1
    last = right
    while left < right:
        # 下向きの走査
        for j in range(right, left, -1):
            if a[j - 1] > a[j]:
                a[j - 1], a[j] = a[j], a[j - 1]
                last = j
        left = last

        # 上向きの走査
        for j in range(left, right):
            if a[j] > a[j + 1]:
                a[j], a[j + 1] = a[j + 1], a[j]
                last = j
        right = last
```

### 解説

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合、最適化版）

バブルソートは単純で理解しやすいですが、大きなデータセットに対しては非効率です。しかし、データがほぼソート済みの場合は、最適化版が効率的に動作します。

---

## 2. 選択ソート

未整列部分の最小値を探し、先頭と交換するアルゴリズムです。

### Red — 失敗するテストを書く

```python
class TestSelectSort:
    def test_selection_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        selection_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
def selection_sort(a: list) -> None:
    """選択ソート（in-place）"""
    n = len(a)
    for i in range(n - 1):
        min_idx = i
        for j in range(i + 1, n):
            if a[j] < a[min_idx]:
                min_idx = j
        if min_idx != i:
            a[i], a[min_idx] = a[min_idx], a[i]
```

### フローチャート

```plantuml
@startuml
title 選択ソート (selection_sort)

start
:入力: 配列 a;
:n = len(a);

repeat :i = 0 から n-2 まで;
  :min = i;
  note right
    未ソート部分の最小要素の添字
  end note

  repeat :j = i+1 から n-1 まで;
    if (a[j] < a[min]) then (はい)
      :min = j;
    endif
  repeat while (j < n-1)

  :a[i]とa[min]を交換;
  note right
    未ソート部分の先頭要素と最小要素を交換
  end note
repeat while (i < n-2)

:出力: ソート済み配列 a;
stop
@enduml
```

この図は、選択ソート（単純選択ソート）のアルゴリズムのフローチャートです。

アルゴリズムの流れ：
1. 配列 a を入力として受け取ります
2. 変数 n に配列の長さを代入します
3. 0 から n-2 までの各インデックス i について、以下の処理を繰り返します：
   - min を i に初期化します（未ソート部分の最小要素の添字）
   - i+1 から n-1 までの各インデックス j について、以下の処理を繰り返します：
     - a[j] が a[min] より小さい場合、min を j に更新します
   - a[i] と a[min] を交換します（未ソート部分の先頭要素と最小要素を交換）
4. ソート済みの配列 a を出力します

バブルソートと比較すると、選択ソートは交換回数が少ないという利点があります。具体的には、各パスで最大でも1回の交換しか行われません。

### 解説

**計算量**: 常に O(n²)（整列済みでも改善されない）

選択ソートは、バブルソートと同様に単純ですが、交換回数が少ないという利点があります。具体的には、各パスで最大でも1回の交換しか行われません。しかし、大きなデータセットに対しては依然として非効率です。

---

## 3. 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入するアルゴリズムです。トランプのカードを手に持って並べ替える操作に似ています。

### Red — 失敗するテストを書く

```python
class TestInsertSort:
    def test_insertion_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        insertion_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
def insertion_sort(a: list) -> None:
    """挿入ソート（in-place）"""
    n = len(a)
    for i in range(1, n):
        key = a[i]
        j = i - 1
        while j >= 0 and a[j] > key:
            a[j + 1] = a[j]
            j -= 1
        a[j + 1] = key
```

### フローチャート

```plantuml
@startuml
title 挿入ソート (insertion_sort)

start
:入力: 配列 a;
:n = len(a);

repeat :i = 1 から n-1 まで;
  :j = i;
  :tmp = a[i];
  note right
    挿入する要素を退避
  end note

  while (j > 0 && a[j-1] > tmp) is (はい)
    :a[j] = a[j-1];
    note right
      要素を後方にずらす
    end note
    :j -= 1;
  endwhile (いいえ)

  :a[j] = tmp;
  note right
    退避した要素を挿入
  end note
repeat while (i < n-1)

:出力: ソート済み配列 a;
stop
@enduml
```

この図は、挿入ソート（単純挿入ソート）のアルゴリズムのフローチャートです。

アルゴリズムの流れ：
1. 配列 a を入力として受け取ります
2. 変数 n に配列の長さを代入します
3. 1 から n-1 までの各インデックス i について、以下の処理を繰り返します：
   - j を i に初期化します
   - tmp に a[i] を代入します（挿入する要素を退避）
   - j が 0 より大きく、かつ a[j-1] が tmp より大きい間、以下の処理を繰り返します：
     - a[j] に a[j-1] を代入します（要素を後方にずらす）
     - j を 1 減らします
   - a[j] に tmp を代入します（退避した要素を挿入）
4. ソート済みの配列 a を出力します

### 二分挿入ソート

挿入ソートの改良版として、二分探索を使って挿入位置を効率的に見つける「二分挿入ソート」があります：

```python
def binary_insertion_sort(a: list) -> None:
    """二分挿入ソート"""
    n = len(a)
    for i in range(1, n):
        key = a[i]
        pl = 0       # 探索範囲の先頭要素の添字
        pr = i - 1   # 探索範囲の末尾要素の添字

        # 二分探索で挿入位置を見つける
        while True:
            pc = (pl + pr) // 2  # 探索範囲の中央要素の添字
            if a[pc] == key:     # 探索成功
                break
            elif a[pc] < key:
                pl = pc + 1
            else:
                pr = pc - 1
            if pl > pr:
                break

        # 挿入すべき位置の添字
        pd = pc + 1 if pl <= pr else pr + 1

        # 要素を後方にずらす
        for j in range(i, pd, -1):
            a[j] = a[j - 1]

        a[pd] = key  # 退避した要素を挿入
```

Python の標準ライブラリ `bisect` を使うと、より簡潔に実装できます：

```python
import bisect

def binary_insertion_sort2(a: list) -> None:
    """二分挿入ソート（bisect.insort を利用）"""
    for i in range(1, len(a)):
        bisect.insort(a, a.pop(i), 0, i)
```

### 解説

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合）

挿入ソートは、小さなデータセットや、ほぼソート済みのデータに対して効率的です。また、安定なソートアルゴリズムであり、オンラインアルゴリズム（データが逐次的に到着する場合に適用可能）としても使用できます。

二分挿入ソートは、挿入位置の探索を効率化しますが、要素の移動コストは変わらないため、全体の時間計算量は依然として O(n²) です。

---

## 4. シェルソート

挿入ソートの改良版。間隔（gap）を縮小しながら複数回の挿入ソートを行います。離れた要素同士を先に比較・交換することで、大きな値を素早く後方に、小さな値を素早く前方に移動させることができます。

### Red — 失敗するテストを書く

```python
class TestShellSort:
    def test_shell_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        shell_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
def shell_sort(a: list) -> None:
    """シェルソート（Knuth 数列使用）"""
    n = len(a)
    gap = 1
    while gap * 3 + 1 < n:
        gap = gap * 3 + 1  # 1, 4, 13, 40, ...

    while gap > 0:
        for i in range(gap, n):
            key = a[i]
            j = i - gap
            while j >= 0 and a[j] > key:
                a[j + gap] = a[j]
                j -= gap
            a[j + gap] = key
        gap //= 3
```

### フローチャート

```plantuml
@startuml
title シェルソート (shell_sort)

start
:入力: 配列 a;
:n = len(a);
:h = n // 2;
note right
  初期間隔
end note

while (h > 0) is (はい)
  repeat :i = h から n-1 まで;
    :j = i - h;
    :tmp = a[i];

    while (j >= 0 && a[j] > tmp) is (はい)
      :a[j + h] = a[j];
      note right
        要素を後方にずらす
      end note
      :j -= h;
    endwhile (いいえ)

    :a[j + h] = tmp;
    note right
      退避した要素を挿入
    end note
  repeat while (i < n-1)

  :h //= 2;
  note right
    間隔を半分に
  end note
endwhile (いいえ)

:出力: ソート済み配列 a;
stop
@enduml
```

この図は、シェルソートのアルゴリズムのフローチャートです。

アルゴリズムの流れ：
1. 配列 a を入力として受け取ります
2. 変数 n に配列の長さを代入します
3. 変数 h に n//2 を代入します（初期間隔）
4. h が 0 より大きい間、以下の処理を繰り返します：
   - h から n-1 までの各インデックス i について、以下の処理を繰り返します：
     - j を i-h に初期化します
     - tmp に a[i] を代入します（挿入する要素を退避）
     - j が 0 以上、かつ a[j] が tmp より大きい間、以下の処理を繰り返します：
       - a[j+h] に a[j] を代入します（要素を後方にずらす）
       - j を h 減らします
     - a[j+h] に tmp を代入します（退避した要素を挿入）
   - h を半分にします（h //= 2）
5. ソート済みの配列 a を出力します

最初は大きな間隔で要素を比較し、徐々に間隔を小さくしていきます。最終的に間隔が 1 になると、通常の挿入ソートと同じ処理になりますが、その時点で配列はほぼソートされているため、効率的に動作します。

### シェルソートの改良

シェルソートの性能は、間隔の選び方に大きく依存します。以下は、より効率的な間隔列を使用した改良版です：

```python
def shell_sort2(a: list) -> None:
    """シェルソート（第2版：Knuth の間隔列）"""
    n = len(a)
    h = 1
    # 間隔の初期値を決定（Knuth の間隔列）
    while h < n // 9:
        h = h * 3 + 1

    while h > 0:
        for i in range(h, n):
            j = i - h
            tmp = a[i]
            while j >= 0 and a[j] > tmp:
                a[j + h] = a[j]
                j -= h
            a[j + h] = tmp
        h //= 3  # 間隔を 1/3 に
```

### 解説

**計算量**: O(n^(3/2)) ～ O(n log² n)（gap 数列に依存）

シェルソートの時間計算量は、間隔列の選び方によって異なります：
- 最良の場合：O(n log n)
- 最悪の場合：O(n²)（単純な間隔列の場合）
- 平均の場合：O(n^1.25)（Knuth の間隔列の場合）

シェルソートは、挿入ソートの欠点（小さな値が配列の後方にある場合の非効率性）を克服するために設計されました。

---

## 5. クイックソート

ピボットを基準に配列を 2 分割し、再帰的にソートします。「分割統治法」に基づく効率的なソートアルゴリズムで、実用的に最も高速なアルゴリズムの一つです。

### 分割手順

クイックソートの核心は、配列を枢軸を中心に分割する手順です：

```python
def partition(a: list) -> None:
    """配列を分割して表示"""
    n = len(a)
    pl = 0           # 左カーソル
    pr = n - 1       # 右カーソル
    x = a[n // 2]    # 枢軸（中央の要素）

    while pl <= pr:
        while a[pl] < x:
            pl += 1
        while a[pr] > x:
            pr -= 1
        if pl <= pr:
            a[pl], a[pr] = a[pr], a[pl]
            pl += 1
            pr -= 1
```

### Red — 失敗するテストを書く

```python
class TestQuickSort:
    def test_quick_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        quick_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]

    def test_large(self):
        import random
        a = list(range(200))
        random.shuffle(a)
        quick_sort(a)
        assert a == list(range(200))
```

### Green — テストを通す実装

```python
def quick_sort(a: list, left: int = 0, right: int | None = None) -> None:
    """クイックソート（in-place）"""
    if right is None:
        right = len(a) - 1

    if left >= right:
        return

    pivot = a[(left + right) // 2]
    i, j = left, right

    while i <= j:
        while a[i] < pivot:
            i += 1
        while a[j] > pivot:
            j -= 1
        if i <= j:
            a[i], a[j] = a[j], a[i]
            i += 1
            j -= 1

    quick_sort(a, left, j)
    quick_sort(a, i, right)
```

### フローチャート

```plantuml
@startuml
title クイックソート (qsort)

start
:入力: 配列 a, 左端 left, 右端 right;

:pl = left;
:pr = right;
:x = a[(left + right) // 2];
note right
  枢軸（中央の要素）
end note

while (pl <= pr) is (はい)
  while (a[pl] < x) is (はい)
    :pl += 1;
  endwhile (いいえ)

  while (a[pr] > x) is (はい)
    :pr -= 1;
  endwhile (いいえ)

  if (pl <= pr) then (はい)
    :a[pl]とa[pr]を交換;
    :pl += 1;
    :pr -= 1;
  endif
endwhile (いいえ)

if (left < pr) then (はい)
  :qsort(a, left, pr);
  note right
    左グループを再帰的にソート
  end note
endif

if (pl < right) then (はい)
  :qsort(a, pl, right);
  note right
    右グループを再帰的にソート
  end note
endif

stop
@enduml
```

この図は、クイックソートのアルゴリズム（qsort 関数）のフローチャートです。

アルゴリズムの流れ：
1. 配列 a、左端 left、右端 right を入力として受け取ります
2. 左カーソル pl を left に、右カーソル pr を right に初期化します
3. 枢軸 x を a[(left + right) // 2]（中央の要素）に設定します
4. pl が pr 以下である間、以下の処理を繰り返します：
   - a[pl] が x より小さい間、pl を 1 増やします
   - a[pr] が x より大きい間、pr を 1 減らします
   - pl が pr 以下の場合：
     - a[pl] と a[pr] を交換します
     - pl を 1 増やします
     - pr を 1 減らします
5. left が pr より小さい場合、左グループ（left から pr まで）を再帰的にソートします
6. pl が right より小さい場合、右グループ（pl から right まで）を再帰的にソートします

### 非再帰的クイックソート

再帰を使わずにスタックを用いて実装することもできます：

```python
def qsort_stack(a: list, left: int, right: int) -> None:
    """a[left]～a[right] をクイックソート（非再帰版）"""
    stack = [(left, right)]

    while stack:
        left, right = stack.pop()
        pl, pr = left, right
        x = a[(left + right) // 2]  # 枢軸（中央の要素）

        while pl <= pr:
            while a[pl] < x:
                pl += 1
            while a[pr] > x:
                pr -= 1
            if pl <= pr:
                a[pl], a[pr] = a[pr], a[pl]
                pl += 1
                pr -= 1

        if left < pr:
            stack.append((left, pr))   # 左グループのカーソルを保存
        if pl < right:
            stack.append((pl, right))  # 右グループのカーソルを保存
```

### 解説

**計算量**: 平均 O(n log n)、最悪 O(n²)

クイックソートは、平均的には非常に効率的なアルゴリズムですが、最悪の場合（例えば、既にソート済みの配列や、すべての要素が同じ値の配列）では効率が悪くなることがあります。また、不安定なソートアルゴリズムです。しかし、適切な枢軸選択や小さな配列に対する挿入ソートへの切り替えなどの最適化により、実用的には非常に高速に動作します。

---

## 6. マージソート

配列を半分に分割し、再帰的にソートして結合します。「分割統治法」に基づくもう一つの効率的なソートアルゴリズムです。

### ソート済み配列のマージ

マージソートの核心は、2 つのソート済み配列をマージする手順です：

```python
def merge_sorted_list(a: list, b: list, c: list) -> None:
    """ソート済み配列 a と b をマージして c に格納"""
    pa, pb, pc = 0, 0, 0
    na, nb = len(a), len(b)

    while pa < na and pb < nb:  # 小さいほうを格納
        if a[pa] <= b[pb]:
            c[pc] = a[pa]
            pa += 1
        else:
            c[pc] = b[pb]
            pb += 1
        pc += 1

    while pa < na:              # a に残った要素をコピー
        c[pc] = a[pa]
        pa += 1
        pc += 1

    while pb < nb:              # b に残った要素をコピー
        c[pc] = b[pb]
        pb += 1
        pc += 1
```

### Red — 失敗するテストを書く

```python
class TestMergeSort:
    def test_merge_sort(self):
        a = [5, 8, 4, 2, 6, 1, 3, 9, 7]
        merge_sort(a)
        assert a == [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
def merge_sort(a: list) -> list:
    """マージソート（新しいリストを返す）"""
    if len(a) <= 1:
        return a[:]

    mid = len(a) // 2
    left = merge_sort(a[:mid])
    right = merge_sort(a[mid:])
    return _merge(left, right)


def _merge(left: list, right: list) -> list:
    """2 つの整列済みリストをマージ"""
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
```

### フローチャート

```plantuml
@startuml
title マージソート (_merge_sort)

start
:入力: 配列 a, 左端 left, 右端 right;

if (left < right) then (はい)
  :center = (left + right) // 2;

  :_merge_sort(a, left, center);
  note right
    前半を再帰的にソート
  end note

  :_merge_sort(a, center + 1, right);
  note right
    後半を再帰的にソート
  end note

  :p = j = 0;
  :i = k = left;

  while (i <= center) is (はい)
    :buff[p] = a[i];
    :p += 1;
    :i += 1;
  endwhile (いいえ)

  while (i <= right && j < p) is (はい)
    if (buff[j] <= a[i]) then (はい)
      :a[k] = buff[j];
      :j += 1;
    else (いいえ)
      :a[k] = a[i];
      :i += 1;
    endif
    :k += 1;
  endwhile (いいえ)

  while (j < p) is (はい)
    :a[k] = buff[j];
    :k += 1;
    :j += 1;
  endwhile (いいえ)
endif

stop
@enduml
```

この図は、マージソートのアルゴリズムのフローチャートです。

アルゴリズムの流れ：
1. 配列 a、左端 left、右端 right を入力として受け取ります
2. left が right より小さい場合（ソートする要素が 2 つ以上ある場合）：
   - center を (left + right) // 2 に設定します（配列の中央位置）
   - 前半部分（left から center まで）を再帰的にソートします
   - 後半部分（center + 1 から right まで）を再帰的にソートします
   - 前半部分を作業用配列 buff にコピーします
   - 前半部分（buff に格納）と後半部分（a に格納）をマージします：
     - buff[j] と a[i] を比較し、小さい方を a[k] に格納します
     - 対応するインデックス（j または i）を 1 増やします
     - k を 1 増やします
   - buff に残った要素を a にコピーします

このアルゴリズムの特徴は、どのような入力に対しても安定した性能を発揮する点です。また、安定なソートアルゴリズムであるという利点もあります。ただし、追加のメモリ空間（作業用配列）が必要であるという欠点があります。

### 解説

**計算量**: 常に O(n log n)

マージソートは、どのような入力に対しても安定した性能を発揮する安定なソートアルゴリズムです。しかし、追加のメモリ空間（作業用配列）が必要であるという欠点があります。

---

---

## 7. ヒープソート

ヒープデータ構造を利用したソートアルゴリズムです。ヒープは、親ノードが子ノードよりも大きい（または小さい）という性質を持つ二分木です。

### Red — 失敗するテストを書く

```python
class TestHeapSort:
    def test_heap_sort(self):
        a = [6, 4, 3, 7, 1, 9, 8]
        heap_sort(a)
        assert a == [1, 3, 4, 6, 7, 8, 9]
```

### Green — テストを通す実装

```python
def heap_sort(a: list) -> None:
    """ヒープソート"""
    def down_heap(a: list, left: int, right: int) -> None:
        """a[left]～a[right] をヒープ化"""
        temp = a[left]  # 根

        parent = left
        while parent < (right + 1) // 2:
            cl = parent * 2 + 1  # 左の子
            cr = cl + 1          # 右の子
            child = cr if cr <= right and a[cr] > a[cl] else cl  # 大きいほう
            if temp >= a[child]:
                break
            a[parent] = a[child]
            parent = child
        a[parent] = temp

    n = len(a)

    # a[i]～a[n-1] をヒープ化
    for i in range((n - 1) // 2, -1, -1):
        down_heap(a, i, n - 1)

    # ヒープの最大要素と未ソート部末尾要素を交換
    for i in range(n - 1, 0, -1):
        a[0], a[i] = a[i], a[0]
        down_heap(a, 0, i - 1)
```

### 解説

**計算量**: 常に O(n log n)

ヒープソートは、どのような入力に対しても安定した性能を発揮し、追加のメモリ空間を必要としないという利点があります。しかし、不安定なソートアルゴリズムであり、キャッシュ効率が悪いという欠点もあります。

---

## 8. 度数ソート

度数ソート（カウンティングソート）は、要素の値の範囲が限られている場合に効率的なソートアルゴリズムです。各値の出現回数をカウントし、それに基づいてソートを行います。

### Red — 失敗するテストを書く

```python
class TestCountingSort:
    def test_counting_sort(self):
        x = [22, 5, 11, 32, 120, 68, 70]
        counting_sort(x)
        assert x == [5, 11, 22, 32, 68, 70, 120]
```

### Green — テストを通す実装

```python
def fsort(a: list, max_val: int) -> None:
    """度数ソート（配列要素の値は 0 以上 max_val 以下）"""
    n = len(a)
    f = [0] * (max_val + 1)  # 累積度数
    b = [0] * n              # 作業用目的配列

    for i in range(n):              # 各要素の度数をカウント
        f[a[i]] += 1

    for i in range(1, max_val + 1): # 累積度数を計算
        f[i] += f[i - 1]

    for i in range(n - 1, -1, -1):  # 各要素を作業用配列に格納
        f[a[i]] -= 1
        b[f[a[i]]] = a[i]

    for i in range(n):              # 作業用配列を a に移動
        a[i] = b[i]


def counting_sort(a: list) -> None:
    """度数ソート"""
    fsort(a, max(a))
```

### 解説

**計算量**: O(n + k)（n は要素数、k は値の範囲）

度数ソートは、値の範囲が小さい場合に非常に効率的ですが、値の範囲が大きい場合はメモリ使用量が増大するという欠点があります。また、浮動小数点数や文字列などの比較可能なデータ型には直接適用できません。

---

## テスト実行結果

```bash
$ uv run pytest tests/test_sort.py -v

...（27 テスト全パス）...

Name                    Stmts   Miss  Cover
-------------------------------------------
src/algorithm/sort.py      79      0   100%
-------------------------------------------
27 passed in 0.15s
```

カバレッジ 100% 達成しました。

---

## ソートアルゴリズムの比較

| アルゴリズム | 最良 | 平均 | 最悪 | 安定 | 備考 |
|-------------|------|------|------|------|------|
| バブルソート | O(n) | O(n²) | O(n²) | ✓ | 整列済み検出あり |
| 選択ソート | O(n²) | O(n²) | O(n²) | ✗ | 交換回数が少ない |
| 挿入ソート | O(n) | O(n²) | O(n²) | ✓ | 小規模データに有効 |
| シェルソート | O(n) | O(n^1.5) | O(n²) | ✗ | 挿入ソートの改良 |
| クイックソート | O(n log n) | O(n log n) | O(n²) | ✗ | 実用的に最速 |
| マージソート | O(n log n) | O(n log n) | O(n log n) | ✓ | 追加メモリが必要 |
| ヒープソート | O(n log n) | O(n log n) | O(n log n) | ✗ | 追加メモリ不要 |
| 度数ソート | O(n + k) | O(n + k) | O(n + k) | ✓ | 値の範囲が限定的な場合に有効 |

## まとめ

この章では、様々なソートアルゴリズムについて学びました：

1. **バブルソート** — 隣接する要素を比較・交換する単純なアルゴリズム
2. **選択ソート** — 未ソート部分から最小要素を選択するアルゴリズム
3. **挿入ソート** — ソート済み部分に要素を挿入するアルゴリズム
4. **シェルソート** — 挿入ソートを改良したアルゴリズム
5. **クイックソート** — 分割統治法に基づく高速なアルゴリズム
6. **マージソート** — 分割統治法に基づく安定なアルゴリズム
7. **ヒープソート** — ヒープデータ構造を利用するアルゴリズム
8. **度数ソート** — 要素の値の範囲が限られている場合に効率的なアルゴリズム

各アルゴリズムには長所と短所があり、データの特性や要件に応じて適切なアルゴリズムを選択することが重要です。

テスト駆動開発の手法を用いることで、これらの複雑なソートアルゴリズムの正確な実装と理解を深めることができました。

次の章では、文字列処理について学んでいきましょう。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
