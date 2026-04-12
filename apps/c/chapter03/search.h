#ifndef SEARCH_H
#define SEARCH_H

#include <stddef.h>

/* Linear search */
int ssearch_while(const int *a, int n, int key);
int ssearch_for(const int *a, int n, int key);
int ssearch_sentinel(const int *a, int n, int key);

/* Binary search */
int bsearch_int(const int *a, int n, int key);

/* Chained hash */
typedef struct ChainedNode {
    int key;
    int value;
    struct ChainedNode *next;
} ChainedNode;

typedef struct {
    int capacity;
    ChainedNode **table;
} ChainedHash;

ChainedHash *chained_hash_new(int capacity);
void         chained_hash_free(ChainedHash *h);
int          chained_hash_search(ChainedHash *h, int key);
int          chained_hash_add(ChainedHash *h, int key, int value);
int          chained_hash_remove(ChainedHash *h, int key);

/* Open addressing hash */
typedef enum { BUCKET_EMPTY = 0, BUCKET_OCCUPIED, BUCKET_DELETED } BucketStatus;

typedef struct {
    int key;
    int value;
    BucketStatus stat;
} Bucket;

typedef struct {
    int capacity;
    Bucket *table;
} OpenHash;

OpenHash *open_hash_new(int capacity);
void      open_hash_free(OpenHash *h);
int       open_hash_search(OpenHash *h, int key);
int       open_hash_add(OpenHash *h, int key, int value);
int       open_hash_remove(OpenHash *h, int key);

#endif /* SEARCH_H */
