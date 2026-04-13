// Package chapter03 第3章 探索アルゴリズム
package chapter03

// SsearchWhile シーケンスaからkeyと等価な要素を線形探索（for-while方式）
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

// SsearchFor シーケンスaからkeyと等価な要素を線形探索（for文）
func SsearchFor(a []int, key int) int {
	for i := 0; i < len(a); i++ {
		if a[i] == key {
			return i
		}
	}
	return -1
}

// SsearchSentinel シーケンスaからkeyと等価な要素を線形探索（番兵法）
func SsearchSentinel(a []int, key int) int {
	n := len(a)
	tmp := make([]int, n+1)
	copy(tmp, a)
	tmp[n] = key // 番兵を追加
	i := 0
	for tmp[i] != key {
		i++
	}
	if i == n {
		return -1
	}
	return i
}

// Bsearch シーケンスaからkeyと一致する要素を二分探索
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

// HashTable チェイン法によるハッシュテーブル
type HashTable struct {
	buckets [][]entry
	size    int
}

type entry struct {
	key   int
	value string
}

// NewHashTable ハッシュテーブルを生成する
func NewHashTable(size int) *HashTable {
	return &HashTable{
		buckets: make([][]entry, size),
		size:    size,
	}
}

func (ht *HashTable) hash(key int) int {
	if key < 0 {
		return (-key) % ht.size
	}
	return key % ht.size
}

// Add キーと値をハッシュテーブルに追加する
func (ht *HashTable) Add(key int, value string) {
	h := ht.hash(key)
	ht.buckets[h] = append(ht.buckets[h], entry{key, value})
}

// Search キーに対応する値を検索する
func (ht *HashTable) Search(key int) (string, bool) {
	h := ht.hash(key)
	for _, e := range ht.buckets[h] {
		if e.key == key {
			return e.value, true
		}
	}
	return "", false
}

// Remove キーに対応するエントリを削除する
func (ht *HashTable) Remove(key int) bool {
	h := ht.hash(key)
	for i, e := range ht.buckets[h] {
		if e.key == key {
			ht.buckets[h] = append(ht.buckets[h][:i], ht.buckets[h][i+1:]...)
			return true
		}
	}
	return false
}

// --- オープンアドレス法（線形探索法）ハッシュ ---

type bucketStatus int

const (
	bucketEmpty    bucketStatus = iota // 空
	bucketOccupied                     // 占有
	bucketDeleted                      // 削除済み
)

type openBucket struct {
	key   int
	value string
	stat  bucketStatus
}

// OpenHash オープンアドレス法（線形探索法）によるハッシュテーブル
type OpenHash struct {
	table []openBucket
	size  int
}

// NewOpenHash オープンアドレス法ハッシュテーブルを生成する
func NewOpenHash(size int) *OpenHash {
	return &OpenHash{
		table: make([]openBucket, size),
		size:  size,
	}
}

func (oh *OpenHash) hashVal(key int) int {
	if key < 0 {
		return (-key) % oh.size
	}
	return key % oh.size
}

// Search キーに対応する値を検索する
func (oh *OpenHash) Search(key int) (string, bool) {
	h := oh.hashVal(key)
	for range oh.size {
		b := oh.table[h]
		if b.stat == bucketEmpty {
			break
		}
		if b.stat == bucketOccupied && b.key == key {
			return b.value, true
		}
		h = (h + 1) % oh.size
	}
	return "", false
}

// Add キーと値をハッシュテーブルに追加する
func (oh *OpenHash) Add(key int, value string) bool {
	if _, ok := oh.Search(key); ok {
		return false // 重複キーは追加しない
	}
	h := oh.hashVal(key)
	for range oh.size {
		b := oh.table[h]
		if b.stat == bucketEmpty || b.stat == bucketDeleted {
			oh.table[h] = openBucket{key, value, bucketOccupied}
			return true
		}
		h = (h + 1) % oh.size
	}
	return false
}

// Remove キーに対応するエントリを削除する
func (oh *OpenHash) Remove(key int) bool {
	h := oh.hashVal(key)
	for range oh.size {
		b := oh.table[h]
		if b.stat == bucketEmpty {
			return false
		}
		if b.stat == bucketOccupied && b.key == key {
			oh.table[h].stat = bucketDeleted
			return true
		}
		h = (h + 1) % oh.size
	}
	return false
}
