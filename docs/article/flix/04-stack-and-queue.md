# 第 4 章 スタックとキュー

## 4.1 はじめに

第 3 章では配列からデータを探索しました。この章では、データを追加・取り出す順序を制御するデータ構造として、スタックとキューを実装します。スタックは LIFO（後入れ先出し）、キューは FIFO（先入れ先出し）です。

どちらも固定長配列を使います。Flix の配列は更新可能ですが、スタックポインターやキューの先頭・末尾・要素数は整数として明示的に受け渡します。操作後の状態を戻り値に含めることで、変更される配列と値として渡す状態の違いを確認できます。満杯・空・不正な状態は `Option` の `None` で表します。

### この章の TODO リスト

- [x] 固定長スタックで push、pop、peek を実装する
- [x] 空・満杯と容量 0 を扱う
- [x] リングバッファで enqueue、dequeue、peek を実装する
- [x] リングバッファの折り返しをテストする
- [x] 操作ごとの状態と計算量を確認する

## 4.2 固定長スタック

スタックは LIFO（Last In First Out）のデータ構造です。最後に追加した値を最初に取り出します。関数呼び出しの管理、深さ優先探索、式の評価などに利用されます。

### Red — LIFO と境界条件をテストする

`test/TestStackQueue.flix` にテストを追加します。以下では 3 つの値を積み、最後に積んだ値から取り出せることを確認します。

```flix
@Test
def stack_push_and_pop_lifo(): Unit \ Assert =
    region rc {
        let values = Array.repeat(rc, 3, 0);
        let firstSize = StackQueue.stackPush(1, values, 0);
        let secondSize = StackQueue.stackPush(2, values, 1);
        let thirdSize = StackQueue.stackPush(3, values, 2);
        Assert.assertEq(expected = Some(1), firstSize);
        Assert.assertEq(expected = Some(2), secondSize);
        Assert.assertEq(expected = Some(3), thirdSize);
        Assert.assertEq(expected = Some((3, 2)), StackQueue.stackPop(values, 3));
        Assert.assertEq(expected = Some((2, 1)), StackQueue.stackPop(values, 2));
        Assert.assertEq(expected = Some((1, 0)), StackQueue.stackPop(values, 1))
    }
```

配列は `Array.repeat(region, length, value)` の順に作ります。空のスタックからの `pop` と `peek`、満杯のスタックへの `push` が `None` になることもテストします。

### Green — 要素数をスタックポインターとして使う

`src/StackQueue.flix` にスタック操作を実装します。

```flix
pub def stackIsEmpty(size: Int32): Bool =
    size <= 0

pub def stackIsFull(size: Int32, values: Array[a, r]): Bool =
    size >= Array.length(values)

pub def stackPush(value: a, values: Array[a, r], size: Int32): Option[Int32] \ r =
    let capacity = Array.length(values);
    if (size < 0 or size >= capacity) {
        None
    } else {
        Array.put(value, size, values);
        Some(size + 1)
    }

pub def stackPop(values: Array[a, r], size: Int32): Option[(a, Int32)] \ r =
    if (size <= 0 or size > Array.length(values)) {
        None
    } else {
        let newSize = size - 1;
        Some((Array.get(newSize, values), newSize))
    }

pub def stackPeek(values: Array[a, r], size: Int32): Option[a] \ r =
    if (size <= 0 or size > Array.length(values))
        None
    else
        Some(Array.get(size - 1, values))
```

`size` はスタックに格納された要素数であり、次に push する配列位置でもあります。たとえば `size = 2` なら有効な要素は `values[0]` と `values[1]` で、次の値は `values[2]` に格納します。`pop` は要素数を 1 減らした位置から値を読み、`peek` は同じ値を読むだけで状態を変えません。

`Array.put` は配列を書き換えるため、`stackPush` の型には領域効果 `\ r` が現れます。戻り値は更新後の要素数で、容量超過や範囲外の状態では `None` です。`pop` も `Some((取り出した値, 更新後の要素数))` を返し、空または配列長を超える状態では `None` を返します。

各操作は配列の 1 要素だけを読み書きするため、`push`、`pop`、`peek` は O(1) 時間です。追加の配列領域はスタック容量分の O(n) ですが、操作ごとの追加領域は O(1) です。

## 4.3 リングバッファによるキュー

キューは FIFO（First In First Out）のデータ構造です。最初に追加した値を最初に取り出します。幅優先探索、タスク処理、イベントの順次処理などに利用されます。

配列の先頭から値を取り出すたびに残りの値を前へ移動する素朴な方法では、`dequeue` が O(n) になります。リングバッファでは `front`（次に取り出す位置）と `rear`（次に追加する位置）を持ち、配列の末尾の次を先頭として再利用します。要素数 `size` も管理し、空と満杯を区別します。

### Red — FIFO と末尾から先頭への折り返しをテストする

キューの状態は `(front, rear, size)` です。ここでは操作に必要な値を個別の引数で渡し、`enqueue` は更新後の `(rear, size)`、`dequeue` は `(値, front, size)` を返す設計にします。

```flix
@Test
def queue_wraps_around(): Unit \ Assert =
    region rc {
        let values = Array.repeat(rc, 3, 0);
        let first = StackQueue.queueEnqueue(1, values, 0, 0);
        let second = StackQueue.queueEnqueue(2, values, 1, 1);
        let third = StackQueue.queueEnqueue(3, values, 2, 2);
        Assert.assertEq(expected = Some((1, 1)), first);
        Assert.assertEq(expected = Some((2, 2)), second);
        Assert.assertEq(expected = Some((0, 3)), third);
        Assert.assertEq(expected = Some((1, 1, 2)), StackQueue.queueDequeue(values, 0, 3));
        Assert.assertEq(expected = Some((1, 3)), StackQueue.queueEnqueue(4, values, 0, 2));
        Assert.assertEq(expected = Some((2, 2, 2)), StackQueue.queueDequeue(values, 1, 3));
        Assert.assertEq(expected = Some((3, 0, 1)), StackQueue.queueDequeue(values, 2, 2));
        Assert.assertEq(expected = Some((4, 1, 0)), StackQueue.queueDequeue(values, 0, 1))
    }
```

### Green — front、rear、size を更新する

`src/StackQueue.flix` にキュー操作を追加します。

```flix
pub def queueIsEmpty(size: Int32): Bool =
    size <= 0

pub def queueIsFull(size: Int32, values: Array[a, r]): Bool =
    size >= Array.length(values)

pub def queueEnqueue(
    value: a,
    values: Array[a, r],
    rear: Int32,
    size: Int32
): Option[(Int32, Int32)] \ r =
    let capacity = Array.length(values);
    if (capacity <= 0 or rear < 0 or rear >= capacity or size < 0 or size >= capacity) {
        None
    } else {
        Array.put(value, rear, values);
        let newRear = if (rear + 1 == capacity) 0 else rear + 1;
        Some((newRear, size + 1))
    }

pub def queueDequeue(
    values: Array[a, r],
    front: Int32,
    size: Int32
): Option[(a, Int32, Int32)] \ r =
    let capacity = Array.length(values);
    if (capacity <= 0 or front < 0 or front >= capacity or size <= 0 or size > capacity) {
        None
    } else {
        let value = Array.get(front, values);
        let newFront = if (front + 1 == capacity) 0 else front + 1;
        Some((value, newFront, size - 1))
    }
```

`queueEnqueue` は `rear` の位置に値を保存してから、末尾に達した場合は `rear` を 0 に戻します。`queueDequeue` は `front` の値を読み、同じ規則で `front` を進めます。両方とも `size` を増減し、満杯・空や不正な添字では `None` を返します。配列長が 0 の場合は添字を計算したり配列へアクセスしたりしません。

`queuePeek` は `front` の値を返すだけで、`front` と `size` は変更しません。実装とテストは `src/StackQueue.flix` と `test/TestStackQueue.flix` にあります。

リングバッファの不変条件は、`0 <= front < capacity`、`0 <= rear < capacity`、`0 <= size <= capacity` です。キューが空か満杯かは `size` で判定するため、`front == rear` だけでは両者を区別できない問題を避けられます。呼び出し側は、各操作が返す状態を次の操作に引き継ぐ必要があります。

配列へのアクセスは各操作で定数回なので、`enqueue`、`dequeue`、`peek` は O(1) 時間です。リングバッファは追加の要素移動を行わず、固定された容量の配列を再利用します。

## 4.4 テストと計算量

次の境界条件をテストしています。

- スタックとキューの初期状態、空の状態、満杯の状態
- `peek` の前後で状態が変わらないこと
- スタックの LIFO とキューの FIFO
- キューの末尾から先頭への折り返し
- 容量 0 と範囲外の状態

```bash
make test
make check
make format-check
```

| 操作 | データ構造 | 時間 | 追加領域 |
|---|---|---:|---:|
| `push` / `pop` / `peek` | 固定長スタック | O(1) | O(1) |
| `enqueue` / `dequeue` / `peek` | リングバッファ | O(1) | O(1) |

上記の追加領域は操作ごとの追加領域です。スタックとキューを作る配列自体は、どちらも容量 n に対して O(n) の領域を使います。スタックでは最後に追加した値を、キューでは最初に追加した値を取り出すため、用途に応じて順序の規則を選びます。

## 4.5 まとめ

この章では、固定長配列と明示的な状態を使ってスタックとキューを実装しました。スタックは要素数を使って LIFO を実現し、キューは `front`、`rear`、`size` を使ったリングバッファで FIFO を実現します。

Flix では配列の更新に領域効果が必要ですが、状態を戻り値として明示することで操作の前後関係を追跡できます。また、`Option` によって空・満杯・不正な状態を通常の結果として表現し、配列範囲外アクセスを避けました。

次章では再帰の基底条件と再帰呼び出しを題材に、階乗、ユークリッドの互除法、ハノイの塔などを実装します。
