# 第 4 章 スタックとキュー

## はじめに

この章では、データ構造の基本である「スタック」と「キュー」を TypeScript で TDD 実装します。スタックは LIFO（後入れ先出し）、キューは FIFO（先入れ先出し）という特性を持ちます。

---

## 1. スタック（固定長）

### Red — 失敗するテストを書く

```typescript
describe('固定長スタック', () => {
  let stack: FixedStack<number>;

  beforeEach(() => {
    stack = new FixedStack(64);
  });

  test('初期状態: 空で満杯でない', () => {
    expect(stack.isEmpty()).toBe(true);
    expect(stack.isFull()).toBe(false);
  });

  test('LIFO 順序', () => {
    stack.push(1); stack.push(2); stack.push(3);
    expect(stack.pop()).toBe(3);
    expect(stack.pop()).toBe(2);
    expect(stack.pop()).toBe(1);
  });

  test('空のスタックから pop すると例外', () => {
    expect(() => stack.pop()).toThrow('Stack is empty');
  });
});
```

### Green — テストを通す最小限の実装

```typescript
export class FixedStack<T> {
  private stk: (T | null)[];
  private ptr: number = 0;

  constructor(public readonly capacity: number) {
    this.stk = new Array(capacity).fill(null);
  }

  isEmpty(): boolean { return this.ptr <= 0; }
  isFull(): boolean { return this.ptr >= this.capacity; }

  push(value: T): void {
    if (this.isFull()) throw new Error('Stack is full');
    this.stk[this.ptr++] = value;
  }

  pop(): T {
    if (this.isEmpty()) throw new Error('Stack is empty');
    return this.stk[--this.ptr] as T;
  }

  peek(): T {
    if (this.isEmpty()) throw new Error('Stack is empty');
    return this.stk[this.ptr - 1] as T;
  }
}
```

### Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| 例外クラス | 内部クラス `FixedStack.Empty` | `Error('Stack is empty')` |
| `__len__` | `def __len__(self)` | `size()` メソッド |
| `__contains__` | `def __contains__(self, v)` | `contains(v)` メソッド |
| 型アノテーション | `list[Any]` | `(T \| null)[]` ジェネリクス |

Python では内部クラス `FixedStack.Empty` で例外を定義しますが、TypeScript では `new Error('Stack is empty')` を throw します。

---

## 2. キュー（固定長・リングバッファ）

キューはリングバッファで実装します。`front`（先頭）と `rear`（末尾）の 2 つのポインタを管理します。

### Red — 失敗するテストを書く

```typescript
test('FIFO 順序', () => {
  queue.enqueue(1); queue.enqueue(2); queue.enqueue(3);
  expect(queue.dequeue()).toBe(1);
  expect(queue.dequeue()).toBe(2);
  expect(queue.dequeue()).toBe(3);
});

test('リングバッファの折り返し動作', () => {
  const small = new FixedQueue<number>(3);
  small.enqueue(1); small.enqueue(2); small.enqueue(3);
  small.dequeue(); // 1 を取り出す
  small.enqueue(4); // 空き位置（先頭）に追加
  expect(small.dequeue()).toBe(2);
  expect(small.dequeue()).toBe(3);
  expect(small.dequeue()).toBe(4);
});
```

### Green — テストを通す最小限の実装

```typescript
export class FixedQueue<T> {
  private que: (T | null)[];
  private front: number = 0;
  private rear: number = 0;
  private num: number = 0;

  constructor(public readonly capacity: number) {
    this.que = new Array(capacity).fill(null);
  }

  enqueue(value: T): void {
    if (this.isFull()) throw new Error('Queue is full');
    this.que[this.rear] = value;
    this.rear++;
    this.num++;
    if (this.rear === this.capacity) this.rear = 0; // 折り返し
  }

  dequeue(): T {
    if (this.isEmpty()) throw new Error('Queue is empty');
    const value = this.que[this.front] as T;
    this.front++;
    this.num--;
    if (this.front === this.capacity) this.front = 0; // 折り返し
    return value;
  }
}
```

### リングバッファの動作イメージ

```
容量 3 のリングバッファ

初期状態: [_, _, _]  front=0, rear=0, num=0
enqueue(1): [1, _, _]  front=0, rear=1, num=1
enqueue(2): [1, 2, _]  front=0, rear=2, num=2
enqueue(3): [1, 2, 3]  front=0, rear=0(折返), num=3
dequeue():  [_, 2, 3]  front=1, rear=0, num=2  → 1 を返す
enqueue(4): [4, 2, 3]  front=1, rear=1(折返), num=3
dequeue():  [4, _, 3]  front=2, rear=1, num=2  → 2 を返す
```

---

## 3. dump — スタック・キューの内容を配列で返す

`dump()` はデバッグや検証に使うユーティリティメソッドです。

```typescript
// FixedStack
dump(): T[] {
  return this.stk.slice(0, this.ptr) as T[];
}

// FixedQueue（リングバッファ折り返しを考慮）
dump(): T[] {
  return Array.from({ length: this.num }, (_, i) =>
    this.que[(i + this.front) % this.capacity] as T,
  );
}
```

```typescript
test('dump: スタック内容を配列で返す', () => {
  stack.push(1); stack.push(2); stack.push(3);
  expect(stack.dump()).toEqual([1, 2, 3]);
});

test('dump: リングバッファ折り返し後も正しい順序', () => {
  const small = new FixedQueue<number>(3);
  small.enqueue(1); small.enqueue(2); small.enqueue(3);
  small.dequeue();
  small.enqueue(4);
  expect(small.dump()).toEqual([2, 3, 4]);
});
```

---

## テスト実行結果

```bash
$ npm test tests/stack_queue.test.ts

Tests: 37 passed, 37 total
```

---

## スタックとキューの比較

| 項目 | スタック | キュー |
|------|---------|--------|
| 取り出し順序 | LIFO（後入れ先出し） | FIFO（先入れ先出し） |
| 追加操作 | `push()` | `enqueue()` |
| 取り出し操作 | `pop()` | `dequeue()` |
| 主な用途 | 関数呼び出し、DFS | タスクキュー、BFS |
| 計算量（追加/取り出し） | O(1) | O(1) |

---

## まとめ

| データ構造 | クラス | 特性 | 計算量 |
|-----------|--------|------|--------|
| スタック | `FixedStack<T>` | LIFO | push/pop O(1) |
| キュー | `FixedQueue<T>` | FIFO | enqueue/dequeue O(1) |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
