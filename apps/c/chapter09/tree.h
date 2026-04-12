#ifndef TREE_H
#define TREE_H

/* ---- 二分探索木（BST） ---- */

typedef struct _BSTNode {
    int key;
    struct _BSTNode *left;
    struct _BSTNode *right;
} BSTNode;

typedef struct {
    BSTNode *root;
    int no;
} BST;

BST    *bst_new(void);
void    bst_free(BST *t);
int     bst_len(const BST *t);
int     bst_search(const BST *t, int key);   /* 1=found, 0=not found */
void    bst_insert(BST *t, int key);
void    bst_delete(BST *t, int key);
int     bst_min(const BST *t);
int     bst_max(const BST *t);
int     bst_inorder(const BST *t, int *buf, int bufsz);
int     bst_preorder(const BST *t, int *buf, int bufsz);
int     bst_postorder(const BST *t, int *buf, int bufsz);

/* ---- 最小ヒープ ---- */

typedef struct {
    int *data;
    int size;
    int capacity;
} MinHeap;

MinHeap *heap_new(int capacity);
void     heap_free(MinHeap *h);
int      heap_len(const MinHeap *h);
void     heap_push(MinHeap *h, int val);
int      heap_pop(MinHeap *h);
int      heap_peek(const MinHeap *h);

#endif /* TREE_H */
