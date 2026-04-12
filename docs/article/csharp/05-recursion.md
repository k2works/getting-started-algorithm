# 第 5 章 再帰アルゴリズム

## はじめに

前章ではスタックとキューというデータ構造を学びました。この章では「**再帰（Recursion）**」というアルゴリズム設計手法を TDD で実装します。

再帰とは、**ある関数が自分自身を呼び出す**ことで問題を解く手法です。大きな問題を同じ構造の小さな問題に分解し、最終的に自明な基底ケースに到達したら戻り始めます。

再帰は、多くの複雑な問題を簡潔かつエレガントに解決できる強力なツールですが、理解するのが難しい概念でもあります。この章では、テスト駆動開発の手法を用いて、再帰の基本から応用までを段階的に学んでいきます。

再帰アルゴリズムは、一般的に以下の 2 つの部分から構成されます：

1. **基底部（base case）**: 再帰呼び出しを終了する条件
2. **再帰部（recursive case）**: 問題を小さくして自分自身を呼び出す部分

### 目次

1. [階乗](#1-階乗)
2. [最大公約数（ユークリッドの互除法）](#2-最大公約数ユークリッドの互除法)
3. [ハノイの塔](#3-ハノイの塔)
4. [再帰アルゴリズムの解析](#4-再帰アルゴリズムの解析)
5. [8 王妃問題](#5-8-王妃問題)
6. [迷路探索（バックトラッキング）](#6-迷路探索バックトラッキング)

---

## 1. 階乗

`n! = n * (n-1) * ... * 1` を再帰で実装します。

### Red — 失敗するテストを書く

```csharp
// Algorithm.Tests/RecursionTest.cs
public class FactorialTest
{
    [Fact] public void factorial_0() => Assert.Equal(1, Recursion.Factorial(0));
    [Fact] public void factorial_5() => Assert.Equal(120, Recursion.Factorial(5));
}
```

### Green — テストを通す実装

```csharp
// Algorithm/Recursion.cs
namespace Algorithm;

/// <summary>第5章 再帰アルゴリズム</summary>
public static class Recursion
{
    public static int Factorial(int n) => n <= 0 ? 1 : n * Factorial(n - 1);
}
```

### アルゴリズムの考え方

#### フローチャート

以下は、階乗を再帰的に計算するアルゴリズムのフローチャートです：

```plantuml
@startuml
title 階乗の再帰的計算 (Factorial)

start
:入力: 非負の整数 n;

if (n > 0) then (はい)
  :return n * Factorial(n - 1);
  note right
    再帰呼び出し
  end note
else (いいえ)
  :return 1;
  note right
    基底部
  end note
endif

stop
@enduml
```

この図は、階乗を再帰的に計算するアルゴリズム（Factorial メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 非負の整数 n を入力として受け取ります
2. n が 0 より大きいかどうかを判定します
   - n > 0 の場合：n と Factorial(n - 1) の積を返します（再帰呼び出し）
   - n = 0 の場合：1 を返します（基底部）

再帰アルゴリズムでは、問題を「より小さな同じ問題」に分割して解きます。階乗の場合、n! = n x (n-1)! という関係を利用しています。再帰の終了条件（基底部）は n = 0 の場合で、0! = 1 と定義されています。

#### 再帰呼び出しの展開

```plantuml
@startuml
title 階乗の再帰呼び出し（n=5）

start
:Factorial(5) → 5 * Factorial(4);
:Factorial(4) → 4 * Factorial(3);
:Factorial(3) → 3 * Factorial(2);
:Factorial(2) → 2 * Factorial(1);
:Factorial(1) → 1 * Factorial(0);
:Factorial(0) = 1（基底ケース）;
note right
  ここから戻り始める
end note
:戻り: 1 * 1 = 1;
:戻り: 2 * 1 = 2;
:戻り: 3 * 2 = 6;
:戻り: 4 * 6 = 24;
:戻り: 5 * 24 = **120**;
stop
@enduml
```

**計算量**: O(n)（n 回の再帰呼び出し）

---

## 2. 最大公約数（ユークリッドの互除法）

`Gcd(a, b) = Gcd(b, a % b)` という関係を再帰で実装します。

### Red — 失敗するテストを書く

```csharp
public class GcdTest
{
    [Fact] public void 基本() => Assert.Equal(2, Recursion.Gcd(22, 8));
    [Fact] public void 互いに素() => Assert.Equal(1, Recursion.Gcd(7, 11));
}
```

### Green — テストを通す実装

```csharp
public static int Gcd(int x, int y) => y == 0 ? x : Gcd(y, x % y);
```

### アルゴリズムの考え方

#### フローチャート

以下は、ユークリッドの互除法による最大公約数を求めるアルゴリズムのフローチャートです：

```plantuml
@startuml
title ユークリッドの互除法 (Gcd)

start
:入力: 整数値 x, y;

if (y == 0) then (はい)
  :return x;
  note right
    基底部
  end note
else (いいえ)
  :return Gcd(y, x % y);
  note right
    再帰呼び出し
  end note
endif

stop
@enduml
```

この図は、ユークリッドの互除法による最大公約数を求めるアルゴリズム（Gcd メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 整数値 x と y を入力として受け取ります
2. y が 0 かどうかを判定します
   - y = 0 の場合：x を返します（基底部）
   - y が 0 でない場合：Gcd(y, x % y) を返します（再帰呼び出し）

ユークリッドの互除法は、「2 つの整数の最大公約数は、一方の整数と、もう一方の整数を一方で割った余りの最大公約数に等しい」という性質を利用しています。

例えば、Gcd(22, 8) を計算する場合：
1. y = 8 が 0 でないので、Gcd(8, 22 % 8) = Gcd(8, 6) を計算
2. y = 6 が 0 でないので、Gcd(6, 8 % 6) = Gcd(6, 2) を計算
3. y = 2 が 0 でないので、Gcd(2, 6 % 2) = Gcd(2, 0) を計算
4. y = 0 なので、x = 2 を返す

よって、Gcd(22, 8) = 2 となります。

**計算量**: O(log min(x, y))

---

## 3. ハノイの塔

n 枚の円盤を A から C へ B を経由して移動する問題です。

```
ルール:
1. 一度に 1 枚しか移動できない
2. 大きい円盤を小さい円盤の上に置けない
```

### Red — 失敗するテストを書く

```csharp
public class HanoiTest
{
    [Fact] public void ハノイ1枚() => Assert.Equal(["A->C"], Recursion.Hanoi(1, "A", "C", "B"));
    [Fact]
    public void ハノイn枚は2のn乗マイナス1手()
    {
        for (int n = 1; n <= 5; n++)
            Assert.Equal((1 << n) - 1, Recursion.Hanoi(n, "A", "C", "B").Count);
    }
}
```

### Green — テストを通す実装

```csharp
public static List<string> Hanoi(int n, string src, string dst, string via)
{
    var moves = new List<string>();
    HanoiHelper(n, src, dst, via, moves);
    return moves;
}

private static void HanoiHelper(int n, string src, string dst, string via, List<string> moves)
{
    if (n == 1) { moves.Add($"{src}->{dst}"); return; }
    HanoiHelper(n - 1, src, via, dst, moves);     // n-1 枚を via へ
    moves.Add($"{src}->{dst}");                     // 最大の円盤を dst へ
    HanoiHelper(n - 1, via, dst, src, moves);      // n-1 枚を dst へ
}
```

### アルゴリズムの考え方

#### フローチャート

以下は、ハノイの塔を解くアルゴリズムのフローチャートです：

```plantuml
@startuml
title ハノイの塔 (Hanoi)

start
:入力: 円盤の枚数 n, 移動元 src, 移動先 dst, 経由 via;

if (n == 1) then (はい)
  :return [(src, dst)];
  note right
    基底部: 1枚の円盤を直接移動
  end note
else (いいえ)
  :Hanoi(n - 1, src, via, dst);
  note right
    n-1枚の円盤を経由先へ移動
  end note

  :(src, dst);
  note right
    最大の円盤を移動先へ移動
  end note

  :Hanoi(n - 1, via, dst, src);
  note right
    n-1枚の円盤を経由先から移動先へ
  end note
endif

stop
@enduml
```

この図は、ハノイの塔を解くアルゴリズム（Hanoi メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 円盤の枚数 n、移動元 src、移動先 dst、経由 via を入力として受け取ります
2. n が 1 の場合（基底部）：移動元から移動先へ直接移動します
3. n が 1 より大きい場合：
   - n-1 枚の円盤を移動元から経由先へ移動します（再帰呼び出し）
   - 最大の円盤を移動元から移動先へ移動します
   - n-1 枚の円盤を経由先から移動先へ移動します（再帰呼び出し）

例えば、3 枚の円盤を A から C へ移動する場合（Hanoi(3, "A", "C", "B")）：
1. まず、上の 2 枚の円盤を A から B に移動します（Hanoi(2, "A", "B", "C")）
   - 上の 1 枚の円盤を A から C に移動し
   - 2 枚目の円盤を A から B に移動し
   - 上の 1 枚の円盤を C から B に移動する
2. 次に、3 枚目（最大）の円盤を A から C に移動します
3. 最後に、上の 2 枚の円盤を B から C に移動します（Hanoi(2, "B", "C", "A")）
   - 上の 1 枚の円盤を B から A に移動し
   - 2 枚目の円盤を B から C に移動し
   - 上の 1 枚の円盤を A から C に移動する

**計算量**: O(2^n)（移動回数 2^n - 1 回）

---

## 4. 再帰アルゴリズムの解析

### 真に再帰的な関数

「真に再帰的な関数」とは、複数の再帰呼び出しを含む関数のことです。C# では `RecursiveSum` が再帰的な加算の典型例です。

#### Red — 失敗するテストを書く

```csharp
public class RecursiveSumTest
{
    [Fact] public void sum_1() => Assert.Equal(1, Recursion.RecursiveSum(1));
    [Fact] public void sum_5() => Assert.Equal(15, Recursion.RecursiveSum(5));
    [Fact] public void sum_10() => Assert.Equal(55, Recursion.RecursiveSum(10));
}
```

#### Green — テストを通す実装

```csharp
public static int RecursiveSum(int n) => n <= 0 ? 0 : n + RecursiveSum(n - 1);
```

この関数は 1 から n までの合計を再帰的に計算します。

#### フローチャート

```plantuml
@startuml
title 真に再帰的な関数 (RecursiveSum)

start
:入力: 整数 n;

if (n <= 0) then (はい)
  :return 0;
  stop
endif

:return n + RecursiveSum(n - 1);
note right
  再帰呼び出し
end note
stop
@enduml
```

例えば、`RecursiveSum(5)` を実行すると：
- `RecursiveSum(5)` = 5 + `RecursiveSum(4)`
  - `RecursiveSum(4)` = 4 + `RecursiveSum(3)`
    - `RecursiveSum(3)` = 3 + `RecursiveSum(2)`
      - `RecursiveSum(2)` = 2 + `RecursiveSum(1)`
        - `RecursiveSum(1)` = 1 + `RecursiveSum(0)` = 1 + 0 = 1
      - = 2 + 1 = 3
    - = 3 + 3 = 6
  - = 4 + 6 = 10
- = 5 + 10 = 15

最終的に `RecursiveSum(5)` = 15 となります。

### 再帰アルゴリズムの非再帰表現

再帰は概念的に理解しやすいですが、実行効率の面では問題があることがあります。特に、深い再帰呼び出しはスタックオーバーフローを引き起こす可能性があります。そのため、再帰アルゴリズムを非再帰（反復的）な形に変換することが重要です。

#### 末尾再帰の除去

末尾再帰（tail recursion）とは、関数の最後の操作が再帰呼び出しである場合の再帰のことです。末尾再帰は、ループに変換することで簡単に除去できます。

#### 再帰の完全除去

すべての再帰呼び出しを除去するには、スタックを使用して関数の呼び出し状態を明示的に管理する必要があります。C# では `Stack<T>` クラスを使って実装できます。

---

## 5. 8 王妃問題

8 王妃問題は、8x8 のチェス盤上に 8 個の王妃を互いに攻撃できないように配置する問題です。王妃は、同じ行、同じ列、または同じ対角線上にある他の王妃を攻撃できます。

8 王妃問題は、バックトラッキング（試行錯誤）と再帰を使って解くことができる典型的な問題です。基本的なアプローチは、1 列目から順に王妃を配置し、矛盾が生じたら前の列に戻って別の配置を試すというものです。

### 王妃の配置

まず、各列に 1 個の王妃を配置する組み合わせを列挙する関数を実装します：

```csharp
public class EightQueen
{
    private int _count;
    private readonly int[] _pos = new int[8];
    public void Set(int i)
    {
        for (int j = 0; j < 8; j++)
        {
            _pos[i] = j;
            if (i == 7) _count++;
            else Set(i + 1);
        }
    }
    public int GetCount() => _count;
}
```

この実装では、各列に王妃を配置する可能な組み合わせをすべて列挙しています。しかし、これでは王妃同士が攻撃できる配置も含まれてしまいます。

### 限定操作と分岐限定法

次に、各行・各列に 1 個の王妃を配置する組み合わせを列挙する関数を実装します：

```csharp
public class EightQueen2
{
    private readonly List<int[]> _result = [];
    private readonly int[] _pos = new int[8];
    private readonly bool[] _flag = new bool[8];
    public void Set(int i)
    {
        for (int j = 0; j < 8; j++)
        {
            if (!_flag[j])
            {
                _pos[i] = j;
                if (i == 7) _result.Add((int[])_pos.Clone());
                else { _flag[j] = true; Set(i + 1); _flag[j] = false; }
            }
        }
    }
    public List<int[]> GetResult() => _result;
}
```

この実装では、各行に 1 個の王妃を配置するという制約を追加しています。しかし、対角線上の制約はまだ考慮されていません。

### 8 王妃問題を解くプログラム

最後に、すべての制約（行、列、対角線）を考慮した完全な解を求める関数を実装します：

```csharp
public class EightQueen3
{
    private readonly List<int[]> _result = [];
    private readonly int[] _pos = new int[8];
    private readonly bool[] _flagA = new bool[8];   // 各行に王妃が配置済みかのフラグ
    private readonly bool[] _flagB = new bool[15];  // 右上がりの対角線
    private readonly bool[] _flagC = new bool[15];  // 右下がりの対角線
    public void Set(int i)
    {
        for (int j = 0; j < 8; j++)
        {
            if (!_flagA[j] && !_flagB[i + j] && !_flagC[i - j + 7])
            {
                _pos[i] = j;
                if (i == 7) _result.Add((int[])_pos.Clone());
                else
                {
                    _flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = true;
                    Set(i + 1);
                    _flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = false;
                }
            }
        }
    }
    public List<int[]> GetResult() => _result;
}
```

#### フローチャート

以下は、8 王妃問題を解くアルゴリズムのフローチャートです：

```plantuml
@startuml
title 8王妃問題 (Set メソッド)

start
:入力: 列番号 i;

repeat :j = 0 から 7 まで;
  if (j行目、i+j対角線、i-j+7対角線に王妃が配置されていない) then (はい)
    :_pos[i] = j;
    note right
      i列目の王妃をj行目に配置
    end note

    if (i == 7) then (はい)
      :結果を記録;
      note right
        解を記録
      end note
    else (いいえ)
      :_flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = true;
      note right
        各フラグを設定
      end note

      :Set(i + 1);
      note right
        次の列に進む（再帰呼び出し）
      end note

      :_flagA[j] = _flagB[i + j] = _flagC[i - j + 7] = false;
      note right
        各フラグを解除（バックトラック）
      end note
    endif
  endif
repeat while (j < 7)

stop
@enduml
```

このアルゴリズムは、バックトラッキング（試行錯誤）と再帰を使って 8 王妃問題を解きます。各列に 1 個の王妃を配置し、行、列、および両方向の対角線上に他の王妃がないことを確認しながら進めます。

矛盾が生じた場合（すべての行に配置できない場合）は、前の列に戻って別の配置を試します。これにより、8 王妃問題の 92 個の解をすべて見つけることができます。

バックトラッキングは、解の候補を少しずつ構築し、候補が解になる見込みがなくなった時点で打ち切る（バックトラックする）効率的な探索手法です。

---

## 6. 迷路探索（バックトラッキング）

再帰的バックトラッキングで迷路を解きます。行き止まりに達したら戻り、別の経路を試みます。

### Red — 失敗するテストを書く

```csharp
public class MazeSolveTest
{
    [Fact]
    public void 解ける迷路()
    {
        int[][] maze = [[1,1,1,1,1], [1,0,0,0,1], [1,0,1,0,1], [1,0,0,0,1], [1,1,1,1,1]];
        Assert.True(Recursion.MazeSolve(maze, 1, 1, 3, 3));
    }
}
```

### Green — テストを通す実装

```csharp
public static bool MazeSolve(int[][] maze, int row, int col, int goalRow, int goalCol)
{
    bool[][] visited = new bool[maze.Length][];
    for (int i = 0; i < maze.Length; i++) visited[i] = new bool[maze[i].Length];
    return MazeSolveHelper(maze, row, col, goalRow, goalCol, visited);
}

private static bool MazeSolveHelper(int[][] maze, int row, int col,
    int goalRow, int goalCol, bool[][] visited)
{
    if (row == goalRow && col == goalCol) return true;
    visited[row][col] = true;
    int[][] dirs = [[-1, 0], [1, 0], [0, -1], [0, 1]];
    foreach (var d in dirs)
    {
        int nr = row + d[0], nc = col + d[1];
        if (nr >= 0 && nr < maze.Length && nc >= 0 && nc < maze[0].Length
            && maze[nr][nc] == 0 && !visited[nr][nc])
            if (MazeSolveHelper(maze, nr, nc, goalRow, goalCol, visited)) return true;
    }
    return false;
}
```

---

## テスト実行結果

```bash
$ dotnet test --filter "FullyQualifiedName~RecursionTest" --verbosity normal

...（17 テスト全パス）...

テスト実行に成功しました。
```

---

## 再帰アルゴリズムの比較

| アルゴリズム | 計算量 | 特徴 |
|-------------|--------|------|
| 階乗 | O(n) | 単純な線形再帰 |
| GCD（ユークリッド） | O(log min(x,y)) | 対数的収束 |
| ハノイの塔 | O(2^n) | 指数的成長 |
| 8 王妃問題 | O(n!) | バックトラッキングによる枝刈り |
| 迷路探索 | O(行数 x 列数) | バックトラッキング |

## まとめ

この章では、再帰アルゴリズムについて学びました：

1. **再帰の基本**：階乗やユークリッドの互除法などの基本的な再帰アルゴリズム
2. **再帰アルゴリズムの解析**：真に再帰的な関数と再帰の非再帰表現（末尾再帰の除去、スタックによる完全除去）
3. **ハノイの塔**：再帰の古典的な応用例
4. **8 王妃問題**：バックトラッキングと再帰を組み合わせた複雑な問題
5. **迷路探索**：バックトラッキングによる経路探索

再帰は、問題を小さな部分問題に分割して解くための強力なツールです。しかし、深い再帰呼び出しはスタックオーバーフローを引き起こす可能性があるため、必要に応じて非再帰的な実装に変換することも重要です。

テスト駆動開発の手法を用いることで、これらの複雑な再帰アルゴリズムの正確な実装と理解を深めることができました。

次の章では、ソートアルゴリズムについて学んでいきましょう。

## 参考文献

- 『新・明解 C# で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
