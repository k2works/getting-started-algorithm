# 第 3 章 探索アルゴリズム

## はじめに

この章では、データの中から目的の要素を見つける「探索」アルゴリズムを TDD で実装します。線形探索、二分探索、ハッシュ法の 3 種類を取り上げ、それぞれの特徴と使い分けを学びます。

Elixir では、探索結果を `{:ok, value}` / `:not_found` のタプルで表現するのが慣例的です。これにより、見つかった場合と見つからなかった場合を明確に区別できます。

---

## 1. 線形探索

リストの先頭から順に要素を調べていく、最も基本的な探索アルゴリズムです。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/search_algorithms_test.exs
defmodule Algorithm.SearchAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.SearchAlgorithms

  describe "linear_search/2" do
    test "値が見つかった場合にインデックスを返す" do
      assert SearchAlgorithms.linear_search([1, 3, 5, 7, 9], 5) == {:ok, 2}
    end

    test "値が見つからない場合に :not_found を返す" do
      assert SearchAlgorithms.linear_search([1, 3, 5], 4) == :not_found
    end
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/search_algorithms.ex
defmodule Algorithm.SearchAlgorithms do
  @moduledoc "探索アルゴリズム"

  @doc "線形探索"
  def linear_search(list, key) do
    case Enum.find_index(list, &(&1 == key)) do
      nil -> :not_found
      idx -> {:ok, idx}
    end
  end
end
```

### Refactor

`Enum.find_index/2` は要素が見つかればインデックスを、見つからなければ `nil` を返します。`case` 式でパターンマッチすることで、結果を `{:ok, idx}` / `:not_found` に変換しています。

### 計算量

- 時間計算量: O(n)
- 空間計算量: O(1)

---

## 2. 二分探索

ソート済みのリストに対して、中央の要素と比較しながら探索範囲を半分に絞っていくアルゴリズムです。

### Red -- 失敗するテストを書く

```elixir
describe "binary_search/2" do
  test "ソート済みリストから値を二分探索する" do
    assert SearchAlgorithms.binary_search([1, 3, 5, 7, 9], 7) == {:ok, 3}
  end

  test "値が見つからない場合に :not_found を返す" do
    assert SearchAlgorithms.binary_search([1, 3, 5, 7, 9], 4) == :not_found
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "二分探索（ソート済みリストに対して）"
def binary_search(list, key) do
  arr = List.to_tuple(list)
  do_binary(arr, key, 0, tuple_size(arr) - 1)
end

defp do_binary(_arr, _key, lo, hi) when lo > hi, do: :not_found

defp do_binary(arr, key, lo, hi) do
  mid = div(lo + hi, 2)
  val = elem(arr, mid)

  cond do
    val == key -> {:ok, mid}
    val < key  -> do_binary(arr, key, mid + 1, hi)
    true       -> do_binary(arr, key, lo, mid - 1)
  end
end
```

### Refactor -- タプルへの変換

Elixir のリストは連結リストであるため、インデックスアクセスは O(n) です。二分探索ではランダムアクセスが必要なので、`List.to_tuple/1` でタプルに変換してから探索します。タプルの `elem/2` は O(1) でアクセスできます。

`cond` 式は、複数の条件を上から順に評価し、最初に `true` になった節の本体を実行します。

### 計算量

- 時間計算量: O(log n)
- 空間計算量: O(1)

---

## 3. ハッシュ法

ハッシュ関数を使ってキーから直接データの格納場所を計算する探索手法です。Elixir では `Map` がハッシュテーブルとして機能します。

### Red -- 失敗するテストを書く

```elixir
describe "hash_search/2" do
  test "ハッシュマップから値を検索する" do
    map = %{1 => "a", 2 => "b", 3 => "c"}
    assert SearchAlgorithms.hash_search(map, 2) == {:ok, "b"}
    assert SearchAlgorithms.hash_search(map, 4) == :not_found
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "ハッシュ法による探索"
def hash_search(map, key) do
  case Map.get(map, key) do
    nil   -> :not_found
    value -> {:ok, value}
  end
end
```

### Refactor

Elixir の `Map` は内部的にハッシュテーブルを使用しているため、キーによる検索は平均 O(1) で行えます。`Map.get/2` で値を取得し、`nil` の場合は `:not_found` を返します。

### 計算量

- 時間計算量: 平均 O(1)
- 空間計算量: O(n)

---

## 4. 探索アルゴリズムの比較

| アルゴリズム | 前提条件 | 平均時間計算量 | 最悪時間計算量 |
|-------------|---------|---------------|---------------|
| 線形探索 | なし | O(n) | O(n) |
| 二分探索 | ソート済み | O(log n) | O(log n) |
| ハッシュ法 | ハッシュテーブル | O(1) | O(n) |

---

## まとめ

この章では、3 種類の探索アルゴリズムを TDD で実装しました。

- **線形探索**: `Enum.find_index/2` を活用したシンプルな実装
- **二分探索**: タプル変換 + 再帰 + `cond` 式による効率的な探索
- **ハッシュ法**: `Map` の O(1) アクセスを活用

Elixir では、結果を `{:ok, value}` / `:not_found` のタプルで返すパターンが一般的です。これは Erlang/OTP の伝統を受け継いだ、エラーハンドリングの基本パターンです。
