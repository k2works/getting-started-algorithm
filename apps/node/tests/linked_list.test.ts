/**
 * 第8章 リスト — テスト
 */
import {
  LinkedList,
  DoublyLinkedList,
  ArrayLinkedList,
  NULL,
} from '../src/algorithm/linked_list';

describe('線形リスト（単方向連結リスト）', () => {
  let lst: LinkedList<number>;
  beforeEach(() => { lst = new LinkedList<number>(); });

  test('初期状態は空', () => { expect(lst.size).toBe(0); expect(lst.isEmpty()).toBe(true); });
  test('先頭に追加', () => { lst.addFirst(1); expect(lst.size).toBe(1); });
  test('末尾に追加', () => { lst.addLast(1); lst.addLast(2); expect(lst.size).toBe(2); });
  test('検索: 見つかる', () => {
    lst.addLast(10); lst.addLast(20); lst.addLast(30);
    const node = lst.search(20);
    expect(node).not.toBeNull();
    expect(node?.data).toBe(20);
  });
  test('検索: 見つからない', () => { lst.addLast(10); expect(lst.search(99)).toBeNull(); });
  test('先頭削除', () => {
    lst.addLast(1); lst.addLast(2);
    lst.removeFirst();
    expect(lst.size).toBe(1);
    expect(lst.search(1)).toBeNull();
  });
  test('末尾削除', () => {
    lst.addLast(1); lst.addLast(2);
    lst.removeLast();
    expect(lst.size).toBe(1);
    expect(lst.search(2)).toBeNull();
  });
  test('ノード削除', () => {
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    const node = lst.search(2)!;
    lst.remove(node);
    expect(lst.search(2)).toBeNull();
    expect(lst.size).toBe(2);
  });
  test('contains', () => { lst.addLast(42); expect(lst.contains(42)).toBe(true); expect(lst.contains(0)).toBe(false); });
  test('先頭削除: 空リストで例外', () => { expect(() => lst.removeFirst()).toThrow(); });
  test('末尾削除: 空リストで例外', () => { expect(() => lst.removeLast()).toThrow(); });
  test('イテレータ', () => {
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    expect(lst.toArray()).toEqual([1, 2, 3]);
  });
  test('clear', () => { lst.addLast(1); lst.addLast(2); lst.clear(); expect(lst.isEmpty()).toBe(true); });
  test('単一要素リストの末尾削除', () => { lst.addLast(1); lst.removeLast(); expect(lst.isEmpty()).toBe(true); });
  test('複数要素リストの末尾削除', () => {
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    lst.removeLast();
    expect(lst.search(3)).toBeNull();
    expect(lst.size).toBe(2);
  });
});

describe('双方向連結リスト', () => {
  let lst: DoublyLinkedList<number>;
  beforeEach(() => { lst = new DoublyLinkedList<number>(); });

  test('初期状態は空', () => { expect(lst.size).toBe(0); expect(lst.isEmpty()).toBe(true); });
  test('先頭に追加', () => { lst.addFirst(1); expect(lst.size).toBe(1); });
  test('末尾に追加', () => { lst.addLast(1); lst.addLast(2); expect(lst.size).toBe(2); });
  test('検索', () => {
    lst.addLast(10); lst.addLast(20);
    const node = lst.search(20);
    expect(node).not.toBeNull();
    expect(node?.data).toBe(20);
  });
  test('検索: 見つからない', () => { expect(lst.search(99)).toBeNull(); });
  test('ノード削除', () => {
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    const node = lst.search(2)!;
    lst.remove(node);
    expect(lst.search(2)).toBeNull();
    expect(lst.size).toBe(2);
  });
  test('contains', () => { lst.addLast(42); expect(lst.contains(42)).toBe(true); expect(lst.contains(0)).toBe(false); });
  test('イテレータ', () => {
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    expect(lst.toArray()).toEqual([1, 2, 3]);
  });
  test('clear', () => { lst.addLast(1); lst.clear(); expect(lst.isEmpty()).toBe(true); });
});

describe('カーソルによる線形リスト（配列版）', () => {
  test('初期化', () => { const lst = new ArrayLinkedList(100); expect(lst.size).toBe(0); });
  test('先頭に追加', () => {
    const lst = new ArrayLinkedList(100);
    lst.addFirst(1); expect(lst.size).toBe(1);
    lst.addFirst(2); expect(lst.size).toBe(2);
  });
  test('先頭追加の順序', () => {
    const lst = new ArrayLinkedList(100);
    lst.addFirst(1); lst.addFirst(2); lst.addFirst(3);
    expect(lst.n[lst.head!].data).toBe(3);
  });
  test('末尾に追加', () => {
    const lst = new ArrayLinkedList(100);
    lst.addLast(1); expect(lst.size).toBe(1);
    lst.addLast(2); expect(lst.size).toBe(2);
  });
  test('末尾追加の順序', () => {
    const lst = new ArrayLinkedList(100);
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    expect(lst.n[lst.head!].data).toBe(1);
  });
  test('検索: 見つかる', () => {
    const lst = new ArrayLinkedList(100);
    lst.addLast(10); lst.addLast(20); lst.addLast(30);
    const idx = lst.search(20);
    expect(idx).not.toBe(NULL);
    expect(lst.n[idx!].data).toBe(20);
  });
  test('検索: 見つからない', () => {
    const lst = new ArrayLinkedList(100);
    lst.addLast(10);
    expect(lst.search(99)).toBe(NULL);
  });
  test('先頭削除', () => {
    const lst = new ArrayLinkedList(100);
    lst.addLast(1); lst.addLast(2); lst.addLast(3);
    lst.removeFirst();
    expect(lst.size).toBe(2);
    expect(lst.search(1)).toBe(NULL);
  });
  test('先頭削除: 空リストは何もしない', () => {
    const lst = new ArrayLinkedList(100);
    lst.removeFirst();
    expect(lst.size).toBe(0);
  });
  test('削除スロットの再利用', () => {
    const lst = new ArrayLinkedList(100);
    lst.addFirst(1); lst.addFirst(2);
    lst.removeFirst();
    lst.addFirst(3);
    expect(lst.size).toBe(2);
  });
});
