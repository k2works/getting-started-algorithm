# 第 6 章 ソートアルゴリズム

## はじめに

前章では再帰アルゴリズムを学びました。この章では、データを特定の順序に並べ替える「ソートアルゴリズム」を TDD で実装します。

ソートは、コンピュータサイエンスにおける最も基本的かつ重要な操作の一つです。データが整列されていると、検索や他の操作が効率的に行えるようになります。

Rust ではスライスの `swap` メソッドや所有権システムにより、in-place ソートを安全に記述できます。また、`isize` へのキャストを用いることで、C 言語的なインデックス操作も型安全に扱えます。

### 目次

1. [バブルソート](#1-バブルソート)
2. [選択ソート](#2-選択ソート)
3. [挿入ソート](#3-挿入ソート)
4. [シェルソート](#4-シェルソート)
5. [クイックソート](#5-クイックソート)
6. [マージソート](#6-マージソート)
7. [ヒープソート](#7-ヒープソート)
8. [度数ソート](#8-度数ソート)

---

## 1. バブルソート

隣接する要素を比較・交換し、最大値を末尾へ「浮き上がらせる」アルゴリズムです。

### Red -- 失敗するテストを書く

```rust
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
```

### Green -- テストを通す実装

```rust
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
```

`saturating_sub(1)` を使うことで、空配列（`len() == 0`）の場合にアンダーフローを防ぎます。`swapped` フラグにより、交換が発生しなかったパスで早期終了します。

### バブルソートの変種

#### 改良版（交換回数カウント）

```rust
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
```

#### シェーカーソート（双方向バブルソート）

```rust
pub fn shaker_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 { return; }
    let mut left = 0usize;
    let mut right = n - 1;
    let mut last = right;
    while left < right {
        // 下向きの走査（右→左）
        let mut j = right;
        while j > left {
            if a[j - 1] > a[j] { a.swap(j - 1, j); last = j; }
            j -= 1;
        }
        left = last;
        // 上向きの走査（左→右）
        j = left;
        while j < right {
            if a[j] > a[j + 1] { a.swap(j, j + 1); last = j; }
            j += 1;
        }
        right = last;
    }
}
```

---

## 2. 選択ソート

未整列部分の最小値を探し、先頭と交換するアルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_selection_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    selection_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
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
```

各パスで最大 1 回の交換しか行わないため、バブルソートより交換回数が少ないのが特徴です。

---

## 3. 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入するアルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_insertion_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    insertion_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
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
```

Rust では `usize` が符号なしのため、`j` を `isize` にキャストして `-1` との比較を安全に行います。データがほぼ整列済みの場合に O(n) で動作します。

---

## 4. シェルソート

挿入ソートの改良版。間隔（gap）を縮小しながら複数回の挿入ソートを行います。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_shell_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    shell_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
pub fn shell_sort(a: &mut Vec<i32>) {
    let n = a.len();
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
```

Knuth 数列（`h = 3h + 1`: 1, 4, 13, 40, ...）を gap として使用します。

---

## 5. クイックソート

ピボットを基準に配列を分割し、再帰的にソートするアルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_quick_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    quick_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
pub fn quick_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 { return; }
    quick_sort_range(a, 0, n - 1);
}

fn quick_sort_range(a: &mut Vec<i32>, left: usize, right: usize) {
    if left >= right { return; }
    let pivot = a[(left + right) / 2];
    let mut i = left as isize;
    let mut j = right as isize;
    while i <= j {
        while a[i as usize] < pivot { i += 1; }
        while a[j as usize] > pivot { j -= 1; }
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
```

中央要素をピボットに選ぶことで、整列済みデータでの最悪ケースを回避しています。

---

## 6. マージソート

配列を半分に分割し、再帰的にソートして結合するアルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_merge_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    merge_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
pub fn merge_sort(a: &mut Vec<i32>) {
    let sorted = merge_sort_recursive(a);
    a.clear();
    a.extend(sorted);
}

fn merge_sort_recursive(a: &[i32]) -> Vec<i32> {
    if a.len() <= 1 { return a.to_vec(); }
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
            result.push(left[i]); i += 1;
        } else {
            result.push(right[j]); j += 1;
        }
    }
    result.extend_from_slice(&left[i..]);
    result.extend_from_slice(&right[j..]);
    result
}
```

Rust のスライス機能（`&a[..mid]`, `&a[mid..]`）により、分割が簡潔に書けます。安定ソートです。

---

## 7. ヒープソート

ヒープデータ構造を利用したソートアルゴリズムです。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_heap_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    heap_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
pub fn heap_sort(a: &mut Vec<i32>) {
    let n = a.len();
    if n <= 1 { return; }
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
        let cl = parent * 2 + 1;
        let cr = cl + 1;
        let child = if cr <= right && a[cr] > a[cl] { cr } else { cl };
        if temp >= a[child] { break; }
        a[parent] = a[child];
        parent = child;
    }
    a[parent] = temp;
}
```

追加メモリなしで O(n log n) を保証します。

---

## 8. 度数ソート

要素の値の頻度を数えて整列する、比較を行わないソートアルゴリズムです。非負整数のみ対応。

### Red -- 失敗するテストを書く

```rust
#[test]
fn test_counting_sort_basic() {
    let mut a = vec![6, 4, 3, 7, 1, 9, 8];
    counting_sort(&mut a);
    assert_eq!(a, vec![1, 3, 4, 6, 7, 8, 9]);
}
```

### Green -- テストを通す実装

```rust
pub fn counting_sort(a: &mut Vec<i32>) {
    if a.is_empty() { return; }
    let max_val = *a.iter().max().unwrap() as usize;
    let mut freq = vec![0usize; max_val + 1];
    for &x in a.iter() { freq[x as usize] += 1; }
    for i in 1..freq.len() { freq[i] += freq[i - 1]; }
    let mut result = vec![0i32; a.len()];
    for &x in a.iter().rev() {
        freq[x as usize] -= 1;
        result[freq[x as usize]] = x;
    }
    a.copy_from_slice(&result);
}
```

逆順に処理することで安定ソートを実現します。O(n + k) の線形時間で動作します。

---

## アルゴリズム比較

| アルゴリズム | 平均 | 最悪 | 安定 | 特徴 |
|------------|------|------|------|------|
| バブル | O(n²) | O(n²) | ✓ | 早期終了可 |
| 選択 | O(n²) | O(n²) | ✗ | 交換回数が少ない |
| 挿入 | O(n²) | O(n²) | ✓ | ほぼ整列済みに強い |
| シェル | O(n^1.5) | O(n²) | ✗ | 挿入の改良 |
| クイック | O(n log n) | O(n²) | ✗ | 実用的に最速 |
| マージ | O(n log n) | O(n log n) | ✓ | 安定・追加メモリ必要 |
| ヒープ | O(n log n) | O(n log n) | ✗ | 追加メモリ不要 |
| 度数 | O(n+k) | O(n+k) | ✓ | 値の範囲が限定的な場合 |

---

## テスト実行結果

```bash
$ cargo test --manifest-path apps/rust/Cargo.toml -p chapter06
running 46 tests
test result: ok. 46 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

---

## まとめ

Rust でのソート実装の特徴：

- `Vec::swap` メソッドにより、借用チェッカーと両立した安全な要素交換ができる
- `usize` が符号なしのため、負の添字が必要な場面では `isize` へのキャストが必要
- `saturating_sub(1)` で空配列のアンダーフローを防ぐイディオムが頻出する
- スライス（`&a[..mid]`）による分割は、追加のメモリコピーなしに部分配列を参照できる
- `copy_from_slice` で出力配列を元の `Vec` に効率的に書き戻せる

## 参考文献

- 『新・明解 C で学ぶアルゴリズムとデータ構造』 -- 柴田望洋
- 『テスト駆動開発』 -- Kent Beck
