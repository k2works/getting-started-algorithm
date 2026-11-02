# 第 4 章 データ構造の実装アプローチ比較

## はじめに

スタック・キューは基本的なデータ構造ですが、その実装は言語のパラダイムによって大きく異なります。本章では、クラス・構造体・モジュール・代数的データ型・日本語命令など、言語ごとの設計アプローチを比較します。

## スタックの実装パターン

### パターン 1: クラスベース（OOP 言語）

OOP 言語ではクラスにデータと操作をカプセル化します。

**Python**:

```python
class FixedStack:
    def __init__(self, capacity):
        self.stk = [None] * capacity
        self.ptr = 0
        self.capacity = capacity

    def push(self, value):
        if self.ptr >= self.capacity:
            raise FixedStack.Full
        self.stk[self.ptr] = value
        self.ptr += 1

    def pop(self):
        if self.ptr <= 0:
            raise FixedStack.Empty
        self.ptr -= 1
        return self.stk[self.ptr]
```

**Java**:

```java
public class FixedStack<T> {
    private Object[] stk;
    private int ptr = 0;
    private int capacity;

    public void push(T value) {
        if (ptr >= capacity) throw new OverflowError();
        stk[ptr++] = value;
    }

    public T pop() {
        if (ptr <= 0) throw new EmptyError();
        return (T) stk[--ptr];
    }
}
```

**Kotlin**:

```kotlin
class FixedStack<T : Any>(private val capacity: Int) {
    private val elements: Array<Any?>
    private var pointer = 0

    init {
        require(capacity > 0)
        elements = arrayOfNulls(capacity)
    }

    fun push(value: T) {
        check(pointer < capacity) { "Stack is full" }
        elements[pointer++] = value
    }
}
```

型パラメータ `T : Any` で nullable な要素を除外し、`private` な配列とポインターをクラス内に隠します。教材の実装では満杯・空の状態を `check` で検査し、違反時は例外を送出します。

### パターン 2: 構造体 + 関数（手続き型 / システム言語）

**Go**:

```go
type FixedStack struct {
    data     []interface{}
    ptr      int
    capacity int
}

func (s *FixedStack) Push(value interface{}) error {
    if s.ptr >= s.capacity { return ErrOverflow }
    s.data[s.ptr] = value
    s.ptr++
    return nil
}
```

**C**:

```c
typedef struct {
    int data[MAX_SIZE];
    int ptr;
    int capacity;
} Stack;

int stack_push(Stack *s, int value) {
    if (s->ptr >= s->capacity) return -1;
    s->data[s->ptr++] = value;
    return 0;
}
```

**Rust**:

```rust
pub struct FixedStack<T> {
    data: Vec<Option<T>>,
    ptr: usize,
    capacity: usize,
}

impl<T: Clone> FixedStack<T> {
    pub fn push(&mut self, value: T) -> Result<(), &str> {
        if self.ptr >= self.capacity { return Err("Stack overflow"); }
        self.data[self.ptr] = Some(value);
        self.ptr += 1;
        Ok(())
    }
}
```

### パターン 3: モジュール + 関数（関数型言語）

**F#**:

```fsharp
module FixedStack =
    type Stack<'T> = { data: 'T option array; mutable ptr: int; capacity: int }

    let push (stack: Stack<'T>) (value: 'T) =
        if stack.ptr >= stack.capacity then failwith "Stack overflow"
        stack.data.[stack.ptr] <- Some value
        stack.ptr <- stack.ptr + 1
```

**Elixir**:

```elixir
defmodule FixedStack do
  defstruct data: [], capacity: 0

  def push(%FixedStack{data: data, capacity: cap} = stack, value) do
    if length(data) >= cap do
      {:error, :overflow}
    else
      {:ok, %{stack | data: [value | data]}}
    end
  end
end
```

**Flix（モジュール関数 + 状態の明示）**:

```flix
pub def stackPush(value: a, values: Array[a, r], size: Int32): Option[Int32] \ r =
    let capacity = Array.length(values);
    if (size < 0 or size >= capacity) {
        None
    } else {
        Array.put(value, size, values);
        Some(size + 1)
    }
```

Flix の固定長スタックはデータを領域 `r` の配列に保持し、サイズは別の値として受け渡します。配列更新の効果 `\ r` をシグネチャに示し、満杯や不正なサイズは `None` で表します。

### パターン 4: 代数的データ型 / リスト（純粋関数型）

**Haskell（IORef ベース）**:

```haskell
type Stack a = IORef [a]

newStack :: IO (Stack a)
newStack = newIORef []

push :: a -> Stack a -> IO ()
push x stack = modifyIORef stack (x:)

pop :: Stack a -> IO (Maybe a)
pop stack = do
  xs <- readIORef stack
  case xs of
    []     -> return Nothing
    (x:xs') -> writeIORef stack xs' >> return (Just x)
```

**Clojure（atom ベース）**:

```clojure
(defn new-stack [capacity]
  (atom {:data [] :capacity capacity}))

(defn stack-push [stack value]
  (swap! stack update :data conj value))

(defn stack-pop [stack]
  (let [top (peek (:data @stack))]
    (swap! stack update :data pop)
    top))
```

### パターン 5: 配列 + 日本語命令（なでしこ3）

なでしこ3 では、配列をスタックとして使い、追加・取り出しを関数にまとめます。空の取り出しは値と混同しないよう、成功状態と値の組で返します。

```nako3
●スタック作成
    []を戻す
ここまで

●(スタックと値で)スタックプッシュ
    スタックに値を配列追加
    はいを戻す
ここまで

●(スタックを)スタックポップ
    もし、(スタックがスタック空)ならば
        戻る値 = [いいえ, 0]
        戻る値を戻す
    ここまで
    値 = スタックの配列ポップ
    戻る値 = [はい, 値]
    戻る値を戻す
ここまで
```

配列は参照型の可変データです。`配列追加` と `配列ポップ` が元のスタックを変更し、`はい` / `いいえ` と値を含む配列で操作結果を表します。

## 実装アプローチの比較

| アプローチ | 言語 | データ隠蔽 | 可変状態 | エラー処理 |
|-----------|------|-----------|---------|-----------|
| **クラス** | Python, TS, Java, Kotlin, C#, Ruby, PHP | private/public | メソッド内で変更 | 例外 |
| **構造体 + 関数** | Go, C | アクセス修飾子（Go）/ なし（C） | ポインタ経由 | 戻り値（error） |
| **構造体 + impl** | Rust | pub/private | `&mut self` | `Result<T, E>` |
| **モジュール + 型** | F#, Scala | モジュール境界 | mutable 明示 | 例外 / Option |
| **モジュール関数 + 領域付き配列** | Flix | モジュール境界 | `\ r` 効果を型に記述 | `Option` |
| **不変データ + IORef** | Haskell | 型で保護 | IO モナド内 | `Maybe` / `Either` |
| **不変データ + atom** | Clojure, Elixir | なし（データ指向） | atom / Agent | 戻り値 |
| **配列 + 関数** | なでしこ3 | 関数単位で操作を整理 | 配列命令で変更 | `[成功, 値]` |

## キューの実装 — リングバッファ比較

キューは **リングバッファ** で効率的に実装されます。言語ごとのインデックス操作の違いが顕著です。

### リングバッファの折り返し計算

全言語で共通する核心ロジック:

```
rear = (rear + 1) % capacity    // enqueue 時
front = (front + 1) % capacity  // dequeue 時
```

| 言語 | 剰余演算子 | 実装例 |
|------|-----------|--------|
| Python | `%` | `self.rear = (self.rear + 1) % self.capacity` |
| Java | `%` | `rear = (rear + 1) % capacity;` |
| Kotlin | `%` | `rear = (rear + 1) % capacity` |
| Go | `%` | `q.rear = (q.rear + 1) % q.capacity` |
| Rust | `%` | `self.rear = (self.rear + 1) % self.capacity;` |
| F# | `%` | `queue.rear <- (queue.rear + 1) % queue.capacity` |
| Haskell | `` `mod` `` | `(rear + 1) \`mod\` capacity` |
| Clojure | `mod` | `(mod (inc rear) capacity)` |
| Flix | `%` | `if (rear + 1 == capacity) 0 else rear + 1` |

なでしこ3 の教材ではリングバッファではなく、2 つのスタックを使ってキューを実装します。入力スタックから出力スタックへ要素を移すことで、先入れ先出し（FIFO）の順序を保ちます。

## 可変/不変データ構造のアプローチ

### 破壊的操作（in-place）vs 非破壊的操作

| アプローチ | 言語 | push の結果 |
|-----------|------|-----------|
| **破壊的** | Python, TS, Java, Kotlin, C#, Ruby, PHP, Go, C | 元のスタックが変更される |
| **破壊的（明示的）** | Rust | `&mut self` で可変参照を明示 |
| **破壊的（IORef）** | Haskell, F# | IO モナド / mutable 内で変更 |
| **非破壊的** | Clojure, Elixir | 新しいスタックが返される |
| **破壊的（配列命令）** | なでしこ3 | `配列追加` / `配列ポップ` が元配列を変更 |
| **破壊的（領域付き配列）** | Flix | `Array.put` で更新し、領域効果を型に記述 |

```mermaid
graph LR
    A[スタック push] --> B{言語のアプローチ}
    B --> C[破壊的: 元のデータを変更]
    B --> D[非破壊的: 新しいデータを返す]
    C --> C1[Python, Java, Go, C]
    C --> C2[Rust: &mut self 明示]
    C --> C3[Haskell: IORef in IO]
    C --> C4[なでしこ3: 配列を変更]
    C --> C5[Flix: 領域効果を明示]
    D --> D1[Clojure: 永続データ構造]
    D --> D2[Elixir: イミュータブル]
```

### ジェネリクス（型パラメータ）のサポート

| 言語 | スタックの型パラメータ | 記法 |
|------|---------------------|------|
| Python | なし（動的型付き） | `FixedStack` |
| TypeScript | `T` | `FixedStack<T>` |
| Java | `T` | `FixedStack<T>` |
| Kotlin | `T : Any` | `FixedStack<T>` |
| C# | `T` | `FixedStack<T>` |
| Ruby | なし（動的型付き） | `FixedStack` |
| PHP | なし（動的型付き） | `FixedStack` |
| Go | `T any`（1.18+） | `FixedStack[T any]` |
| C | なし（`void*` / マクロ） | `Stack`（int 固定が多い） |
| Rust | `T` | `FixedStack<T>` |
| F# | `'T` | `Stack<'T>` |
| Scala | `T` | `FixedStack[T]` |
| Clojure | なし（動的型付き） | `(new-stack capacity)` |
| Elixir | なし（動的型付き） | `%FixedStack{}` |
| Haskell | `a` | `Stack a` |
| Flix | `a` | `Array[a, r]`（配列要素の型） |
| なでしこ3 | なし | 動的型付き配列 |

## エラー処理パターン

スタックの overflow/underflow の処理方法は、言語の設計哲学を反映しています。

| パターン | 言語 | 例 |
|---------|------|-----|
| **例外** | Python, Java, Kotlin, C#, Ruby, PHP | `raise OverflowError` / `throw new ...` |
| **戻り値（error）** | Go | `return nil, ErrOverflow` |
| **Result 型** | Rust | `Err("Stack overflow")` |
| **Option/Maybe** | Haskell, F# | `Nothing` / `None` |
| **タプル** | Elixir | `{:error, :overflow}` |
| **nil** | Clojure | `nil`（空スタックの pop） |
| **真偽値と値の配列** | なでしこ3 | `[いいえ, 0]` / `[はい, 値]` |
| **Option** | Flix | `None` / `Some(value)` |

## まとめ

- **OOP 言語**: クラスでデータと操作をカプセル化。例外でエラーを通知
- **Kotlin**: `private` な可変状態とジェネリクスをクラスにまとめ、`check` / `require` で不変条件を検査
- **システム言語（Go, C）**: 構造体 + 関数。エラーは戻り値で返す
- **Rust**: 構造体 + impl。所有権システムと `Result` 型で安全性を保証
- **Flix**: 配列とサイズ状態を関数間で受け渡し、配列の可変領域を型付き効果で明示
- **関数型言語**: モジュール / 代数的データ型。不変データを基本とし、可変状態は明示的に管理
- **Haskell**: 最も厳格。可変状態は `IORef` を通じて IO モナド内でのみ許可
- **Clojure/Elixir**: 不変データ構造を基本とし、状態管理は `atom` / プロセスで行う
