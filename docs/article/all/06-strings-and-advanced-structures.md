# 第 6 章 文字列処理と高度なデータ構造比較

## はじめに

文字列探索アルゴリズムと連結リスト・木構造は、言語ごとのポインタ操作・参照モデル・代数的データ型の違いが最も鮮明に現れるテーマです。本章では、これらの実装パターンを比較します。

## 文字列探索の比較

### 文字列の基本的な扱い

| 言語 | 文字列型 | 可変性 | 文字アクセス | エンコーディング |
|------|---------|--------|------------|----------------|
| Python | `str` | 不変 | `s[i]` | Unicode |
| TypeScript | `string` | 不変 | `s[i]` / `charAt(i)` | UTF-16 |
| Java | `String` | 不変 | `charAt(i)` | UTF-16 |
| C# | `string` | 不変 | `s[i]` | UTF-16 |
| Ruby | `String` | 可変 | `s[i]` | UTF-8 |
| PHP | `string` | 可変 | `$s[$i]` | バイト列 |
| Go | `string` | 不変 | `s[i]`（バイト）/ `rune` | UTF-8 |
| C | `char[]` / `char*` | 可変 | `s[i]` | ASCII / バイト列 |
| Rust | `String` / `&str` | String: 可変 | `.chars().nth(i)` | UTF-8 |
| F# | `string` | 不変 | `s.[i]` | UTF-16 |
| Scala | `String` | 不変 | `s(i)` / `charAt(i)` | UTF-16 |
| Clojure | `String`（Java） | 不変 | `(.charAt s i)` / `(nth s i)` | UTF-16 |
| Elixir | `binary` | 不変 | `String.at(s, i)` | UTF-8 |
| Haskell | `String`（`[Char]`） | 不変 | `s !! i` | Unicode |

### BF 法（力まかせ法）の比較

**Python**:

```python
def bf_match(txt, pat):
    for i in range(len(txt) - len(pat) + 1):
        j = 0
        while j < len(pat) and txt[i + j] == pat[j]:
            j += 1
        if j == len(pat):
            return i
    return -1
```

**Rust**:

```rust
pub fn bf_match(txt: &str, pat: &str) -> Option<usize> {
    let txt: Vec<char> = txt.chars().collect();
    let pat: Vec<char> = pat.chars().collect();
    for i in 0..=txt.len() - pat.len() {
        if txt[i..i + pat.len()] == pat[..] {
            return Some(i);
        }
    }
    None
}
```

**Haskell**:

```haskell
bfMatch :: String -> String -> Maybe Int
bfMatch txt pat = go 0
  where
    n = length txt
    m = length pat
    go i
      | i > n - m = Nothing
      | take m (drop i txt) == pat = Just i
      | otherwise = go (i + 1)
```

## 連結リストの実装パターン

連結リストの実装は、言語の **メモリモデル** と **参照の扱い** を最も深く反映します。

### パターン 1: ポインタベース（C）

```c
typedef struct Node {
    int data;
    struct Node *next;
} Node;

void add_first(Node **head, int data) {
    Node *new_node = malloc(sizeof(Node));
    new_node->data = data;
    new_node->next = *head;
    *head = new_node;
}
```

### パターン 2: 参照ベース（OOP 言語）

**Java**:

```java
class Node<T> {
    T data;
    Node<T> next;
}

class SinglyLinkedList<T> {
    private Node<T> head;

    public void addFirst(T data) {
        Node<T> node = new Node<>(data);
        node.next = head;
        head = node;
    }
}
```

### パターン 3: 所有権ベース（Rust）

```rust
struct Node<T> {
    data: T,
    next: Option<Box<Node<T>>>,
}

struct SinglyLinkedList<T> {
    head: Option<Box<Node<T>>>,
}

impl<T> SinglyLinkedList<T> {
    fn add_first(&mut self, data: T) {
        let node = Box::new(Node {
            data,
            next: self.head.take(),
        });
        self.head = Some(node);
    }
}
```

### パターン 4: Union Type / Option（関数型ハイブリッド）

**Scala**:

```scala
private class SNode[T](val data: T, var next: SNode[T] | Null = null)

class SinglyLinkedList[T]:
  private var head: SNode[T] | Null = null

  def addFirst(data: T): Unit =
    val node = SNode(data, head)
    head = node
```

### パターン 5: 代数的データ型（純粋関数型）

**Haskell**:

```haskell
data LinkedList a = Empty | Cons a (LinkedList a)

addFirst :: a -> LinkedList a -> LinkedList a
addFirst x xs = Cons x xs

-- リスト自体が不変。addFirst は新しいリストを返す
```

**F#**:

```fsharp
// F# の標準リストは連結リスト
let addFirst x xs = x :: xs  // cons 演算子
```

### パターン 6: プロセスベース / Map ベース

**Elixir**:

```elixir
defmodule SinglyLinkedList do
  defstruct head: nil

  def add_first(%SinglyLinkedList{head: head}, data) do
    node = %{data: data, next: head}
    %SinglyLinkedList{head: node}
  end
end
```

**Clojure**:

```clojure
;; Clojure のリストは連結リスト
(cons x xs)  ;; addFirst 相当
```

### 連結リスト実装の比較

| アプローチ | 言語 | ノード表現 | 参照の管理 |
|-----------|------|-----------|-----------|
| **ポインタ** | C | `struct` + `*next` | 手動 `malloc`/`free` |
| **参照** | Java, C#, Python, TS, Ruby, PHP | class + 参照型 | GC が管理 |
| **所有権** | Rust | `struct` + `Option<Box<Node>>` | コンパイル時チェック |
| **Union Type** | Scala | class + `T \| Null` | GC |
| **代数的データ型** | Haskell, F# | `data`/判別共用体 | GC（不変） |
| **Map/構造体** | Go | `struct` + `*Node` | GC |
| **Map** | Elixir, Clojure | Map / リスト | BEAM VM / JVM GC |

## 木構造（二分探索木）の比較

### 代数的データ型 vs クラス

**Haskell（代数的データ型）**:

```haskell
data BST a = Empty | Node a (BST a) (BST a)

insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
  | x < y    = Node y (insert x left) right
  | x > y    = Node y left (insert x right)
  | otherwise = Node y left right
```

**F#（判別共用体）**:

```fsharp
type BST<'T when 'T : comparison> =
    | Empty
    | Node of value: 'T * left: BST<'T> * right: BST<'T>

let rec insert x = function
    | Empty -> Node(x, Empty, Empty)
    | Node(v, left, right) when x < v -> Node(v, insert x left, right)
    | Node(v, left, right) when x > v -> Node(v, left, insert x right)
    | node -> node
```

**Java（クラス）**:

```java
class BinarySearchTree<T extends Comparable<T>> {
    private class Node {
        T value;
        Node left, right;
    }

    public void insert(T value) {
        root = insert(root, value);
    }

    private Node insert(Node node, T value) {
        if (node == null) return new Node(value);
        int cmp = value.compareTo(node.value);
        if (cmp < 0) node.left = insert(node.left, value);
        else if (cmp > 0) node.right = insert(node.right, value);
        return node;
    }
}
```

### 木構造の表現力

| 言語 | 木の定義 | パターンマッチ | 再帰の自然さ |
|------|---------|-------------|------------|
| Haskell | `data BST a = Empty \| Node ...` | 関数定義で直接 | 非常に自然 |
| F# | `type BST = Empty \| Node of ...` | `match` 式 | 非常に自然 |
| Scala | `sealed trait` + `case class` | `match` 式 | 自然 |
| Rust | `enum` + `Box<T>` | `match` 式 | 自然 |
| Elixir | Map / struct | `case` / 関数定義 | 自然 |
| Java | class + null チェック | if-else | やや冗長 |
| Python | class + None チェック | if-else | やや冗長 |
| C | struct + NULL チェック | if-else | やや冗長 |

## 双方向リスト — 言語の限界が見える

双方向リストは、各ノードが前後両方への参照を持つため、**不変データ構造では素直に実装できない** という制約があります。

| 言語 | 実装方式 | 難易度 |
|------|---------|--------|
| C | ポインタ（`prev`, `next`） | 自然 |
| Java, Python | 参照（`prev`, `next`） | 自然 |
| Rust | `Rc<RefCell<Node>>` / `unsafe` | 困難（循環参照） |
| Haskell | `IORef` による可変実装 | 不自然（純粋でない） |
| Clojure | zipper パターン | やや不自然 |
| Elixir | プロセスベース / Map | やや不自然 |

この制約は、言語の設計思想を如実に反映しています。不変性を重視する言語ほど、双方向リストの実装が難しくなります。

## まとめ

- **文字列探索**: 言語間の差は比較的小さいが、Rust と Haskell の型安全な戻り値（`Option`/`Maybe`）が際立つ
- **連結リスト**: C のポインタ、Java の参照、Rust の所有権、Haskell の代数的データ型 —— 最もメモリモデルの違いが現れる
- **木構造**: 代数的データ型 + パターンマッチ（Haskell, F#, Scala）が最も自然で簡潔
- **双方向リスト**: 不変性を重視する言語ほど実装が困難。言語の設計思想の限界が見える
- **パターンマッチ**: 再帰的データ構造の操作において、パターンマッチは圧倒的な可読性を提供する
