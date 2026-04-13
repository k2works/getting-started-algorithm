defmodule Algorithm.ArraysTest do
  use ExUnit.Case
  alias Algorithm.Arrays

  describe "max_of_list/1" do
    test "リストの最大値を返す" do
      assert Arrays.max_of_list([172, 153, 192, 140, 165]) == 192
    end

    test "要素が 1 つのリスト" do
      assert Arrays.max_of_list([42]) == 42
    end

    test "全要素が同じ" do
      assert Arrays.max_of_list([5, 5, 5]) == 5
    end
  end

  describe "reverse_list/1" do
    test "リストの要素の並びを反転する" do
      assert Arrays.reverse_list([2, 5, 1, 3, 9, 6, 7]) == [7, 6, 9, 3, 1, 5, 2]
    end

    test "偶数個のリストを反転する" do
      assert Arrays.reverse_list([1, 2, 3, 4]) == [4, 3, 2, 1]
    end

    test "要素が 1 つのリスト" do
      assert Arrays.reverse_list([42]) == [42]
    end
  end

  describe "cardinal_number/2" do
    test "2 進数に変換する" do
      assert Arrays.cardinal_number(29, 2) == "11101"
    end

    test "8 進数に変換する" do
      assert Arrays.cardinal_number(29, 8) == "35"
    end

    test "16 進数に変換する" do
      assert Arrays.cardinal_number(255, 16) == "FF"
    end
  end

  describe "prime_numbers/1" do
    test "n 以下の素数リストを返す" do
      assert Arrays.prime_numbers(20) == [2, 3, 5, 7, 11, 13, 17, 19]
    end
  end

  describe "prime1/1" do
    test "素直な素数列挙の除算回数を返す" do
      assert Arrays.prime1(1000) == 78022
    end
  end

  describe "prime2/1" do
    test "奇数 + 素数リスト活用の除算回数を返す" do
      assert Arrays.prime2(1000) == 14622
    end
  end

  describe "prime3/1" do
    test "平方根以下のみ確認の除算回数を返す" do
      assert Arrays.prime3(1000) == 3774
    end
  end
end
