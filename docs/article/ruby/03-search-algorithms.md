# 第 3 章 探索アルゴリズム

## はじめに

探索（サーチ）とは、多くのデータの中から目的のデータを探し出す処理のことです。この章では、線形探索・二分探索・ハッシュ法の 3 種類を TDD で実装します。

---

## 1. 線形探索

配列の先頭から末尾に向かって順番に探していく方法です。

### 1-1. while 文による線形探索

```ruby
def self.ssearch_while(a, key)
  i = 0
  loop do
    return -1 if i == a.length
    return i if a[i] == key

    i += 1
  end
end
```

### 1-2. each による線形探索

```ruby
def self.ssearch_for(a, key)
  a.each_with_index do |val, i|
    return i if val == key
  end
  -1
end
```

### 1-3. 番兵法

```ruby
def self.ssearch_sentinel(a, key)
  arr = a.dup
  arr << key  # 番兵を追加
  i = 0
  i += 1 until arr[i] == key
  i == a.length ? -1 : i
end
```

### テスト

```ruby
describe "線形探索" do
  let(:arr) { [6, 4, 3, 2, 1, 2, 8] }

  it "ssearch_while: キーが見つかる" do
    expect(Algorithm.ssearch_while(arr, 2)).to eq(3)
  end

  it "ssearch_sentinel: キーが見つからない" do
    expect(Algorithm.ssearch_sentinel(arr, 99)).to eq(-1)
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 無限ループ | `while True:` | `loop do ... end` |
| 配列のコピー | `copy.deepcopy(list(seq))` | `a.dup` |
| 末尾追加 | `a.append(key)` | `arr << key` |
| until ループ | なし（`while not` を使用） | `until 条件` で条件が偽の間ループ |
| 三項演算子 | `x if cond else y` | `cond ? x : y` |

Ruby の `dup` は浅いコピーです。`loop do` は `while true do` と等価です。

---

## 2. 二分探索

整列済みの配列から、中央の要素と比較しながら探索範囲を半分ずつ絞り込む方法です。

### Red — テストを書く

```ruby
describe "二分探索" do
  let(:sorted) { [1, 2, 3, 5, 7, 8, 9] }

  it "キーが見つかる" do
    expect(Algorithm.bseach(sorted, 5)).to eq(3)
  end

  it "キーが見つからない" do
    expect(Algorithm.bseach(sorted, 4)).to eq(-1)
  end
end
```

### Green — 実装

```ruby
def self.bseach(a, key)
  pl = 0
  pr = a.length - 1
  loop do
    pc = (pl + pr) / 2
    return pc if a[pc] == key

    if a[pc] < key
      pl = pc + 1
    else
      pr = pc - 1
    end
    return -1 if pl > pr
  end
end
```

---

## 3. チェイン法ハッシュ

ハッシュ法は、データのキーからハッシュ値を計算し、そのハッシュ値を添字とする配列にデータを格納する手法です。チェイン法は衝突したデータを連結リストでつなぐ方法です。

### Red — テストを書く

```ruby
describe "Algorithm::ChainedHash" do
  let(:hash) { Algorithm::ChainedHash.new(13) }

  it "追加と探索ができる" do
    hash.add("Alice", 1)
    hash.add("Bob", 2)
    expect(hash.search("Alice")).to eq(1)
  end

  it "削除できる" do
    hash.add("Alice", 1)
    hash.remove("Alice")
    expect(hash.search("Alice")).to be nil
  end
end
```

### Green — 実装

```ruby
class ChainNode
  attr_accessor :key, :value, :next_node

  def initialize(key, value, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end
end

class ChainedHash
  def initialize(capacity)
    @capacity = capacity
    @table = Array.new(@capacity)
  end

  def hash_value(key)
    if key.is_a?(Integer)
      key % @capacity
    else
      Digest::SHA256.hexdigest(key.to_s).to_i(16) % @capacity
    end
  end

  def add(key, value)
    h = hash_value(key)
    p = @table[h]
    while p
      return false if p.key == key
      p = p.next_node
    end
    @table[h] = ChainNode.new(key, value, @table[h])
    true
  end

  def search(key)
    h = hash_value(key)
    p = @table[h]
    while p
      return p.value if p.key == key
      p = p.next_node
    end
    nil
  end

  def remove(key)
    h = hash_value(key)
    p = @table[h]
    pp = nil
    while p
      if p.key == key
        if pp.nil?
          @table[h] = p.next_node
        else
          pp.next_node = p.next_node
        end
        return true
      end
      pp = p
      p = p.next_node
    end
    false
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| ハッシュ（SHA256） | `hashlib.sha256(...)` | `Digest::SHA256.hexdigest(...)` |
| isinstance チェック | `isinstance(key, int)` | `key.is_a?(Integer)` |
| `None` | `None` | `nil` |

Ruby では `require "digest"` で `Digest` モジュールが使えます。

---

## 4. オープンアドレス法ハッシュ

衝突したデータを別のバケットに格納する方法（線形探索法）です。

```ruby
module BucketStatus
  OCCUPIED = :occupied
  EMPTY = :empty
  DELETED = :deleted
end

class OpenHash
  def initialize(capacity)
    @capacity = capacity
    @table = Array.new(@capacity) { Bucket.new }
  end

  def add(key, value)
    return false unless search(key).nil?

    h = hash_value(key)
    @capacity.times do
      p = @table[h]
      if [BucketStatus::EMPTY, BucketStatus::DELETED].include?(p.stat)
        @table[h] = Bucket.new(key, value, BucketStatus::OCCUPIED)
        return true
      end
      h = (h + 1) % @capacity
    end
    false
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| Enum | `from enum import Enum` / `class _Status(Enum)` | `module BucketStatus` + シンボル |
| 状態チェック | `p.stat == _Status.EMPTY` | `p.stat == BucketStatus::EMPTY` |

Ruby ではシンボル（`:empty` 等）を使ってエニュームに相当する定数を表現します。

---

## まとめ

| 探索法 | 計算量（平均） | 前提条件 |
|--------|--------------|---------|
| 線形探索 | O(n) | なし |
| 番兵法 | O(n) | なし（若干高速） |
| 二分探索 | O(log n) | ソート済み |
| チェイン法ハッシュ | O(1) | キーからハッシュ値が計算可能 |
| オープンアドレス法 | O(1) | キーからハッシュ値が計算可能 |

### Ruby の特徴

- `arr.dup` で浅いコピー（Python の `copy.copy()` に相当）
- シンボル（`:symbol`）で軽量な不変の文字列として定数を表現
- `include?` でコレクションに要素が含まれるか確認
- `is_a?(ClassName)` で型チェック
