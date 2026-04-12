# 第 2 章 配列

## はじめに

配列（Array）は、同じ型のデータを連続して格納するデータ構造です。この章では、Ruby の Array を使って配列操作のアルゴリズムを TDD で実装します。

---

## 1. 配列の最大値

### Red — テストを書く

```ruby
describe "Algorithm.max_of" do
  it "配列の最大値を返す" do
    expect(Algorithm.max_of([172, 153, 192, 140, 165])).to eq(192)
  end
end
```

### Green — 実装

```ruby
def self.max_of(a)
  maximum = a[0]
  (1...a.length).each do |i|
    maximum = a[i] if a[i] > maximum
  end
  maximum
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 配列の長さ | `len(a)` | `a.length` または `a.size` |
| 範囲（右端除く） | `range(1, len(a))` | `(1...a.length)` |

---

## 2. 配列の反転

### Red — テストを書く

```ruby
describe "Algorithm.reverse_array" do
  it "配列を逆順にする（破壊的）" do
    a = [2, 5, 1, 3, 9, 6, 7]
    Algorithm.reverse_array(a)
    expect(a).to eq([7, 6, 9, 3, 1, 5, 2])
  end
end
```

### Green — 実装

```ruby
def self.reverse_array(a)
  n = a.length
  (n / 2).times do |i|
    a[i], a[n - i - 1] = a[n - i - 1], a[i]
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 多重代入（スワップ） | `a[i], a[j] = a[j], a[i]` | `a[i], a[j] = a[j], a[i]`（同様） |
| 整数除算 | `n // 2` | `n / 2`（整数同士は自動的に整数除算） |

Ruby も Python と同様に多重代入でスワップを簡潔に書けます。

---

## 3. 基数変換

整数値を指定された基数（r 進数）に変換します。

### Red — テストを書く

```ruby
describe "Algorithm.card_conv" do
  it "2進数変換" do
    expect(Algorithm.card_conv(29, 2)).to eq("11101")
  end

  it "16進数変換" do
    expect(Algorithm.card_conv(255, 16)).to eq("FF")
  end
end
```

### Green — 実装

```ruby
def self.card_conv(x, r)
  d = ""
  dchar = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  while x > 0
    d += dchar[x % r]
    x /= r
  end
  d.reverse
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| 文字列の逆順 | `d[::-1]` | `d.reverse` |
| 文字列のインデックスアクセス | `dchar[x % r]` | `dchar[x % r]`（同様） |

Ruby の `d.reverse` は Python のスライス `d[::-1]` より直感的です。

---

## 4. 素数列挙

x 以下の素数を列挙するアルゴリズムを 3 段階で最適化します。

### 4-1. 第 1 版（基本実装）

```ruby
# 除算回数を返す
def self.prime1(x)
  counter = 0
  (2..x).each do |n|
    (2...n).each do |i|
      counter += 1
      break if (n % i).zero?
    end
  end
  counter
end
```

### 4-2. 第 2 版（奇数のみチェック）

```ruby
def self.prime2(x)
  counter = 0
  ptr = 0
  prime = Array.new(500)

  prime[ptr] = 2
  ptr += 1

  (3..x).step(2) do |n|
    found_divisor = false
    (1...ptr).each do |i|
      counter += 1
      if (n % prime[i]).zero?
        found_divisor = true
        break
      end
    end
    unless found_divisor
      prime[ptr] = n
      ptr += 1
    end
  end

  counter
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| ステップ付きループ | `range(3, x+1, 2)` | `(3..x).step(2)` |
| `for...else` | Python 固有の構文 | `found_divisor` フラグで代替 |
| 空配列 | `[None] * 500` | `Array.new(500)` |

Python の `for...else` は Ruby にはない構文です。Ruby ではフラグ変数を使って同等のロジックを実現します。

### 4-3. 第 3 版（平方根最適化）

```ruby
def self.prime3(x)
  counter = 0
  ptr = 0
  prime = Array.new(500)

  prime[ptr] = 2; ptr += 1
  prime[ptr] = 3; ptr += 1

  (5..1000).step(2) do |n|
    i = 1
    found_divisor = false
    while prime[i] * prime[i] <= n
      counter += 2
      if (n % prime[i]).zero?
        found_divisor = true
        break
      end
      i += 1
    end
    unless found_divisor
      prime[ptr] = n
      ptr += 1
      counter += 1
    end
  end

  counter
end
```

### テスト

```ruby
describe "素数列挙" do
  it "prime1: 1000以下の素数の除算回数" do
    expect(Algorithm.prime1(1000)).to eq(78022)
  end

  it "prime2: 最適化版" do
    expect(Algorithm.prime2(1000)).to eq(14622)
  end

  it "prime3: 平方根最適化版" do
    expect(Algorithm.prime3(1000)).to eq(3774)
  end
end
```

---

## まとめ

| アルゴリズム | メソッド | 計算量 |
|-------------|---------|--------|
| 配列の最大値 | `max_of` | O(n) |
| 配列の反転 | `reverse_array` | O(n) |
| 基数変換 | `card_conv` | O(log x) |
| 素数列挙（基本） | `prime1` | O(n²) |
| 素数列挙（最適化） | `prime2` | O(n √n) |
| 素数列挙（平方根） | `prime3` | O(n √n / ln n) |

### Ruby の配列の特徴

- `Array.new(n)` で n 要素の配列を作成（初期値は `nil`）
- `Array.new(n, val)` で初期値を指定
- `arr.length` または `arr.size` で要素数を取得
- スライス: `arr[start..end]` または `arr[start...end]`
- `arr.reverse` で逆順の新しい配列を返す（`!` 付きは破壊的）
