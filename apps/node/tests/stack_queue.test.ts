/**
 * 第4章 スタックとキュー — テスト
 */
import { FixedStack, FixedQueue } from '../src/algorithm/stack_queue';

describe('固定長スタック', () => {
  let stack: FixedStack<number>;

  beforeEach(() => {
    stack = new FixedStack(64);
  });

  test('初期状態: 空で満杯でない', () => {
    expect(stack.isEmpty()).toBe(true);
    expect(stack.isFull()).toBe(false);
  });

  test('push して peek', () => {
    stack.push(1);
    expect(stack.peek()).toBe(1);
  });

  test('push して pop', () => {
    stack.push(1);
    expect(stack.pop()).toBe(1);
  });

  test('LIFO 順序', () => {
    stack.push(1);
    stack.push(2);
    stack.push(3);
    expect(stack.pop()).toBe(3);
    expect(stack.pop()).toBe(2);
    expect(stack.pop()).toBe(1);
  });

  test('満杯判定', () => {
    const small = new FixedStack<number>(3);
    small.push(1);
    small.push(2);
    small.push(3);
    expect(small.isFull()).toBe(true);
  });

  test('空のスタックから pop すると例外', () => {
    expect(() => stack.pop()).toThrow('Stack is empty');
  });

  test('満杯のスタックに push すると例外', () => {
    const small = new FixedStack<number>(2);
    small.push(1);
    small.push(2);
    expect(() => small.push(3)).toThrow('Stack is full');
  });

  test('空のスタックを peek すると例外', () => {
    expect(() => stack.peek()).toThrow('Stack is empty');
  });

  test('find: 底から検索', () => {
    stack.push(10);
    stack.push(20);
    stack.push(30);
    expect(stack.find(20)).toBe(1);
  });

  test('find: 存在しない場合は -1', () => {
    stack.push(10);
    expect(stack.find(99)).toBe(-1);
  });

  test('count: 同じ値の個数', () => {
    stack.push(5);
    stack.push(5);
    stack.push(10);
    expect(stack.count(5)).toBe(2);
    expect(stack.count(10)).toBe(1);
    expect(stack.count(99)).toBe(0);
  });

  test('contains: 包含判定', () => {
    stack.push(42);
    expect(stack.contains(42)).toBe(true);
    expect(stack.contains(0)).toBe(false);
  });

  test('clear: スタックを空にする', () => {
    stack.push(1);
    stack.push(2);
    stack.clear();
    expect(stack.isEmpty()).toBe(true);
  });

  test('size: 要素数', () => {
    stack.push(1);
    stack.push(2);
    expect(stack.size()).toBe(2);
  });

  test('capacity: 容量', () => {
    expect(stack.capacity).toBe(64);
  });
});

describe('固定長キュー（リングバッファ）', () => {
  let queue: FixedQueue<number>;

  beforeEach(() => {
    queue = new FixedQueue(64);
  });

  test('初期状態: 空で満杯でない', () => {
    expect(queue.isEmpty()).toBe(true);
    expect(queue.isFull()).toBe(false);
  });

  test('enqueue して dequeue', () => {
    queue.enqueue(1);
    expect(queue.dequeue()).toBe(1);
  });

  test('FIFO 順序', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);
    expect(queue.dequeue()).toBe(1);
    expect(queue.dequeue()).toBe(2);
    expect(queue.dequeue()).toBe(3);
  });

  test('peek: 先頭要素を参照', () => {
    queue.enqueue(10);
    queue.enqueue(20);
    expect(queue.peek()).toBe(10);
  });

  test('満杯判定', () => {
    const small = new FixedQueue<number>(3);
    small.enqueue(1);
    small.enqueue(2);
    small.enqueue(3);
    expect(small.isFull()).toBe(true);
  });

  test('空のキューから dequeue すると例外', () => {
    expect(() => queue.dequeue()).toThrow('Queue is empty');
  });

  test('満杯のキューに enqueue すると例外', () => {
    const small = new FixedQueue<number>(2);
    small.enqueue(1);
    small.enqueue(2);
    expect(() => small.enqueue(3)).toThrow('Queue is full');
  });

  test('空のキューを peek すると例外', () => {
    expect(() => queue.peek()).toThrow('Queue is empty');
  });

  test('find: 先頭からの検索', () => {
    queue.enqueue(10);
    queue.enqueue(20);
    queue.enqueue(30);
    expect(queue.find(10)).toBe(0);
  });

  test('find: 存在しない場合は -1', () => {
    queue.enqueue(10);
    expect(queue.find(99)).toBe(-1);
  });

  test('count: 同じ値の個数', () => {
    queue.enqueue(5);
    queue.enqueue(5);
    queue.enqueue(10);
    expect(queue.count(5)).toBe(2);
  });

  test('contains: 包含判定', () => {
    queue.enqueue(42);
    expect(queue.contains(42)).toBe(true);
    expect(queue.contains(0)).toBe(false);
  });

  test('clear: キューを空にする', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    queue.clear();
    expect(queue.isEmpty()).toBe(true);
  });

  test('size: 要素数', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    expect(queue.size()).toBe(2);
  });

  test('capacity: 容量', () => {
    expect(queue.capacity).toBe(64);
  });

  test('リングバッファの折り返し動作', () => {
    const small = new FixedQueue<number>(3);
    small.enqueue(1);
    small.enqueue(2);
    small.enqueue(3);
    small.dequeue(); // 1 を取り出す
    small.enqueue(4); // 空き位置（先頭）に追加
    expect(small.dequeue()).toBe(2);
    expect(small.dequeue()).toBe(3);
    expect(small.dequeue()).toBe(4);
  });
});
