#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stddef.h>

/* ---- 単方向連結リスト ---- */

typedef struct _LLNode {
    int data;
    struct _LLNode *next;
} LLNode;

typedef struct {
    LLNode *head;
    int no;
} LinkedList;

LinkedList *ll_new(void);
void        ll_free(LinkedList *lst);
int         ll_len(const LinkedList *lst);
int         ll_get_head(const LinkedList *lst);
void        ll_add_first(LinkedList *lst, int data);
void        ll_add_last(LinkedList *lst, int data);
void        ll_remove_first(LinkedList *lst);
void        ll_remove_last(LinkedList *lst);
int         ll_search(const LinkedList *lst, int data);  /* 1=found, 0=not found */
void        ll_clear(LinkedList *lst);

/* ---- 双方向連結リスト（番兵ノード使用） ---- */

typedef struct _DLNode {
    int data;
    struct _DLNode *prev;
    struct _DLNode *next;
} DLNode;

typedef struct {
    DLNode *head;  /* 番兵ノード */
    int no;
} DList;

DList *dl_new(void);
void   dl_free(DList *dl);
int    dl_len(const DList *dl);
void   dl_add_first(DList *dl, int data);
void   dl_add_last(DList *dl, int data);
void   dl_remove_node(DList *dl, DLNode *node);
int    dl_search(const DList *dl, int data);  /* 1=found, 0=not found */
void   dl_clear(DList *dl);

/* ---- 配列カーソル版リスト ---- */

#define AL_NULL (-1)

typedef struct {
    int data;
    int next;   /* 次ノードのインデックス（AL_NULL = なし）*/
    int dnext;  /* 削除リスト用次インデックス */
} ANode;

typedef struct {
    int head;
    int current;
    int max;
    int deleted;
    int capacity;
    ANode *n;
    int no;
} AList;

AList *al_new(int capacity);
void   al_free(AList *al);
int    al_len(const AList *al);
void   al_add_first(AList *al, int data);
void   al_add_last(AList *al, int data);
int    al_search(AList *al, int data);  /* インデックスを返す、AL_NULL = 未発見 */
void   al_remove_first(AList *al);

#endif /* LINKED_LIST_H */
