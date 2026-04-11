package algorithm;

import java.util.ArrayList;
import java.util.List;

/** 第9章 二分探索木 */
public class BinarySearchTree<T extends Comparable<T>> {

    public static class EmptyException extends RuntimeException {
        public EmptyException() { super("木は空です"); }
    }

    private static class BSTNode<T> {
        T key;
        BSTNode<T> left, right;
        BSTNode(T key) { this.key = key; }
    }

    private BSTNode<T> root;
    private int size;

    public BinarySearchTree() { root = null; size = 0; }

    public int size() { return size; }
    public boolean isEmpty() { return root == null; }
    public boolean contains(T key) { return search(key) != null; }

    private BSTNode<T> search(T key) {
        BSTNode<T> ptr = root;
        while (ptr != null) {
            int cmp = key.compareTo(ptr.key);
            if (cmp == 0) return ptr;
            ptr = cmp < 0 ? ptr.left : ptr.right;
        }
        return null;
    }

    public void insert(T key) {
        if (root == null) { root = new BSTNode<>(key); size++; return; }
        BSTNode<T> ptr = root;
        while (true) {
            int cmp = key.compareTo(ptr.key);
            if (cmp == 0) return; // 重複は無視
            if (cmp < 0) {
                if (ptr.left == null) { ptr.left = new BSTNode<>(key); size++; return; }
                ptr = ptr.left;
            } else {
                if (ptr.right == null) { ptr.right = new BSTNode<>(key); size++; return; }
                ptr = ptr.right;
            }
        }
    }

    public void delete(T key) {
        BSTNode<T> parent = null;
        BSTNode<T> ptr = root;
        boolean isLeftChild = false;

        while (ptr != null) {
            int cmp = key.compareTo(ptr.key);
            if (cmp == 0) break;
            parent = ptr;
            if (cmp < 0) { isLeftChild = true; ptr = ptr.left; }
            else { isLeftChild = false; ptr = ptr.right; }
        }
        if (ptr == null) return;

        size--;

        if (ptr.left == null && ptr.right == null) {
            replaceNode(parent, isLeftChild, null);
        } else if (ptr.right == null) {
            replaceNode(parent, isLeftChild, ptr.left);
        } else if (ptr.left == null) {
            replaceNode(parent, isLeftChild, ptr.right);
        } else {
            // 右部分木の最小ノード（中順後継）で置き換え
            BSTNode<T> succParent = ptr;
            BSTNode<T> succ = ptr.right;
            while (succ.left != null) { succParent = succ; succ = succ.left; }
            ptr.key = succ.key;
            if (succParent == ptr) succParent.right = succ.right;
            else succParent.left = succ.right;
            size++; // delete で既に -1 したので +1 で調整
        }
    }

    private void replaceNode(BSTNode<T> parent, boolean isLeftChild, BSTNode<T> newNode) {
        if (parent == null) root = newNode;
        else if (isLeftChild) parent.left = newNode;
        else parent.right = newNode;
    }

    public T min() {
        if (root == null) throw new EmptyException();
        BSTNode<T> ptr = root;
        while (ptr.left != null) ptr = ptr.left;
        return ptr.key;
    }

    public T max() {
        if (root == null) throw new EmptyException();
        BSTNode<T> ptr = root;
        while (ptr.right != null) ptr = ptr.right;
        return ptr.key;
    }

    public List<T> inOrder() {
        List<T> result = new ArrayList<>();
        inOrderHelper(root, result);
        return result;
    }

    private void inOrderHelper(BSTNode<T> node, List<T> result) {
        if (node == null) return;
        inOrderHelper(node.left, result);
        result.add(node.key);
        inOrderHelper(node.right, result);
    }

    public List<T> preOrder() {
        List<T> result = new ArrayList<>();
        preOrderHelper(root, result);
        return result;
    }

    private void preOrderHelper(BSTNode<T> node, List<T> result) {
        if (node == null) return;
        result.add(node.key);
        preOrderHelper(node.left, result);
        preOrderHelper(node.right, result);
    }

    public List<T> postOrder() {
        List<T> result = new ArrayList<>();
        postOrderHelper(root, result);
        return result;
    }

    private void postOrderHelper(BSTNode<T> node, List<T> result) {
        if (node == null) return;
        postOrderHelper(node.left, result);
        postOrderHelper(node.right, result);
        result.add(node.key);
    }
}
