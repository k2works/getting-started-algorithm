# 第 1 章 基本的なアルゴリズム

## はじめに

プログラミングを学ぶ上で、アルゴリズムの理解は非常に重要です。アルゴリズムとは、問題を解決するための手順や方法のことです。この章では、Elixir を使って基本的なアルゴリズムを学びながら、テスト駆動開発（TDD）の手法を用いて実装していきます。

テスト駆動開発とは、コードを書く前にまずテストを書き、そのテストが通るようにコードを実装していく開発手法です。Red-Green-Refactor というサイクルを繰り返しながら、確実に動作するコードを段階的に作り上げます。

## 準備

### 環境構築

```bash
# Nix 環境に入る（Elixir + Erlang が利用可能になる）
nix develop .#elixir

# プロジェクトディレクトリへ移動
cd apps/elixir

# テスト実行
mix test
```

### プロジェクト構成

```
apps/elixir/
├── mix.exs                           # プロジェクト設定
├── lib/
│   └── algorithm/
│       └── basic_algorithms.ex       # 実装ファイル
└── test/
    ├── test_helper.exs               # テストヘルパー
    └── algorithm/
        └── basic_algorithms_test.exs # テストファイル
```

### テスト実行コマンド

```bash
# 全テスト実行
mix test

# 特定ファイルのテスト実行
mix test test/algorithm/basic_algorithms_test.exs

# 詳細出力
mix test --trace
```

---

## 1. アルゴリズムとは

アルゴリズムとは、問題を解決するための明確な手順のことです。コンピュータプログラムは、アルゴリズムを実行可能な形で表現したものと言えます。

良いアルゴリズムは以下の特徴を持ちます：

- 入力と出力が明確である
- 各ステップが明確である
- 有限のステップで終了する
- 効率的である

---

## 2. 3 値の最大値

3 つの整数値の中から最大値を求めるアルゴリズムを TDD で実装します。

### Red -- 失敗するテストを書く

```elixir
# test/algorithm/basic_algorithms_test.exs
defmodule Algorithm.BasicAlgorithmsTest do
  use ExUnit.Case
  alias Algorithm.BasicAlgorithms

  describe "max3/3" do
    test "3 つの値のうち最大値を返す" do
      assert BasicAlgorithms.max3(3, 2, 1) == 3
      assert BasicAlgorithms.max3(1, 2, 3) == 3
      assert BasicAlgorithms.max3(3, 3, 2) == 3
    end
  end
end
```

3 つの値の大小関係の代表的なパターンを網羅したテストです。

### Green -- テストを通す最小限の実装

```elixir
# lib/algorithm/basic_algorithms.ex
defmodule Algorithm.BasicAlgorithms do
  @moduledoc "基本的なアルゴリズム"

  @doc "3 つの値のうち最大値を返す"
  def max3(a, b, c) do
    a |> max(b) |> max(c)
  end
end
```

### Refactor -- パイプ演算子の活用

Elixir ではパイプ演算子 `|>` を使うことで、データの流れを左から右へと読みやすく表現できます。`max/2` は Elixir の組み込み関数で、2 つの値のうち大きい方を返します。パイプでつなぐことで、「a と b の大きい方」と「c」をさらに比較する、という意図が明確になります。

### アルゴリズムの考え方

1. 最初の値を最大値候補とする
2. `max/2` で次の値と比較し、大きい方を残す
3. パイプ演算子 `|>` で結果をチェーンする

---

## 3. 3 値の中央値

3 つの整数値の中央値（3 つの値を大きさの順に並べたときに真ん中に来る値）を求めます。

### Red -- 失敗するテストを書く

```elixir
describe "mid3/3" do
  test "3 つの値のうち中央値を返す" do
    assert BasicAlgorithms.mid3(3, 2, 1) == 2
    assert BasicAlgorithms.mid3(1, 2, 3) == 2
    assert BasicAlgorithms.mid3(1, 1, 3) == 1
  end
end
```

### Green -- テストを通す最小限の実装

```elixir
@doc "3 つの値のうち中央値を返す"
def mid3(a, b, c) do
  [a, b, c] |> Enum.sort() |> Enum.at(1)
end
```

### Refactor -- Elixir らしい実装

Elixir ではリストの操作が非常に簡潔です。`Enum.sort/1` でリストをソートし、`Enum.at/2` でインデックス 1（2 番目の要素 = 中央値）を取得します。パイプ演算子 `|>` でつなぐことで、「リストを作り → ソートし → 真ん中を取る」というデータの流れが一目で分かります。

### アルゴリズムの考え方

1. 3 つの値をリストにまとめる
2. `Enum.sort/1` で昇順にソートする
3. `Enum.at(1)` でソート後のリストの 2 番目の要素（中央値）を取得する

---

## まとめ

この章では、Elixir を使って基本的なアルゴリズムを TDD で実装しました。

- **パイプ演算子 `|>`** を使ったデータ変換チェーン
- **`Enum` モジュール** によるリスト操作（`sort`、`at`）
- **ExUnit** によるテスト駆動開発

Elixir では、データを変換するパイプラインとして処理を記述するスタイルが自然です。次の章では、配列（リスト）操作についてさらに詳しく学びます。
