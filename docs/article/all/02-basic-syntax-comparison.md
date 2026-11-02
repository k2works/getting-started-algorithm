# 第 2 章 基本構文と制御フロー比較

## はじめに

同じアルゴリズムでも、言語によって構文の見た目は大きく異なります。本章では、最もシンプルなアルゴリズム —— **3 値の最大値（max3）** を題材に、17 言語の基本構文を比較します。

## 関数定義の比較

### max3 の 17 言語実装

#### OOP 言語グループ

**Python**:

```python
def max3(a: int, b: int, c: int) -> int:
    maximum = a
    if b > maximum:
        maximum = b
    if c > maximum:
        maximum = c
    return maximum
```

**TypeScript**:

```typescript
export function max3(a: number, b: number, c: number): number {
  let maximum = a;
  if (b > maximum) maximum = b;
  if (c > maximum) maximum = c;
  return maximum;
}
```

**Java**:

```java
public static int max3(int a, int b, int c) {
    int max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    return max;
}
```

**Kotlin**:

```kotlin
fun max3(a: Int, b: Int, c: Int): Int =
    maxOf(a, b, c)
```

**C#**:

```csharp
public static int Max3(int a, int b, int c)
{
    int max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    return max;
}
```

**Ruby**:

```ruby
def self.max3(a, b, c)
  [a, b, c].max
end
```

**PHP**:

```php
public static function max3(int $a, int $b, int $c): int
{
    return max($a, $b, $c);
}
```

#### 手続き型 / システム言語グループ

**Go**:

```go
func Max3(a, b, c int) int {
    max := a
    if b > max { max = b }
    if c > max { max = c }
    return max
}
```

**C**:

```c
int max3(int a, int b, int c) {
    int max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    return max;
}
```

**Rust**:

```rust
pub fn max3(a: i32, b: i32, c: i32) -> i32 {
    let mut max = a;
    if b > max { max = b; }
    if c > max { max = c; }
    max
}
```

#### 関数型言語グループ

**F#**:

```fsharp
let max3 a b c =
    max a (max b c)
```

**Scala**:

```scala
def max3(a: Int, b: Int, c: Int): Int =
    a max b max c
```

**Clojure**:

```clojure
(defn max3
  [a b c]
  (max a b c))
```

**Elixir**:

```elixir
def max3(a, b, c) do
  Enum.max([a, b, c])
end
```

**Haskell**:

```haskell
max3 :: Ord a => a -> a -> a -> a
max3 a b c = max a (max b c)
```

**Flix**:

```flix
pub def max3(a: Int32, b: Int32, c: Int32): Int32 =
    if (a >= b)
        if (a >= c) a else c
    else
        if (b >= c) b else c
```

Flix は引数・戻り値の型をシグネチャに記述し、`if` は値を返す式です。再代入なしに条件ごとの値を返す純粋関数として表します。

#### 日本語指向のスクリプト言語

**なでしこ3**:

```nako3
●(AとBとCで)三値最大
    最大候補 = A
    もし、B > 最大候補ならば
        最大候補 = B
    ここまで
    もし、C > 最大候補ならば
        最大候補 = C
    ここまで
    最大候補を戻す
ここまで
```

関数定義の `●`、条件分岐の `もし ... ならば` / `ここまで`、戻り値の `を戻す` が日本語の語順で読めます。呼び出し側も `(3と2と1で三値最大)` のように助詞で引数を示します。

## 構文の比較ポイント

### 関数定義の構文

| 言語 | キーワード | 型注釈 | 波括弧 | セミコロン | 戻り値 |
|------|-----------|--------|--------|-----------|--------|
| Python | `def` | 型ヒント（任意） | なし（インデント） | なし | `return` |
| TypeScript | `function` | 必須 | `{}` | あり | `return` |
| Java | 型名 | 必須 | `{}` | あり | `return` |
| Kotlin | `fun` | 推論可能 | `{}` | なし | 式または `return` |
| C# | 型名 | 必須 | `{}` | あり | `return` |
| Ruby | `def` | なし | `end` | なし | 最後の式 |
| PHP | `function` | 任意（推奨） | `{}` | あり | `return` |
| Go | `func` | 必須 | `{}` | なし | `return` |
| C | 型名 | 必須 | `{}` | あり | `return` |
| Rust | `fn` | 必須 | `{}` | あり | 最後の式 |
| F# | `let` | 推論（任意） | なし（インデント） | なし | 最後の式 |
| Scala | `def` | 推論（推奨） | なし / `{}` | なし | 最後の式 |
| Clojure | `defn` | なし | `()` | なし | 最後の式 |
| Elixir | `def` | なし | `do...end` | なし | 最後の式 |
| Haskell | なし（型宣言別） | 型宣言（推奨） | なし（インデント） | なし | 最後の式 |
| Flix | `def` | 明示または推論 | `{}` / インデント | なし | 最後の式 |
| なでしこ3 | `●` | なし | `ここまで` | なし | `を戻す` |

### 実装アプローチの違い

上記の `max3` 実装を見ると、大きく **3 つのアプローチ** に分かれます:

1. **命令型**: 変数に代入しながら `if` で更新（Python, TypeScript, Java, C#, Go, C, Rust, なでしこ3）
2. **組み込み関数活用**: 言語標準の `max` 関数やコレクション操作を利用（Ruby, PHP, Clojure, Elixir）
3. **関数合成・式指向**: `max` 関数の合成、または条件式で値を選択（F#, Scala, Haskell, Flix）

```mermaid
graph LR
    A[max3 の実装アプローチ] --> B[命令型]
    A --> C[組み込み関数活用]
    A --> D[関数合成]
    B --> B1[Python, TS, Java]
    B --> B2[C#, Go, C, Rust, なでしこ3]
    C --> C1[Ruby, PHP]
    C --> C2[Clojure, Elixir]
    D --> D1[F#, Scala, Haskell, Flix]
```

## 変数宣言の比較

| 言語 | 不変 | 可変 | 型推論 |
|------|------|------|--------|
| Python | - | `x = 1` | 常に推論 |
| TypeScript | `const x = 1` | `let x = 1` | `const` 時推論 |
| Java | `final int x = 1` | `int x = 1` | `var x = 1`（10+） |
| C# | - | `int x = 1` / `var x = 1` | `var` で推論 |
| Ruby | `X = 1`（定数） | `x = 1` | 常に推論 |
| PHP | `const X = 1` | `$x = 1` | 常に推論 |
| Go | `const x = 1` | `x := 1` / `var x int = 1` | `:=` で推論 |
| C | `const int x = 1` | `int x = 1` | なし |
| Rust | `let x = 1` | `let mut x = 1` | 推論あり |
| F# | `let x = 1` | `let mutable x = 1` | 推論あり |
| Scala | `val x = 1` | `var x = 1` | 推論あり |
| Kotlin | `val x = 1` | `var x = 1` | 推論あり |
| Clojure | `(def x 1)` | `(atom 1)` | 常に推論 |
| Elixir | `x = 1` | -（再束縛可） | 常に推論 |
| Haskell | `x = 1`（全て不変） | `IORef`（IO 内） | 推論あり |
| Flix | `let x = 1` | `let mut x = 1` / `Array` 等 | 推論あり |
| なでしこ3 | `x = 1` | 同じ代入で更新 | 実行時 |

### デフォルトの不変性

関数型言語は **デフォルトが不変**（immutable）で、可変にするには明示的な宣言が必要です:

- **デフォルト不変**: Rust (`let`), F# (`let`), Scala (`val`), Kotlin (`val`), Haskell（全て不変）, Flix (`let`)
- **デフォルト可変**: Python, Java, C#, Ruby, PHP, Go, C

なでしこ3 は `最大候補 = B` のように代入して状態を更新する命令型の書き方です。変数に型注釈は付けず、値に応じて実行時に型が扱われます。

Kotlin は `val` を優先して再代入を防ぎ、状態を更新する必要がある場合だけ `var` を使います。型は初期値から推論できますが、関数引数や公開 API では型を明示するのが基本です。

## 条件分岐の比較

**if-else の構文**:

| 言語 | 構文例 | 式 or 文 |
|------|--------|---------|
| Python | `if x > 0: ... elif: ... else: ...` | 式（三項） |
| TypeScript | `if (x > 0) { } else if { } else { }` | 文 |
| Java | `if (x > 0) { } else if { } else { }` | 文 |
| Kotlin | `if (x > 0) { ... } else { ... }` | 式 |
| Flix | `if (x > 0) positive else nonPositive` | 式 |
| Ruby | `if x > 0 ... elsif ... else ... end` | 式 |
| Go | `if x > 0 { } else if { } else { }` | 文 |
| C | `if (x > 0) { } else if { } else { }` | 文 |
| Rust | `if x > 0 { } else if { } else { }` | 式 |
| F# | `if x > 0 then ... elif ... else ...` | 式 |
| Scala | `if x > 0 then ... else ...` | 式 |
| Clojure | `(if (> x 0) ... ...)` / `(cond ...)` | 式 |
| Elixir | `if x > 0 do ... else ... end` / `cond` | 式 |
| Haskell | `if x > 0 then ... else ...` / ガード | 式 |
| なでしこ3 | `もし、x > 0ならば ... 違えば ... ここまで` | 文 |

**パターンマッチング対応**:

| 言語 | パターンマッチング |
|------|------------------|
| Rust | `match` 式（網羅性チェックあり） |
| F# | `match ... with` 式（網羅性チェックあり） |
| Scala | `match` 式（sealed trait で網羅性チェック） |
| Haskell | `case ... of` / 関数定義でのパターンマッチ（網羅性警告） |
| Elixir | `case` / 関数の複数定義 |
| Clojure | `condp`、`case`、マルチメソッド |
| C# | `switch` 式（8.0+パターンマッチング） |
| Java | `switch` 式（14+） |
| Kotlin | `when` 式。sealed class と組み合わせると全ケースを網羅できる |
| Flix | `match` 式。enum の全 variant を網羅するよう検査される |

## テストの書き方比較

`max3` のテストを各言語で比較すると、テストフレームワークの違いが明確になります:

**Python (pytest)**:

```python
def test_max3_cases(self):
    cases = [(3, 2, 1, 3), (1, 3, 2, 3), (1, 2, 3, 3)]
    for a, b, c, expected in cases:
        assert max3(a, b, c) == expected
```

**Java (JUnit 5)**:

```java
@Test void testMax3() {
    int[][] cases = {{3,2,1,3}, {1,3,2,3}, {1,2,3,3}};
    for (int[] c : cases)
        assertEquals(c[3], BasicAlgorithms.max3(c[0], c[1], c[2]));
}
```

**Kotlin (`kotlin.test`)**:

```kotlin
@Test
fun max3ReturnsMaximum() {
    assertEquals(3, BasicAlgorithms.max3(3, 2, 1))
}
```

**Haskell (HSpec)**:

```haskell
describe "max3" $ do
  it "returns the maximum of three values" $ do
    max3 3 2 1 `shouldBe` 3
    max3 1 3 2 `shouldBe` 3
    max3 1 2 3 `shouldBe` 3
```

**Flix (`@Test` / `Assert`)**:

```flix
@Test
def max3_returns_maximum(): Unit \ Assert =
    Assert.assertEq(expected = 3, BasicAlgorithms.max3(3, 2, 1))
```

**Elixir (ExUnit)**:

```elixir
test "max3 returns the maximum of three values" do
  assert BasicAlgorithms.max3(3, 2, 1) == 3
  assert BasicAlgorithms.max3(1, 3, 2) == 3
end
```

**なでしこ3 (`検証`)**:

```nako3
!「./helper.nako3」を取り込む
!「../src/basic_algorithms.nako3」を取り込む

「最大値: A>B>C」と(3と2と1で三値最大)と3で検証
```

なでしこ3 版はフレームワークのアサーションマクロではなく、教材の `helper.nako3` に定義した `検証` 関数を使います。章 1〜9 のテストは `gonako run` で実行し、Makefile の `make check` で lint・format・全章テストをまとめて確認します。

## まとめ

- **OOP 言語**（Java, C#, Python, TypeScript）は似た構文で命令型のアプローチを取る
- **Kotlin** は JVM のクラスベース OOP に式指向構文、高階関数、null 安全な型を組み合わせる
- **Flix** は型付き関数シグネチャと式指向の分岐を用い、必要な可変操作を効果として明示する
- **関数型言語**（F#, Scala, Haskell）は関数合成による簡潔な表現が特徴
- **動的型付き言語**（Ruby, PHP, Clojure, Elixir）は組み込み関数を活用した短い実装になる
- **パターンマッチング**は関数型言語に共通する強力な機能で、`mid3` のような条件分岐で威力を発揮する
- **デフォルトの不変性**は、関数型言語と Rust の重要な設計思想で、安全性と予測可能性を高める
- **なでしこ3**は日本語の語順と助詞を構文に取り入れ、命令型の処理を文章のように追える
