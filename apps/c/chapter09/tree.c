#include <stdlib.h>
#include "tree.h"

/* ===== 二分探索木（BST） ===== */

BST *bst_new(void) {
    BST *t = (BST *)malloc(sizeof(BST));
    t->root = NULL;
    t->no = 0;
    return t;
}

static void _bst_free_node(BSTNode *node) {
    if (node == NULL) return;
    _bst_free_node(node->left);
    _bst_free_node(node->right);
    free(node);
}

void bst_free(BST *t) {
    _bst_free_node(t->root);
    free(t);
}

int bst_len(const BST *t) { return t->no; }

int bst_search(const BST *t, int key) {
    BSTNode *ptr = t->root;
    while (ptr != NULL) {
        if (key == ptr->key) return 1;
        ptr = (key < ptr->key) ? ptr->left : ptr->right;
    }
    return 0;
}

void bst_insert(BST *t, int key) {
    if (t->root == NULL) {
        t->root = (BSTNode *)malloc(sizeof(BSTNode));
        t->root->key = key;
        t->root->left = t->root->right = NULL;
        t->no++;
        return;
    }
    BSTNode *ptr = t->root;
    while (1) {
        if (key == ptr->key) return;  /* 重複は無視 */
        if (key < ptr->key) {
            if (ptr->left == NULL) {
                ptr->left = (BSTNode *)malloc(sizeof(BSTNode));
                ptr->left->key = key;
                ptr->left->left = ptr->left->right = NULL;
                t->no++;
                return;
            }
            ptr = ptr->left;
        } else {
            if (ptr->right == NULL) {
                ptr->right = (BSTNode *)malloc(sizeof(BSTNode));
                ptr->right->key = key;
                ptr->right->left = ptr->right->right = NULL;
                t->no++;
                return;
            }
            ptr = ptr->right;
        }
    }
}

void bst_delete(BST *t, int key) {
    BSTNode *parent = NULL;
    BSTNode *ptr = t->root;
    int is_left = 0;

    while (ptr != NULL) {
        if (key == ptr->key) break;
        parent = ptr;
        if (key < ptr->key) { is_left = 1; ptr = ptr->left; }
        else                 { is_left = 0; ptr = ptr->right; }
    }
    if (ptr == NULL) return;
    t->no--;

    BSTNode *replacement;
    if (ptr->left == NULL && ptr->right == NULL) {
        replacement = NULL;
    } else if (ptr->right == NULL) {
        replacement = ptr->left;
    } else if (ptr->left == NULL) {
        replacement = ptr->right;
    } else {
        /* 右部分木の最小ノード（中順後継）で置き換える */
        BSTNode *succ_parent = ptr;
        BSTNode *succ = ptr->right;
        while (succ->left != NULL) {
            succ_parent = succ;
            succ = succ->left;
        }
        ptr->key = succ->key;
        if (succ_parent == ptr) succ_parent->right = succ->right;
        else                     succ_parent->left  = succ->right;
        free(succ);
        t->no++;  /* delete で既に -1 しているので調整 */
        return;
    }

    if (parent == NULL) {
        t->root = replacement;
    } else if (is_left) {
        parent->left = replacement;
    } else {
        parent->right = replacement;
    }
    free(ptr);
}

int bst_min(const BST *t) {
    BSTNode *ptr = t->root;
    while (ptr->left != NULL) ptr = ptr->left;
    return ptr->key;
}

int bst_max(const BST *t) {
    BSTNode *ptr = t->root;
    while (ptr->right != NULL) ptr = ptr->right;
    return ptr->key;
}

static int _inorder(BSTNode *node, int *buf, int bufsz, int idx) {
    if (node == NULL || idx >= bufsz) return idx;
    idx = _inorder(node->left, buf, bufsz, idx);
    if (idx < bufsz) buf[idx++] = node->key;
    idx = _inorder(node->right, buf, bufsz, idx);
    return idx;
}

int bst_inorder(const BST *t, int *buf, int bufsz) {
    return _inorder(t->root, buf, bufsz, 0);
}

static int _preorder(BSTNode *node, int *buf, int bufsz, int idx) {
    if (node == NULL || idx >= bufsz) return idx;
    if (idx < bufsz) buf[idx++] = node->key;
    idx = _preorder(node->left, buf, bufsz, idx);
    idx = _preorder(node->right, buf, bufsz, idx);
    return idx;
}

int bst_preorder(const BST *t, int *buf, int bufsz) {
    return _preorder(t->root, buf, bufsz, 0);
}

static int _postorder(BSTNode *node, int *buf, int bufsz, int idx) {
    if (node == NULL || idx >= bufsz) return idx;
    idx = _postorder(node->left, buf, bufsz, idx);
    idx = _postorder(node->right, buf, bufsz, idx);
    if (idx < bufsz) buf[idx++] = node->key;
    return idx;
}

int bst_postorder(const BST *t, int *buf, int bufsz) {
    return _postorder(t->root, buf, bufsz, 0);
}

/* ===== 最小ヒープ ===== */

MinHeap *heap_new(int capacity) {
    MinHeap *h = (MinHeap *)malloc(sizeof(MinHeap));
    h->data = (int *)malloc((size_t)capacity * sizeof(int));
    h->size = 0;
    h->capacity = capacity;
    return h;
}

void heap_free(MinHeap *h) {
    free(h->data);
    free(h);
}

int heap_len(const MinHeap *h) { return h->size; }

void heap_push(MinHeap *h, int val) {
    if (h->size >= h->capacity) return;
    int i = h->size++;
    h->data[i] = val;
    while (i > 0) {
        int parent = (i - 1) / 2;
        if (h->data[parent] <= h->data[i]) break;
        int tmp = h->data[parent];
        h->data[parent] = h->data[i];
        h->data[i] = tmp;
        i = parent;
    }
}

int heap_pop(MinHeap *h) {
    int top = h->data[0];
    h->data[0] = h->data[--h->size];
    int i = 0;
    while (1) {
        int left = 2 * i + 1, right = 2 * i + 2, smallest = i;
        if (left < h->size && h->data[left] < h->data[smallest]) smallest = left;
        if (right < h->size && h->data[right] < h->data[smallest]) smallest = right;
        if (smallest == i) break;
        int tmp = h->data[i];
        h->data[i] = h->data[smallest];
        h->data[smallest] = tmp;
        i = smallest;
    }
    return top;
}

int heap_peek(const MinHeap *h) { return h->data[0]; }
