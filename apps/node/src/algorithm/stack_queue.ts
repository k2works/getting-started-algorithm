/**
 * 第4章 スタックとキュー
 */

/** 固定長スタック */
export class FixedStack<T> {
  private stk: (T | null)[];
  private ptr: number = 0;

  constructor(public readonly capacity: number) {
    this.stk = new Array(capacity).fill(null);
  }

  isEmpty(): boolean {
    return this.ptr <= 0;
  }

  isFull(): boolean {
    return this.ptr >= this.capacity;
  }

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

  find(value: T): number {
    for (let i = this.ptr - 1; i >= 0; i--) {
      if (this.stk[i] === value) return i;
    }
    return -1;
  }

  count(value: T): number {
    return this.stk.slice(0, this.ptr).filter((v) => v === value).length;
  }

  contains(value: T): boolean {
    return this.find(value) !== -1;
  }

  clear(): void {
    this.ptr = 0;
  }

  size(): number {
    return this.ptr;
  }
}

/** 固定長キュー（リングバッファ） */
export class FixedQueue<T> {
  private que: (T | null)[];
  private front: number = 0;
  private rear: number = 0;
  private num: number = 0;

  constructor(public readonly capacity: number) {
    this.que = new Array(capacity).fill(null);
  }

  isEmpty(): boolean {
    return this.num <= 0;
  }

  isFull(): boolean {
    return this.num >= this.capacity;
  }

  enqueue(value: T): void {
    if (this.isFull()) throw new Error('Queue is full');
    this.que[this.rear] = value;
    this.rear++;
    this.num++;
    if (this.rear === this.capacity) this.rear = 0;
  }

  dequeue(): T {
    if (this.isEmpty()) throw new Error('Queue is empty');
    const value = this.que[this.front] as T;
    this.front++;
    this.num--;
    if (this.front === this.capacity) this.front = 0;
    return value;
  }

  peek(): T {
    if (this.isEmpty()) throw new Error('Queue is empty');
    return this.que[this.front] as T;
  }

  find(value: T): number {
    for (let i = 0; i < this.num; i++) {
      const idx = (i + this.front) % this.capacity;
      if (this.que[idx] === value) return i;
    }
    return -1;
  }

  count(value: T): number {
    let c = 0;
    for (let i = 0; i < this.num; i++) {
      if (this.que[(i + this.front) % this.capacity] === value) c++;
    }
    return c;
  }

  contains(value: T): boolean {
    return this.find(value) !== -1;
  }

  clear(): void {
    this.front = this.rear = this.num = 0;
  }

  size(): number {
    return this.num;
  }
}
