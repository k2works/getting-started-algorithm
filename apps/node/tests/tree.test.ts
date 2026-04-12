/**
 * 第9章 木構造 — テスト
 */
import { BinarySearchTree } from '../src/algorithm/tree';

describe('二分探索木', () => {
  let bst: BinarySearchTree<number>;
  beforeEach(() => { bst = new BinarySearchTree<number>(); });

  test('初期状態は空', () => { expect(bst.isEmpty()).toBe(true); });
  test('挿入と検索', () => {
    bst.insert(5);
    expect(bst.search(5)).not.toBeNull();
    expect(bst.search(5)?.key).toBe(5);
  });
  test('検索: 見つからない', () => { expect(bst.search(99)).toBeNull(); });
  test('複数挿入と検索', () => {
    [5, 3, 7, 1, 4, 6, 8].forEach(v => bst.insert(v));
    [5, 3, 7, 1, 4, 6, 8].forEach(v => expect(bst.search(v)).not.toBeNull());
  });
  test('中順探索は昇順', () => {
    [5, 3, 7, 1, 4, 6, 8].forEach(v => bst.insert(v));
    expect(bst.inorder()).toEqual([1, 3, 4, 5, 6, 7, 8]);
  });
  test('前順探索', () => {
    [5, 3, 7].forEach(v => bst.insert(v));
    expect(bst.preorder()).toEqual([5, 3, 7]);
  });
  test('後順探索', () => {
    [5, 3, 7].forEach(v => bst.insert(v));
    expect(bst.postorder()).toEqual([3, 7, 5]);
  });
  test('min', () => {
    [5, 3, 7, 1, 4].forEach(v => bst.insert(v));
    expect(bst.min()).toBe(1);
  });
  test('max', () => {
    [5, 3, 7, 1, 4].forEach(v => bst.insert(v));
    expect(bst.max()).toBe(7);
  });
  test('min: 空で例外', () => { expect(() => bst.min()).toThrow(); });
  test('max: 空で例外', () => { expect(() => bst.max()).toThrow(); });
  test('葉ノードの削除', () => {
    [5, 3, 7].forEach(v => bst.insert(v));
    bst.delete(3);
    expect(bst.search(3)).toBeNull();
    expect(bst.search(5)).not.toBeNull();
  });
  test('子が 1 つのノードの削除', () => {
    [5, 3, 7, 1].forEach(v => bst.insert(v));
    bst.delete(3);
    expect(bst.search(3)).toBeNull();
    expect(bst.search(1)).not.toBeNull();
  });
  test('子が 2 つのノードの削除', () => {
    [5, 3, 7, 1, 4].forEach(v => bst.insert(v));
    bst.delete(3);
    expect(bst.search(3)).toBeNull();
    [1, 4, 5, 7].forEach(v => expect(bst.search(v)).not.toBeNull());
  });
  test('根ノードの削除', () => {
    [5, 3, 7].forEach(v => bst.insert(v));
    bst.delete(5);
    expect(bst.search(5)).toBeNull();
    expect(bst.inorder()).toEqual([3, 7]);
  });
  test('存在しないキーの削除は何もしない', () => {
    bst.insert(5);
    bst.delete(99);
    expect(bst.search(5)).not.toBeNull();
  });
  test('size', () => { [5, 3, 7].forEach(v => bst.insert(v)); expect(bst.size).toBe(3); });
  test('contains', () => { bst.insert(42); expect(bst.contains(42)).toBe(true); expect(bst.contains(0)).toBe(false); });
  test('根のみ削除で空になる', () => { bst.insert(5); bst.delete(5); expect(bst.isEmpty()).toBe(true); });
  test('重複挿入は無視', () => { bst.insert(5); bst.insert(5); expect(bst.size).toBe(1); });
  test('右子のみのノードの削除', () => {
    [5, 3, 7, 8].forEach(v => bst.insert(v));
    bst.delete(7);
    expect(bst.search(7)).toBeNull();
    expect(bst.search(8)).not.toBeNull();
  });
  test('深い後継ノードを持つ削除', () => {
    [10, 5, 20, 15, 25, 12, 18].forEach(v => bst.insert(v));
    bst.delete(10);
    expect(bst.search(10)).toBeNull();
    expect(bst.inorder()).toEqual([5, 12, 15, 18, 20, 25]);
  });
});
