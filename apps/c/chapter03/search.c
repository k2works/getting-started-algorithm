#include <stdlib.h>
#include <string.h>
#include "search.h"

/* ---- Linear search ---- */

int ssearch_while(const int *a, int n, int key) {
    int i = 0;
    while (i < n) {
        if (a[i] == key) return i;
        i++;
    }
    return -1;
}

int ssearch_for(const int *a, int n, int key) {
    for (int i = 0; i < n; i++) {
        if (a[i] == key) return i;
    }
    return -1;
}

int ssearch_sentinel(const int *a, int n, int key) {
    int *tmp = (int *)malloc((size_t)(n + 1) * sizeof(int));
    memcpy(tmp, a, (size_t)n * sizeof(int));
    tmp[n] = key;
    int i = 0;
    while (tmp[i] != key) i++;
    free(tmp);
    return (i == n) ? -1 : i;
}

/* ---- Binary search ---- */

int bsearch_int(const int *a, int n, int key) {
    int pl = 0, pr = n - 1;
    while (pl <= pr) {
        int pc = (pl + pr) / 2;
        if (a[pc] == key) return pc;
        else if (a[pc] < key) pl = pc + 1;
        else pr = pc - 1;
    }
    return -1;
}

/* ---- Chained hash ---- */

static int chain_hash(int key, int cap) {
    return ((key % cap) + cap) % cap;
}

ChainedHash *chained_hash_new(int capacity) {
    ChainedHash *h = (ChainedHash *)malloc(sizeof(ChainedHash));
    h->capacity = capacity;
    h->table = (ChainedNode **)calloc((size_t)capacity, sizeof(ChainedNode *));
    return h;
}

void chained_hash_free(ChainedHash *h) {
    for (int i = 0; i < h->capacity; i++) {
        ChainedNode *p = h->table[i];
        while (p) {
            ChainedNode *next = p->next;
            free(p);
            p = next;
        }
    }
    free(h->table);
    free(h);
}

int chained_hash_search(ChainedHash *h, int key) {
    ChainedNode *p = h->table[chain_hash(key, h->capacity)];
    while (p) {
        if (p->key == key) return p->value;
        p = p->next;
    }
    return -1;
}

int chained_hash_add(ChainedHash *h, int key, int value) {
    if (chained_hash_search(h, key) != -1) return 0;
    int idx = chain_hash(key, h->capacity);
    ChainedNode *node = (ChainedNode *)malloc(sizeof(ChainedNode));
    node->key = key;
    node->value = value;
    node->next = h->table[idx];
    h->table[idx] = node;
    return 1;
}

int chained_hash_remove(ChainedHash *h, int key) {
    int idx = chain_hash(key, h->capacity);
    ChainedNode *p = h->table[idx], *pp = NULL;
    while (p) {
        if (p->key == key) {
            if (pp) pp->next = p->next;
            else h->table[idx] = p->next;
            free(p);
            return 1;
        }
        pp = p;
        p = p->next;
    }
    return 0;
}

/* ---- Open addressing hash ---- */

static int open_hash_val(int key, int cap) {
    return ((key % cap) + cap) % cap;
}

OpenHash *open_hash_new(int capacity) {
    OpenHash *h = (OpenHash *)malloc(sizeof(OpenHash));
    h->capacity = capacity;
    h->table = (Bucket *)calloc((size_t)capacity, sizeof(Bucket));
    for (int i = 0; i < capacity; i++) h->table[i].stat = BUCKET_EMPTY;
    return h;
}

void open_hash_free(OpenHash *h) {
    free(h->table);
    free(h);
}

int open_hash_search(OpenHash *h, int key) {
    int idx = open_hash_val(key, h->capacity);
    for (int i = 0; i < h->capacity; i++) {
        Bucket *b = &h->table[idx];
        if (b->stat == BUCKET_EMPTY) return -1;
        if (b->stat == BUCKET_OCCUPIED && b->key == key) return b->value;
        idx = (idx + 1) % h->capacity;
    }
    return -1;
}

int open_hash_add(OpenHash *h, int key, int value) {
    if (open_hash_search(h, key) != -1) return 0;
    int idx = open_hash_val(key, h->capacity);
    for (int i = 0; i < h->capacity; i++) {
        Bucket *b = &h->table[idx];
        if (b->stat == BUCKET_EMPTY || b->stat == BUCKET_DELETED) {
            b->key = key;
            b->value = value;
            b->stat = BUCKET_OCCUPIED;
            return 1;
        }
        idx = (idx + 1) % h->capacity;
    }
    return 0;
}

int open_hash_remove(OpenHash *h, int key) {
    int idx = open_hash_val(key, h->capacity);
    for (int i = 0; i < h->capacity; i++) {
        Bucket *b = &h->table[idx];
        if (b->stat == BUCKET_EMPTY) return 0;
        if (b->stat == BUCKET_OCCUPIED && b->key == key) {
            b->stat = BUCKET_DELETED;
            return 1;
        }
        idx = (idx + 1) % h->capacity;
    }
    return 0;
}
