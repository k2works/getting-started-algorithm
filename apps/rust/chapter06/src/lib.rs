// chapter06: ソートアルゴリズム

/// バブルソート（単純交換ソート）
///
/// 隣接する要素を比較・交換し、最大値を末尾へ浮き上がらせる。
/// 最適化: 交換が発生しなければ終了。
///
/// 計算量: O(n²) 最悪, O(n) 最良（整列済み）
pub fn bubble_sort(a: &mut Vec<i32>) {
    let n = a.len();
    for i in 0..n.saturating_sub(1) {
        let mut swapped = false;
        for j in (i + 1..n).rev() {
            if a[j - 1] > a[j] {
                a.swap(j - 1, j);
                swapped = true;
            }
        }
        if !swapped {
            break;
        }
    }
}

/// バブルソート改良版（交換回数カウントによる早期終了）
///
/// 各パスで交換が 0 回なら整列完了と判断して終了する。
pub fn bubble_sort2(a: &mut Vec<i32>) {
    let n = a.len();
    for i in 0..n.saturating_sub(1) {
        let mut exchng = 0;
        for j in (i + 1..n).rev() {
            if a[j - 1] > a[j] {
                a.swap(j - 1, j);
                exchng += 1;
            }
        }
        if exchng == 0 {
            break;
        }
    }
}

/// シェーカーソート（双方向バブルソート）
///
/// 走査を交互に上向きと下向きに行い、小さな値を先頭へ、
/// 大きな値を末尾へ同時に移動させる。
pub fn shaker_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 {
        return;
    }
    let mut left = 0usize;
    let mut right = n - 1;
    let mut last = right;

    while left < right {
        // 下向きの走査（右→左）
        let mut j = right;
        while j > left {
            if a[j - 1] > a[j] {
                a.swap(j - 1, j);
                last = j;
            }
            j -= 1;
        }
        left = last;

        // 上向きの走査（左→右）
        j = left;
        while j < right {
            if a[j] > a[j + 1] {
                a.swap(j, j + 1);
                last = j;
            }
            j += 1;
        }
        right = last;
    }
}

/// 選択ソート（単純選択ソート）
///
/// 未整列部分の最小値を探し、先頭と交換する。
///
/// 計算量: O(n²)
pub fn selection_sort(a: &mut Vec<i32>) {
    let n = a.len();
    for i in 0..n.saturating_sub(1) {
        let mut min_idx = i;
        for j in (i + 1)..n {
            if a[j] < a[min_idx] {
                min_idx = j;
            }
        }
        if min_idx != i {
            a.swap(i, min_idx);
        }
    }
}

/// 挿入ソート（単純挿入ソート）
///
/// 未整列部分の先頭要素を、整列済み部分の適切な位置に挿入する。
///
/// 計算量: O(n²) 最悪, O(n) 最良（整列済み）
pub fn insertion_sort(a: &mut Vec<i32>) {
    let n = a.len();
    for i in 1..n {
        let key = a[i];
        let mut j = i as isize - 1;
        while j >= 0 && a[j as usize] > key {
            a[(j + 1) as usize] = a[j as usize];
            j -= 1;
        }
        a[(j + 1) as usize] = key;
    }
}

/// シェルソート
///
/// 挿入ソートの改良版。間隔（gap）を縮小しながら複数回の挿入ソートを行う。
/// Knuth 数列（1, 4, 13, 40, ...）を使用。
///
/// 計算量: O(n^(3/2)) ～ O(n log²n)
pub fn shell_sort(a: &mut Vec<i32>) {
    let n = a.len();
    // Knuth 数列で最大 gap を決定
    let mut gap = 1usize;
    while gap * 3 + 1 < n {
        gap = gap * 3 + 1;
    }

    while gap > 0 {
        for i in gap..n {
            let key = a[i];
            let mut j = i as isize - gap as isize;
            while j >= 0 && a[j as usize] > key {
                a[(j as usize) + gap] = a[j as usize];
                j -= gap as isize;
            }
            a[(j + gap as isize) as usize] = key;
        }
        gap /= 3;
    }
}

/// クイックソート
///
/// ピボットを基準に配列を分割し、再帰的にソートする。
///
/// 計算量: O(n log n) 平均, O(n²) 最悪
pub fn quick_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 {
        return;
    }
    quick_sort_range(a, 0, n - 1);
}

fn quick_sort_range(a: &mut Vec<i32>, left: usize, right: usize) {
    if left >= right {
        return;
    }
    let pivot = a[(left + right) / 2];
    let mut i = left as isize;
    let mut j = right as isize;

    while i <= j {
        while a[i as usize] < pivot {
            i += 1;
        }
        while a[j as usize] > pivot {
            j -= 1;
        }
        if i <= j {
            a.swap(i as usize, j as usize);
            i += 1;
            j -= 1;
        }
    }

    if j > left as isize {
        quick_sort_range(a, left, j as usize);
    }
    if (i as usize) < right {
        quick_sort_range(a, i as usize, right);
    }
}

/// マージソート
///
/// 配列を半分に分割し、再帰的にソートして結合する。
///
/// 計算量: O(n log n)
pub fn merge_sort(a: &mut Vec<i32>) {
    let sorted = merge_sort_recursive(a);
    a.clear();
    a.extend(sorted);
}

fn merge_sort_recursive(a: &[i32]) -> Vec<i32> {
    if a.len() <= 1 {
        return a.to_vec();
    }
    let mid = a.len() / 2;
    let left = merge_sort_recursive(&a[..mid]);
    let right = merge_sort_recursive(&a[mid..]);
    merge(&left, &right)
}

fn merge(left: &[i32], right: &[i32]) -> Vec<i32> {
    let mut result = Vec::with_capacity(left.len() + right.len());
    let (mut i, mut j) = (0, 0);
    while i < left.len() && j < right.len() {
        if left[i] <= right[j] {
            result.push(left[i]);
            i += 1;
        } else {
            result.push(right[j]);
            j += 1;
        }
    }
    result.extend_from_slice(&left[i..]);
    result.extend_from_slice(&right[j..]);
    result
}

/// ヒープソート
///
/// ヒープデータ構造を利用したソートアルゴリズム。
/// 最大ヒープを構築してから、最大値を末尾に移動することを繰り返す。
///
/// 計算量: O(n log n)
pub fn heap_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 {
        return;
    }
    // 最大ヒープを構築
    for i in (0..=(n - 1) / 2).rev() {
        down_heap(a, i, n - 1);
    }
    // ヒープの最大要素と未ソート部末尾要素を交換
    for i in (1..n).rev() {
        a.swap(0, i);
        down_heap(a, 0, i - 1);
    }
}

fn down_heap(a: &mut Vec<i32>, left: usize, right: usize) {
    let temp = a[left];
    let mut parent = left;
    while parent < (right + 1) / 2 {
        let cl = parent * 2 + 1; // 左の子
        let cr = cl + 1; // 右の子
        let child = if cr <= right && a[cr] > a[cl] {
            cr
        } else {
            cl
        };
        if temp >= a[child] {
            break;
        }
        a[parent] = a[child];
        parent = child;
    }
    a[parent] = temp;
}

/// 度数ソート（計数ソート）
///
/// 要素の値の頻度を数えて整列する。非負整数のみ対応。
///
/// 計算量: O(n + k)（k は値の最大値）
pub fn counting_sort(a: &mut Vec<i32>) {
    if a.is_empty() {
        return;
    }
    let max_val = *a.iter().max().unwrap() as usize;
    // 度数（各値の出現回数）
    let mut freq = vec![0usize; max_val + 1];
    for &x in a.iter() {
        freq[x as usize] += 1;
    }
    // 累積度数
    for i in 1..freq.len() {
        freq[i] += freq[i - 1];
    }
    // 出力配列を後ろから埋める（安定ソート）
    let mut result = vec![0i32; a.len()];
    for &x in a.iter().rev() {
        freq[x as usize] -= 1;
        result[freq[x as usize]] = x;
    }
    a.copy_from_slice(&result);
}

#[cfg(test)]
mod tests {
    use super::*;

    // ── ヘルパー ──────────────────────────
    fn assert_sorted(a: &[i32]) {
        for i in 0..a.len().saturating_sub(1) {
            assert!(a[i] <= a[i + 1], "not sorted at index {}: {} > {}", i, a[i], a[i + 1]);
        }
    }

    // ── 1. バブルソート ──────────────────────
    #[test]
    fn test_bubble_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        bubble_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_bubble_sort_already_sorted() {
        let mut a = vec![1, 3, 4, 6, 7, 8, 9];
        bubble_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_bubble_sort_empty() {
        let mut a: Vec<i32> = vec![];
        bubble_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_bubble_sort_single() {
        let mut a = vec![42];
        bubble_sort(&mut a);
        assert_eq!(a, vec![42]);
    }

    #[test]
    fn test_bubble_sort_reverse() {
        let mut a = vec![5, 4, 3, 2, 1];
        bubble_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    // ── 2. バブルソート改良版 ─────────────────
    #[test]
    fn test_bubble_sort2_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        bubble_sort2(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_bubble_sort2_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        bubble_sort2(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_bubble_sort2_empty() {
        let mut a: Vec<i32> = vec![];
        bubble_sort2(&mut a);
        assert_eq!(a, vec![]);
    }

    // ── 3. シェーカーソート ─────────────────────
    #[test]
    fn test_shaker_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        shaker_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_shaker_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        shaker_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_shaker_sort_reverse() {
        let mut a = vec![5, 4, 3, 2, 1];
        shaker_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_shaker_sort_empty() {
        let mut a: Vec<i32> = vec![];
        shaker_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_shaker_sort_single() {
        let mut a = vec![1];
        shaker_sort(&mut a);
        assert_eq!(a, vec![1]);
    }

    // ── 4. 選択ソート ───────────────────────
    #[test]
    fn test_selection_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        selection_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_selection_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        selection_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_selection_sort_empty() {
        let mut a: Vec<i32> = vec![];
        selection_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_selection_sort_duplicates() {
        let mut a = vec![3, 1, 4, 1, 5, 9, 2, 6, 5];
        selection_sort(&mut a);
        assert_sorted(&a);
        assert_eq!(a, vec![1, 1, 2, 3, 4, 5, 5, 6, 9]);
    }

    // ── 5. 挿入ソート ───────────────────────
    #[test]
    fn test_insertion_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        insertion_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_insertion_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        insertion_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_insertion_sort_empty() {
        let mut a: Vec<i32> = vec![];
        insertion_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_insertion_sort_reverse() {
        let mut a = vec![5, 4, 3, 2, 1];
        insertion_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    // ── 6. シェルソート ──────────────────────
    #[test]
    fn test_shell_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        shell_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_shell_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        shell_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_shell_sort_empty() {
        let mut a: Vec<i32> = vec![];
        shell_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_shell_sort_large() {
        let mut a = vec![10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
        shell_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    }

    // ── 7. クイックソート ────────────────────
    #[test]
    fn test_quick_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        quick_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_quick_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        quick_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_quick_sort_empty() {
        let mut a: Vec<i32> = vec![];
        quick_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_quick_sort_single() {
        let mut a = vec![42];
        quick_sort(&mut a);
        assert_eq!(a, vec![42]);
    }

    #[test]
    fn test_quick_sort_duplicates() {
        let mut a = vec![3, 1, 4, 1, 5, 9, 2, 6, 5];
        quick_sort(&mut a);
        assert_eq!(a, vec![1, 1, 2, 3, 4, 5, 5, 6, 9]);
    }

    // ── 8. マージソート ──────────────────────
    #[test]
    fn test_merge_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        merge_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_merge_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        merge_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_merge_sort_empty() {
        let mut a: Vec<i32> = vec![];
        merge_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_merge_sort_single() {
        let mut a = vec![42];
        merge_sort(&mut a);
        assert_eq!(a, vec![42]);
    }

    #[test]
    fn test_merge_sort_duplicates() {
        let mut a = vec![3, 1, 4, 1, 5, 9, 2, 6, 5];
        merge_sort(&mut a);
        assert_eq!(a, vec![1, 1, 2, 3, 4, 5, 5, 6, 9]);
    }

    // ── 9. ヒープソート ──────────────────────
    #[test]
    fn test_heap_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        heap_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_heap_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        heap_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_heap_sort_empty() {
        let mut a: Vec<i32> = vec![];
        heap_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_heap_sort_single() {
        let mut a = vec![42];
        heap_sort(&mut a);
        assert_eq!(a, vec![42]);
    }

    #[test]
    fn test_heap_sort_reverse() {
        let mut a = vec![5, 4, 3, 2, 1];
        heap_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    // ── 10. 度数ソート（計数ソート） ──────────────
    #[test]
    fn test_counting_sort_basic() {
        let mut a = vec![6, 4, 3, 7, 1, 9, 8];
        counting_sort(&mut a);
        assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
    }

    #[test]
    fn test_counting_sort_already_sorted() {
        let mut a = vec![1, 2, 3, 4, 5];
        counting_sort(&mut a);
        assert_eq!(a, vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn test_counting_sort_empty() {
        let mut a: Vec<i32> = vec![];
        counting_sort(&mut a);
        assert_eq!(a, vec![]);
    }

    #[test]
    fn test_counting_sort_duplicates() {
        let mut a = vec![3, 1, 4, 1, 5, 9, 2, 6, 5];
        counting_sort(&mut a);
        assert_eq!(a, vec![1, 1, 2, 3, 4, 5, 5, 6, 9]);
    }

    #[test]
    fn test_counting_sort_single() {
        let mut a = vec![42];
        counting_sort(&mut a);
        assert_eq!(a, vec![42]);
    }

    // ── 全ソートアルゴリズムの共通テスト ──────────────
    #[test]
    fn test_all_sorts_produce_same_result() {
        let original = vec![9, 3, 7, 1, 8, 2, 6, 4, 5, 0];
        let expected = vec![0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

        let sort_fns: Vec<(&str, fn(&mut Vec<i32>))> = vec![
            ("bubble_sort", bubble_sort),
            ("bubble_sort2", bubble_sort2),
            ("shaker_sort", shaker_sort),
            ("selection_sort", selection_sort),
            ("insertion_sort", insertion_sort),
            ("shell_sort", shell_sort),
            ("quick_sort", quick_sort),
            ("merge_sort", merge_sort),
            ("heap_sort", heap_sort),
            ("counting_sort", counting_sort),
        ];

        for (name, sort_fn) in sort_fns {
            let mut a = original.clone();
            sort_fn(&mut a);
            assert_eq!(a, expected, "{} failed", name);
        }
    }
}
