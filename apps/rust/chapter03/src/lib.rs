// chapter03: 探索アルゴリズム

// ============================================================
// 1. 線形探索（基本 — while 版）
// ============================================================

/// 配列 `arr` から `key` と一致する要素を線形探索（while 版）。
/// 見つかればインデックスを `Some` で、見つからなければ `None` を返す。
pub fn seq_search(arr: &[i32], key: i32) -> Option<usize> {
    let mut i = 0;
    while i < arr.len() {
        if arr[i] == key {
            return Some(i);
        }
        i += 1;
    }
    None
}

// ============================================================
// 2. 線形探索（番兵法）
// ============================================================

/// 番兵法による線形探索。
/// 配列の末尾に `key` を番兵として追加し、ループ内の終端判定を省略する。
pub fn seq_search_sentinel(arr: &[i32], key: i32) -> Option<usize> {
    let mut a = arr.to_vec();
    a.push(key); // 番兵を追加

    let mut i = 0;
    while a[i] != key {
        i += 1;
    }

    if i < arr.len() {
        Some(i)
    } else {
        None
    }
}

// ============================================================
// 3. 二分探索
// ============================================================

/// ソート済み配列 `arr` から `key` を二分探索する。
pub fn bin_search(arr: &[i32], key: i32) -> Option<usize> {
    if arr.is_empty() {
        return None;
    }
    let mut lo: usize = 0;
    let mut hi: usize = arr.len() - 1;

    while lo <= hi {
        let mid = lo + (hi - lo) / 2;
        if arr[mid] == key {
            return Some(mid);
        } else if arr[mid] < key {
            lo = mid + 1;
        } else {
            if mid == 0 {
                break;
            }
            hi = mid - 1;
        }
    }
    None
}

// ============================================================
// 4. チェイン法ハッシュ
// ============================================================

/// チェイン法によるハッシュテーブル。
/// 各バケットは `Vec<(i32, i32)>` で衝突を解決する。
pub struct ChainHash {
    capacity: usize,
    table: Vec<Vec<(i32, i32)>>,
}

impl ChainHash {
    /// 指定した容量でハッシュテーブルを生成する。
    pub fn new(capacity: usize) -> Self {
        Self {
            capacity,
            table: vec![Vec::new(); capacity],
        }
    }

    fn hash(&self, key: i32) -> usize {
        (key.unsigned_abs() as usize) % self.capacity
    }

    /// キーに対応する値を探索する。見つからなければ `None`。
    pub fn search(&self, key: i32) -> Option<i32> {
        let h = self.hash(key);
        for &(k, v) in &self.table[h] {
            if k == key {
                return Some(v);
            }
        }
        None
    }

    /// キーと値のペアを追加する。重複キーの場合は `false` を返す。
    pub fn add(&mut self, key: i32, value: i32) -> bool {
        let h = self.hash(key);
        // 重複チェック
        for &(k, _) in &self.table[h] {
            if k == key {
                return false;
            }
        }
        self.table[h].push((key, value));
        true
    }

    /// キーに対応する要素を削除する。削除成功で `true`。
    pub fn remove(&mut self, key: i32) -> bool {
        let h = self.hash(key);
        if let Some(pos) = self.table[h].iter().position(|&(k, _)| k == key) {
            self.table[h].remove(pos);
            true
        } else {
            false
        }
    }
}

// ============================================================
// 5. オープンアドレス法ハッシュ
// ============================================================

/// バケットの状態
#[derive(Clone, Copy, Debug, PartialEq)]
enum BucketStatus {
    Empty,
    Occupied,
    Deleted,
}

/// オープンアドレス法（線形探査法）によるハッシュテーブル。
pub struct OpenHash {
    capacity: usize,
    table: Vec<(i32, i32, BucketStatus)>,
}

impl OpenHash {
    /// 指定した容量でハッシュテーブルを生成する。
    pub fn new(capacity: usize) -> Self {
        Self {
            capacity,
            table: vec![(0, 0, BucketStatus::Empty); capacity],
        }
    }

    fn hash(&self, key: i32) -> usize {
        (key.unsigned_abs() as usize) % self.capacity
    }

    /// キーに対応する値を探索する。見つからなければ `None`。
    pub fn search(&self, key: i32) -> Option<i32> {
        let mut h = self.hash(key);
        for _ in 0..self.capacity {
            match self.table[h].2 {
                BucketStatus::Empty => return None,
                BucketStatus::Occupied if self.table[h].0 == key => {
                    return Some(self.table[h].1);
                }
                _ => {
                    h = (h + 1) % self.capacity;
                }
            }
        }
        None
    }

    /// キーと値のペアを追加する。重複キーまたはテーブルが満杯の場合は `false`。
    pub fn add(&mut self, key: i32, value: i32) -> bool {
        if self.search(key).is_some() {
            return false;
        }
        let mut h = self.hash(key);
        for _ in 0..self.capacity {
            match self.table[h].2 {
                BucketStatus::Empty | BucketStatus::Deleted => {
                    self.table[h] = (key, value, BucketStatus::Occupied);
                    return true;
                }
                _ => {
                    h = (h + 1) % self.capacity;
                }
            }
        }
        false
    }

    /// キーに対応する要素を削除する。削除成功で `true`。
    pub fn remove(&mut self, key: i32) -> bool {
        let mut h = self.hash(key);
        for _ in 0..self.capacity {
            match self.table[h].2 {
                BucketStatus::Empty => return false,
                BucketStatus::Occupied if self.table[h].0 == key => {
                    self.table[h].2 = BucketStatus::Deleted;
                    return true;
                }
                _ => {
                    h = (h + 1) % self.capacity;
                }
            }
        }
        false
    }
}

// ============================================================
// テスト
// ============================================================

#[cfg(test)]
mod tests {
    use super::*;

    // --------------------------------------------------------
    // 線形探索
    // --------------------------------------------------------

    #[test]
    fn test_seq_search_found() {
        assert_eq!(seq_search(&[6, 4, 3, 2, 1, 2, 8], 2), Some(3));
    }

    #[test]
    fn test_seq_search_first_element() {
        assert_eq!(seq_search(&[6, 4, 3, 2, 1, 2, 8], 6), Some(0));
    }

    #[test]
    fn test_seq_search_last_element() {
        assert_eq!(seq_search(&[6, 4, 3, 2, 1, 2, 8], 8), Some(6));
    }

    #[test]
    fn test_seq_search_not_found() {
        assert_eq!(seq_search(&[1, 2, 3], 99), None);
    }

    #[test]
    fn test_seq_search_empty_array() {
        assert_eq!(seq_search(&[], 1), None);
    }

    // --------------------------------------------------------
    // 番兵法
    // --------------------------------------------------------

    #[test]
    fn test_seq_search_sentinel_found() {
        assert_eq!(seq_search_sentinel(&[6, 4, 3, 2, 1, 2, 8], 2), Some(3));
    }

    #[test]
    fn test_seq_search_sentinel_first() {
        assert_eq!(seq_search_sentinel(&[6, 4, 3, 2, 1, 2, 8], 6), Some(0));
    }

    #[test]
    fn test_seq_search_sentinel_last() {
        assert_eq!(seq_search_sentinel(&[6, 4, 3, 2, 1, 2, 8], 8), Some(6));
    }

    #[test]
    fn test_seq_search_sentinel_not_found() {
        assert_eq!(seq_search_sentinel(&[1, 2, 3], 99), None);
    }

    #[test]
    fn test_seq_search_sentinel_empty() {
        assert_eq!(seq_search_sentinel(&[], 1), None);
    }

    // --------------------------------------------------------
    // 二分探索
    // --------------------------------------------------------

    #[test]
    fn test_bin_search_found() {
        assert_eq!(bin_search(&[1, 2, 3, 5, 7, 8, 9], 5), Some(3));
    }

    #[test]
    fn test_bin_search_first() {
        assert_eq!(bin_search(&[1, 2, 3, 5, 7, 8, 9], 1), Some(0));
    }

    #[test]
    fn test_bin_search_last() {
        assert_eq!(bin_search(&[1, 2, 3, 5, 7, 8, 9], 9), Some(6));
    }

    #[test]
    fn test_bin_search_not_found() {
        assert_eq!(bin_search(&[1, 2, 3, 5, 7, 8, 9], 4), None);
    }

    #[test]
    fn test_bin_search_empty() {
        assert_eq!(bin_search(&[], 1), None);
    }

    #[test]
    fn test_bin_search_single_found() {
        assert_eq!(bin_search(&[42], 42), Some(0));
    }

    #[test]
    fn test_bin_search_single_not_found() {
        assert_eq!(bin_search(&[42], 1), None);
    }

    // --------------------------------------------------------
    // チェイン法ハッシュ
    // --------------------------------------------------------

    #[test]
    fn test_chain_hash_add_and_search() {
        let mut h = ChainHash::new(13);
        assert!(h.add(1, 100));
        assert!(h.add(14, 200)); // 1%13==1, 14%13==1 → 衝突
        assert_eq!(h.search(1), Some(100));
        assert_eq!(h.search(14), Some(200));
    }

    #[test]
    fn test_chain_hash_search_not_found() {
        let h = ChainHash::new(13);
        assert_eq!(h.search(99), None);
    }

    #[test]
    fn test_chain_hash_add_duplicate() {
        let mut h = ChainHash::new(13);
        assert!(h.add(1, 100));
        assert!(!h.add(1, 999)); // 重複
    }

    #[test]
    fn test_chain_hash_remove() {
        let mut h = ChainHash::new(13);
        h.add(1, 100);
        h.add(14, 200);
        assert!(h.remove(1));
        assert_eq!(h.search(1), None);
        assert_eq!(h.search(14), Some(200)); // 衝突先は残る
    }

    #[test]
    fn test_chain_hash_remove_not_found() {
        let mut h = ChainHash::new(13);
        assert!(!h.remove(42));
    }

    // --------------------------------------------------------
    // オープンアドレス法ハッシュ
    // --------------------------------------------------------

    #[test]
    fn test_open_hash_add_and_search() {
        let mut h = OpenHash::new(13);
        assert!(h.add(1, 100));
        assert!(h.add(14, 200)); // 衝突
        assert_eq!(h.search(1), Some(100));
        assert_eq!(h.search(14), Some(200));
    }

    #[test]
    fn test_open_hash_search_not_found() {
        let h = OpenHash::new(13);
        assert_eq!(h.search(99), None);
    }

    #[test]
    fn test_open_hash_add_duplicate() {
        let mut h = OpenHash::new(13);
        assert!(h.add(1, 100));
        assert!(!h.add(1, 999));
    }

    #[test]
    fn test_open_hash_remove() {
        let mut h = OpenHash::new(13);
        h.add(1, 100);
        h.add(14, 200);
        assert!(h.remove(1));
        assert_eq!(h.search(1), None);
        assert_eq!(h.search(14), Some(200));
    }

    #[test]
    fn test_open_hash_remove_not_found() {
        let mut h = OpenHash::new(13);
        assert!(!h.remove(42));
    }

    #[test]
    fn test_open_hash_add_after_remove() {
        let mut h = OpenHash::new(13);
        h.add(1, 100);
        h.remove(1);
        assert!(h.add(1, 300)); // DELETED スロットへの再挿入
        assert_eq!(h.search(1), Some(300));
    }

    #[test]
    fn test_open_hash_full_table() {
        let mut h = OpenHash::new(3);
        assert!(h.add(0, 10));
        assert!(h.add(1, 20));
        assert!(h.add(2, 30));
        assert!(!h.add(3, 40)); // 満杯
    }
}
