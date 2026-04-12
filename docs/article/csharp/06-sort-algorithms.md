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

```csharp
// Algorithm.Tests/SortTest.cs
public class BubbleSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.BubbleSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }

    [Fact] public void 整列済み()
    {
        int[] a = [1, 3, 4, 6, 7, 8, 9];
        Sort.BubbleSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }
}
```

### Green — テストを通す実装

```csharp
// Algorithm/Sort.cs
namespace Algorithm;

/// <summary>第6章 ソートアルゴリズム</summary>
public static class Sort
{
    public static void BubbleSort(int[] a)
    {
        int n = a.Length;
        for (int i = 0; i < n - 1; i++)
        {
            bool swapped = false;
            for (int j = n - 1; j > i; j--)
                if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); swapped = true; }
            if (!swapped) break;  // 交換なし → 整列完了
        }
    }
}
```

### フローチャート

```plantuml
@startuml
title バブルソート (BubbleSort)

start
:入力: 配列 a;
:n = a.Length;

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

#### 走査範囲の限定

各走査で、最後に交換が行われた位置より先は既にソート済みです。次の走査ではその位置までしか見る必要がありません。

```csharp
// Algorithm.Tests/SortTest.cs
public class BubbleSort2Test
{
    [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.BubbleSort2(a); Assert.Equal([1,3,4,6,7,8,9], a); }
    [Fact] public void 整列済み() { int[] a = [1,3,4,6,7,8,9]; Sort.BubbleSort2(a); Assert.Equal([1,3,4,6,7,8,9], a); }
}
```

```csharp
// Algorithm/Sort.cs
public static void BubbleSort2(int[] a)
{
    int n = a.Length, k = 0;
    while (k < n - 1)
    {
        int last = n - 1;
        for (int j = n - 1; j > k; j--)
            if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); last = j; }
        k = last;
    }
}
```

### シェーカーソート

シェーカーソート（双方向バブルソート）は、走査を交互に下向き・上向きに行います。これにより、小さな値が先頭に、大きな値が末尾に同時に移動します。

```csharp
// Algorithm.Tests/SortTest.cs
public class ShakerSortTest
{
    [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.ShakerSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
}
```

```csharp
// Algorithm/Sort.cs
public static void ShakerSort(int[] a)
{
    int left = 0, right = a.Length - 1, last = right;
    while (left < right)
    {
        for (int j = right; j > left; j--)
            if (a[j - 1] > a[j]) { (a[j - 1], a[j]) = (a[j], a[j - 1]); last = j; }
        left = last;
        for (int j = left; j < right; j++)
            if (a[j] > a[j + 1]) { (a[j], a[j + 1]) = (a[j + 1], a[j]); last = j; }
        right = last;
    }
}
```

### 解説

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合、最適化版）

バブルソートは単純で理解しやすいですが、大きなデータセットに対しては非効率です。しかし、データがほぼソート済みの場合は、最適化版が効率的に動作します。

---

## 2. 選択ソート

未整列部分の最小値を探し、先頭と交換するアルゴリズムです。

### Red — 失敗するテストを書く

```csharp
public class SelectionSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.SelectionSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }
}
```

### Green — テストを通す実装

```csharp
public static void SelectionSort(int[] a)
{
    int n = a.Length;
    for (int i = 0; i < n - 1; i++)
    {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) if (a[j] < a[minIdx]) minIdx = j;
        if (minIdx != i) (a[i], a[minIdx]) = (a[minIdx], a[i]);
    }
}
```

### フローチャート

```plantuml
@startuml
title 選択ソート (SelectionSort)

start
:入力: 配列 a;
:n = a.Length;

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

**計算量**: 常に O(n^2)（整列済みでも改善されない）

選択ソートは、バブルソートと同様に単純ですが、交換回数が少ないという利点があります。具体的には、各パスで最大でも1回の交換しか行われません。しかし、大きなデータセットに対しては依然として非効率です。

---

## 3. 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入するアルゴリズムです。トランプのカードを手に持って並べ替える操作に似ています。

### Red — 失敗するテストを書く

```csharp
public class InsertionSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.InsertionSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }
}
```

### Green — テストを通す実装

```csharp
public static void InsertionSort(int[] a)
{
    int n = a.Length;
    for (int i = 1; i < n; i++)
    {
        int key = a[i], j = i - 1;
        while (j >= 0 && a[j] > key) { a[j + 1] = a[j]; j--; }
        a[j + 1] = key;
    }
}
```

### フローチャート

```plantuml
@startuml
title 挿入ソート (InsertionSort)

start
:入力: 配列 a;
:n = a.Length;

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

```csharp
// Algorithm.Tests/SortTest.cs
public class BinaryInsertionSortTest
{
    [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.BinaryInsertionSort(a); Assert.Equal([1,3,4,6,7,8,9], a); }
}
```

```csharp
// Algorithm/Sort.cs
public static void BinaryInsertionSort(int[] a)
{
    int n = a.Length;
    for (int i = 1; i < n; i++)
    {
        int key = a[i], pl = 0, pr = i - 1, pc = 0;
        while (pl <= pr)
        {
            pc = (pl + pr) / 2;
            if (a[pc] == key) break;
            else if (a[pc] < key) pl = pc + 1;
            else pr = pc - 1;
        }
        int pd = (pl <= pr) ? pc + 1 : pr + 1;
        for (int j = i; j > pd; j--) a[j] = a[j - 1];
        a[pd] = key;
    }
}
```

### 解説

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合）

挿入ソートは、小さなデータセットや、ほぼソート済みのデータに対して効率的です。また、安定なソートアルゴリズムであり、オンラインアルゴリズム（データが逐次的に到着する場合に適用可能）としても使用できます。

二分挿入ソートは、挿入位置の探索を O(log n) で行いますが、要素の移動コストは変わらないため、全体の時間計算量は依然として O(n²) です。

---

## 4. シェルソート

挿入ソートの改良版。間隔（gap）を縮小しながら複数回の挿入ソートを行います。離れた要素同士を先に比較・交換することで、大きな値を素早く後方に、小さな値を素早く前方に移動させることができます。

### Red — 失敗するテストを書く

```csharp
public class ShellSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.ShellSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }
}
```

### Green — テストを通す実装

```csharp
public static void ShellSort(int[] a)
{
    int n = a.Length, gap = 1;
    while (gap * 3 + 1 < n) gap = gap * 3 + 1;  // 1, 4, 13, 40, ...
    while (gap > 0)
    {
        for (int i = gap; i < n; i++)
        {
            int key = a[i], j = i - gap;
            while (j >= 0 && a[j] > key) { a[j + gap] = a[j]; j -= gap; }
            a[j + gap] = key;
        }
        gap /= 3;
    }
}
```

### フローチャート

```plantuml
@startuml
title シェルソート (ShellSort)

start
:入力: 配列 a;
:n = a.Length;
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
3. 変数 gap に Knuth 数列の初期値を設定します（1, 4, 13, 40, ...）
4. gap が 0 より大きい間、以下の処理を繰り返します：
   - gap から n-1 までの各インデックス i について、以下の処理を繰り返します：
     - j を i-gap に初期化します
     - tmp に a[i] を代入します（挿入する要素を退避）
     - j が 0 以上、かつ a[j] が tmp より大きい間、以下の処理を繰り返します：
       - a[j+gap] に a[j] を代入します（要素を後方にずらす）
       - j を gap 減らします
     - a[j+gap] に tmp を代入します（退避した要素を挿入）
   - gap を 1/3 にします（gap /= 3）
5. ソート済みの配列 a を出力します

最初は大きな間隔で要素を比較し、徐々に間隔を小さくしていきます。最終的に間隔が 1 になると、通常の挿入ソートと同じ処理になりますが、その時点で配列はほぼソートされているため、効率的に動作します。

### 解説

**計算量**: O(n^(3/2)) ~ O(n log^2 n)（gap 数列に依存）

シェルソートの時間計算量は、間隔列の選び方によって異なります：
- 最良の場合：O(n log n)
- 最悪の場合：O(n^2)（単純な間隔列の場合）
- 平均の場合：O(n^1.25)（Knuth の間隔列の場合）

シェルソートは、挿入ソートの欠点（小さな値が配列の後方にある場合の非効率性）を克服するために設計されました。

---

## 5. クイックソート

ピボットを基準に配列を 2 分割し、再帰的にソートします。「分割統治法」に基づく効率的なソートアルゴリズムで、実用的に最も高速なアルゴリズムの一つです。

### 分割手順

クイックソートの核心は、配列をピボットを中心に分割する手順です。

例として `[5, 1, 4, 6, 3, 2, 7]` を分割します（ピボット = 中央値 = 6）：

```
初期状態: [5, 1, 4, 6, 3, 2, 7]  pl=0, pr=6, pivot=6
  a[pl]=5 < 6 → pl++ → pl=1
  a[pl]=1 < 6 → pl++ → pl=2
  a[pl]=4 < 6 → pl++ → pl=3
  a[pl]=6 == 6 → stop
  a[pr]=7 > 6 → pr-- → pr=5
  a[pr]=2 < 6 → stop
  pl(3) <= pr(5): swap a[3]↔a[5] → [5, 1, 4, 2, 3, 6, 7]
  pl=4, pr=4
  a[pl]=3 < 6 → pl++ → pl=5
  a[pr]=3 < 6 → stop
  pl(5) > pr(4): 終了

分割結果:
  左グループ: [5, 1, 4, 2, 3]  (a[0..pr])
  右グループ: [6, 7]           (a[pl..n-1])
```

### Red — 失敗するテストを書く

```csharp
public class QuickSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.QuickSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }

    [Fact] public void 大きな配列()
    {
        int[] a = Enumerable.Range(0, 200).ToArray();
        int[] shuffled = Shuffle(a);
        Sort.QuickSort(shuffled);
        Assert.Equal(a, shuffled);
    }
}
```

### Green — テストを通す実装

```csharp
public static void QuickSort(int[] a, int left, int right)
{
    if (left >= right) return;
    int pivot = a[(left + right) / 2], i = left, j = right;
    while (i <= j)
    {
        while (a[i] < pivot) i++;
        while (a[j] > pivot) j--;
        if (i <= j) { (a[i], a[j]) = (a[j], a[i]); i++; j--; }
    }
    QuickSort(a, left, j);
    QuickSort(a, i, right);
}

public static void QuickSort(int[] a) { if (a.Length > 1) QuickSort(a, 0, a.Length - 1); }
```

### フローチャート

```plantuml
@startuml
title クイックソート (QuickSort)

start
:入力: 配列 a, 左端 left, 右端 right;

:pl = left;
:pr = right;
:x = a[(left + right) / 2];
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
  :QuickSort(a, left, pr);
  note right
    左グループを再帰的にソート
  end note
endif

if (pl < right) then (はい)
  :QuickSort(a, pl, right);
  note right
    右グループを再帰的にソート
  end note
endif

stop
@enduml
```

この図は、クイックソートのアルゴリズム（QuickSort メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 配列 a、左端 left、右端 right を入力として受け取ります
2. 左カーソル pl を left に、右カーソル pr を right に初期化します
3. 枢軸 x を a[(left + right) / 2]（中央の要素）に設定します
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

再帰の代わりに明示的なスタックを使って実装できます：

```csharp
// Algorithm.Tests/SortTest.cs
public class QuickSortNonRecursiveTest
{
    [Fact] public void 基本() { int[] a = [6,4,3,7,1,9,8]; Sort.QuickSortNonRecursive(a); Assert.Equal([1,3,4,6,7,8,9], a); }
    [Fact] public void 重複() { int[] a = [3,1,2,1,3]; Sort.QuickSortNonRecursive(a); Assert.Equal([1,1,2,3,3], a); }
}
```

```csharp
// Algorithm/Sort.cs
public static void QuickSortNonRecursive(int[] a)
{
    if (a.Length <= 1) return;
    var stack = new Stack<(int, int)>();
    stack.Push((0, a.Length - 1));
    while (stack.Count > 0)
    {
        var (left, right) = stack.Pop();
        if (left >= right) continue;
        int pivot = a[(left + right) / 2], i = left, j = right;
        while (i <= j)
        {
            while (a[i] < pivot) i++;
            while (a[j] > pivot) j--;
            if (i <= j) { (a[i], a[j]) = (a[j], a[i]); i++; j--; }
        }
        if (left < j) stack.Push((left, j));
        if (i < right) stack.Push((i, right));
    }
}
```

### 解説

**計算量**: 平均 O(n log n)、最悪 O(n²)

クイックソートは、平均的には非常に効率的なアルゴリズムですが、最悪の場合（既にソート済みの配列や同一値のみの配列）では効率が悪くなることがあります。また、不安定なソートアルゴリズムです。

---

## 6. マージソート

配列を半分に分割し、再帰的にソートして結合します。「分割統治法」に基づくもう一つの効率的なソートアルゴリズムです。

### ソート済み配列のマージ

マージソートの核心操作は、2 つのソート済み配列を 1 つのソート済み配列にマージすることです。

```csharp
// Algorithm.Tests/SortTest.cs
public class MergeSortedArraysTest
{
    [Fact] public void 基本() => Assert.Equal([1,2,3,4,5,6], Sort.MergeSortedArrays([1,3,5],[2,4,6]));
    [Fact] public void 一方が空() => Assert.Equal([1,2,3], Sort.MergeSortedArrays([],[1,2,3]));
    [Fact] public void 重複あり() => Assert.Equal([1,2,2,3,4], Sort.MergeSortedArrays([1,2,4],[2,3]));
}
```

```csharp
// Algorithm/Sort.cs
public static int[] MergeSortedArrays(int[] a, int[] b)
{
    int[] result = new int[a.Length + b.Length];
    int i = 0, j = 0, k = 0;
    while (i < a.Length && j < b.Length)
        result[k++] = a[i] <= b[j] ? a[i++] : b[j++];
    while (i < a.Length) result[k++] = a[i++];
    while (j < b.Length) result[k++] = b[j++];
    return result;
}
```

2 つのポインタ i, j を先頭から進めながら小さい方を選んで結果配列に格納します。一方が尽きたらもう一方の残りをそのままコピーします。

### Red — 失敗するテストを書く

```csharp
public class MergeSortTest
{
    [Fact] public void 基本()
        => Assert.Equal([1, 3, 4, 6, 7, 8, 9], Sort.MergeSort([6, 4, 3, 7, 1, 9, 8]));
}
```

### Green — テストを通す実装

```csharp
public static int[] MergeSort(int[] a)
{
    if (a.Length <= 1) return (int[])a.Clone();
    int mid = a.Length / 2;
    int[] left = MergeSort(a[..mid]);
    int[] right = MergeSort(a[mid..]);
    return Merge(left, right);
}

private static int[] Merge(int[] left, int[] right)
{
    int[] result = new int[left.Length + right.Length];
    int i = 0, j = 0, k = 0;
    while (i < left.Length && j < right.Length)
        result[k++] = left[i] <= right[j] ? left[i++] : right[j++];
    while (i < left.Length) result[k++] = left[i++];
    while (j < right.Length) result[k++] = right[j++];
    return result;
}
```

### フローチャート

```plantuml
@startuml
title マージソート (MergeSort)

start
:入力: 配列 a, 左端 left, 右端 right;

if (left < right) then (はい)
  :center = (left + right) // 2;

  :MergeSort(a, left, center);
  note right
    前半を再帰的にソート
  end note

  :MergeSort(a, center + 1, right);
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
   - center を (left + right) / 2 に設定します（配列の中央位置）
   - 前半部分（left から center まで）を再帰的にソートします
   - 後半部分（center + 1 から right まで）を再帰的にソートします
   - 前半部分と後半部分をマージします

このアルゴリズムの特徴は、どのような入力に対しても安定した性能を発揮する点です。また、安定なソートアルゴリズムであるという利点もあります。ただし、追加のメモリ空間（作業用配列）が必要であるという欠点があります。

### 解説

**計算量**: 常に O(n log n)

マージソートは、どのような入力に対しても安定した性能を発揮する安定なソートアルゴリズムです。しかし、追加のメモリ空間（作業用配列）が必要であるという欠点があります。

---

## 7. ヒープソート

ヒープデータ構造を利用したソートアルゴリズムです。ヒープは、親ノードが子ノードよりも大きい（または小さい）という性質を持つ二分木です。

### Red — 失敗するテストを書く

```csharp
public class HeapSortTest
{
    [Fact] public void 基本()
    {
        int[] a = [6, 4, 3, 7, 1, 9, 8];
        Sort.HeapSort(a);
        Assert.Equal([1, 3, 4, 6, 7, 8, 9], a);
    }
}
```

### Green — テストを通す実装

```csharp
public static void HeapSort(int[] a)
{
    int n = a.Length;
    if (n <= 1) return;
    for (int i = (n - 1) / 2; i >= 0; i--) DownHeap(a, i, n - 1);
    for (int i = n - 1; i > 0; i--) { (a[0], a[i]) = (a[i], a[0]); DownHeap(a, 0, i - 1); }
}

private static void DownHeap(int[] a, int left, int right)
{
    int temp = a[left], parent = left;
    while (parent < (right + 1) / 2)
    {
        int cl = parent * 2 + 1, cr = cl + 1;
        int child = (cr <= right && a[cr] > a[cl]) ? cr : cl;
        if (temp >= a[child]) break;
        a[parent] = a[child]; parent = child;
    }
    a[parent] = temp;
}
```

### 解説

**計算量**: 常に O(n log n)

ヒープソートは、どのような入力に対しても安定した性能を発揮し、追加のメモリ空間を必要としないという利点があります。しかし、不安定なソートアルゴリズムであり、キャッシュ効率が悪いという欠点もあります。

---

## 8. 度数ソート

度数ソート（カウンティングソート）は、要素の値の範囲が限られている場合に効率的なソートアルゴリズムです。各値の出現回数をカウントし、それに基づいてソートを行います。

### Red — 失敗するテストを書く

```csharp
public class CountingSortTest
{
    [Fact] public void 基本()
        => Assert.Equal([1, 3, 4, 6, 7, 8, 9], Sort.CountingSort([6, 4, 3, 7, 1, 9, 8]));
}
```

### Green — テストを通す実装

```csharp
public static int[] CountingSort(int[] a)
{
    if (a.Length == 0) return [];
    int maxVal = a[0];
    foreach (int x in a) if (x > maxVal) maxVal = x;
    int[] freq = new int[maxVal + 1];
    foreach (int x in a) freq[x]++;
    for (int i = 1; i < freq.Length; i++) freq[i] += freq[i - 1];
    int[] result = new int[a.Length];
    for (int i = a.Length - 1; i >= 0; i--) { freq[a[i]]--; result[freq[a[i]]] = a[i]; }
    return result;
}
```

### 解説

**計算量**: O(n + k)（n は要素数、k は値の範囲）

度数ソートは、値の範囲が小さい場合に非常に効率的ですが、値の範囲が大きい場合はメモリ使用量が増大するという欠点があります。また、浮動小数点数や文字列などの比較可能なデータ型には直接適用できません。

---

## テスト実行結果

```bash
$ dotnet test --filter "FullyQualifiedName~SortTest" --verbosity normal

...（27 テスト全パス）...

テスト実行に成功しました。
```

---

## ソートアルゴリズムの比較

| アルゴリズム | 最良 | 平均 | 最悪 | 安定 | 備考 |
|-------------|------|------|------|------|------|
| バブルソート | O(n) | O(n^2) | O(n^2) | ○ | 整列済み検出あり |
| 選択ソート | O(n^2) | O(n^2) | O(n^2) | × | 交換回数が少ない |
| 挿入ソート | O(n) | O(n^2) | O(n^2) | ○ | 小規模データに有効 |
| シェルソート | O(n) | O(n^1.5) | O(n^2) | × | 挿入ソートの改良 |
| クイックソート | O(n log n) | O(n log n) | O(n^2) | × | 実用的に最速 |
| マージソート | O(n log n) | O(n log n) | O(n log n) | ○ | 追加メモリが必要 |
| ヒープソート | O(n log n) | O(n log n) | O(n log n) | × | 追加メモリ不要 |
| 度数ソート | O(n + k) | O(n + k) | O(n + k) | ○ | 値の範囲が限定的な場合に有効 |

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

- 『新・明解 C# で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
