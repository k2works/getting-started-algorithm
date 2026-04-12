# 第 5 章 再帰アルゴリズム

## はじめに

再帰（Recursion）とは、自分自身を呼び出す関数・メソッドを使ってアルゴリズムを表現する手法です。この章では、階乗・GCD・ハノイの塔・8 王妃問題を TDD で実装します。

---

## 1. 階乗（Factorial）

n! = n × (n-1) × ... × 2 × 1 を再帰的に計算します。

### Red — テストを書く

```ruby
describe "Algorithm.factorial" do
  it "5の階乗" do
    expect(Algorithm.factorial(5)).to eq(120)
  end

  it "0の階乗" do
    expect(Algorithm.factorial(0)).to eq(1)
  end
end
```

### Green — 実装

```ruby
def self.factorial(n)
  return 1 if n <= 0

  n * factorial(n - 1)
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| ガード節 | `if n <= 0: return 1` | `return 1 if n <= 0` |

Ruby の後置 `if` でガード節を簡潔に書けます。

---

## 2. 最大公約数（GCD）

ユークリッドの互除法で最大公約数を求めます。

### Green — 実装

```ruby
def self.gcd(x, y)
  return x if y == 0

  gcd(y, x % y)
end
```

---

## 3. 再帰的な総和

1 から n までの和を再帰的に計算します。

```ruby
def self.recursive_sum(n)
  return 0 if n <= 0

  n + recursive_sum(n - 1)
end
```

---

## 4. ハノイの塔

n 枚の円盤を src から dst へ via を経由して移動する手順を返します。

### Red — テストを書く

```ruby
describe "Algorithm.hanoi" do
  it "円盤1枚のハノイ" do
    expect(Algorithm.hanoi(1, "A", "C", "B")).to eq([["A", "C"]])
  end

  it "円盤3枚のハノイの手順数" do
    expect(Algorithm.hanoi(3, "A", "C", "B").length).to eq(7)
  end
end
```

### Green — 実装

```ruby
def self.hanoi(n, src, dst, via)
  return [[src, dst]] if n == 1

  moves = []
  moves.concat(hanoi(n - 1, src, via, dst))
  moves << [src, dst]
  moves.concat(hanoi(n - 1, via, dst, src))
  moves
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| リストの連結 | `moves.extend(hanoi(...))` | `moves.concat(hanoi(...))` |
| 要素追加 | `moves.append((src, dst))` | `moves << [src, dst]` |
| タプル | `(src, dst)` | `[src, dst]`（配列で代替） |

Ruby にはタプルがないため、配列 `[src, dst]` で代替します。`<<` は配列への末尾追加演算子です。

---

## 4. 再帰アルゴリズムの解析

### 真に再帰的な関数

「真に再帰的な関数」とは、複数の再帰呼び出しを含む関数のことです。

#### Red — テストを書く

```ruby
describe "Algorithm.recure" do
  it "真に再帰的な関数: recure(4, []) => [1, 2, 3, 1, 4, 1, 2]" do
    expect(Algorithm.recure(4, [])).to eq([1, 2, 3, 1, 4, 1, 2])
  end
end
```

#### Green — 実装

```ruby
def self.recure(n, list)
  if n > 0
    recure(n - 1, list)   # 最初の再帰呼び出し
    list << n
    recure(n - 2, list)   # 2番目の再帰呼び出し
  end
  list
end
```

#### 実行の流れ

`recure(4, [])` を実行すると、以下の呼び出しの連鎖が発生します：

```
recure(4, [])
  → recure(3, [])
    → recure(2, [])
      → recure(1, [])
        → recure(0, []) → 何もしない
        list << 1  → [1]
        → recure(-1, [1]) → 何もしない
      list << 2  → [1, 2]
      → recure(0, [1, 2]) → 何もしない
    list << 3  → [1, 2, 3]
    → recure(1, [1, 2, 3])
      list << 1  → [1, 2, 3, 1]
  list << 4  → [1, 2, 3, 1, 4]
  → recure(2, [1, 2, 3, 1, 4])
    list << 1  → [1, 2, 3, 1, 4, 1]
    list << 2  → [1, 2, 3, 1, 4, 1, 2]
```

最終結果: `[1, 2, 3, 1, 4, 1, 2]`

### 再帰アルゴリズムの非再帰表現

再帰は概念的に理解しやすいですが、深い再帰呼び出しはスタックオーバーフローを引き起こす可能性があります。そのため、再帰アルゴリズムを非再帰（反復的）な形に変換することが重要です。

#### 末尾再帰の除去

末尾再帰（tail recursion）とは、関数の最後の操作が再帰呼び出しである場合の再帰のことです。以下は `recure` 関数の末尾にある再帰呼び出しをループに変換した例です：

```ruby
def self.recure2(n, list)
  while n > 0
    recure2(n - 1, list)   # 最初の再帰呼び出しはそのまま
    list << n
    n -= 2                  # 2番目の再帰呼び出しをループに変換
  end
  list
end
```

#### テスト

```ruby
describe "Algorithm.recure2" do
  it "末尾再帰除去版: recure2(4, []) => [1, 2, 3, 1, 4, 1, 2]" do
    expect(Algorithm.recure2(4, [])).to eq([1, 2, 3, 1, 4, 1, 2])
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| リストへの追加 | `list.append(n)` | `list << n` |
| ガード節 | `if n > 0:` 内に処理 | `if n > 0` 内に処理（同様） |
| 末尾再帰の除去 | `while True:` + `continue` | `while n > 0` で簡潔に表現 |

---

## 5. 8 王妃問題

8×8 のチェス盤に 8 個の王妃を互いに攻撃できない位置に配置する問題です。

### 第 1 版（全組み合わせ）

```ruby
class EightQueen
  attr_reader :result

  def initialize
    @result = []
    @pos = Array.new(8, 0)
  end

  def put
    @result << @pos.dup
  end

  def set(i)
    8.times do |j|
      @pos[i] = j
      if i == 7
        put
      else
        set(i + 1)
      end
    end
  end
end
```

```ruby
it "全組み合わせは 8^8 = 16777216 通り" do
  q = Algorithm::EightQueen.new
  q.set(0)
  expect(q.result.length).to eq(8**8)
end
```

### 第 3 版（行・対角線制約あり — 92 通り）

```ruby
class EightQueen3
  def initialize
    @result = []
    @pos = Array.new(8, 0)
    @flag_a = Array.new(8, false)    # 各行のフラグ
    @flag_b = Array.new(15, false)   # 右上がり対角線
    @flag_c = Array.new(15, false)   # 右下がり対角線
  end

  def set(i)
    8.times do |j|
      next if @flag_a[j] || @flag_b[i + j] || @flag_c[i - j + 7]

      @pos[i] = j
      if i == 7
        @result << @pos.dup
      else
        @flag_a[j] = @flag_b[i + j] = @flag_c[i - j + 7] = true
        set(i + 1)
        @flag_a[j] = @flag_b[i + j] = @flag_c[i - j + 7] = false
      end
    end
  end
end
```

```ruby
it "完全な8王妃問題: 92 通り" do
  q = Algorithm::EightQueen3.new
  q.set(0)
  expect(q.result.length).to eq(92)
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| インスタンス変数 | `self.__pos` | `@pos` |
| プライベート変数 | `__` プレフィックス | `private` でメソッド単位 |
| クラス定義 | `class EightQueen:` | `class EightQueen` |
| 配列の深いコピー | `self.__pos[:]` | `@pos.dup` |
| 多重代入 | 個別に代入 | `@flag_a[j] = @flag_b[i+j] = @flag_c[i-j+7] = true` |

---

## まとめ

| アルゴリズム | メソッド | 計算量 |
|-------------|---------|--------|
| 階乗 | `factorial` | O(n) |
| GCD | `gcd` | O(log min(x,y)) |
| 再帰的総和 | `recursive_sum` | O(n) |
| ハノイの塔 | `hanoi` | O(2^n) |
| 8 王妃問題 | `EightQueen3#set` | O(n!) |

### Ruby の特徴

- `@変数` でインスタンス変数（クラス全体で共有）
- `attr_reader :result` で読み取り専用のアクセサを定義
- `next if 条件` でループのスキップ
- `Array.new(n, 初期値)` で初期値付き配列を作成
- `arr.dup` で配列の浅いコピー
