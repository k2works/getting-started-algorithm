defmodule Algorithm.SearchAlgorithms do
  @moduledoc """
  探索アルゴリズム
  """

  @doc "線形探索"
  def linear_search(list, key) do
    case Enum.find_index(list, &(&1 == key)) do
      nil -> :not_found
      idx -> {:ok, idx}
    end
  end

  @doc "線形探索（番兵法）"
  def linear_search_sentinel(list, key) do
    # 末尾に番兵を追加
    guarded = list ++ [key]
    idx = do_sentinel_search(guarded, key, 0)

    if idx == length(list) do
      :not_found
    else
      {:ok, idx}
    end
  end

  defp do_sentinel_search([head | _tail], key, idx) when head == key, do: idx
  defp do_sentinel_search([_head | tail], key, idx), do: do_sentinel_search(tail, key, idx + 1)

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
      val < key -> do_binary(arr, key, mid + 1, hi)
      true -> do_binary(arr, key, lo, mid - 1)
    end
  end

  @doc "ハッシュ法による探索"
  def hash_search(map, key) do
    case Map.get(map, key) do
      nil -> :not_found
      value -> {:ok, value}
    end
  end

  # === チェイン法ハッシュ ===

  defmodule ChainedHash do
    @moduledoc "チェイン法を実現するハッシュテーブル"

    defstruct [:capacity, :table]

    @doc "新しいチェイン法ハッシュテーブルを作成する"
    def new(capacity) do
      %__MODULE__{
        capacity: capacity,
        table: :erlang.make_tuple(capacity, [])
      }
    end

    @doc "キーに対応する値を検索する"
    def search(%__MODULE__{capacity: cap, table: table}, key) do
      h = rem(key, cap)
      chain = elem(table, h)

      case Enum.find(chain, fn {k, _v} -> k == key end) do
        nil -> :not_found
        {_k, v} -> {:ok, v}
      end
    end

    @doc "キーと値のペアを追加する（重複キーは無視）"
    def add(%__MODULE__{capacity: cap, table: table} = hash, key, value) do
      h = rem(key, cap)
      chain = elem(table, h)

      if Enum.any?(chain, fn {k, _v} -> k == key end) do
        hash
      else
        new_chain = [{key, value} | chain]
        %{hash | table: put_elem(table, h, new_chain)}
      end
    end

    @doc "キーに対応する要素を削除する"
    def remove(%__MODULE__{capacity: cap, table: table} = hash, key) do
      h = rem(key, cap)
      chain = elem(table, h)
      new_chain = Enum.reject(chain, fn {k, _v} -> k == key end)
      %{hash | table: put_elem(table, h, new_chain)}
    end
  end

  # === オープンアドレス法ハッシュ ===

  defmodule OpenHash do
    @moduledoc "オープンアドレス法（線形探索法）を実現するハッシュテーブル"

    @empty :empty
    @deleted :deleted

    defstruct [:capacity, :table]

    @doc "新しいオープンアドレス法ハッシュテーブルを作成する"
    def new(capacity) do
      %__MODULE__{
        capacity: capacity,
        table: :erlang.make_tuple(capacity, @empty)
      }
    end

    @doc "キーに対応する値を検索する"
    def search(%__MODULE__{capacity: cap, table: table}, key) do
      h = rem(key, cap)
      do_search(table, key, h, cap, 0)
    end

    defp do_search(_table, _key, _h, cap, count) when count >= cap, do: :not_found

    defp do_search(table, key, h, cap, count) do
      case elem(table, h) do
        @empty ->
          :not_found

        @deleted ->
          do_search(table, key, rem(h + 1, cap), cap, count + 1)

        {k, v} when k == key ->
          {:ok, v}

        _other ->
          do_search(table, key, rem(h + 1, cap), cap, count + 1)
      end
    end

    @doc "キーと値のペアを追加する"
    def add(%__MODULE__{capacity: cap, table: table} = hash, key, value) do
      h = rem(key, cap)
      do_add(hash, table, key, value, h, cap, 0)
    end

    defp do_add(hash, _table, _key, _value, _h, cap, count) when count >= cap, do: hash

    defp do_add(hash, table, key, value, h, cap, count) do
      case elem(table, h) do
        slot when slot == @empty or slot == @deleted ->
          %{hash | table: put_elem(table, h, {key, value})}

        {k, _v} when k == key ->
          hash

        _other ->
          do_add(hash, table, key, value, rem(h + 1, cap), cap, count + 1)
      end
    end

    @doc "キーに対応する要素を削除する"
    def remove(%__MODULE__{capacity: cap, table: table} = hash, key) do
      h = rem(key, cap)
      do_remove(hash, table, key, h, cap, 0)
    end

    defp do_remove(hash, _table, _key, _h, cap, count) when count >= cap, do: hash

    defp do_remove(hash, table, key, h, cap, count) do
      case elem(table, h) do
        @empty ->
          hash

        {k, _v} when k == key ->
          %{hash | table: put_elem(table, h, @deleted)}

        _other ->
          do_remove(hash, table, key, rem(h + 1, cap), cap, count + 1)
      end
    end
  end
end
