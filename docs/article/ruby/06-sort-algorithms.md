# 第 6 章 ソートアルゴリズム

## はじめに

ソートとは、データを一定の順序（昇順・降順など）に並び替える処理です。この章では、代表的なソートアルゴリズムを TDD で実装します。

---

## 共通テスト

```ruby
let(:unsorted) { [6, 4, 3, 7, 1, 9, 8] }
let(:sorted)   { [1, 3, 4, 6, 7, 8, 9] }
```

---

## 1. バブルソート

隣接する要素を比較・交換し、最大値を末尾へ「浮き上がらせる」。

### Red — テストを書く

```ruby
describe "Algorithm.bubble_sort" do
  it "バブルソート（in-place）" do
    a = [6, 4, 3, 7, 1, 9, 8]
    Algorithm.bubble_sort(a)
    expect(a).to eq([1, 3, 4, 6, 7, 8, 9])
  end
end
```

### Green — 実装

```ruby
def self.bubble_sort(a)
  n = a.length
  (n - 1).times do |i|
    swapped = false
    (n - 1).downto(i + 1) do |j|
      if a[j - 1] > a[j]
        a[j - 1], a[j] = a[j], a[j - 1]
        swapped = true
      end
    end
    break unless swapped
  end
end
```

### バブルソートの最適化

#### 走査範囲の限定（第3版）

各走査で最後に交換が行われた位置より先は既にソート済みです。次の走査ではその位置までしか見る必要がありません。

```ruby
def self.bubble_sort3(a)
  n = a.length
  k = 0
  while k < n - 1
    last = n - 1
    (n - 1).downto(k + 1) do |j|
      if a[j - 1] > a[j]
        a[j - 1], a[j] = a[j], a[j - 1]
        last = j
      end
    end
    k = last
  end
end
```

### シェーカーソート

シェーカーソート（双方向バブルソート）は、走査を交互に上向きと下向きに行います。小さな値が先頭に、大きな値が末尾に同時に移動します。

```ruby
def self.shaker_sort(a)
  left = 0
  right = a.length - 1
  last = right
  while left < right
    # 下向きの走査（大きい値を後方へ）
    right.downto(left + 1) do |j|
      if a[j - 1] > a[j]
        a[j - 1], a[j] = a[j], a[j - 1]
        last = j
      end
    end
    left = last

    # 上向きの走査（小さい値を前方へ）
    (left...right).each do |j|
      if a[j] > a[j + 1]
        a[j], a[j + 1] = a[j + 1], a[j]
        last = j
      end
    end
    right = last
  end
end
```

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合）

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 逆順ループ | `range(n-1, i, -1)` | `(n-1).downto(i+1)` |
| break 条件 | `if not swapped: break` | `break unless swapped` |

---

## 2. 選択ソート

未整列部分の最小値を探し、先頭と交換する。

```ruby
def self.selection_sort(a)
  n = a.length
  (n - 1).times do |i|
    min_idx = i
    (i + 1...n).each { |j| min_idx = j if a[j] < a[min_idx] }
    a[i], a[min_idx] = a[min_idx], a[i] if min_idx != i
  end
end
```

---

## 3. 挿入ソート

未整列部分の先頭要素を、整列済み部分の適切な位置に挿入する。

```ruby
def self.insertion_sort(a)
  n = a.length
  (1...n).each do |i|
    key = a[i]
    j = i - 1
    while j >= 0 && a[j] > key
      a[j + 1] = a[j]
      j -= 1
    end
    a[j + 1] = key
  end
end
```

### 二分挿入ソート

挿入ソートの改良版として、二分探索を使って挿入位置を効率的に見つける「二分挿入ソート」があります：

```ruby
def self.binary_insertion_sort(a)
  n = a.length
  (1...n).each do |i|
    key = a[i]
    pl = 0
    pr = i - 1

    loop do
      pc = (pl + pr) / 2
      if a[pc] == key
        break
      elsif a[pc] < key
        pl = pc + 1
      else
        pr = pc - 1
      end
      break if pl > pr
    end

    pd = pl <= pr ? pc + 1 : pr + 1

    i.downto(pd + 1) { |j| a[j] = a[j - 1] }
    a[pd] = key
  end
end
```

**計算量**: 最悪 O(n²)、最良 O(n)（整列済みの場合）

挿入位置の探索は O(log n) に改善されますが、要素の移動コストは変わらないため、全体の時間計算量は依然として O(n²) です。

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 無限ループ | `while True:` + `break` | `loop do` + `break` |
| 三項演算子 | `pc + 1 if pl <= pr else pr + 1` | `pl <= pr ? pc + 1 : pr + 1` |
| `bisect` モジュール | Python 標準ライブラリにあり | Ruby には対応する標準ライブラリなし |

---

## 4. シェルソート（Knuth 数列）

挿入ソートの改良。間隔（gap）を縮小しながら複数回の挿入ソートを行う。

```ruby
def self.shell_sort(a)
  n = a.length
  gap = 1
  gap = gap * 3 + 1 while gap * 3 + 1 < n

  while gap > 0
    (gap...n).each do |i|
      key = a[i]
      j = i - gap
      while j >= 0 && a[j] > key
        a[j + gap] = a[j]
        j -= gap
      end
      a[j + gap] = key
    end
    gap /= 3
  end
end
```

---

## 5. クイックソート

ピボットを基準に配列を分割し、再帰的にソートする。

```ruby
def self.quick_sort(a, left = 0, right = nil)
  right ||= a.length - 1
  return if left >= right

  pivot = a[(left + right) / 2]
  i, j = left, right

  while i <= j
    i += 1 while a[i] < pivot
    j -= 1 while a[j] > pivot
    if i <= j
      a[i], a[j] = a[j], a[i]
      i += 1
      j -= 1
    end
  end

  quick_sort(a, left, j)
  quick_sort(a, i, right)
end
```

### 非再帰的クイックソート

再帰を使わずにスタックを用いて実装することもできます：

```ruby
def self.qsort_stack(a, left = 0, right = nil)
  right ||= a.length - 1
  stack = [[left, right]]

  while stack.any?
    left, right = stack.pop
    pl = left
    pr = right
    x = a[(left + right) / 2]

    while pl <= pr
      pl += 1 while a[pl] < x
      pr -= 1 while a[pr] > x
      if pl <= pr
        a[pl], a[pr] = a[pr], a[pl]
        pl += 1
        pr -= 1
      end
    end

    stack << [left, pr] if left < pr
    stack << [pl, right] if pl < right
  end
end
```

**計算量**: 平均 O(n log n)、最悪 O(n²)

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| デフォルト引数 | `right: int = None` | `right = nil` |
| None チェック | `if right is None: right = ...` | `right \|\|= a.length - 1` |
| スタック操作 | `stack.append(...)` / `stack.pop()` | `stack << [...]` / `stack.pop` |

---

## 6. マージソート

配列を半分に分割し、再帰的にソートして結合する。

### ソート済み配列のマージ

マージソートの核心は、2 つのソート済み配列をマージする手順です：

```ruby
def self.merge_sorted_array(a, b, c)
  pa = pb = pc = 0
  na = a.length
  nb = b.length

  while pa < na && pb < nb
    if a[pa] <= b[pb]
      c[pc] = a[pa]; pa += 1
    else
      c[pc] = b[pb]; pb += 1
    end
    pc += 1
  end

  while pa < na
    c[pc] = a[pa]; pa += 1; pc += 1
  end

  while pb < nb
    c[pc] = b[pb]; pb += 1; pc += 1
  end
end
```

使用例：

```ruby
a = [1, 3, 5, 7]
b = [2, 4, 6, 8]
c = Array.new(8)
Algorithm.merge_sorted_array(a, b, c)
# c => [1, 2, 3, 4, 5, 6, 7, 8]
```

### マージソート本体

```ruby
def self.merge_sort(a)
  return a.dup if a.length <= 1

  mid = a.length / 2
  left = merge_sort(a[0...mid])
  right = merge_sort(a[mid..])
  _merge(left, right)
end

def self._merge(left, right)
  result = []
  i = j = 0
  while i < left.length && j < right.length
    if left[i] <= right[j]
      result << left[i]
      i += 1
    else
      result << right[j]
      j += 1
    end
  end
  result.concat(left[i..])
  result.concat(right[j..])
  result
end
private_class_method :_merge
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| スライス（末尾まで） | `a[mid:]` | `a[mid..]` |
| リスト拡張 | `result.extend(left[i:])` | `result.concat(left[i..])` |

---

## 7. ヒープソート

ヒープデータ構造を利用し、最大値を末尾へ移動することを繰り返す。

```ruby
def self.heap_sort(a)
  n = a.length

  down_heap = lambda do |arr, left, right|
    temp = arr[left]
    parent = left
    while parent < (right + 1) / 2
      cl = parent * 2 + 1
      cr = cl + 1
      child = (cr <= right && arr[cr] > arr[cl]) ? cr : cl
      break if temp >= arr[child]
      arr[parent] = arr[child]
      parent = child
    end
    arr[parent] = temp
  end

  ((n - 1) / 2).downto(0) { |i| down_heap.call(a, i, n - 1) }
  (n - 1).downto(1) do |i|
    a[0], a[i] = a[i], a[0]
    down_heap.call(a, 0, i - 1)
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| ネスト関数 | `def down_heap(...):` | `down_heap = lambda do \|...\| end` |
| ラムダ呼び出し | 直接呼び出し | `down_heap.call(...)` |

Ruby のラムダ（`lambda do...end` または `->(){}`）で内部関数を表現できます。

---

## 8. 度数ソート（計数ソート）

要素の値の頻度を数えて整列する（非負整数のみ）。

```ruby
def self.counting_sort(a)
  return [] if a.empty?

  max_val = a.max
  freq = Array.new(max_val + 1, 0)
  a.each { |x| freq[x] += 1 }
  (1...freq.length).each { |i| freq[i] += freq[i - 1] }

  result = Array.new(a.length, 0)
  a.reverse_each do |x|
    freq[x] -= 1
    result[freq[x]] = x
  end
  result
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 最大値 | `max(a)` | `a.max` |
| 逆順イテレーション | `reversed(a)` | `a.reverse_each` |
| 初期化配列 | `[0] * n` | `Array.new(n, 0)` |

---

## まとめ

| アルゴリズム | 計算量（平均） | 計算量（最悪） | 安定性 |
|-------------|--------------|--------------|--------|
| バブルソート | O(n²) | O(n²) | 安定 |
| 選択ソート | O(n²) | O(n²) | 不安定 |
| 挿入ソート | O(n²) | O(n²) | 安定 |
| シェルソート | O(n^1.5) | O(n²) | 不安定 |
| クイックソート | O(n log n) | O(n²) | 不安定 |
| マージソート | O(n log n) | O(n log n) | 安定 |
| ヒープソート | O(n log n) | O(n log n) | 不安定 |
| 度数ソート | O(n+k) | O(n+k) | 安定 |

### Ruby の特徴

- `(n-1).downto(0)` で逆順ループ
- `a.max` / `a.min` で最大・最小値を取得
- `a.reverse_each` で逆順イテレーション
- ラムダ: `lambda do |...| end` または `->(...){ }` で内部関数を定義
- `private_class_method :method_name` でクラスメソッドをプライベート化
