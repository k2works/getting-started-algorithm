# 第 8 章 リスト（連結リスト）

## はじめに

この章では **連結リスト** を学びます。配列は添字でランダムアクセスできますが、挿入・削除が O(n) かかります。連結リストはその逆で、ランダムアクセスは O(n) ですが、先頭への挿入・削除が O(1) で行えます。

---

## 1. 単方向連結リスト

各ノードが次のノードへのポインタを持ちます。

### Red — 失敗するテストを書く

```typescript
test('先頭に追加', () => { lst.addFirst(1); expect(lst.size).toBe(1); });
test('検索: 見つかる', () => {
  lst.addLast(10); lst.addLast(20);
  const node = lst.search(20);
  expect(node?.data).toBe(20);
});
test('先頭削除: 空リストで例外', () => { expect(() => lst.removeFirst()).toThrow(); });
```

### Green — 最小限の実装

```typescript
export class ListNode<T> {
  constructor(public data: T, public next: ListNode<T> | null = null) {}
}

export class LinkedList<T> {
  private head: ListNode<T> | null = null;
  private no = 0;

  addFirst(data: T): void {
    this.head = new ListNode<T>(data, this.head);
    this.no++;
  }

  removeFirst(): void {
    if (this.head === null) throw new Error('LinkedList is empty');
    this.head = this.head.next;
    this.no--;
  }
}
```

ジェネリクス `<T>` により、型安全なリストを実現します。

---

## 2. 双方向連結リスト（番兵ノード）

各ノードが前後のポインタを持ちます。番兵ノード（ダミー）により境界チェックを簡略化します。

```typescript
export class DoublyLinkedList<T> {
  private readonly sentinel: DNode<T>;

  constructor() {
    this.sentinel = new DNode<T>(null);
    this.sentinel.prev = this.sentinel;
    this.sentinel.next = this.sentinel;
  }

  addFirst(data: T): void {
    const node = new DNode<T>(data, this.sentinel, this.sentinel.next);
    this.sentinel.next!.prev = node;
    this.sentinel.next = node;
    this.no++;
  }

  remove(node: DNode<T>): void {
    if (this.isEmpty()) return;
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
    this.no--;
  }
}
```

番兵ノード（sentinel）を使うことで、先頭・末尾の特殊処理が不要になります。

---

## 3. カーソルによる線形リスト（配列版）

ポインタの代わりに配列の添字（カーソル）でリストを実現します。フリーリスト（削除済みスロット）を再利用します。

```typescript
export const NULL = -1;

export class ArrayLinkedList {
  head: number = NULL;
  n: ArrayNode[];

  addFirst(data: unknown): void {
    const ptr = this.head;
    const rec = this.getInsertIndex(); // 空きスロットを確保
    if (rec !== NULL) {
      this.head = rec;
      this.n[this.head] = new ArrayNode(data, ptr);
      this.no++;
    }
  }

  removeFirst(): void {
    if (this.head !== NULL) {
      const ptr = this.head;
      this.head = this.n[ptr].next;
      this.n[ptr].dnext = this.deleted; // フリーリストに追加
      this.deleted = ptr;
      this.no--;
    }
  }
}
```

---

## テスト実行結果

```bash
$ npm test tests/linked_list.test.ts

Tests:  34 passed, 34 total
```

---

## まとめ

| データ構造 | 先頭挿入 | 末尾挿入 | 検索 | メモリ |
|-----------|---------|---------|------|--------|
| 単方向連結リスト | O(1) | O(n) | O(n) | 少 |
| 双方向連結リスト | O(1) | O(1) | O(n) | 中（prev ポインタ分） |
| 配列カーソル版 | O(1) | O(n) | O(n) | 固定（配列サイズ分） |

## Python との比較

| 概念 | Python | TypeScript |
|------|--------|-----------|
| ジェネリクス | `class LinkedList[T]:` | `class LinkedList<T>` |
| Optional 型 | `_Node \| None` | `ListNode<T> \| null` |
| 内部例外クラス | `class Empty(Exception)` | `throw new Error(...)` |
| `__len__` | `def __len__(self)` | `get size()` |
| `__contains__` | `def __contains__(self, x)` | `contains(x)` |
| `__iter__` | `def __iter__(self)` | `toArray()` |

## 参考文献

- 『新・明解 Python で学ぶアルゴリズムとデータ構造』 — 柴田望洋
- 『テスト駆動開発』 — Kent Beck
