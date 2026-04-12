# 第 3 章 探索アルゴリズム

## はじめに

探索アルゴリズムは、データの集合から目的の要素を見つけるアルゴリズムです。

---

## 1. 線形探索

### while 方式

```go
func SsearchWhile(a []int, key int) int {
    i := 0
    for {
        if i == len(a) {
            return -1
        }
        if a[i] == key {
            return i
        }
        i++
    }
}
```

### for 方式

```go
func SsearchFor(a []int, key int) int {
    for i := 0; i < len(a); i++ {
        if a[i] == key {
            return i
        }
    }
    return -1
}
```

---

## 2. 二分探索

整列済みスライスに対して効率的に探索できます（O(log n)）。

```go
func Bsearch(a []int, key int) int {
    pl := 0
    pr := len(a) - 1
    for pl <= pr {
        pc := (pl + pr) / 2
        if a[pc] == key {
            return pc
        } else if a[pc] < key {
            pl = pc + 1
        } else {
            pr = pc - 1
        }
    }
    return -1
}
```

---

## 3. ハッシュ法（チェイン法）

Go の `map` を使えばハッシュテーブルは組み込みで提供されていますが、ここでは内部構造を理解するためにスライスで実装します。

```go
type HashTable struct {
    buckets [][]entry
    size    int
}

type entry struct {
    key   int
    value string
}

func NewHashTable(size int) *HashTable {
    return &HashTable{
        buckets: make([][]entry, size),
        size:    size,
    }
}

func (ht *HashTable) Add(key int, value string) {
    h := key % ht.size
    ht.buckets[h] = append(ht.buckets[h], entry{key, value})
}

func (ht *HashTable) Search(key int) (string, bool) {
    h := key % ht.size
    for _, e := range ht.buckets[h] {
        if e.key == key {
            return e.value, true
        }
    }
    return "", false
}
```

---

## Python との比較

| 処理 | Python | Go |
|------|--------|----|
| 無限ループ | `while True:` | `for {` |
| 複数戻り値 | タプル `(val, found)` | `(string, bool)` |
| 辞書（組み込み） | `dict` | `map[K]V` |
| 関数の戻り値なし | `return None` | `return "", false` |
