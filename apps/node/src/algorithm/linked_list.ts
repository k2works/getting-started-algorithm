/**
 * 第8章 リスト（連結リスト）
 */

// ─── 単方向連結リスト ────────────────────────────────────────

export class ListNode<T> {
  constructor(public data: T, public next: ListNode<T> | null = null) {}
}

/** 線形リスト（単方向連結リスト） */
export class LinkedList<T> {
  private head: ListNode<T> | null = null;
  private no = 0;

  get size(): number { return this.no; }

  isEmpty(): boolean { return this.head === null; }

  contains(data: T): boolean { return this.search(data) !== null; }

  search(data: T): ListNode<T> | null {
    let ptr = this.head;
    while (ptr !== null) {
      if (ptr.data === data) return ptr;
      ptr = ptr.next;
    }
    return null;
  }

  addFirst(data: T): void {
    this.head = new ListNode<T>(data, this.head);
    this.no++;
  }

  addLast(data: T): void {
    if (this.head === null) {
      this.head = new ListNode<T>(data);
    } else {
      let ptr = this.head;
      while (ptr.next !== null) ptr = ptr.next;
      ptr.next = new ListNode<T>(data);
    }
    this.no++;
  }

  removeFirst(): void {
    if (this.head === null) throw new Error('LinkedList is empty');
    this.head = this.head.next;
    this.no--;
  }

  removeLast(): void {
    if (this.head === null) throw new Error('LinkedList is empty');
    if (this.head.next === null) {
      this.head = null;
    } else {
      let ptr = this.head;
      while (ptr.next !== null && ptr.next.next !== null) ptr = ptr.next;
      ptr.next = null;
    }
    this.no--;
  }

  remove(node: ListNode<T>): void {
    if (this.head === null) return;
    if (this.head === node) {
      this.head = this.head.next;
      this.no--;
      return;
    }
    let ptr = this.head;
    while (ptr.next !== null) {
      if (ptr.next === node) {
        ptr.next = node.next;
        this.no--;
        return;
      }
      ptr = ptr.next;
    }
  }

  clear(): void { this.head = null; this.no = 0; }

  toArray(): T[] {
    const result: T[] = [];
    let ptr = this.head;
    while (ptr !== null) { result.push(ptr.data); ptr = ptr.next; }
    return result;
  }
}

// ─── 双方向連結リスト ────────────────────────────────────────

export class DNode<T> {
  constructor(
    public data: T | null = null,
    public prev: DNode<T> | null = null,
    public next: DNode<T> | null = null,
  ) {}
}

/** 双方向連結リスト（番兵ノード使用） */
export class DoublyLinkedList<T> {
  private readonly sentinel: DNode<T>;
  private no = 0;

  constructor() {
    this.sentinel = new DNode<T>(null);
    this.sentinel.prev = this.sentinel;
    this.sentinel.next = this.sentinel;
  }

  get size(): number { return this.no; }

  isEmpty(): boolean { return this.no === 0; }

  contains(data: T): boolean { return this.search(data) !== null; }

  search(data: T): DNode<T> | null {
    let ptr = this.sentinel.next!;
    while (ptr !== this.sentinel) {
      if (ptr.data === data) return ptr;
      ptr = ptr.next!;
    }
    return null;
  }

  addFirst(data: T): void {
    const node = new DNode<T>(data, this.sentinel, this.sentinel.next);
    this.sentinel.next!.prev = node;
    this.sentinel.next = node;
    this.no++;
  }

  addLast(data: T): void {
    const node = new DNode<T>(data, this.sentinel.prev, this.sentinel);
    this.sentinel.prev!.next = node;
    this.sentinel.prev = node;
    this.no++;
  }

  remove(node: DNode<T>): void {
    if (this.isEmpty()) return;
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
    this.no--;
  }

  clear(): void {
    this.sentinel.prev = this.sentinel;
    this.sentinel.next = this.sentinel;
    this.no = 0;
  }

  toArray(): T[] {
    const result: T[] = [];
    let ptr = this.sentinel.next!;
    while (ptr !== this.sentinel) { result.push(ptr.data as T); ptr = ptr.next!; }
    return result;
  }
}

// ─── カーソルによる線形リスト（配列版） ──────────────────────

export const NULL = -1;

export class ArrayNode {
  constructor(
    public data: unknown = null,
    public next: number = NULL,
    public dnext: number = NULL,
  ) {}
}

/** 線形リスト（配列カーソル版） */
export class ArrayLinkedList {
  head: number = NULL;
  private current: number = NULL;
  private max: number = NULL;
  private deleted: number = NULL;
  private capacity: number;
  n: ArrayNode[];
  private no = 0;

  constructor(capacity: number) {
    this.capacity = capacity;
    this.n = Array.from({ length: capacity }, () => new ArrayNode());
  }

  get size(): number { return this.no; }

  private getInsertIndex(): number {
    if (this.deleted === NULL) {
      if (this.max + 1 < this.capacity) {
        this.max++;
        return this.max;
      }
      return NULL;
    }
    const rec = this.deleted;
    this.deleted = this.n[rec].dnext;
    return rec;
  }

  addFirst(data: unknown): void {
    const ptr = this.head;
    const rec = this.getInsertIndex();
    if (rec !== NULL) {
      this.head = this.current = rec;
      this.n[this.head] = new ArrayNode(data, ptr);
      this.no++;
    }
  }

  addLast(data: unknown): void {
    if (this.head === NULL) {
      this.addFirst(data);
    } else {
      let ptr = this.head;
      while (this.n[ptr].next !== NULL) ptr = this.n[ptr].next;
      const rec = this.getInsertIndex();
      if (rec !== NULL) {
        this.n[ptr].next = this.current = rec;
        this.n[rec] = new ArrayNode(data);
        this.no++;
      }
    }
  }

  search(data: unknown): number {
    let ptr = this.head;
    while (ptr !== NULL) {
      if (this.n[ptr].data === data) { this.current = ptr; return ptr; }
      ptr = this.n[ptr].next;
    }
    return NULL;
  }

  removeFirst(): void {
    if (this.head !== NULL) {
      const ptr = this.head;
      this.head = this.current = this.n[ptr].next;
      this.n[ptr].dnext = this.deleted;
      this.deleted = ptr;
      this.no--;
    }
  }
}
