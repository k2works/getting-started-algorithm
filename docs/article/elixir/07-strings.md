# 第 7 章 文字列処理

## はじめに

この章では、文字列に関するアルゴリズムを TDD で実装します。文字列探索（ブルートフォース法、KMP 法）、文字数カウント、文字列反転、回文判定を取り上げます。

Elixir の文字列は UTF-8 エンコードされたバイナリです。`String.graphemes/1` で書記素クラスタ（ユーザーが認識する「1 文字」）のリストに変換して操作します。

---

## 1. ブルートフォース文字列探索

テキスト内でパターン文字列を先頭から順に探索する最も基本的なアルゴリズムです。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/strings_test.exs
defmodule Algorithm.StringsTest do
  use ExUnit.Case
  alias Algorithm.Strings

  describe "brute_force_search/2" do
    test "文字列内のパターンを検索する" do
      assert Strings.brute_force_search("ABCABC", "CAB") == {:ok, 2}
    end

    test "パターンが見つからない場合 :not_found を返す" do
      assert Strings.brute_force_search("ABCABC", "XYZ") == :not_found
    end
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/strings.ex
defmodule Algorithm.Strings do
  @moduledoc "文字列処理"

  @doc "ブルートフォース文字列探索"
  def brute_force_search(text, pattern) do
    t = String.graphemes(text)
    p = String.graphemes(pattern)
    tlen = length(t)
    plen = length(p)

    result =
      Enum.find(0..(tlen - plen), fn i ->
        Enum.slice(t, i, plen) == p
      end)

    case result do
      nil -> :not_found
      idx -> {:ok, idx}
    end
  end
end
```

### Refactor

`String.graphemes/1` で文字列を書記素クラスタのリストに分解し、`Enum.slice/3` でスライスを取得して比較します。`Enum.find/2` は条件を満たす最初の要素を返すので、最初に一致する位置が見つかります。

- 計算量: O(n * m)（n: テキスト長、m: パターン長）

---

## 2. KMP 法（Knuth-Morris-Pratt）

パターンの内部構造を事前解析し、不一致時に無駄な比較をスキップする効率的な文字列探索アルゴリズムです。

### Red -- 失敗するテストを書く

```elixir
describe "kmp_search/2" do
  test "KMP 法で文字列を検索する" do
    assert Strings.kmp_search("ABCABC", "CAB") == {:ok, 2}
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "KMP 法による文字列探索"
def kmp_search(text, pattern) do
  t = String.graphemes(text)
  p = String.graphemes(pattern)
  plen = length(p)

  if plen == 0 do
    {:ok, 0}
  else
    failure = build_failure_table(p, plen)
    do_kmp_search(t, p, failure, 0, 0, length(t), plen)
  end
end
```

### Refactor -- 失敗関数テーブル

KMP 法の核心は「失敗関数テーブル」の構築です。パターン内の接頭辞と接尾辞の一致情報を事前計算しておくことで、不一致時にパターンの比較位置を効率的に戻せます。

- 計算量: O(n + m)

---

## 3. 文字数カウント

### Red -- 失敗するテストを書く

```elixir
describe "char_count/1" do
  test "各文字の出現回数を返す" do
    assert Strings.char_count("hello") == %{"h" => 1, "e" => 1, "l" => 2, "o" => 1}
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "各文字の出現回数を返す"
def char_count(str) do
  str
  |> String.graphemes()
  |> Enum.frequencies()
end
```

### Refactor

`Enum.frequencies/1` は Elixir 1.10 で追加された関数で、リストの各要素の出現回数をマップで返します。パイプ演算子と組み合わせることで、「文字列を分解し → 頻度を数える」という処理が 1 行で表現できます。

---

## 4. 文字列の反転

### Red -- 失敗するテストを書く

```elixir
describe "reverse_string/1" do
  test "文字列を逆順にする" do
    assert Strings.reverse_string("hello") == "olleh"
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "文字列を逆順にする"
def reverse_string(str) do
  str |> String.graphemes() |> Enum.reverse() |> Enum.join()
end
```

### Refactor

`String.reverse/1` という組み込み関数もありますが、ここではアルゴリズムの理解のために `String.graphemes` + `Enum.reverse` + `Enum.join` のパイプラインで実装しています。

---

## 5. 回文判定

### Red -- 失敗するテストを書く

```elixir
describe "palindrome?/1" do
  test "回文の場合 true を返す" do
    assert Strings.palindrome?("racecar") == true
  end

  test "回文でない場合 false を返す" do
    assert Strings.palindrome?("hello") == false
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "回文判定"
def palindrome?(str) do
  str == reverse_string(str)
end
```

### Refactor

既に実装した `reverse_string/1` を再利用して、元の文字列と反転した文字列が等しいかどうかで回文を判定しています。関数の再利用による DRY 原則の実践です。

---

## まとめ

この章では、文字列処理アルゴリズムを TDD で実装しました。

- **`String.graphemes/1`**: UTF-8 文字列を書記素クラスタのリストに分解
- **`Enum.frequencies/1`**: 要素の出現頻度を 1 行でカウント
- **パイプ演算子 `|>`**: 文字列操作のチェーンを読みやすく表現
- **KMP 法**: 失敗関数テーブルによる効率的な文字列探索

Elixir の文字列は UTF-8 バイナリであるため、マルチバイト文字も正しく扱えます。`String.graphemes/1` を使うことで、絵文字や結合文字を含む文字列でも正確な操作が可能です。
