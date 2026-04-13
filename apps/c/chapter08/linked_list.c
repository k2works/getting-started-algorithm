#include <stdlib.h>
#include "linked_list.h"

/* ===== 単方向連結リスト ===== */

LinkedList *ll_new(void) {
    LinkedList *lst = (LinkedList *)malloc(sizeof(LinkedList));
    lst->head = NULL;
    lst->no = 0;
    return lst;
}

void ll_free(LinkedList *lst) {
    ll_clear(lst);
    free(lst);
}

int ll_len(const LinkedList *lst) { return lst->no; }

int ll_get_head(const LinkedList *lst) {
    return lst->head ? lst->head->data : AL_NULL;
}

void ll_add_first(LinkedList *lst, int data) {
    LLNode *node = (LLNode *)malloc(sizeof(LLNode));
    node->data = data;
    node->next = lst->head;
    lst->head = node;
    lst->no++;
}

void ll_add_last(LinkedList *lst, int data) {
    LLNode *node = (LLNode *)malloc(sizeof(LLNode));
    node->data = data;
    node->next = NULL;
    if (lst->head == NULL) {
        lst->head = node;
    } else {
        LLNode *ptr = lst->head;
        while (ptr->next != NULL) ptr = ptr->next;
        ptr->next = node;
    }
    lst->no++;
}

void ll_remove_first(LinkedList *lst) {
    if (lst->head == NULL) return;
    LLNode *old = lst->head;
    lst->head = old->next;
    free(old);
    lst->no--;
}

void ll_remove_last(LinkedList *lst) {
    if (lst->head == NULL) return;
    if (lst->head->next == NULL) {
        free(lst->head);
        lst->head = NULL;
    } else {
        LLNode *ptr = lst->head;
        while (ptr->next != NULL && ptr->next->next != NULL)
            ptr = ptr->next;
        free(ptr->next);
        ptr->next = NULL;
    }
    lst->no--;
}

int ll_search(const LinkedList *lst, int data) {
    LLNode *ptr = lst->head;
    while (ptr != NULL) {
        if (ptr->data == data) return 1;
        ptr = ptr->next;
    }
    return 0;
}

void ll_clear(LinkedList *lst) {
    LLNode *ptr = lst->head;
    while (ptr != NULL) {
        LLNode *next = ptr->next;
        free(ptr);
        ptr = next;
    }
    lst->head = NULL;
    lst->no = 0;
}

/* ===== 双方向連結リスト（番兵ノード使用） ===== */

DList *dl_new(void) {
    DList *dl = (DList *)malloc(sizeof(DList));
    dl->head = (DLNode *)malloc(sizeof(DLNode));
    dl->head->data = 0;
    dl->head->prev = dl->head;
    dl->head->next = dl->head;
    dl->no = 0;
    return dl;
}

void dl_free(DList *dl) {
    dl_clear(dl);
    free(dl->head);
    free(dl);
}

int dl_len(const DList *dl) { return dl->no; }

void dl_add_first(DList *dl, int data) {
    DLNode *node = (DLNode *)malloc(sizeof(DLNode));
    node->data = data;
    node->prev = dl->head;
    node->next = dl->head->next;
    dl->head->next->prev = node;
    dl->head->next = node;
    dl->no++;
}

void dl_add_last(DList *dl, int data) {
    DLNode *node = (DLNode *)malloc(sizeof(DLNode));
    node->data = data;
    node->next = dl->head;
    node->prev = dl->head->prev;
    dl->head->prev->next = node;
    dl->head->prev = node;
    dl->no++;
}

void dl_remove_node(DList *dl, DLNode *node) {
    if (dl->no == 0) return;
    node->prev->next = node->next;
    node->next->prev = node->prev;
    free(node);
    dl->no--;
}

int dl_search(const DList *dl, int data) {
    DLNode *ptr = dl->head->next;
    while (ptr != dl->head) {
        if (ptr->data == data) return 1;
        ptr = ptr->next;
    }
    return 0;
}

void dl_clear(DList *dl) {
    DLNode *ptr = dl->head->next;
    while (ptr != dl->head) {
        DLNode *next = ptr->next;
        free(ptr);
        ptr = next;
    }
    dl->head->prev = dl->head;
    dl->head->next = dl->head;
    dl->no = 0;
}

/* ===== 配列カーソル版リスト ===== */

AList *al_new(int capacity) {
    AList *al = (AList *)malloc(sizeof(AList));
    al->head = AL_NULL;
    al->current = AL_NULL;
    al->max = AL_NULL;
    al->deleted = AL_NULL;
    al->capacity = capacity;
    al->n = (ANode *)malloc((size_t)capacity * sizeof(ANode));
    for (int i = 0; i < capacity; i++) {
        al->n[i].data = AL_NULL;
        al->n[i].next = AL_NULL;
        al->n[i].dnext = AL_NULL;
    }
    al->no = 0;
    return al;
}

void al_free(AList *al) {
    free(al->n);
    free(al);
}

int al_len(const AList *al) { return al->no; }

static int al_get_insert_index(AList *al) {
    if (al->deleted == AL_NULL) {
        if (al->max + 1 < al->capacity) {
            al->max++;
            return al->max;
        }
        return AL_NULL;
    } else {
        int rec = al->deleted;
        al->deleted = al->n[rec].dnext;
        return rec;
    }
}

void al_add_first(AList *al, int data) {
    int ptr = al->head;
    int rec = al_get_insert_index(al);
    if (rec == AL_NULL) return;
    al->head = al->current = rec;
    al->n[rec].data = data;
    al->n[rec].next = ptr;
    al->n[rec].dnext = AL_NULL;
    al->no++;
}

void al_add_last(AList *al, int data) {
    if (al->head == AL_NULL) {
        al_add_first(al, data);
        return;
    }
    int ptr = al->head;
    while (al->n[ptr].next != AL_NULL)
        ptr = al->n[ptr].next;
    int rec = al_get_insert_index(al);
    if (rec == AL_NULL) return;
    al->n[ptr].next = al->current = rec;
    al->n[rec].data = data;
    al->n[rec].next = AL_NULL;
    al->n[rec].dnext = AL_NULL;
    al->no++;
}

int al_search(AList *al, int data) {
    int ptr = al->head;
    while (ptr != AL_NULL) {
        if (al->n[ptr].data == data) {
            al->current = ptr;
            return ptr;
        }
        ptr = al->n[ptr].next;
    }
    return AL_NULL;
}

void al_remove_first(AList *al) {
    if (al->head == AL_NULL) return;
    int ptr = al->head;
    al->head = al->current = al->n[ptr].next;
    al->n[ptr].dnext = al->deleted;
    al->deleted = ptr;
    al->no--;
}
