# 第 4 章 スタックとキュー

## はじめに

前章では探索アルゴリズムを学びました。この章では、データを特定の順序で格納・取り出すための基本的なデータ構造である「スタック」と「キュー」について TDD で実装します。

スタックとキューは、多くのアルゴリズムやプログラムの基礎となる重要なデータ構造です。これらの構造は、データの追加と削除の方法が異なり、それぞれ特定の問題に対して効率的な解決策を提供します。

### 目次

1. [スタック](#1-スタック)
2. [キュー](#2-キュー)
3. [スタックとキューの比較](#スタックとキューの比較)

---

## 1. スタック

スタックは **LIFO（Last In First Out）** — 後から入れたものを最初に取り出す — データ構造です。

皿を積み重ねるのに似ています。新しい皿は常に一番上に置かれ（プッシュ）、皿を取るときも一番上から取ります（ポップ）。

スタックの主な操作は以下の通りです：

- **プッシュ（Push）**: スタックの一番上にデータを追加する
- **ポップ（Pop）**: スタックの一番上からデータを取り出す
- **ピーク（Peek）**: スタックの一番上のデータを参照する（取り出さない）

スタックは、関数呼び出し、式の評価、構文解析、バックトラッキングなど、多くのアルゴリズムで使用されます。

### Red — 失敗するテストを書く

```python
# tests/test_stack_queue.py
class TestFixedStack:
    """固定長スタック"""

    def setup_method(self):
        self.stack = FixedStack(64)

    def test_initial_state(self):
        assert self.stack.is_empty() is True
        assert self.stack.is_full() is False

    def test_push_and_pop(self):
        self.stack.push(1)
        assert self.stack.pop() == 1

    def test_push_multiple(self):
        self.stack.push(1)
        self.stack.push(2)
        self.stack.push(3)
        assert self.stack.pop() == 3  # LIFO
```

### Green — テストを通す実装

```python
# src/algorithm/stack_queue.py
from typing import Any


class FixedStack:
    """固定長スタック"""

    class Empty(Exception):
        """スタックが空の場合の例外"""

    class Full(Exception):
        """スタックが満杯の場合の例外"""

    def __init__(self, capacity: int) -> None:
        self.stk: list[Any] = [None] * capacity
        self.capacity = capacity
        self.ptr = 0  # スタックポインタ（積まれた要素数）

    def push(self, value: Any) -> None:
        """スタックにvalueをプッシュ"""
        if self.is_full():
            raise FixedStack.Full
        self.stk[self.ptr] = value
        self.ptr += 1

    def pop(self) -> Any:
        """スタックからポップ"""
        if self.is_empty():
            raise FixedStack.Empty
        self.ptr -= 1
        return self.stk[self.ptr]

    def peek(self) -> Any:
        """スタックの先頭要素を参照（取り出さない）"""
        if self.is_empty():
            raise FixedStack.Empty
        return self.stk[self.ptr - 1]
```

### collections.deque を使った実装

Python の標準ライブラリである `collections.deque` を使って、より簡潔にスタックを実装することもできます：

```python
from collections import deque

class Stack:
    def __init__(self, maxlen: int = 256) -> None:
        self.capacity = maxlen
        self.__stk = deque([], maxlen)

    def __len__(self) -> int:
        return len(self.__stk)

    def is_empty(self) -> bool:
        return not self.__stk

    def is_full(self) -> bool:
        return len(self.__stk) == self.__stk.maxlen

    def push(self, value: Any) -> None:
        self.__stk.append(value)

    def pop(self) -> Any:
        return self.__stk.pop()

    def peek(self) -> Any:
        return self.__stk[-1]

    def clear(self) -> None:
        self.__stk.clear()

    def find(self, value: Any) -> Any:
        try:
            return self.__stk.index(value)
        except ValueError:
            return -1

    def count(self, value: Any) -> int:
        return self.__stk.count(value)

    def dump(self) -> Any:
        return list(self.__stk)
```

### 解説

スタックの実装には、主に以下の 2 つの方法があります：

1. **配列（リスト）を使った実装**：
   - 長所：シンプルで理解しやすい
   - 短所：固定長の場合、容量を超えるとエラーになる

2. **collections.deque を使った実装**：
   - 長所：Python の標準ライブラリを活用でき、コードが簡潔になる
   - 短所：内部実装の詳細が隠蔽されるため、学習目的では理解しにくい場合がある

どちらの実装も、スタックの基本操作（プッシュ、ポップ、ピーク）を提供します。また、便宜上、要素の検索や個数のカウントなどの追加機能も実装しています。

### アルゴリズムの考え方

```plantuml
@startuml
title スタック（LIFO）

start
:push(1), push(2), push(3);
note right
  stk = [1, 2, 3]
  ptr = 3
end note

:pop() → 3;
note right
  ptr -= 1 → 2
  return stk[2] = 3
end note

:pop() → 2;
note right
  ptr -= 1 → 1
  return stk[1] = 2
end note

:pop() → 1;
note right
  ptr -= 1 → 0
  return stk[0] = 1
end note
stop
@enduml
```

**主な操作**:

| 操作 | メソッド | 計算量 | 説明 |
|------|---------|--------|------|
| プッシュ | `push(value)` | O(1) | 頂上に追加 |
| ポップ | `pop()` | O(1) | 頂上から取り出す |
| ピーク | `peek()` | O(1) | 頂上を参照（取り出さない） |
| 探索 | `find(value)` | O(n) | 値のインデックスを返す |
| カウント | `count(value)` | O(n) | 値の出現回数 |

### フローチャート

#### スタックのプッシュ操作

以下は、スタックのプッシュ操作のフローチャートです：

```plantuml
@startuml
title スタックのプッシュ操作 (push)

start
:入力: 追加する値 value;

if (スタックは満杯か？) then (はい)
  :例外 Full を発生;
  stop
endif

:stk[ptr] = value;
:ptr += 1;

stop
@enduml
```

この図は、スタックのプッシュ操作（FixedStack クラスの push メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 追加する値 value を入力として受け取ります
2. スタックが満杯かどうかをチェックします
   - 満杯の場合、例外 Full を発生させて終了します
3. スタック配列の現在のポインタ位置に value を格納します
4. ポインタを 1 増やします（次の格納位置を指すように）

#### スタックのポップ操作

以下は、スタックのポップ操作のフローチャートです：

```plantuml
@startuml
title スタックのポップ操作 (pop)

start

if (スタックは空か？) then (はい)
  :例外 Empty を発生;
  stop
endif

:ptr -= 1;
:return stk[ptr];

stop
@enduml
```

この図は、スタックのポップ操作（FixedStack クラスの pop メソッド）のフローチャートです。

アルゴリズムの流れ：
1. スタックが空かどうかをチェックします
   - 空の場合、例外 Empty を発生させて終了します
2. ポインタを 1 減らします（最後に追加された要素の位置を指すように）
3. スタック配列のポインタ位置の値を返します

#### スタックのピーク操作

以下は、スタックのピーク操作のフローチャートです：

```plantuml
@startuml
title スタックのピーク操作 (peek)

start

if (スタックは空か？) then (はい)
  :例外 Empty を発生;
  stop
endif

:return stk[ptr - 1];

stop
@enduml
```

この図は、スタックのピーク操作（FixedStack クラスの peek メソッド）のフローチャートです。

アルゴリズムの流れ：
1. スタックが空かどうかをチェックします
   - 空の場合、例外 Empty を発生させて終了します
2. スタック配列の ptr - 1 位置（最後に追加された要素の位置）の値を返します
   - ポインタは変更せず、値の参照のみを行います

スタックの基本操作は非常にシンプルで効率的です。すべての操作が O(1) の時間複雑度で実行できるため、多くのアルゴリズムで活用されています。

---

## 2. キュー

キューは **FIFO（First In First Out）** — 最初に入れたものを最初に取り出す — データ構造です。

銀行の行列をイメージすると分かりやすいです。新しい人は列の最後尾に並び（エンキュー）、サービスを受けるのは列の先頭の人からです（デキュー）。

キューの主な操作は以下の通りです：

- **エンキュー（Enqueue）**: キューの末尾にデータを追加する
- **デキュー（Dequeue）**: キューの先頭からデータを取り出す
- **ピーク（Peek）**: キューの先頭のデータを参照する（取り出さない）

キューは、幅優先探索、プリンタのスプーリング、プロセススケジューリングなど、多くのアルゴリズムやシステムで使用されます。

### 単純な配列によるキューの実現

単純な配列を使ってキューを実装する場合、デキュー操作を行うたびに残りの要素をシフトする必要があり、効率が悪くなります（O(n) の時間複雑度）。そのため、実用的なキューの実装には、リングバッファを使用することが一般的です。

### リングバッファ

固定長配列でキューを実現する際、素朴な実装では先頭要素を取り出すたびにすべての要素をシフトする必要があり O(n) のコストがかかります。

**リングバッファ**を使うと、`front`（先頭インデックス）と `rear`（末尾インデックス）を管理することで、エンキュー・デキューを O(1) で実現できます。

```plantuml
@startuml
title リングバッファの動作

start
:enque(1), enque(2), enque(3);
note right
  que = [1, 2, 3]
  front=0, rear=3, num=3
end note

:deque() → 1;
note right
  front = 1 (折り返しなし)
  num = 2
end note

:enque(4) （折り返し）;
note right
  rear = 4 → 0 (capacity=4のとき)
  que = [4, 2, 3, _]
  front=1, rear=0, num=3
end note
stop
@enduml
```

### Red — 失敗するテストを書く

```python
class TestFixedQueue:
    """固定長キュー（リングバッファ）"""

    def test_enque_multiple(self):
        self.queue.enque(1)
        self.queue.enque(2)
        self.queue.enque(3)
        assert self.queue.deque() == 1  # FIFO

    def test_ring_buffer_wrap_around(self):
        """リングバッファの折り返し動作確認"""
        small = FixedQueue(3)
        small.enque(1)
        small.enque(2)
        small.enque(3)
        small.deque()  # 1 を取り出す
        small.enque(4)  # 空き位置（先頭）に追加
        assert small.deque() == 2
        assert small.deque() == 3
        assert small.deque() == 4
```

### Green — テストを通す実装

```python
class FixedQueue:
    """固定長キュー（リングバッファ）"""

    def __init__(self, capacity: int) -> None:
        self.que: list[Any] = [None] * capacity
        self.capacity = capacity
        self.front = 0   # 先頭インデックス
        self.rear = 0    # 末尾インデックス
        self.num = 0     # キューに積まれた要素数

    def enque(self, value: Any) -> None:
        """キューにvalueをエンキュー"""
        if self.is_full():
            raise FixedQueue.Full
        self.que[self.rear] = value
        self.rear += 1
        self.num += 1
        if self.rear == self.capacity:
            self.rear = 0  # リングバッファの折り返し

    def deque(self) -> Any:
        """キューからデキュー"""
        if self.is_empty():
            raise FixedQueue.Empty
        value = self.que[self.front]
        self.front += 1
        self.num -= 1
        if self.front == self.capacity:
            self.front = 0  # リングバッファの折り返し
        return value
```

### 解説

キューの実装には、主に以下の 2 つの方法があります：

1. **単純な配列を使った実装**：
   - 長所：シンプルで理解しやすい
   - 短所：デキュー操作が非効率（O(n) の時間複雑度）

2. **リングバッファを使った実装**：
   - 長所：すべての操作が効率的（O(1) の時間複雑度）
   - 短所：実装がやや複雑

リングバッファを使った実装では、`front` と `rear` の 2 つのポインタを使用して、キューの先頭と末尾を追跡します。これにより、配列の物理的な終端に達した後も、論理的に連続したキューを維持することができます。

Python の標準ライブラリには、`collections.deque` というクラスがあり、これを使ってキューを簡単に実装することもできます。`deque` は両端キュー（デック）として機能し、両端からの追加と削除を効率的に行うことができます。

### フローチャート

#### キューのエンキュー操作

以下は、リングバッファを使ったキューのエンキュー操作のフローチャートです：

```plantuml
@startuml
title キューのエンキュー操作 (enque)

start
:入力: 追加する値 x;

if (キューは満杯か？) then (はい)
  :例外 Full を発生;
  stop
endif

:que[rear] = x;
:rear += 1;
:num += 1;

if (rear == capacity) then (はい)
  :rear = 0;
endif

stop
@enduml
```

この図は、リングバッファを使ったキューのエンキュー操作（FixedQueue クラスの enque メソッド）のフローチャートです。

アルゴリズムの流れ：
1. 追加する値 x を入力として受け取ります
2. キューが満杯かどうかをチェックします
   - 満杯の場合、例外 Full を発生させて終了します
3. キュー配列の rear 位置（末尾）に x を格納します
4. rear を 1 増やします（次の格納位置を指すように）
5. num（格納されているデータ数）を 1 増やします
6. rear が capacity（キューの容量）に達した場合、rear を 0 にリセットします（リングバッファの先頭に戻る）

#### キューのデキュー操作

以下は、リングバッファを使ったキューのデキュー操作のフローチャートです：

```plantuml
@startuml
title キューのデキュー操作 (deque)

start

if (キューは空か？) then (はい)
  :例外 Empty を発生;
  stop
endif

:x = que[front];
:front += 1;
:num -= 1;

if (front == capacity) then (はい)
  :front = 0;
endif

:return x;

stop
@enduml
```

この図は、リングバッファを使ったキューのデキュー操作（FixedQueue クラスの deque メソッド）のフローチャートです。

アルゴリズムの流れ：
1. キューが空かどうかをチェックします
   - 空の場合、例外 Empty を発生させて終了します
2. キュー配列の front 位置（先頭）の値を変数 x に格納します
3. front を 1 増やします（次の要素を指すように）
4. num（格納されているデータ数）を 1 減らします
5. front が capacity（キューの容量）に達した場合、front を 0 にリセットします（リングバッファの先頭に戻る）
6. 取り出した値 x を返します

#### キューのピーク操作

以下は、リングバッファを使ったキューのピーク操作のフローチャートです：

```plantuml
@startuml
title キューのピーク操作 (peek)

start

if (キューは空か？) then (はい)
  :例外 Empty を発生;
  stop
endif

:return que[front];

stop
@enduml
```

この図は、リングバッファを使ったキューのピーク操作（FixedQueue クラスの peek メソッド）のフローチャートです。

アルゴリズムの流れ：
1. キューが空かどうかをチェックします
   - 空の場合、例外 Empty を発生させて終了します
2. キュー配列の front 位置（先頭）の値を返します
   - ポインタは変更せず、値の参照のみを行います

リングバッファを使ったキューの実装は、すべての操作が O(1) の時間複雑度で実行できるため、効率的です。また、配列の物理的な終端に達した後も、論理的に連続したキューを維持できる点が大きな利点です。

---

## テスト実行結果

```bash
$ uv run pytest tests/test_stack_queue.py -v

...（35 テスト全パス）...

Name                              Stmts   Miss  Cover
-----------------------------------------------------
src/algorithm/stack_queue.py      102      0   100%
-----------------------------------------------------
35 passed in 0.20s
```

カバレッジ 100% 達成しました。

---

## スタックとキューの比較

| 項目 | スタック | キュー |
|------|---------|--------|
| 取り出し順序 | LIFO（後入れ先出し） | FIFO（先入れ先出し） |
| 追加操作 | `push()` | `enque()` |
| 取り出し操作 | `pop()` | `deque()` |
| 主な用途 | 関数呼び出し、DFS | タスクキュー、BFS |
| 計算量（追加/取り出し） | O(1) | O(1) |

## まとめ

この章では、2 つの基本的なデータ構造、スタックとキューについて学びました：

1. **スタック**：後入れ先出し（LIFO）の原則に従うデータ構造。主な操作はプッシュ、ポップ、ピーク。

2. **キュー**：先入れ先出し（FIFO）の原則に従うデータ構造。主な操作はエンキュー、デキュー、ピーク。

これらのデータ構造は、それぞれ異なる問題に対して効率的な解決策を提供します。スタックは関数呼び出しや式の評価に適しており、キューは幅優先探索やプロセススケジューリングに適しています。

テスト駆動開発の手法を用いることで、これらのデータ構造の正確な実装と理解を深めることができました。

次の章では、再帰アルゴリズムについて学んでいきましょう。

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
