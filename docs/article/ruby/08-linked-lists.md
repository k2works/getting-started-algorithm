# 第 8 章 リスト

## はじめに

連結リスト（Linked List）は、各ノードが次のノードへの参照を持つデータ構造です。この章では、単方向・双方向・配列カーソル版の 3 種類を TDD で実装します。

---

## 1. 単方向連結リスト

各ノードは「データ」と「次のノードへの参照」を持ちます。

### ノードクラス

```ruby
class LLNode
  attr_accessor :data, :next_node

  def initialize(data, next_node = nil)
    @data = data
    @next_node = next_node
  end
end
```

### Red — テストを書く

```ruby
describe "Algorithm::LinkedList" do
  let(:list) { Algorithm::LinkedList.new }

  it "先頭への挿入と探索" do
    list.add_first(1)
    list.add_first(2)
    list.add_first(3)
    expect(list.length).to eq(3)
    expect(list.search(2)).not_to be nil
  end

  it "空リストからの削除は例外" do
    expect { list.remove_first }.to raise_error(Algorithm::LinkedList::Empty)
  end
end
```

### Green — 主要メソッドの実装

```ruby
class LinkedList
  class Empty < StandardError; end

  def initialize
    @head = nil
    @no = 0
  end

  def add_first(data)
    @head = LLNode.new(data, @head)
    @no += 1
  end

  def add_last(data)
    if @head.nil?
      @head = LLNode.new(data)
    else
      ptr = @head
      ptr = ptr.next_node while ptr.next_node
      ptr.next_node = LLNode.new(data)
    end
    @no += 1
  end

  def remove_first
    raise Empty if @head.nil?
    @head = @head.next_node
    @no -= 1
  end

  def search(data)
    ptr = @head
    while ptr
      return ptr if ptr.data == data
      ptr = ptr.next_node
    end
    nil
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| ノードクラス | `class _Node:` | `class LLNode` |
| `next` 属性 | `self.next = next_node` | `@next_node = next_node` |
| `None` チェック | `if ptr is None` | `if ptr.nil?` |
| イテレーション | `__iter__` / `yield` | `def each` / `yield node` |
| 例外継承 | `class Empty(Exception):` | `class Empty < StandardError; end` |

---

## 2. 双方向連結リスト（番兵ノード使用）

各ノードが前後双方向の参照を持ちます。番兵ノード（ダミー）で先頭・末尾の特別扱いをなくします。

### Green — 実装

```ruby
class DoublyLinkedList
  def initialize
    @head = DLLNode.new  # 番兵ノード
    @head.prev_node = @head
    @head.next_node = @head
    @no = 0
  end

  def add_first(data)
    node = DLLNode.new(data, @head, @head.next_node)
    @head.next_node.prev_node = node
    @head.next_node = node
    @no += 1
  end

  def add_last(data)
    node = DLLNode.new(data, @head.prev_node, @head)
    @head.prev_node.next_node = node
    @head.prev_node = node
    @no += 1
  end

  def remove(node)
    return if empty?
    node.prev_node.next_node = node.next_node
    node.next_node.prev_node = node.prev_node
    @no -= 1
  end
end
```

---

## 3. 配列カーソル版リスト

配列を使って連結リストをシミュレートします。

```ruby
NULL = -1

class ArrayLinkedList
  def initialize(capacity)
    @head = NULL
    @max = NULL
    @deleted = NULL
    @capacity = capacity
    @n = Array.new(@capacity) { ArrayNode.new }
    @no = 0
  end

  def add_first(data)
    ptr = @head
    rec = get_insert_index
    if rec != NULL
      @head = @current = rec
      @n[@head] = ArrayNode.new(data, ptr)
      @no += 1
    end
  end

  def remove_first
    if @head != NULL
      ptr = @head
      @head = @current = @n[ptr].next_idx
      @n[ptr].dnext = @deleted
      @deleted = ptr
      @no -= 1
    end
  end
end
```

### Python 版との違い

| 概念 | Python | Ruby |
|------|--------|------|
| `Null = -1` | `Null = -1` | `NULL = -1`（モジュール定数） |
| `None` チェック | `self.head == Null` | `@head == NULL` |
| リストノード配列 | `[_ArrayNode() for _ in range(n)]` | `Array.new(n) { ArrayNode.new }` |

---

## まとめ

| リスト種別 | 挿入 | 削除 | 探索 | 特徴 |
|-----------|------|------|------|------|
| 単方向連結リスト | O(1) 先頭 | O(1) 先頭 | O(n) | シンプル |
| 双方向連結リスト | O(1) | O(1) | O(n) | 前後移動可能 |
| 配列カーソル | O(1) | O(1) | O(n) | メモリ局所性 |

### Ruby の特徴

- `attr_accessor :field` でゲッター・セッター両方を定義
- `attr_reader :field` で読み取り専用アクセサ
- `node.nil?` で `nil` チェック（Python の `node is None` に相当）
- `ptr.equal?(other)` でオブジェクトの同一性（参照の一致）を確認
- ブロック付きの `Array.new(n) { expr }` で各要素を個別に初期化
