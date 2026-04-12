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
