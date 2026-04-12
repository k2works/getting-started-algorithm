/**
 * 第9章 木構造
 */

class BSTNode<T> {
  constructor(
    public key: T,
    public left: BSTNode<T> | null = null,
    public right: BSTNode<T> | null = null,
  ) {}
}

/** 二分探索木（Binary Search Tree） */
export class BinarySearchTree<T> {
  private root: BSTNode<T> | null = null;
  private no = 0;

  get size(): number { return this.no; }

  isEmpty(): boolean { return this.root === null; }

  contains(key: T): boolean { return this.search(key) !== null; }

  search(key: T): BSTNode<T> | null {
    let ptr = this.root;
    while (ptr !== null) {
      if (key === ptr.key) return ptr;
      ptr = key < ptr.key ? ptr.left : ptr.right;
    }
    return null;
  }

  insert(key: T): void {
    if (this.root === null) {
      this.root = new BSTNode<T>(key);
      this.no++;
      return;
    }
    let ptr = this.root;
    while (true) {
      if (key === ptr.key) return; // 重複は無視
      if (key < ptr.key) {
        if (ptr.left === null) { ptr.left = new BSTNode<T>(key); this.no++; return; }
        ptr = ptr.left;
      } else {
        if (ptr.right === null) { ptr.right = new BSTNode<T>(key); this.no++; return; }
        ptr = ptr.right;
      }
    }
  }

  delete(key: T): void {
    let parent: BSTNode<T> | null = null;
    let ptr = this.root;
    let isLeftChild = false;

    while (ptr !== null) {
      if (key === ptr.key) break;
      parent = ptr;
      if (key < ptr.key) { isLeftChild = true; ptr = ptr.left; }
      else { isLeftChild = false; ptr = ptr.right; }
    }
    if (ptr === null) return;

    this.no--;

    if (ptr.left === null && ptr.right === null) {
      this.replaceNode(parent, isLeftChild, null);
    } else if (ptr.right === null) {
      this.replaceNode(parent, isLeftChild, ptr.left);
    } else if (ptr.left === null) {
      this.replaceNode(parent, isLeftChild, ptr.right);
    } else {
      // 子が 2 つ: 右部分木の最小ノード（中順後継）で置き換える
      let successorParent = ptr;
      let successor = ptr.right;
      while (successor.left !== null) {
        successorParent = successor;
        successor = successor.left;
      }
      ptr.key = successor.key;
      if (successorParent === ptr) successorParent.right = successor.right;
      else successorParent.left = successor.right;
      this.no++; // delete で既に -1 しているので +1 で調整
    }
  }

  private replaceNode(
    parent: BSTNode<T> | null,
    isLeftChild: boolean,
    newNode: BSTNode<T> | null,
  ): void {
    if (parent === null) this.root = newNode;
    else if (isLeftChild) parent.left = newNode;
    else parent.right = newNode;
  }

  min(): T {
    if (this.root === null) throw new Error('BinarySearchTree is empty');
    let ptr = this.root;
    while (ptr.left !== null) ptr = ptr.left;
    return ptr.key;
  }

  max(): T {
    if (this.root === null) throw new Error('BinarySearchTree is empty');
    let ptr = this.root;
    while (ptr.right !== null) ptr = ptr.right;
    return ptr.key;
  }

  inorder(): T[] {
    const result: T[] = [];
    this.inorderNode(this.root, result);
    return result;
  }

  private inorderNode(node: BSTNode<T> | null, result: T[]): void {
    if (node === null) return;
    this.inorderNode(node.left, result);
    result.push(node.key);
    this.inorderNode(node.right, result);
  }

  preorder(): T[] {
    const result: T[] = [];
    this.preorderNode(this.root, result);
    return result;
  }

  private preorderNode(node: BSTNode<T> | null, result: T[]): void {
    if (node === null) return;
    result.push(node.key);
    this.preorderNode(node.left, result);
    this.preorderNode(node.right, result);
  }

  postorder(): T[] {
    const result: T[] = [];
    this.postorderNode(this.root, result);
    return result;
  }

  private postorderNode(node: BSTNode<T> | null, result: T[]): void {
    if (node === null) return;
    this.postorderNode(node.left, result);
    this.postorderNode(node.right, result);
    result.push(node.key);
  }
}
