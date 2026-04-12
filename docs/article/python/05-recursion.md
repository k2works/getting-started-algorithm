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

`n! = n × (n-1) × ... × 1` を再帰で実装します。

### Red — 失敗するテストを書く

```python
# tests/test_recursion.py
class TestFactorial:
    def test_factorial_0(self):
        assert factorial(0) == 1

    def test_factorial_5(self):
        assert factorial(5) == 120
```

### Green — テストを通す実装

```python
# src/algorithm/recursion.py
def factorial(n: int) -> int:
    """n の階乗を再帰的に計算

    >>> factorial(5)
    120
    """
    if n <= 0:
        return 1
    return n * factorial(n - 1)
```

### アルゴリズムの考え方

#### フローチャート

以下は、階乗を再帰的に計算するアルゴリズムのフローチャートです：

```plantuml
@startuml
title 階乗の再帰的計算 (factorial)

start
:入力: 非負の整数 n;

if (n > 0) then (はい)
  :return n * factorial(n - 1);
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

この図は、階乗を再帰的に計算するアルゴリズム（factorial 関数）のフローチャートです。

アルゴリズムの流れ：
1. 非負の整数 n を入力として受け取ります
2. n が 0 より大きいかどうかを判定します
   - n > 0 の場合：n と factorial(n - 1) の積を返します（再帰呼び出し）
   - n = 0 の場合：1 を返します（基底部）

再帰アルゴリズムでは、問題を「より小さな同じ問題」に分割して解きます。階乗の場合、n! = n x (n-1)! という関係を利用しています。再帰の終了条件（基底部）は n = 0 の場合で、0! = 1 と定義されています。

#### 再帰呼び出しの展開

```plantuml
@startuml
title 階乗の再帰呼び出し（n=5）

start
:factorial(5) → 5 × factorial(4);
:factorial(4) → 4 × factorial(3);
:factorial(3) → 3 × factorial(2);
:factorial(2) → 2 × factorial(1);
:factorial(1) → 1 × factorial(0);
:factorial(0) = 1（基底ケース）;
note right
  ここから戻り始める
end note
:戻り: 1 × 1 = 1;
:戻り: 2 × 1 = 2;
:戻り: 3 × 2 = 6;
:戻り: 4 × 6 = 24;
:戻り: 5 × 24 = **120**;
stop
@enduml
```

**計算量**: O(n)（n 回の再帰呼び出し）

---

## 2. 最大公約数（ユークリッドの互除法）

`gcd(a, b) = gcd(b, a % b)` という関係を再帰で実装します。

### Red — 失敗するテストを書く

```python
class TestGcd:
    def test_gcd_basic(self):
        assert gcd(22, 8) == 2

    def test_gcd_coprime(self):
        assert gcd(7, 11) == 1
```

### Green — テストを通す実装

```python
def gcd(x: int, y: int) -> int:
    """ユークリッドの互除法で最大公約数を求める

    >>> gcd(22, 8)
    2
    """
    if y == 0:
        return x
    return gcd(y, x % y)
```

### アルゴリズムの考え方

#### フローチャート

以下は、ユークリッドの互除法による最大公約数を求めるアルゴリズムのフローチャートです：

```plantuml
@startuml
title ユークリッドの互除法 (gcd)

start
:入力: 整数値 x, y;

if (y == 0) then (はい)
  :return x;
  note right
    基底部
  end note
else (いいえ)
  :return gcd(y, x % y);
  note right
    再帰呼び出し
  end note
endif

stop
@enduml
```

この図は、ユークリッドの互除法による最大公約数を求めるアルゴリズム（gcd 関数）のフローチャートです。

アルゴリズムの流れ：
1. 整数値 x と y を入力として受け取ります
2. y が 0 かどうかを判定します
   - y = 0 の場合：x を返します（基底部）
   - y が 0 でない場合：gcd(y, x % y) を返します（再帰呼び出し）

ユークリッドの互除法は、「2 つの整数の最大公約数は、一方の整数と、もう一方の整数を一方で割った余りの最大公約数に等しい」という性質を利用しています。

例えば、gcd(22, 8) を計算する場合：
1. y = 8 が 0 でないので、gcd(8, 22 % 8) = gcd(8, 6) を計算
2. y = 6 が 0 でないので、gcd(6, 8 % 6) = gcd(6, 2) を計算
3. y = 2 が 0 でないので、gcd(2, 6 % 2) = gcd(2, 0) を計算
4. y = 0 なので、x = 2 を返す

よって、gcd(22, 8) = 2 となります。

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

```python
class TestHanoi:
    def test_hanoi_1(self):
        moves = hanoi(1, "A", "C", "B")
        assert moves == [("A", "C")]

    def test_hanoi_move_count(self):
        """n 枚のハノイの塔は 2^n - 1 回の移動が必要"""
        for n in range(1, 6):
            moves = hanoi(n, "A", "C", "B")
            assert len(moves) == 2**n - 1
```

### Green — テストを通す実装

```python
def hanoi(n: int, src: str, dst: str, via: str) -> list[tuple[str, str]]:
    """ハノイの塔: n 枚の円盤を src から dst へ via を経由して移動する手順を返す"""
    if n == 1:
        return [(src, dst)]
    moves = []
    moves.extend(hanoi(n - 1, src, via, dst))  # n-1 枚を via へ
    moves.append((src, dst))                     # 最大の円盤を dst へ
    moves.extend(hanoi(n - 1, via, dst, src))   # n-1 枚を dst へ
    return moves
```

### アルゴリズムの考え方

#### フローチャート

以下は、ハノイの塔を解くアルゴリズムのフローチャートです：

```plantuml
@startuml
title ハノイの塔 (hanoi)

start
:入力: 円盤の枚数 n, 移動元 src, 移動先 dst, 経由 via;

if (n == 1) then (はい)
  :return [(src, dst)];
  note right
    基底部: 1枚の円盤を直接移動
  end note
else (いいえ)
  :hanoi(n - 1, src, via, dst);
  note right
    n-1枚の円盤を経由先へ移動
  end note

  :(src, dst);
  note right
    最大の円盤を移動先へ移動
  end note

  :hanoi(n - 1, via, dst, src);
  note right
    n-1枚の円盤を経由先から移動先へ
  end note
endif

stop
@enduml
```

この図は、ハノイの塔を解くアルゴリズム（hanoi 関数）のフローチャートです。

アルゴリズムの流れ：
1. 円盤の枚数 n、移動元 src、移動先 dst、経由 via を入力として受け取ります
2. n が 1 の場合（基底部）：移動元から移動先へ直接移動します
3. n が 1 より大きい場合：
   - n-1 枚の円盤を移動元から経由先へ移動します（再帰呼び出し）
   - 最大の円盤を移動元から移動先へ移動します
   - n-1 枚の円盤を経由先から移動先へ移動します（再帰呼び出し）

例えば、3 枚の円盤を A から C へ移動する場合（hanoi(3, "A", "C", "B")）：
1. まず、上の 2 枚の円盤を A から B に移動します（hanoi(2, "A", "B", "C")）
   - 上の 1 枚の円盤を A から C に移動し
   - 2 枚目の円盤を A から B に移動し
   - 上の 1 枚の円盤を C から B に移動する
2. 次に、3 枚目（最大）の円盤を A から C に移動します
3. 最後に、上の 2 枚の円盤を B から C に移動します（hanoi(2, "B", "C", "A")）
   - 上の 1 枚の円盤を B から A に移動し
   - 2 枚目の円盤を B から C に移動し
   - 上の 1 枚の円盤を A から C に移動する

**計算量**: O(2^n)（移動回数 2^n - 1 回）

---

## 4. 再帰アルゴリズムの解析

### 真に再帰的な関数

「真に再帰的な関数」とは、複数の再帰呼び出しを含む関数のことです。

#### Red -- 失敗するテストを書く

```python
class TestRecur:
    def test_実行結果を配列で返す(self):
        assert recure(4, []) == [1, 2, 3, 1, 4, 1, 2]
```

#### Green -- テストを通す実装

```python
def recure(n: int, list: list) -> list:
    """真に再帰的な関数 recure

    >>> recure(4, [])
    [1, 2, 3, 1, 4, 1, 2]
    """
    if n > 0:
        recure(n - 1, list)  # 最初の再帰呼び出し
        list.append(n)
        recure(n - 2, list)  # 2番目の再帰呼び出し

    return list
```

#### フローチャート

以下は、真に再帰的な関数のフローチャートです：

```plantuml
@startuml
title 真に再帰的な関数 (recure)

start
:入力: 整数 n, リスト list;

if (n > 0) then (はい)
  :recure(n - 1, list);
  note right
    最初の再帰呼び出し
  end note

  :list.append(n);

  :recure(n - 2, list);
  note right
    2番目の再帰呼び出し
  end note
endif

:return list;
stop
@enduml
```

この関数は「真に再帰的」と呼ばれます。なぜなら、1 つの関数呼び出しの中で複数回の再帰呼び出しを行うからです。

例えば、recure(4, []) を実行すると、以下のような呼び出しの連鎖が発生します：
- recure(4, []) は recure(3, []) を呼び出す
  - recure(3, []) は recure(2, []) を呼び出す
    - recure(2, []) は recure(1, []) を呼び出す
      - recure(1, []) は recure(0, []) を呼び出す（何もしない）
      - 1 を追加して [1] になる
      - recure(-1, [1]) を呼び出す（何もしない）
    - 2 を追加して [1, 2] になる
    - recure(0, [1, 2]) を呼び出す（何もしない）
  - 3 を追加して [1, 2, 3] になる
  - recure(1, [1, 2, 3]) を呼び出す
    - recure(0, ...) → 何もしない
    - 1 を追加して [1, 2, 3, 1] になる
    - recure(-1, ...) → 何もしない
- 4 を追加して [1, 2, 3, 1, 4] になる
- recure(2, [1, 2, 3, 1, 4]) を呼び出す
  - recure(1, ...) → 1 を追加して [1, 2, 3, 1, 4, 1] になる
  - 2 を追加して [1, 2, 3, 1, 4, 1, 2] になる

最終的に、recure(4, []) は [1, 2, 3, 1, 4, 1, 2] を返します。

### 再帰アルゴリズムの非再帰表現

再帰は概念的に理解しやすいですが、実行効率の面では問題があることがあります。特に、深い再帰呼び出しはスタックオーバーフローを引き起こす可能性があります。そのため、再帰アルゴリズムを非再帰（反復的）な形に変換することが重要です。

#### 末尾再帰の除去

末尾再帰（tail recursion）とは、関数の最後の操作が再帰呼び出しである場合の再帰のことです。末尾再帰は、ループに変換することで簡単に除去できます。

以下は、先ほどの `recure` 関数の末尾再帰を除去した例です：

```python
def recure2(n: int, list: list) -> list:
    """末尾再帰を除去した関数 recure

    >>> recure2(4, [])
    [1, 2, 3, 1, 4, 1, 2]
    """
    while n > 0:
        recure2(n - 1, list)  # 最初の再帰呼び出しはそのまま
        list.append(n)
        n = n - 2  # 2番目の再帰呼び出しをループに変換

    return list
```

#### 再帰の完全除去

すべての再帰呼び出しを除去するには、スタックを使用して関数の呼び出し状態を明示的に管理する必要があります。

以下は、`recure` 関数の再帰を完全に除去した例です：

```python
def recure3(n: int, list: list) -> list:
    """再帰を除去した関数 recure

    >>> recure3(4, [])
    [1, 2, 3, 1, 4, 1, 2]
    """
    s = Stack(n)  # スタックを用意

    while True:
        if n > 0:
            s.push(n)  # 現在の状態をスタックに保存
            n = n - 1  # 最初の再帰呼び出しに相当
            continue
        if not s.is_empty():
            n = s.pop()  # 保存した状態を復元
            list.append(n)
            n = n - 2  # 2番目の再帰呼び出しに相当
            continue
        break

    return list
```

この実装では、スタックを使って関数の呼び出し状態を明示的に管理しています。これにより、再帰呼び出しを使わずに同じ結果を得ることができます。

---

## 5. 8 王妃問題

8 王妃問題は、8x8 のチェス盤上に 8 個の王妃を互いに攻撃できないように配置する問題です。王妃は、同じ行、同じ列、または同じ対角線上にある他の王妃を攻撃できます。

8 王妃問題は、バックトラッキング（試行錯誤）と再帰を使って解くことができる典型的な問題です。基本的なアプローチは、1 列目から順に王妃を配置し、矛盾が生じたら前の列に戻って別の配置を試すというものです。

### 王妃の配置

まず、各列に 1 個の王妃を配置する組み合わせを列挙する関数を実装します：

```python
class EightQueen:
    def __init__(self):
        self.result = []
        self.__pos = [0] * 8  # 各列の王妃の位置

    def put(self) -> None:
        """盤面（各列の王妃の位置）を出力"""
        row = []
        for i in range(8):
            row.append(self.__pos[i])
        self.result.append(row)

    def set(self, i: int) -> None:
        """i列目に王妃を配置"""
        for j in range(8):
            self.__pos[i] = j  # i列目の王妃をj行目に配置
            if i == 7:  # 全列に配置完了
                self.put()
            else:
                self.set(i + 1)  # 次の列に進む
```

この実装では、各列に王妃を配置する可能な組み合わせをすべて列挙しています。しかし、これでは王妃同士が攻撃できる配置も含まれてしまいます。

### 限定操作と分岐限定法

次に、各行・各列に 1 個の王妃を配置する組み合わせを列挙する関数を実装します：

```python
class EightQueen2:
    def __init__(self):
        self.result = []
        self.__pos = [0] * 8  # 各列の王妃の位置
        self.__flag = [False] * 8  # 各行に王妃が配置済みかのフラグ

    def put(self) -> None:
        """盤面（各列の王妃の位置）を出力"""
        row = []
        for i in range(8):
            row.append(self.__pos[i])
        self.result.append(row)

    def set(self, i: int) -> None:
        """i列目の適切な位置に王妃を配置"""
        for j in range(8):
            if not self.__flag[j]:  # j行目に王妃が配置されていない
                self.__pos[i] = j  # i列目の王妃をj行目に配置
                if i == 7:  # 全列に配置完了
                    self.put()
                else:
                    self.__flag[j] = True  # j行目に王妃を配置済みとマーク
                    self.set(i + 1)  # 次の列に進む
                    self.__flag[j] = False  # j行目の王妃を取り除く（バックトラック）
```

この実装では、各行に 1 個の王妃を配置するという制約を追加しています。しかし、対角線上の制約はまだ考慮されていません。

### 8 王妃問題を解くプログラム

最後に、すべての制約（行、列、対角線）を考慮した完全な解を求める関数を実装します：

```python
class EightQueen3:
    def __init__(self):
        self.result = []
        self.__pos = [0] * 8  # 各列の王妃の位置
        self.__flag_a = [False] * 8  # 各行に王妃が配置済みかのフラグ
        self.__flag_b = [False] * 15  # 右上がりの対角線に王妃が配置済みかのフラグ
        self.__flag_c = [False] * 15  # 右下がりの対角線に王妃が配置済みかのフラグ

    def put(self) -> None:
        """盤面（各列の王妃の位置）を出力"""
        row = []
        for i in range(8):
            row.append(self.__pos[i])
        self.result.append(row)

    def set(self, i: int) -> None:
        """i列目の適切な位置に王妃を配置"""
        for j in range(8):
            # j行目、i+j対角線、i-j+7対角線に王妃が配置されていない
            if (not self.__flag_a[j] and not self.__flag_b[i + j] and not self.__flag_c[i - j + 7]):
                self.__pos[i] = j  # i列目の王妃をj行目に配置
                if i == 7:  # 全列に配置完了
                    self.put()
                else:
                    # 各フラグを設定
                    self.__flag_a[j] = self.__flag_b[i + j] = self.__flag_c[i - j + 7] = True
                    self.set(i + 1)  # 次の列に進む
                    # 各フラグを解除（バックトラック）
                    self.__flag_a[j] = self.__flag_b[i + j] = self.__flag_c[i - j + 7] = False
```

#### フローチャート

以下は、8 王妃問題を解くアルゴリズムのフローチャートです：

```plantuml
@startuml
title 8王妃問題 (set メソッド)

start
:入力: 列番号 i;

repeat :j = 0 から 7 まで;
  if (j行目、i+j対角線、i-j+7対角線に王妃が配置されていない) then (はい)
    :__pos[i] = j;
    note right
      i列目の王妃をj行目に配置
    end note

    if (i == 7) then (はい)
      :put();
      note right
        解を記録
      end note
    else (いいえ)
      :__flag_a[j] = __flag_b[i + j] = __flag_c[i - j + 7] = True;
      note right
        各フラグを設定
      end note

      :set(i + 1);
      note right
        次の列に進む（再帰呼び出し）
      end note

      :__flag_a[j] = __flag_b[i + j] = __flag_c[i - j + 7] = False;
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

```python
class TestMazeSolve:
    def test_maze_solvable(self):
        maze = [
            [1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1],
            [1, 0, 1, 0, 1],
            [1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1],
        ]
        assert maze_solve(maze, 1, 1, 3, 3) is True
```

### Green — テストを通す実装

```python
def maze_solve(maze, row, col, goal_row, goal_col, visited=None):
    if visited is None:
        visited = set()
    if row == goal_row and col == goal_col:
        return True
    visited.add((row, col))
    for dr, dc in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
        nr, nc = row + dr, col + dc
        if (
            0 <= nr < len(maze) and 0 <= nc < len(maze[0])
            and maze[nr][nc] == 0
            and (nr, nc) not in visited
        ):
            if maze_solve(maze, nr, nc, goal_row, goal_col, visited):
                return True
    return False
```

---

## テスト実行結果

```bash
$ uv run pytest tests/test_recursion.py -v

...（17 テスト全パス）...

Name                        Stmts   Miss  Cover
-----------------------------------------------
src/algorithm/recursion.py     34      0   100%
-----------------------------------------------
17 passed in 0.12s
```

カバレッジ 100% 達成しました。

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

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
